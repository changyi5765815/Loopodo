package admin.customer.guanwangbao.processor;

import java.util.Hashtable;
import java.util.Vector;

import simpleWebFrame.config.Module;
import simpleWebFrame.database.DBProxy;
import simpleWebFrame.util.DateTimeUtil;
import simpleWebFrame.web.CheckList;
import simpleWebFrame.web.DataHandle;
import simpleWebFrame.web.validate.StringCheckItem;
import admin.customer.guanwangbao.AppKeys;
import admin.customer.guanwangbao.LocalDataCache;
import admin.customer.guanwangbao.tool.StockBillTool;
import admin.customer.guanwangbao.tool.SupplierAmountTool;
import admin.customer.guanwangbao.tool.UserMoneyTool;

public class RefundProcessor extends BaseProcessor {

	public RefundProcessor(Module module, DataHandle dataHandle) {
		super(module, dataHandle);
	}
	
	public void makeView() throws Exception {
		String action = getFormData("action");
		if (action.equals("list")) {
			initPageByQueryDataList("refund_V", getFormDatas(), "datas", "", new Vector<String>(), "order by status, refundID desc");
			
			setFormData("queryRefundStatusSelect", makeSelectElementString("q_status", 
					LocalDataCache.getInstance().getTableDatas("c_refundStatus"), "c_refundStatusID", "c_refundStatusName", ""));
			setFormData("queryRefundTypeSelect", makeSelectElementString("q_refundTypeID", 
					LocalDataCache.getInstance().getTableDatas("c_refundType"), "c_refundTypeID", "c_refundTypeName", ""));
		}
		if (!action.equals("list")) { 
			setFormData("queryConditionHtml", makeQueryConditionHtml("refund_V"));
		}
	}
	
	public void defaultViewAction() throws Exception {
		listAction();
	}
	
	public void detailViewAction() throws Exception {
		getData("refund", DATA_TYPE_VIEW);
	}
	
	public void agreeRefundWindowAction() throws Exception {
		getData("refund", DATA_TYPE_VIEW);
	}
	
	public void agreeRefundAction() throws Exception {
		Hashtable<String, String> key = new Hashtable<String, String>();
		key.put("refundID", getFormData("refundID"));
		Hashtable<String, String> refund = DBProxy.query(getConnection(), "refund" , key).get(0);
		if (!"1".equals(refund.get("status"))) {
			setAjaxJavascript("alert('该申请不为未退款状态，不能执行此操作')");
			return;
		}
		
		Hashtable<String, String> k = new Hashtable<String, String>();
		k.put("shopOrderID", refund.get("shopOrderID"));
		Hashtable<String, String> shopOrder = DBProxy.query(getConnection(), "shopOrder", k).get(0);
		
		String status = "2";
		Hashtable<String, String> value = new Hashtable<String, String>();
		value.put("status", status);
		value.put("dealNote", getFormData("dealNote"));
		value.put("dealTime", DateTimeUtil.getCurrentDateTime());
		int count = DBProxy.update(getConnection(), "refund", key, value);
		
		if (count > 0) {
			Hashtable<String, String> shopOrderV = new Hashtable<String, String>();
			shopOrderV.put("refundStatus", "2");
			if (shopOrder.get("rebateFlag").equals("1")) {
				shopOrderV.put("rebateFinishFlag", "9");
				shopOrderV.put("rebateFinishTime", DateTimeUtil.getCurrentDateTime());
			}
			shopOrderV.put("status", AppKeys.ORDER_STATUS_CLOSE);
			int updateRow = DBProxy.update(getConnection(), "shopOrder", k, shopOrderV);
			
			if (updateRow == 1) {
				boolean ziTiFlag = shopOrder.get("ztFlag").equals("1");
				if (!ziTiFlag) {
					Hashtable<String, String> orderProductK = new Hashtable<String, String>();
					orderProductK.put("shopOrderID", refund.get("shopOrderID"));
					orderProductK.put("skuDeletedFlag", "0");
					Vector<Hashtable<String, String>> orderProducts = DBProxy.query(getConnection(), "orderProduct", k);
					Vector<Hashtable<String, String>> skus = new Vector<Hashtable<String,String>>();
					for (int i = 0; i < orderProducts.size(); i++) {
						Hashtable<String, String> skuData = new Hashtable<String, String>();
						skuData.put("productID", orderProducts.get(i).get("productID"));
						skuData.put("skuID", orderProducts.get(i).get("skuID"));
						skuData.put("updStock", orderProducts.get(i).get("number"));
						skuData.put("updNote", orderProducts.get(i).get("skuID") + "_refund_note");
						skus.add(skuData);
					}
					StockBillTool.plusFreeStockAndStock(getConnection(), "", shopOrder.get("supplierID"), "2", shopOrder.get("shopOrderID"), 
							getLoginedUserInfo().get("systemUserID"), getLoginedUserInfo().get("userName"), skus);
				}
				
				if (!shopOrder.get("supplierID").equals("") && !shopOrder.get("payWayID").equals("99")) {
					String supplierAmount = shopOrder.get("supplierAmount");
					SupplierAmountTool.minLockAmount(getConnection(), "", shopOrder.get("supplierID"), 
							supplierAmount, shopOrder.get("shopOrderID"), "");

					Hashtable<String, String> v = new Hashtable<String, String>();
					v.put("supplierAmount", "0.00");
					v.put("supplierAmountFinishFlag", "1");
					DBProxy.update(getConnection(), "shopOrder", k, v);
				}
				if (Float.parseFloat(refund.get("refundToAccountAmount")) > 0.00f) {
					UserMoneyTool.plusUserMoney(getConnection(), refund.get("userID"), refund.get("supplierID"),
							refund.get("refundToAccountAmount"), "2", refund.get("shopOrderID"));
				}
			}
			
		}
		setAjaxJavascript("alert('操作成功！');closeInfoWindow();postModuleAndAction('refund', 'list')");
	}
	
	public void refuseRefundWindowAction() throws Exception {
		getData("refund", DATA_TYPE_VIEW);
	}
	
	public void refuseRefundAction() throws Exception {
		CheckList list = getChecklist();
		list.addCheckItem(new StringCheckItem("dealNote", "原因描述", true, 100));
		if (!list.check()) {
			return;
		}
		Hashtable<String, String> key = new Hashtable<String, String>();
		key.put("refundID", getFormData("refundID"));
		Hashtable<String, String> refund = DBProxy.query(getConnection(), "refund" , key).get(0);
		if (!"0".equals(refund.get("status"))) {
			setAjaxJavascript("alert('该申请不为未退款状态，不能执行此操作')");
			return;
		}
		String status = "9";
		Hashtable<String, String> value = new Hashtable<String, String>();
		value.put("status", status);
		value.put("dealNote", getFormData("dealNote"));
		value.put("dealTime", DateTimeUtil.getCurrentDateTime());
		DBProxy.update(getConnection(), "refund", key, value);
		
		key.remove("refundID");
		key.put("shopOrderID", refund.get("shopOrderID"));
		Hashtable<String, String> shopOrderV = new Hashtable<String, String>();
		shopOrderV.put("refundStatus", "0");
		shopOrderV.put("canRefundAmount", refund.get("refundAmount"));
		DBProxy.update(getConnection(), "shopOrder", key, shopOrderV);
		
		setAjaxJavascript("alert('操作成功！');closeInfoWindow();postModuleAndAction('refund', 'list')");
	}
}
