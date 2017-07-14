package admin.customer.guanwangbao;

import java.sql.Connection;
import java.util.Hashtable;
import java.util.Vector;

import simpleWebFrame.database.DBConnectionPool;
import simpleWebFrame.database.DBProxy;
import simpleWebFrame.log.AppLogger;
import simpleWebFrame.util.DateTimeUtil;
import admin.customer.guanwangbao.tool.StockBillTool;
import admin.customer.guanwangbao.tool.SupplierAmountTool;
import admin.customer.guanwangbao.tool.UserMoneyTool;

public class ShopOrderThread extends Thread {
	private static ShopOrderThread instance = new ShopOrderThread();
	private static boolean isRunning = true;
	
	private ShopOrderThread() {
	}
	
	public static ShopOrderThread getInstance() {
		return instance;
	}
	
	public void run() {
		while (isRunning) {
			try {
				sleep(1 * 60 * 1000);
				autoUpdShopOrderStatus();
			} catch (Exception e) {
				AppLogger.getInstance().errorLog("ShopOrderThread run error", e);
			}
		}
	}
	
	public void autoUpdShopOrderStatus() throws Exception {
		Connection con = null;
		try {
			con = DBConnectionPool.getInstance().getConnection();
			con.setAutoCommit(false);
			long curMills = System.currentTimeMillis();
			String sql = "select * from shopOrder where " +
					"(status = " + AppKeys.ORDER_STATUS_UNPAY + " and autoCloseTimeMills <= " +curMills + ")" + 
					" or (status = " + AppKeys.ORDER_STATUS_DAISHOUHUO + " and autoReviceGoodsDeadTimeMills <= " + curMills + ")" +
					" or (status = " + AppKeys.ORDER_STATUS_YISHOUHUO + " and autoFinishDeadTimeMills <= " + curMills + " and returnGoodsStatus != '1')" +
					" limit 0, 1";
			Vector<Hashtable<String, String>> shopOrders = DBProxy.query(con, "shopOrder", 
					sql, new Vector<String>());
			for (int i = 0; i < shopOrders.size(); ++i) {
				Hashtable<String, String> shopOrder = shopOrders.get(i);
				String status = shopOrder.get("status");
				Hashtable<String, String> k = new Hashtable<String, String>();
				k.put("shopOrderID", shopOrder.get("shopOrderID"));
				Hashtable<String, String> v = new Hashtable<String, String>();
				if (status.equals(AppKeys.ORDER_STATUS_DAISHOUHUO)) {
					v.put("receiveGoodsTime", DateTimeUtil.getCurrentDateTime());
					v.put("status", AppKeys.ORDER_STATUS_YISHOUHUO);
					long reviceTimeMills = System.currentTimeMillis();
					v.put("autoFinishDeadTimeMills", 
							(reviceTimeMills + AppKeys.AUTO_FINISH_DAY) + "");
					DBProxy.update(con, "shopOrder", k, v);
				} else if (status.equals(AppKeys.ORDER_STATUS_YISHOUHUO)) {
					v.put("finishTime", DateTimeUtil.getCurrentDateTime());
					v.put("status", AppKeys.ORDER_STATUS_SUCCEED);
					int count = DBProxy.update(con, "shopOrder", k, v);
					if (count > 0) {
						if (!shopOrder.get("supplierID").equals("")) {
							String supplierAmount = shopOrder.get("supplierAmount");
							SupplierAmountTool.lockAmount2CanCashAmount(con, "", shopOrder.get("supplierID"), 
									supplierAmount, shopOrder.get("shopOrderID"), "");
						}
						// 如果使用了拿样订单 将拿样订单钱返还到用户商户余额中。
						if(!shopOrder.get("sampleMoney").equals("") && Float.parseFloat(shopOrder.get("sampleMoney")) > 0.00f && !shopOrder.get("sampleShopOrderID").equals("")) {
							UserMoneyTool.plusUserMoney(con, shopOrder.get("userID"), shopOrder.get("supplierID"), 
									shopOrder.get("sampleMoney"), "8", shopOrder.get("shopOrderID"));
						}
					}
					AppUtil.updShopOrderProductSellNumber(con, shopOrder.get("shopOrderID"));
				} else if (status.equals(AppKeys.ORDER_STATUS_UNPAY)) {
					v.put("status", AppKeys.ORDER_STATUS_CLOSE);
					v.put("canRefundAmount", "0.00");
					v.put("canRefundPoint", "0");
					int count = DBProxy.update(con, "shopOrder", k, v);
					if (count > 0) {
						if (Float.parseFloat(shopOrder.get("canRefundAccountMoney")) > 0.00f) {
							UserMoneyTool.plusUserMoney(con, shopOrder.get("userID"), shopOrder.get("supplierID"), 
									shopOrder.get("canRefundAccountMoney"), "2", shopOrder.get("shopOrderID"));
						}
						
						StockBillTool.minStockBillByUpdateOrder(con, "", shopOrder.get("shopOrderID"), false);
						// 如果使用了拿样订单 将拿样订单释放。
						if(!shopOrder.get("sampleMoney").equals("") && Float.parseFloat(shopOrder.get("sampleMoney")) > 0.00f && !shopOrder.get("sampleShopOrderID").equals("")) {
							Hashtable<String, String> keys = new Hashtable<String, String>(); 
							keys.put("shopOrderID", shopOrder.get("sampleShopOrderID"));
							Hashtable<String, String> values = new Hashtable<String, String>(); 
							values.put("canUseSampleFlag", "0");
							DBProxy.update(con, "shopOrder", keys, values);
						}
					}
					
				}
			}
			con.commit();
		} catch (Exception e) {
			AppLogger.getInstance().errorLog("ShopOrderThread autoUpdShopOrderStatus error", e);
			con.rollback();
		} finally {
			try {
				if (con != null) {
					con.close();
				}
			} catch (Exception e2) {}
		}
	}
	
	
//	private Hashtable<String, String> updateShopCanGetAmount(Connection con, String shopOrderID, String settlementShopID, String settlementAmount) {
//		Hashtable<String, String> v = new Hashtable<String, String>();
//		try {
//			if (!settlementShopID.equals("") && !settlementAmount.equals("")) {
//				Double totalAmountD = Double.parseDouble(settlementAmount);
//				if (totalAmountD > 0.00d) {
//					String sql = "update shop set canGetAmount = canGetAmount + ? where shopID = ?";
//					Vector<String> p = new Vector<String>();
//					p.add(settlementAmount);
//					p.add(settlementShopID);
//					DBProxy.update(con, "shop", sql, p);
//				}
//			}
//		} catch (Exception e) {
//			AppLogger.getInstance().errorLog("updateShopCanGetAmount order :" + shopOrderID + " error", e);
//		}
//		
//		return v;
//	}
	
//	private Hashtable<String, String> getShopOrderSettlementInfo(Connection con, String shopOrderID) throws Exception {
//		Hashtable<String, String> info = new Hashtable<String, String>();
//		info.put("settlementFinishFlag", "0");
//		info.put("settlementAmount", "0.00");
//		
//		Hashtable<String, String> k = new Hashtable<String, String>();
//		k.put("shopOrderID", shopOrderID);
//		Hashtable<String, String> shopOrder = DBProxy.query(con, "shopOrder", k).get(0);
//		
//		//如果该订单没有对应的结算线下店或者订单已关闭
//		if (shopOrder.get("settlementShopID").equals("") || shopOrder.get("status").equals(AppKeys.ORDER_STATUS_CLOSE)) {
//			info.put("settlementFinishFlag", "1");
//			info.put("settlementAmount", "0.00");
//			return info;
//		}
//		
//		Vector<Hashtable<String, String>> orderProducts = DBProxy.query(con, "orderProduct", k);
//		String settlementAmount = "0.00";
//		for (int i = 0; i < orderProducts.size(); ++i) {
//			Hashtable<String, String> orderProduct = orderProducts.get(i);
//			String tmpPrice = PriceUtil.minusPrice(orderProduct.get("price"), orderProduct.get("settlementPrice").equals("") ? orderProduct.get("price") : orderProduct.get("settlementPrice"));
//			int actualNumber = Integer.parseInt(orderProduct.get("number")) - 
//					Integer.parseInt(orderProduct.get("returnNumber").equals("") ? "0" : orderProduct.get("returnNumber"));
//			if (actualNumber < 0) {
//				actualNumber = 0;
//			}
//			settlementAmount = PriceUtil.plusPrice(settlementAmount, PriceUtil.multiPrice(tmpPrice, actualNumber));
//		}
//		
//		info.put("settlementFinishFlag", shopOrder.get("status").equals(AppKeys.ORDER_STATUS_SUCCEED) ? "1" : "0");
//		info.put("settlementAmount", settlementAmount);
//		return info;
//	}
	
	public void stopRunning() {
		isRunning = false;
	}
	
	public void beginRunning() {
		isRunning = true;
	}
}
