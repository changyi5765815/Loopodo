package admin.customer.guanwangbao.processor;

import java.util.Hashtable;
import java.util.Vector;

import simpleWebFrame.config.Module;
import simpleWebFrame.database.DBProxy;
import simpleWebFrame.util.DateTimeUtil;
import simpleWebFrame.web.CheckList;
import simpleWebFrame.web.DataHandle;
import simpleWebFrame.web.validate.IntegerCheckItem;
import simpleWebFrame.web.validate.StringCheckItem;
import admin.customer.guanwangbao.AppKeys;
import admin.customer.guanwangbao.LocalDataCache;
import admin.customer.guanwangbao.tool.ExcelUtils;

public class UserStoreProcessor extends BaseProcessor {
	public UserStoreProcessor(Module module, DataHandle dataHandle) {
		super(module, dataHandle);
	}
	
	public void makeView() throws Exception {
		if (getFormData("action").equals("list")) {
			setFormData("q_deletedFlag", "0");
			setFormData("q_normalFlag", "0");
			String extendSql = "";
			if (getFormData("supplierOptName").equals("waitAudit")) {
				setFormData("q_status", AppKeys.SUPPLIER_STATUS_WAIT_AUDIT);
			} else {
				extendSql = " status !=  " + AppKeys.SUPPLIER_STATUS_WAIT_AUDIT;
			}
			initPageByQueryDataList("supplier", getFormDatas(), "datas", extendSql, new Vector<String>(), "order by sortIndex, supplierID desc");
	
			setFormData("querySupplierStatusSelect", makeSelectElementString("q_status", 
					LocalDataCache.getInstance().getTableDatas("c_supplierStatus"), "c_supplierStatusID",
					"c_supplierStatusName", "", "form-control", true, "", ""));
//			setFormData("querySupplierLevelSelect", makeSelectElementString("q_name", 
//					LocalDataCache.getInstance().getTableDatas("supplierLevel"), "supplierLevelID",
//					"name", "", "form-control", true, "", ""));
			
		}
		
		if (!getFormData("action").equals("list")) { 
			setFormData("queryConditionHtml", makeQueryConditionHtml("supplier"));
		}
	}
	
	public void defaultViewAction() throws Exception {
		listAction();
	}
	
	public void detailViewAction() throws Exception {
		getData("supplier", DATA_TYPE_TABLE);
		
		Hashtable<String, String> key = new Hashtable<String, String>();
		key.put("supplierID", getFormData("supplierID"));
		Vector<Hashtable<String, String>> datas = DBProxy.query(getConnection(), "supplierDetail", key);
		setFormData(datas.get(0));
	}
	
	public void auditSupplierWindowAction() throws Exception {
		getData("supplier", DATA_TYPE_TABLE);
		if (!getFormData("status").equals(AppKeys.SUPPLIER_STATUS_WAIT_AUDIT)) {
			setAjaxInfoMessage("店铺的状态不为[待审核]，无法进行此操作");
			setReDispath();
			return;
		}
	}
	
	public void auditSupplierAction() throws Exception {
		CheckList list = getChecklist();
		list.addCheckItem(new IntegerCheckItem("auditResult", "审核结果", true));
		if (getFormData("auditResult").equals("0")) {
			list.addCheckItem(new StringCheckItem("auditNote", "备注", true));
		}
		
		if (!list.check()) {
			return;
		}
		
		Hashtable<String, String> k = new Hashtable<String, String>();
		k.put("supplierID", getFormData("supplierID"));
		
		Hashtable<String, String> supplier = DBProxy.query(getConnection(), "supplier", k).get(0);
		if (!supplier.get("status").equals(AppKeys.SUPPLIER_STATUS_WAIT_AUDIT)) {
			setAjaxInfoMessage("店铺的状态不为[待审核]，无法进行此操作");
			return;
		}
		
		Hashtable<String, String> v = new Hashtable<String, String>();
		v.put("auditNote", getFormData("auditNote"));
		String status = getFormData("auditResult").equals("1") ? AppKeys.SUPPLIER_STATUS_VALID : AppKeys.SUPPLIER_STATUS_AUDIT_NOTPASS;
		v.put("status", status);
		v.put("auditTime", DateTimeUtil.getCurrentDateTime());
		DBProxy.update(getConnection(), "supplier", k, v);
		
		Hashtable<String, String> userK = new Hashtable<String, String>();
		userK.put("userID", supplier.get("userID"));
		Hashtable<String, String> userV = new Hashtable<String, String>();
		userV.put("supplierStatus", status);
		DBProxy.update(getConnection(), "user", userK, userV);
		
		setAjaxJavascript("alert('审核完成');closeInfoWindow();postModuleAndAction('userStore', 'list')");
	}
	
	public void openAction() throws Exception {
		Hashtable<String, String> k = new Hashtable<String, String>();
		k.put("supplierID", getFormData("supplierID"));
		
		Hashtable<String, String> supplier = DBProxy.query(getConnection(), "supplier", k).get(0);
		if (!supplier.get("status").equals(AppKeys.SUPPLIER_STATUS_UNVALID)) {
			setAjaxInfoMessage("该状态下，无法进行此操作");
			return;
		}
		
		
		Hashtable<String, String> v = new Hashtable<String, String>();
		v.put("status", AppKeys.SUPPLIER_STATUS_VALID);
		DBProxy.update(getConnection(), "supplier", k, v);
		
		Hashtable<String, String> userK = new Hashtable<String, String>();
		userK.put("userID", supplier.get("userID"));
		Hashtable<String, String> userV = new Hashtable<String, String>();
		userV.put("supplierStatus", v.get("status"));
		DBProxy.update(getConnection(), "user", userK, userV);
		
		listAction();
	}
	
	public void closeAction() throws Exception {
		Hashtable<String, String> k = new Hashtable<String, String>();
		k.put("supplierID", getFormData("supplierID"));
		
		Hashtable<String, String> supplier = DBProxy.query(getConnection(), "supplier", k).get(0);
		if (!supplier.get("status").equals(AppKeys.SUPPLIER_STATUS_VALID)) {
			setAjaxInfoMessage("店铺的未上线，无法进行此操作");
			return;
		}
		
		Hashtable<String, String> v = new Hashtable<String, String>();
		v.put("status", AppKeys.SUPPLIER_STATUS_UNVALID);
		DBProxy.update(getConnection(), "supplier", k, v);
		
		Hashtable<String, String> userK = new Hashtable<String, String>();
		userK.put("userID", supplier.get("userID"));
		Hashtable<String, String> userV = new Hashtable<String, String>();
		userV.put("supplierStatus", v.get("status"));
		DBProxy.update(getConnection(), "user", userK, userV);
		
		listAction();
	}
	
	public void deleteSupplierAction() throws Exception {
		Hashtable<String, String> k = new Hashtable<String, String>();
		k.put("supplierID", getFormData("supplierID"));
		
		Hashtable<String, String> supplier = DBProxy.query(getConnection(), "supplier", k).get(0);
		if (!supplier.get("deletedFlag").equals("0")) {
			setAjaxInfoMessage("该店铺已经被删除，无法进行此操作");
			return;
		}
		
		Hashtable<String, String> v = new Hashtable<String, String>();
		v.put("deletedFlag", "1");
		DBProxy.update(getConnection(), "supplier", k, v);
		
		Hashtable<String, String> userK = new Hashtable<String, String>();
		userK.put("userID", supplier.get("userID"));
		Hashtable<String, String> userV = new Hashtable<String, String>();
		userV.put("supplierID", "");
		userV.put("supplierStatus", "");
		DBProxy.update(getConnection(), "user", userK, userV);
		
		listAction();
	}
	
	public void exportAction() throws Exception {
		Vector<String> exportColumnsInfo = new Vector<String>();
		exportColumnsInfo.add("店铺ID-supplierID");
		exportColumnsInfo.add("旺铺名称-name");
		exportColumnsInfo.add("申请时间-applyTime");
		exportColumnsInfo.add("联系人-linkMan");
		exportColumnsInfo.add("联系电话-linkPhone");
		exportColumnsInfo.add("排序-sortIndex");
		exportColumnsInfo.add("状态-statusName");
		
		setFormData("q_deletedFlag", "0");
		setFormData("q_normalFlag", "0");
		String extendSql = " status != 10 ";
		initPageByQueryDataList("supplier", getFormDatas(), "datas", extendSql, new Vector<String>(), "order by sortIndex, supplierID desc");
		
		Vector<Hashtable<String, String>> exportDatas = new Vector<Hashtable<String,String>>();
		
		int pageCount = Integer.parseInt(getFormData("pageCount"));
		Vector<Hashtable<String, String>> firstPageDatas = (Vector<Hashtable<String, String>>) getJSPData("datas");
		exportDatas.addAll(firstPageDatas);
		
		for (int i = 2; i <= pageCount; ++i) {
			setFormData("pageIndex", i + "");
			initPageByQueryDataList("supplier", getFormDatas(), "datas", 
					extendSql, new Vector<String>(), "order by sortIndex, supplierID desc");
			Vector<Hashtable<String, String>> curPageDatas = (Vector<Hashtable<String, String>>) getJSPData("datas");
			exportDatas.addAll(curPageDatas);
		}
		
		dealData(exportDatas);
		
		String fileName = ExcelUtils.export("导出店铺", exportColumnsInfo, exportDatas);
		
		if(fileName == null) {
			setAjaxJavascript("toastr.error('导出失败，请重试');$('#exportBtn').css('display', '');$('#export_watting_Btn').css('display', 'none');");
			return;
		}
		String fileDirName = "default/tmp";
		String downLoadDir = "location.href='/download?dir=" + fileDirName + "&fileName=" + fileName + "'";
		setAjaxJavascript(downLoadDir + ";$('#exportBtn').css('display', '');$('#export_watting_Btn').css('display', 'none');");
	}
	
	private void dealData(Vector<Hashtable<String, String>> datas) {
		for (Hashtable<String, String> data : datas) {
			data.put("statusName", data.get("status").equals("") ? "" : LocalDataCache.getInstance().getTableDataColumnValue("c_supplierStatus", data.get("status"), "c_supplierStatusName"));
		}
	}
	
	public void showIdCardImgWindowAction() throws Exception {
		setFormData("idCardImg", getFormData("idCardImg"));
	}
	
	public void supplierTagWindowAction() throws Exception {
		getData("supplier", DATA_TYPE_TABLE);
	}
	
	public void shopReputationWindowAction() throws Exception {
		getData("supplier", DATA_TYPE_TABLE);
	}
	
	public void confirmShopReputationAction() throws Exception {
		CheckList checklist = getChecklist();
		checklist.addCheckItem(new IntegerCheckItem("value", "信誉值", true));
		if(!checklist.check()) {
			setErrorMessageAndFocusItem();
			return;
		}
		String id = "";
		Vector<Hashtable<String, String>> datas = LocalDataCache.getInstance().getTableDatas("c_shopReputation");
		for(int i = 0; i < datas.size(); i++) {
			Hashtable<String, String> data = datas.get(i);
			if(Integer.valueOf(getFormData("value")) >= Integer.valueOf(data.get("c_shopReputationValue"))) {
				id = data.get("c_shopReputationID");
				break;
			}
		}
		
		Hashtable<String, String> k = new Hashtable<String, String>();
		k.put("supplierID", getFormData("supplierID"));
		Hashtable<String, String> v = new Hashtable<String, String>();
		v.put("reputationValue", getFormData("value"));
		v.put("reputationID", id);
		
		DBProxy.update(getConnection(), "supplier", k, v);
		
		setAjaxJavascript("alert('修改成功');closeInfoWindow();postModuleAndAction('userStore', 'list')");
	}
	
	public void supplierLevelWindowAction() throws Exception {
		getData("supplier", DATA_TYPE_TABLE);
		setFormData("q_supplierLevelID", getFormData("supplierLevelID"));
		setFormData("querySupplierLevelSelect", makeSelectElementString("q_supplierLevelID", 
				LocalDataCache.getInstance().getTableDatas("supplierLevel"), 
				"supplierLevelID", "name", ""));
	}
	
	/**
	 * 修改店铺标签
	 * @throws Exception
	 */
	public void confirmSupplierTagAction() throws Exception {
		Hashtable<String, String> k = new Hashtable<String, String>();
		k.put("supplierID", getFormData("supplierID"));
		Hashtable<String, String> v = new Hashtable<String, String>();
		v.put("supplierTagIDs", getFormData("supplierTagIDs"));
		DBProxy.update(getConnection(), "supplier", k, v);
		
		setAjaxJavascript("alert('修改成功');closeInfoWindow();postModuleAndAction('userStore', 'list')");
	}
	
	/**
	 * 修改店铺等级
	 * @throws Exception
	 */
	public void confirmSupplierLevelAction() throws Exception {
		Hashtable<String, String> k = new Hashtable<String, String>();
		k.put("supplierID", getFormData("supplierID"));
		Hashtable<String, String> v = new Hashtable<String, String>();
		v.put("supplierLevelID", getFormData("q_supplierLevelID"));
		DBProxy.update(getConnection(), "supplier", k, v);
		setAjaxJavascript("alert('修改成功');closeInfoWindow();postModuleAndAction('userStore', 'list')");
	}
	
	public void disableExcellentFlagAction() throws Exception {
		Hashtable<String, String> k = new Hashtable<String, String>();
		k.put("supplierID", getFormData("supplierID"));
		Hashtable<String, String> v = new Hashtable<String, String>();
		v.put("excellentFlag", "0");
		DBProxy.update(getConnection(), "supplier", k, v);
		
		listAction();
	}

	public void enableExcellentFlagAction() throws Exception {
		Hashtable<String, String> k = new Hashtable<String, String>();
		k.put("supplierID", getFormData("supplierID"));
		Hashtable<String, String> v = new Hashtable<String, String>();
		v.put("excellentFlag", "1");
		DBProxy.update(getConnection(), "supplier", k, v);
		
		listAction();
	}
}