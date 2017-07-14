package admin.customer.guanwangbao.processor;

import java.util.Hashtable;
import java.util.Vector;

import simpleWebFrame.config.Module;
import simpleWebFrame.database.DBProxy;
import simpleWebFrame.util.StringUtil;
import simpleWebFrame.web.DataHandle;

public class FamousCompanyProcessor extends BaseProcessor {

	public FamousCompanyProcessor(Module module, DataHandle dataHandle) {
		super(module, dataHandle);
	}

	@Override
	public void makeView() throws Exception {
		String action = getFormData("action");
		if ("list".equals(action)) {
			setFormData("q_deletedFlag", "0");
			setFormData("q_famousFlag", "1");
			initPageByQueryDataList("user", getFormDatas(), "datas", "", new Vector<String>(), "order by famousSortIndex, userID desc");
			
		}
		
		if (!"list".equals(action)) {
			setFormData("queryConditionHtml", makeQueryConditionHtml("user"));
		}
	}
	
	public void defaultViewAction() throws Exception  {
		listAction();
	}

	public void editViewAction() throws Exception {
		getData("user", DATA_TYPE_TABLE);
	}
	
	public void deleteAction() throws Exception {
		Hashtable<String, String> k = new Hashtable<String, String>();
		k.put("userID", getFormData("userID"));
		Hashtable<String, String> v = new Hashtable<String, String>();
		v.put("famousFlag", "0");
		DBProxy.update(getConnection(), "user", k, v);
		
		listAction();
	}
	
	public void selectCompanyUserWindowAction() throws Exception {
		setFormData("count", getFormData("windowCount"));
		setFormData("pageCount", getFormData("windowPageCount"));
		setFormData("pageNumber", getFormData("windowPageNumber"));
		setFormData("pageFrom", getFormData("windowPageFrom"));
		setFormData("pageTo", getFormData("windowPageTo"));
		setFormData("pageIndex", getFormData("windowPageIndex"));
		
		setFormData("q_userID", "");
		setFormData("q_companyName", "");
		setFormData("q_deletedFlag", "0");
		setFormData("q_famousFlag", "0");
		setFormData("q_userTypeID", "2");
		initPageByQueryDataList("user", getFormDatas(), "datas", "", new Vector<String>(), "");
		
		setFormData("windowCount", getFormData("count"));
		setFormData("windowPageCount", getFormData("pageCount"));
		setFormData("windowPageNumber", getFormData("pageNumber"));
		setFormData("windowPageFrom", getFormData("pageFrom"));
		setFormData("windowPageTo", getFormData("pageTo"));
		setFormData("windowPageIndex", getFormData("pageIndex"));
	}
	
	public void addCompanyUsersAction() throws Exception {
		String selectedValues = getFormData("selectedValues");
		if (StringUtil.split(selectedValues, ",").length == 0) {
			setAjaxInfoMessage("请选择一个企业");
			return;
		}
		
		String sql = "update user set famousFlag = 1 where userID in (" + selectedValues + ")";
		DBProxy.update(getConnection(), "user", sql, new Vector<String>());
		
		setAjaxJavascript("closeInfoWindow();postModuleAndAction('famousCompany', 'list')");
	}
}
