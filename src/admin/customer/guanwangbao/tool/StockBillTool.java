package admin.customer.guanwangbao.tool;


import java.sql.Connection;
import java.util.Collections;
import java.util.Hashtable;
import java.util.Vector;

import simpleWebFrame.database.DBProxy;
import simpleWebFrame.database.IndexGenerater;
import simpleWebFrame.util.DateTimeUtil;
import admin.customer.guanwangbao.AppKeys;
import admin.customer.guanwangbao.ColumnComparator;
import admin.customer.guanwangbao.PropUtil;

public class StockBillTool {
	/**
	 * 增加锁定库存并减少可用库存，适用于下单未支付的场景
	 * @param con 数据库连接
	 * @param skus 需要更新的sku集合
	 * @return 更新成功返回true，失败返回false
	 * @throws Exception
	 */
	public static boolean plusLcokStockAndMinFreeStock(Connection con, 
			Vector<Hashtable<String, String>> skus) throws Exception {
		boolean res = false;
		if (skus.size() > 0) {
			// 对需要更新的记录进行排序，确保数据库加锁顺序一致，避免死锁
			sortSkus(skus);
			
			for (int i = 0; i < skus.size(); i++) { 
				String skuID = skus.get(i).get("skuID");
				if(skuID.equals("")) continue;
				String productID = skus.get(i).get("productID");
				String number = skus.get(i).get("updStock");
					
				String updateSql1 = "update sku set lockStock = lockStock + " + number + ", freeStock = freeStock - " + number + " where skuID = " + skuID + " and freeStock >= " + number;
				int count = DBProxy.update(con, "sku", updateSql1, new Vector<String>());
				if (count > 0) {
					String updateSql = "update product set lockStock = lockStock + " + number + ", freeStock = freeStock - " + number + " where productID = " + productID + " and freeStock >= " + number;
					count = DBProxy.update(con, "product", updateSql, new Vector<String>());
					res = count > 0;
					if (!res) {
						return res;
					}
				}
			}
		}
		
		return res;
	}
	
	/**
	 * 减少锁定库存并新增可用库存，适用于取消订单场景
	 * @param con 数据库连接
	 * @param skus 需要操作的sku集合
	 * @return 更新成功返回true，失败返回false
	 * @throws Exception
	 */
	public static boolean minusLcokStockAndPlusFreeStock(Connection con, 
			Vector<Hashtable<String, String>> skus) throws Exception {
		boolean res = false;
		if (skus.size() > 0) {
			// 对需要更新的记录进行排序，确保数据库加锁顺序一致，避免死锁
			sortSkus(skus);
			
			for (int i = 0; i < skus.size(); i++) { 
				String skuID = skus.get(i).get("skuID");
				String productID = skus.get(i).get("productID");
				String number = skus.get(i).get("updStock");
					
				String updateSql1 = "update sku set lockStock = lockStock - " + number + ", freeStock = freeStock + " + number + " where skuID = " + skuID + " and lockStock >= " + number;
				int count = DBProxy.update(con, "sku", updateSql1, new Vector<String>());
				if (count > 0) {
					String updateSql = "update product set lockStock = lockStock - " + number + ", freeStock = freeStock + " + number + " where productID = " + productID + " and lockStock >= " + number;
					count = DBProxy.update(con, "product", updateSql, new Vector<String>());
					res = count > 0;
					if (!res) {
						return res;
					}
				}
			}
		}
		
		return res;
	}
	
	/**
	 * 扣减商品锁定库存和实际库存，适用于订单支付的时候
	 * @param con 数据库连接
	 * @param siteID 暂无用处
	 * @param supplierID 店铺ID
	 * @param stockOutTypeID 出库类型ID
	 * @param relateID 关联数据ID
	 * @param siteManagerUserID
	 * @param userName
	 * @param skus
	 * @return 更新成功返回true，否则返回false
	 * @throws Exception
	 */
	public static boolean minusLockStockAndStock(Connection con, String siteID, String supplierID, 
			String stockOutTypeID, String relateID,
			String siteManagerUserID, String userName,
			Vector<Hashtable<String, String>> skus) throws Exception {
		boolean res = false;
		if (skus.size() > 0) {
			// 对需要更新的记录进行排序，确保数据库加锁顺序一致，避免死锁
			sortSkus(skus);
			String currentTime = DateTimeUtil.getCurrentDateTime();
			
			Hashtable<String, String> sIBValues = new Hashtable<String, String>();
			String stockOutBillID = IndexGenerater.getTableIndex("stockOutBill", con);
			sIBValues.put("stockOutBillID", stockOutBillID);
			sIBValues.put("supplierID", supplierID);
			sIBValues.put("stockOutTypeID", stockOutTypeID);
			sIBValues.put("relateID", relateID);
			sIBValues.put("siteManagerUserID", siteManagerUserID);
			sIBValues.put("siteManagerUserName", userName);
			sIBValues.put("addTime", currentTime);
			
			DBProxy.insert(con, "stockOutBill", sIBValues);
			
			for (int i = 0; i < skus.size(); i++) { 
				String skuID = skus.get(i).get("skuID");
				String productID = skus.get(i).get("productID");
				String number = skus.get(i).get("updStock");
				String note = skus.get(i).get("updNote") == null ? "" : skus.get(i).get("updNote");
					
				Hashtable<String, String> sIBIValues = new Hashtable<String, String>();
				sIBIValues.put("stockOutBillItemID", IndexGenerater.getTableIndex("stockOutBillItem", con));
				sIBIValues.put("stockOutBillID", stockOutBillID);
				sIBIValues.put("productID", productID);
				sIBIValues.put("number", number);
				sIBIValues.put("note", note);
				sIBIValues.put("skuID", skuID);
				
				Hashtable<String, String> k = new Hashtable<String, String>();
				k.put("skuID", skuID);
				Vector<Hashtable<String, String>> skuDatas = DBProxy.query(con, "sku_V", k);
				if (skuDatas.size() > 0) {
					Hashtable<String, String> skuData = skuDatas.get(0);
					String props = skuData.get("props").toString();
					String showPropsName = PropUtil.getSkuPropName(props, skuData.get("skuPropAlias"), skuData.get("skuPropValueAlias"));
					sIBIValues.put("props", skuData.get("props"));
					sIBIValues.put("propsName", showPropsName);
					DBProxy.insert(con, "stockOutBillItem", sIBIValues);
					
					String updateSql1 = " update sku set lockStock = lockStock - " + number + ", stock = stock - " + number + " where skuID = " + skuID + " and lockStock >= " + number + " and stock >= " + number;
					int count = DBProxy.update(con, "sku", updateSql1, new Vector<String>());
					if (count > 0) {
						String updateSql = " update product set lockStock = lockStock - " + number + ",  stock = stock - " + number + " where productID = " + productID + " and lockStock >= " + number + " and stock >= " + number;
						count = DBProxy.update(con, "product", updateSql, new Vector<String>());
						res = count > 0;
						if (!res) {
							return res;
						}
					}
				}
			}
		}
		
		return res;
	}
	
	/**
	 * 根据订单状态变更，减少订单中的商品库存(更新订单状态后再调用改方法)
	 * @param con
	 * @param siteID
	 * @param supplierID
	 * @param stockOutTypeID 出库单类型
	 * @param shopOrderID 订单ID
	 * @throws Exception
	 */
	public static boolean minStockBillByUpdateOrder(Connection con,
			String stockOutTypeID, String shopOrderID, boolean newShopOrder) throws Exception {
		Hashtable<String, String> key = new Hashtable<String, String>();
		key.put("shopOrderID", shopOrderID);
		Hashtable<String, String> shopOrder = DBProxy.query(con, "shopOrder", key).get(0);
		
		String status = shopOrder.get("status");
		String supplierID = shopOrder.get("supplierID");
		
		boolean minFreeStockFlag = false;
		boolean minStockFlag = false;
		boolean isSampleOrder = false; // 是否是拿样订单
		boolean plusFreeStockAndMinLockStockFlag = false;
		
		
		if (shopOrder.get("shopOrderTypeID").equals("3")) {
			isSampleOrder = true;
		}
		if (status.equals(AppKeys.ORDER_STATUS_UNPAY)) {
			minFreeStockFlag = true;
		} else if (status.equals(AppKeys.ORDER_STATUS_DAIPEIHUO)) {//其他：付款完成后减库存
			minStockFlag = true;
		} else if (status.equals(AppKeys.ORDER_STATUS_CLOSE) && !isSampleOrder) {
			plusFreeStockAndMinLockStockFlag = true;
		}
		
		if (minStockFlag && isSampleOrder) {
			Vector<Hashtable<String, String>> orderProducts = DBProxy.query(con, "orderProduct", key);
			for (int i = 0; i < orderProducts.size(); i++) {
				Hashtable<String, String> tmp = orderProducts.get(i);
				int number = Integer.parseInt(tmp.get("number"));
				String sql = "update sampleProduct set sampleProductStock = sampleProductStock - ? where productID = ?";
				Vector<String> p = new Vector<String>();
				p.add(number + "");
				p.add(tmp.get("productID"));
				DBProxy.update(con, "sampleProduct", sql, p);
			}
			return true;
		} else if (minStockFlag) {
			key.put("skuDeletedFlag", "0");
			Vector<Hashtable<String, String>> orderProducts = DBProxy.query(con, "orderProduct", key);
			for (int i = 0; i < orderProducts.size(); i++) {
				Hashtable<String, String> tmp = orderProducts.get(i);
				int number = Integer.parseInt(tmp.get("number"));
				updateTableSellNumber(con, "product", tmp.get("productID"), number, "", true);
				
				tmp.put("updStock", number + "");
				tmp.put("updNote", "");
			}
			if (newShopOrder) {
				return minFreeStockAndStock(con, "", supplierID, "1", shopOrderID, "", "", orderProducts);
			} else {
				return minusLockStockAndStock(con, "", supplierID, stockOutTypeID, "", "", 
						"", orderProducts);
			}
		} else if (minFreeStockFlag) {
			key.put("skuDeletedFlag", "0");
			Vector<Hashtable<String, String>> orderProducts = DBProxy.query(con, "orderProduct", key);
			for (int i = 0; i < orderProducts.size(); i++) {
				Hashtable<String, String> tmp = orderProducts.get(i);
				int number = Integer.parseInt(tmp.get("number"));
				tmp.put("updStock", number + "");
				tmp.put("updNote", "");
			}
			
			return StockBillTool.plusLcokStockAndMinFreeStock(con, orderProducts);
		} else if (plusFreeStockAndMinLockStockFlag) {
			key.put("skuDeletedFlag", "0");
			Vector<Hashtable<String, String>> orderProducts = DBProxy.query(con, "orderProduct", key);
			for (int i = 0; i < orderProducts.size(); i++) {
				Hashtable<String, String> tmp = orderProducts.get(i);
				int number = Integer.parseInt(tmp.get("number"));
				updateTableSellNumber(con, "product", tmp.get("productID"), number, "", true);
				
				tmp.put("updStock", number + "");
				tmp.put("updNote", "");
				// 回滚团购秒杀活动库存
				if("2".equals(tmp.get("orderProductTypeID"))) {
					String preparedSql = "update groupBuy set stock = stock + ?, saleNumber = saleNumber - 1 where groupBuyID = ? and supplierID = ?";
					Vector<String> values = new Vector<String>();
					values.add(number + "");
					values.add(tmp.get("groupBuyID"));
					values.add(supplierID + "");
					DBProxy.update(con, "groupBuy", preparedSql, values);
				}
			}
			return StockBillTool.minusLcokStockAndPlusFreeStock(con, orderProducts);
		}
		
		return false;
	}
	
	private static void updateTableSellNumber(Connection con, String tableName, 
			String columnID, int number, String siteID, boolean plusFlag) throws Exception {
		String operater = plusFlag ? "+" : "-";
		String columnName = tableName + "ID";
		String sql = "update " + tableName + " set sellNumber = sellNumber " + operater + " ? where " + columnName + " = ?";
		Vector<String> values = new Vector<String>();
		values.add(number + "");
		values.add(columnID);
		DBProxy.update(con, tableName, sql, values);
	}
	
	/**
	 * 新增商品库存，同时新增商品可用库存，
	 * 适用于
	 * 1：后台手动新增商品库存
	 * 2：订单退货后回收库存
	 * 3：订单退款后回收库存
	 * @param con
	 * @param siteID
	 * @param supplierID
	 * @param stockInTypeID
	 * @param relateID
	 * @param siteManagerUserID
	 * @param userName
	 * @param skus
	 * @return
	 * @throws Exception
	 */
	public static boolean plusFreeStockAndStock(Connection con, String siteID, String supplierID, String stockInTypeID, String relateID,
			String siteManagerUserID, String userName,
			Vector<Hashtable<String, String>> skus) throws Exception {
		boolean res = false;
		if (skus.size() > 0) {
			// 对需要更新的记录进行排序，确保数据库加锁顺序一致，避免死锁
			sortSkus(skus);
			String currentTime = DateTimeUtil.getCurrentDateTime();
			
			Hashtable<String, String> sIBValues = new Hashtable<String, String>();
			String stockInBillID = IndexGenerater.getTableIndex("stockInBill", con);
			sIBValues.put("stockInBillID", stockInBillID);
			sIBValues.put("supplierID", supplierID);
			sIBValues.put("stockInTypeID", stockInTypeID);
			sIBValues.put("relateID", relateID);
			sIBValues.put("siteManagerUserID", siteManagerUserID);
			sIBValues.put("siteManagerUserName", userName);
			sIBValues.put("addTime", currentTime);
			DBProxy.insert(con, "stockInBill", sIBValues);
			
			for (int i = 0; i < skus.size(); i++) { 
				String skuID = skus.get(i).get("skuID");
				String productID = skus.get(i).get("productID");
				String number = skus.get(i).get("updStock");
				String note = skus.get(i).get("updNote") == null ? "" : skus.get(i).get("updNote");
					
				Hashtable<String, String> sIBIValues = new Hashtable<String, String>();
				sIBIValues.put("stockInBillItemID", IndexGenerater.getTableIndex("stockInBillItem", con));
				sIBIValues.put("stockInBillID", stockInBillID);
				sIBIValues.put("productID", productID);
				sIBIValues.put("number", number);
				sIBIValues.put("note", note);
				sIBIValues.put("skuID", skuID);
				Hashtable<String, String> k = new Hashtable<String, String>();
				k.put("skuID", skuID);
				Vector<Hashtable<String, String>> skuDatas = DBProxy.query(con, "sku_V", k);
				if (skuDatas.size() > 0) {
					Hashtable<String, String> skuData = skuDatas.get(0);
					String props = skuData.get("props").toString();
					String showPropsName = PropUtil.getSkuPropName(props, skuData.get("skuPropAlias"), skuData.get("skuPropValueAlias"));
					sIBIValues.put("props", skuData.get("props"));
					sIBIValues.put("propsName", showPropsName);
					DBProxy.insert(con, "stockInBillItem", sIBIValues);
					
					String updateSql1 = " update sku set freeStock = freeStock + " + number + ", stock = stock + " + number + " where skuID = " + skuID;
					int count = DBProxy.update(con, "sku", updateSql1, new Vector<String>());
					if (count > 0) {
						String updateSql = " update product set freeStock = freeStock + " + number + ", stock = stock + " + number + " where productID = " + productID;
						count = DBProxy.update(con, "product", updateSql, new Vector<String>());
						res = count > 0;
						if (!res) {
							return false;
						}
					}
				}
			}
		}
		
		return res;
	}
	
	/**
	 * 减少商品库存，同时减少商品可用库存，
	 * 适用于
	 * 1：后台手动减少商品库存
	 * 2：前台直接下单时候已完成付款（如使用优惠券等支付完成）
	 * @param con
	 * @param siteID
	 * @param supplierID
	 * @param stockInTypeID
	 * @param relateID
	 * @param siteManagerUserID
	 * @param userName
	 * @param skus
	 * @return
	 * @throws Exception
	 */
	public static boolean minFreeStockAndStock(Connection con, String siteID, String supplierID, String stockOutTypeID, String relateID,
			String siteManagerUserID, String userName,
			Vector<Hashtable<String, String>> skus) throws Exception {
		boolean res = false;
		if (skus.size() > 0) {
			// 对需要更新的记录进行排序，确保数据库加锁顺序一致，避免死锁
			sortSkus(skus);
			String currentTime = DateTimeUtil.getCurrentDateTime();
			
			Hashtable<String, String> sIBValues = new Hashtable<String, String>();
			String stockOutBillID = IndexGenerater.getTableIndex("stockOutBill", con);
			sIBValues.put("stockOutBillID", stockOutBillID);
			sIBValues.put("supplierID", supplierID);
			sIBValues.put("stockOutTypeID", stockOutTypeID);
			sIBValues.put("relateID", relateID);
			sIBValues.put("siteManagerUserID", siteManagerUserID);
			sIBValues.put("siteManagerUserName", userName);
			sIBValues.put("addTime", currentTime);
			DBProxy.insert(con, "stockOutBill", sIBValues);
			
			for (int i = 0; i < skus.size(); i++) { 
				String skuID = skus.get(i).get("skuID");
				String productID = skus.get(i).get("productID");
				String number = skus.get(i).get("updStock");
				String note = skus.get(i).get("updNote") == null ? "" : skus.get(i).get("updNote");
					
				Hashtable<String, String> sIBIValues = new Hashtable<String, String>();
				sIBIValues.put("stockOutBillItemID", IndexGenerater.getTableIndex("stockOutBillItem", con));
				sIBIValues.put("stockOutBillID", stockOutBillID);
				sIBIValues.put("productID", productID);
				sIBIValues.put("number", number);
				sIBIValues.put("note", note);
				sIBIValues.put("skuID", skuID);
				Hashtable<String, String> k = new Hashtable<String, String>();
				k.put("skuID", skuID);
				Vector<Hashtable<String, String>> skuDatas = DBProxy.query(con, "sku_V", k);
				if (skuDatas.size() > 0) {
					Hashtable<String, String> skuData = skuDatas.get(0);
					String props = skuData.get("props").toString();
					String showPropsName = PropUtil.getSkuPropName(props, skuData.get("skuPropAlias"), skuData.get("skuPropValueAlias"));
					sIBIValues.put("props", skuData.get("props"));
					sIBIValues.put("propsName", showPropsName);
					DBProxy.insert(con, "stockOutBillItem", sIBIValues);
					
					String updateSql1 = " update sku set freeStock = freeStock - " + number + ", stock = stock - " + number + " where skuID = " + skuID + " and freeStock >= " + number + " and stock >= " + number;
					int count = DBProxy.update(con, "sku", updateSql1, new Vector<String>());
					if (count > 0) {
						String updateSql = " update product set freeStock = freeStock - " + number + ", stock = stock - " + number + " where productID = " + productID + " and freeStock >= " + number + " and stock >= " + number;
						count = DBProxy.update(con, "product", updateSql, new Vector<String>());
						res = count > 0;
						if (!res) {
							return res;
						}
					}
				}
			}
		}
		
		return res;
	}
	
	private static void sortSkus(Vector<Hashtable<String, String>> skus) {
		for (Hashtable<String, String> sku: skus) {
			sku.put("identify", sku.get("productID") + "-" + sku.get("skuID"));
		}
		
		Collections.sort(skus, new ColumnComparator("identify"));
	}
}
