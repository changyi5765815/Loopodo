package admin.customer.guanwangbao.processor;

import java.math.BigDecimal;
import java.util.Hashtable;
import java.util.Vector;

import simpleWebFrame.config.Module;
import simpleWebFrame.database.DBProxy;
import simpleWebFrame.util.DateTimeUtil;
import simpleWebFrame.util.PriceUtil;
import simpleWebFrame.web.CheckList;
import simpleWebFrame.web.DataHandle;
import simpleWebFrame.web.validate.IntegerCheckItem;
import simpleWebFrame.web.validate.StringCheckItem;
import admin.customer.guanwangbao.AppKeys;
import admin.customer.guanwangbao.AppUtil;
import admin.customer.guanwangbao.LocalDataCache;
import admin.customer.guanwangbao.tool.StockBillTool;
import admin.customer.guanwangbao.tool.SupplierAmountTool;
import admin.customer.guanwangbao.tool.UserMoneyTool;

public class ReturnGoodsProcessor extends BaseProcessor {

	public ReturnGoodsProcessor(Module module, DataHandle dataHandle) {
		super(module, dataHandle);
	}
	
	public void makeView() throws Exception {
		String action = getFormData("action");
		if (action.equals("list")) {
			initPageByQueryDataList("returnGoods_V", getFormDatas(), "datas", "", new Vector<String>(), "order by status, returnGoodsID desc");
			
			setFormData("queryReturnGoodsStatusSelect", makeSelectElementString("q_status", LocalDataCache.getInstance().getTableDatas("c_returnGoodsStatus"),
					"c_returnGoodsStatusID", "c_returnGoodsStatusName", ""));
			
		}
		if (!action.equals("list")) { 
			setFormData("queryCondition", makeQueryConditionHtml("returnGoods_V"));
		}
	}
	
	public void defaultViewAction() throws Exception {
		listAction();
	}
	
	public void detailViewAction() throws Exception {
		getData("returnGoods", DATA_TYPE_VIEW);
	}
	
	public void auditReturnGoodsWindowAction() throws Exception {
		String returnGoodsID = getFormData("returnGoodsID");
		Hashtable<String, String> k = new Hashtable<String, String>();
		k.put("returnGoodsID", returnGoodsID);
		
		Hashtable<String, String> data = 
			DBProxy.query(getConnection(), "returnGoods", k).get(0);
		
		if (!data.get("status").equals("1") || true) {
			setAjaxJavascript("alert('状态不为[待审核],无法进行此操作')");
			return;
		}
	}
	
	/**
	 * 审核
	 * 更新退货单状态
	 * 如果审核不通过，则更新订单项状态为未退货，并更新订单的可退款金额，可退积分以及订单的退货状态
	 * @throws Exception
	 */
	public void auditReturnGoodsAction() throws Exception {
		CheckList list = getChecklist();
		list.addCheckItem(new IntegerCheckItem("auditResult", "审核结果", true));
		if (getFormData("auditResult").equals("0")) {
			list.addCheckItem(new StringCheckItem("auditNote", "审核备注", true));
		}
		if (!list.check()) {
			return;
		}
		String returnGoodsID = getFormData("returnGoodsID");
		Hashtable<String, String> k = new Hashtable<String, String>();
		k.put("returnGoodsID", returnGoodsID);
		
		Hashtable<String, String> returnGoods = 
			DBProxy.query(getConnection(), "returnGoods", k).get(0);
		
		if (!returnGoods.get("status").equals("1")) {
			setAjaxJavascript("alert('状态不为[待审核],无法进行此操作')");
			return;
		}
		
		Hashtable<String, String> v = new Hashtable<String, String>();
		v.put("status", getFormData("auditResult").equals("1") ? "2" : "4");
		v.put("auditResult", getFormData("auditResult"));
		v.put("auditNote", getFormData("auditNote"));
		v.put("auditTime", DateTimeUtil.getCurrentDateTime());
		DBProxy.update(getConnection(), "returnGoods", k, v);
		if (v.get("status").equals("4")) {
			Hashtable<String, String> orderProductK = new Hashtable<String, String>();
			orderProductK.put("orderProductID", returnGoods.get("orderProductID"));
			Hashtable<String, String> orderProductV = new Hashtable<String, String>();
			orderProductV.put("status", "1");
			orderProductV.put("returnNumber", "0");
			DBProxy.update(getConnection(), "orderProduct", orderProductK, orderProductV);
			
			String sql = "update shopOrder set canRefundAmount = canRefundAmount + ?, " +
					"canRefundBankMoney = canRefundBankMoney + ?, "
					+ "canRefundAccountMoney = canRefundAccountMoney + ?, " +
				" returnGoodsStatus = ? where shopOrderID = ?";
			Vector<String> p = new Vector<String>();
			p.add(returnGoods.get("refundAmount"));
			p.add(returnGoods.get("refundToBankAmount"));
			p.add(returnGoods.get("refundToAccountAmount"));
			p.add(AppUtil.getShopOrderReturnGoodsStatus(getConnection(), returnGoods.get("shopOrderID")));
			p.add(returnGoods.get("shopOrderID"));
			DBProxy.update(getConnection(), "shopOrder", sql, p);
		}
		
		setAjaxJavascript("alert('操作成功！');closeInfoWindow();postModuleAndAction('returnGoods', 'list')");
	}
	
	public void confirmReturnGoodsWindowAction() throws Exception {
		String returnGoodsID = getFormData("returnGoodsID");
		Hashtable<String, String> k = new Hashtable<String, String>();
		k.put("returnGoodsID", returnGoodsID);
		
		Hashtable<String, String> data = 
			DBProxy.query(getConnection(), "returnGoods", k).get(0);
		
		if (!data.get("status").equals("3")) {
			setAjaxJavascript("alert('状态不为[待商家收货],无法进行此操作')");
			return;
		}
	}
	
	/**
	 * 收货
	 * 更新退货单状态
	 * 如果拒收，则更新订单项状态为未退货，更新订单的可退款金额，可退积分以及订单的退货状态
	 * @throws Exception
	 */
	public void confirmReturnGoodsAction() throws Exception {
		CheckList list = getChecklist();
		list.addCheckItem(new IntegerCheckItem("confirmResult", "确认结果", true));
		if (getFormData("confirmResult").equals("2")) {
			list.addCheckItem(new StringCheckItem("confirmNote", "备注", true));
		}
		if (!list.check()) {
			return;
		}
		
		String returnGoodsID = getFormData("returnGoodsID");
		Hashtable<String, String> k = new Hashtable<String, String>();
		k.put("returnGoodsID", returnGoodsID);
		
		Hashtable<String, String> returnGoods = 
			DBProxy.query(getConnection(), "returnGoods", k).get(0);
		
		if (!returnGoods.get("status").equals("3")) {
			setAjaxJavascript("alert('状态不为[待商家收货],无法进行此操作')");
			return;
		}
		
		Hashtable<String, String> v = new Hashtable<String, String>();
		v.put("status", getFormData("confirmResult").equals("1") ? "5" : "4");
		v.put("confirmResult", getFormData("confirmResult"));
		v.put("confirmNote", getFormData("confirmNote"));
		v.put("confirmTime", DateTimeUtil.getCurrentDateTime());
		DBProxy.update(getConnection(), "returnGoods", k, v);
		
		if (v.get("status").equals("4")) {
			Hashtable<String, String> orderProductK = new Hashtable<String, String>();
			orderProductK.put("orderProductID", returnGoods.get("orderProductID"));
			Hashtable<String, String> orderProductV = new Hashtable<String, String>();
			orderProductV.put("status", "1");
			orderProductV.put("returnNumber", "0");
			DBProxy.update(getConnection(), "orderProduct", orderProductK, orderProductV);
			
			String sql = "update shopOrder set canRefundAmount = canRefundAmount + ?, " +
					"canRefundBankMoney = canRefundBankMoney + ?, "
					+ "canRefundAccountMoney = canRefundAccountMoney + ?, " +
				" returnGoodsStatus = ? where shopOrderID = ?";
			Vector<String> p = new Vector<String>();
			p.add(returnGoods.get("refundAmount"));
			p.add(returnGoods.get("refundToBankAmount"));
			p.add(returnGoods.get("refundToAccountAmount"));
			p.add(AppUtil.getShopOrderReturnGoodsStatus(getConnection(), returnGoods.get("shopOrderID")));
			p.add(returnGoods.get("shopOrderID"));
			DBProxy.update(getConnection(), "shopOrder", sql, p);
		}
		
		setAjaxJavascript("alert('操作成功！');closeInfoWindow();postModuleAndAction('returnGoods', 'list')");
	}
	
	public void returnGoodsRefundWindowAction() throws Exception {
		getData("returnGoods", DATA_TYPE_VIEW);
	}
	
	/**
	 * 退款
	 * 退款完成更新退货单状态
	 * 退款完成后更新订单的已退款金额，已退还积分以及订单的退货状态
	 * 退款给用户（账户余额的退还到账户余额，网上支付的系统外退款）
	 * 更新订单项的退货状态
	 * @throws Exception
	 */
	public void returnGoodsRefundAction() throws Exception { 
		String returnGoodsID = getFormData("returnGoodsID");
		Hashtable<String, String> k = new Hashtable<String, String>();
		k.put("returnGoodsID", returnGoodsID);
		
		Hashtable<String, String> returnGoods = 
			DBProxy.query(getConnection(), "returnGoods", k).get(0);
		
		Hashtable<String, String> orderProductK = new Hashtable<String, String>();
		orderProductK.put("orderProductID", returnGoods.get("orderProductID"));
		Hashtable<String, String> orderProduct = DBProxy.query(getConnection(), "orderProduct", orderProductK).get(0);
		
		if (!returnGoods.get("status").equals("5")) {
			setAjaxJavascript("alert('状态不为[待退款],无法进行此操作')");
			return;
		}
		
		Hashtable<String, String> v = new Hashtable<String, String>();
		v.put("status", "6");
		v.put("refundTime", DateTimeUtil.getCurrentDateTime());
		int count = DBProxy.update(getConnection(), "returnGoods", k, v);
		if (count > 0) {
			int orderProductTotalReturnNumber = Integer.parseInt(orderProduct.get("returnNumber").equals("") ? "0" : orderProduct.get("returnNumber")) 
			+ Integer.parseInt(returnGoods.get("returnNumber"));
			Hashtable<String, String> orderProductV = new Hashtable<String, String>();
			orderProductV.put("returnNumber", orderProductTotalReturnNumber + "");
			orderProductV.put("refundAmount", returnGoods.get("refundAmount"));
			orderProductV.put("status", (orderProductTotalReturnNumber + "").equals(orderProduct.get("number")) ? "4" : "3");
			DBProxy.update(getConnection(), "orderProduct", orderProductK, orderProductV);
			
			if (orderProduct.get("skuDeletedFlag").equals("0")) {
				Hashtable<String, String> updSku = new Hashtable<String, String>();
				updSku.put("productID", orderProduct.get("productID"));
				updSku.put("skuID", orderProduct.get("skuID"));
				updSku.put("updStock", orderProduct.get("returnNumber"));
				updSku.put("updNote", "订单" + orderProduct.get("shopOrderID") + "退货");
				Vector<Hashtable<String, String>> updSkus = new Vector<Hashtable<String,String>>();
				updSkus.add(updSku);
				StockBillTool.plusFreeStockAndStock(getConnection(), "", returnGoods.get("supplierID"), "2", orderProduct.get("shopOrderID"), "", "", updSkus);
			}
			
			String sql = "update shopOrder set refundAmount = refundAmount + ?, " +
			" returnGoodsStatus = ? where shopOrderID = ?";
			Vector<String> p = new Vector<String>();
			p.add(returnGoods.get("refundAmount"));
			p.add("2");
			p.add(returnGoods.get("shopOrderID"));
			int updateRow = DBProxy.update(getConnection(), "shopOrder", sql, p);
			
			String status = resetShopOrderStatus(returnGoods.get("shopOrderID"));
			
			if (Float.parseFloat(returnGoods.get("refundToAccountAmount")) > 0.00f) {
				UserMoneyTool.plusUserMoney(getConnection(), returnGoods.get("userID"), returnGoods.get("supplierID"),
						returnGoods.get("refundToAccountAmount"), "6", returnGoods.get("shopOrderID"));
			}
			
			if (updateRow == 1 && !returnGoods.get("supplierID").equals("")) {
				Hashtable<String, String> soK = new Hashtable<String, String>();
				soK.put("shopOrderID", orderProduct.get("shopOrderID"));
				Hashtable<String, String> shopOrder = DBProxy.query(getConnection(), "shopOrder", soK).get(0);
				
				BigDecimal totalMinusAmount = new BigDecimal("0");
				BigDecimal refundAmount = new BigDecimal(returnGoods.get("refundAmount"));
				totalMinusAmount = refundAmount;
				String supplierAmount = shopOrder.get("supplierAmount");
				String newSupplierAmount = PriceUtil.minusPrice(supplierAmount, PriceUtil.formatPrice(totalMinusAmount + ""));
				Hashtable<String, String> shopOrderV = new Hashtable<String, String>();
				shopOrderV.put("supplierAmount", newSupplierAmount);
				if (status.equals(AppKeys.ORDER_STATUS_CLOSE)) {
					shopOrderV.put("supplierAmount", "0.00");
					shopOrderV.put("supplierAmountFinishFlag", "1");
				}
				DBProxy.update(getConnection(), "shopOrder", soK, shopOrderV);
				
				SupplierAmountTool.minLockAmount(getConnection(), "", returnGoods.get("supplierID"), totalMinusAmount.toString(), returnGoods.get("orderProductID"), "");
			}
		}
		setAjaxJavascript("alert('操作成功！');closeInfoWindow();postModuleAndAction('returnGoods', 'list')");
	}
}

