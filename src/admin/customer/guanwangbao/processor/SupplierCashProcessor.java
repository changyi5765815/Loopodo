package admin.customer.guanwangbao.processor;

import java.util.Hashtable;
import java.util.Vector;

import simpleWebFrame.config.Module;
import simpleWebFrame.database.DBProxy;
import simpleWebFrame.util.DateTimeUtil;
import simpleWebFrame.web.DataHandle;
import admin.customer.guanwangbao.AppKeys;
import admin.customer.guanwangbao.tool.SupplierAmountTool;

public class SupplierCashProcessor extends BaseProcessor {
	public SupplierCashProcessor(Module module, DataHandle dataHandle) {
		super(module, dataHandle);
	}

	public void makeView() throws Exception {
		if (getFormData("action").equals("list")) {
			String sortSql = getFormData(AppKeys.ORDER_SQL);
			if (sortSql.equals("")) {
				sortSql = "order by addTime desc";
			}
			initPageByQueryDataList("supplierCash_V", getFormDatas(), "datas", "", 
					new Vector<String>(), sortSql);
		} 
	}

	public void defaultViewAction() throws Exception {
		listAction();
	}
	
	public void finishSupplierDaKuanWindowAction() throws Exception {
	}
	
	public void finishSupplierDaKuanAction() throws Exception {
		Hashtable<String, String> k = new Hashtable<String, String>();
		k.put("supplierCashID", getFormData("supplierCashID"));
		k.put("status", "1");
		
		Vector<Hashtable<String, String>> supplierCashs = DBProxy.query(getConnection(), "supplierCash", k);
		if (supplierCashs.size() == 0) {
			setAjaxInfoMessage("该提现申请状态不为待打款，无法进行此操作");
			return;
		}
		Hashtable<String, String> supplierCash = supplierCashs.get(0);
		
		Hashtable<String, String> v = new Hashtable<String, String>();
		v.put("note", getFormData("note"));
		v.put("systemUserID", getLoginedUserInfo().get("systemUserID"));
		v.put("systemUserName", getLoginedUserInfo().get("userName"));
		v.put("status", "2");
		v.put("finishTime", DateTimeUtil.getCurrentDateTime());
		int count = DBProxy.update(getConnection(), "supplierCash", k, v);
		
		if (count > 0) {
			SupplierAmountTool.cashingAmount2HasCashAmount(getConnection(), "", supplierCash.get("supplierID"), supplierCash.get("amount"), supplierCash.get("supplierCashID"), getFormData("note"));
			
			setAjaxJavascript("alert('打款完成');closeInfoWindow();postModuleAndAction('supplierCash', 'list')");
		} else {
			setAjaxJavascript("alert('打款失败');closeInfoWindow();postModuleAndAction('supplierCash', 'list')");
		}
	}
}
