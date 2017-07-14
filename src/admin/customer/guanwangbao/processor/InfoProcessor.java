package admin.customer.guanwangbao.processor;

import java.util.Hashtable;
import java.util.Vector;

import simpleWebFrame.config.Module;
import simpleWebFrame.database.DBProxy;
import simpleWebFrame.util.DateTimeUtil;
import simpleWebFrame.util.HTMLUtil;
import simpleWebFrame.util.StringUtil;
import simpleWebFrame.web.CheckList;
import simpleWebFrame.web.DataHandle;
import simpleWebFrame.web.validate.IntegerCheckItem;
import simpleWebFrame.web.validate.StringCheckItem;

public class InfoProcessor extends BaseProcessor {

	public InfoProcessor(Module module, DataHandle dataHandle) {
		super(module, dataHandle);
	}

	@Override
	public void makeView() throws Exception {
		if (getFormData("action").equals("list")){
			setFormData("q_deletedFlag", "0");
			String extendSql = "";
			if(getFormData("operationName").equals("0")) {
				extendSql = "supplierID = '0' or supplierID is null";
			} else {
				extendSql = "supplierID != '0'";
			}
			initPageByQueryDataList("info_V", getFormDatas(), "datas", 
					extendSql, new Vector<String>(), "order by infoID desc");
			
			setFormData("queryInfoTypeSelect", getQueryInfoTypeSelect());
			
			setFormData("queryInfoAuditTypeSelect", getQueryInfoAuditTypeSelect());
		} else {
			setFormData("infoTypeSelect", getInfoTypeSelect());
		}
		
		if (!getFormData("action").equals("list")){ 
			setFormData("queryConditionHtml", makeQueryConditionHtml("info_V"));
		}
	}
	
	public void defaultViewAction() throws Exception {
		listAction();
	}
	
	public void addViewAction() throws Exception {
		String[] items = {"infoID", "content"};
		clearDatas(items);
	}
	
	public void tjDisableAction() throws Exception {
		Hashtable<String, String> k = new Hashtable<String, String>();
		k.put("infoID", getFormData("infoID"));
		Hashtable<String, String> v = new Hashtable<String, String>();
		v.put("tjFlag", "0");
		DBProxy.update(getConnection(), "info", k, v);
		
		listAction();
	}
	
	public void tjEnableAction() throws Exception {
		Hashtable<String, String> k = new Hashtable<String, String>();
		k.put("infoID", getFormData("infoID"));
		Hashtable<String, String> v = new Hashtable<String, String>();
		v.put("tjFlag", "1");
		DBProxy.update(getConnection(), "info", k, v);
		
		listAction();
	}
	
	public void editViewAction() throws Exception {
		Hashtable<String, String> key = new Hashtable<String, String>();
		key.put("infoID", getFormData("infoID"));
		setFormData(DBProxy.query(getConnection(), "infoDetail_V", key).get(0));
	}
	
	public boolean confirmActionCheck() throws Exception {
		CheckList list = getChecklist();
		list.addCheckItem(new IntegerCheckItem("infoTypeID", "版块", true));
		list.addCheckItem(new StringCheckItem("title", "标题", true));
		return list.check();
	}
	
	public void confirmAction() throws Exception {
		String contentTxt = HTMLUtil.parseHtml(getFormData("content"));
		setFormData("contentTxt", contentTxt);
		
		if (getFormData("infoID").equals("")) {
			setFormData("addTime", DateTimeUtil.getCurrentDateTime());
		}
		
		if (getFormData("infoID").equals("")) {
			setFormData("auditStatus", "20");
			confirmValue("info");
			DBProxy.insert(getConnection(), "infoDetail", getFormDatas());
		} else {
			confirmValue("info");
			
			Hashtable<String, String> key = new Hashtable<String, String>();
			key.put("infoID", getFormData("infoID"));
			DBProxy.update(getConnection(), "infoDetail", key, getFormDatas());
		}
		
		listAction();
	}
	
	public void deleteAction() throws Exception {
		Hashtable<String, String> k = new Hashtable<String, String>();
		k.put("infoID", getFormData("infoID"));
		Hashtable<String, String> v = new Hashtable<String, String>();
		v.put("deletedFlag", "1");
		DBProxy.update(getConnection(), "info", k, v);
		
		listAction();
	}
	
	public void batchUpdateInfoStatusAction() throws Exception {
		String selectedValues = getFormData("selectedValues");
		if(selectedValues.equals("")) {
			setAjaxJavascript("alert('请选择需要审批的文章')");
			return;
		}
		String[] split = StringUtil.split(selectedValues, ",");
		StringBuffer sb = new StringBuffer();
		Vector<String> v = new Vector<String>();
		v.add(getFormData("typeID").equals("1") ? "20" : "30");
		for(int i = 0; i < split.length; i++) {
			String string = split[i];
			sb.append(",").append("?");
			v.add(string);
		}
		String sql = "update info set auditStatus = ? where supplierID != '0' and infoID in(" + sb.toString().substring(1) + ")";
		DBProxy.update(getConnection(), "info", sql, v);
		setAjaxJavascript("alert('操作成功');postModuleAndAction('info', 'list')");
	}
	
}
