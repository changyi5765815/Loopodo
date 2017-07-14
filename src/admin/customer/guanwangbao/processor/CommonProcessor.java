package admin.customer.guanwangbao.processor;

import java.util.Hashtable;
import java.util.Vector;

import admin.customer.guanwangbao.AppKeys;

import simpleWebFrame.config.Module;
import simpleWebFrame.database.DBProxy;
import simpleWebFrame.util.StringUtil;
import simpleWebFrame.web.DataHandle;

public class CommonProcessor extends BaseProcessor {

	public CommonProcessor(Module module, DataHandle dataHandle) {
		super(module, dataHandle);
	}

	@Override
	public void makeView() throws Exception {
	}
	
	public void selectUserWindowAction() throws Exception {
		setFormData("count", getFormData("windowCount"));
		setFormData("pageCount", getFormData("windowPageCount"));
		setFormData("pageNumber", getFormData("windowPageNumber"));
		setFormData("pageFrom", getFormData("windowPageFrom"));
		setFormData("pageTo", getFormData("windowPageTo"));
		setFormData("pageIndex", getFormData("windowPageIndex"));
		
		setFormData("q_deletedFlag", "0");
		initPageByQueryDataList("user", getFormDatas(), "datas", "mobile is not null", new Vector<String>(), "");
		
		setFormData("windowCount", getFormData("count"));
		setFormData("windowPageCount", getFormData("pageCount"));
		setFormData("windowPageNumber", getFormData("pageNumber"));
		setFormData("windowPageFrom", getFormData("pageFrom"));
		setFormData("windowPageTo", getFormData("pageTo"));
		setFormData("windowPageIndex", getFormData("pageIndex"));
	}
	
	public void selectSupplierWindowAction() throws Exception {
		setFormData("count", getFormData("windowCount"));
		setFormData("pageCount", getFormData("windowPageCount"));
		setFormData("pageNumber", getFormData("windowPageNumber"));
		setFormData("pageFrom", getFormData("windowPageFrom"));
		setFormData("pageTo", getFormData("windowPageTo"));
		setFormData("pageIndex", getFormData("windowPageIndex"));
		
		setFormData("q_deletedFlag", "0");
		setFormData("q_normalFlag", "0");
		setFormData("q_supplierID", getFormData("q_supplierID2"));
		String extendSql = " status !=  " + AppKeys.SUPPLIER_STATUS_WAIT_AUDIT;
		
		initPageByQueryDataList("supplier", getFormDatas(), "datas", extendSql, new Vector<String>(), "");
		
		setFormData("windowCount", getFormData("count"));
		setFormData("windowPageCount", getFormData("pageCount"));
		setFormData("windowPageNumber", getFormData("pageNumber"));
		setFormData("windowPageFrom", getFormData("pageFrom"));
		setFormData("windowPageTo", getFormData("pageTo"));
		setFormData("windowPageIndex", getFormData("pageIndex"));
	}

	public void selectUsersAction() throws Exception {
		String userIDs = getFormData("selectedValues");
		Vector<Hashtable<String, String>> users = new Vector<Hashtable<String,String>>();
		if (StringUtil.split(userIDs, ",").length > 0) {
			String sql = "select * from user where userID in (" + userIDs + ") and mobile is not null and deletedFlag = 0";
			Vector<String> p = new Vector<String>();
			users = DBProxy.query(getConnection(), "user", sql, p);
		}
		
		setJSPData("users", users);
		
		dispatch("card/selectedUsers.jsp");
	}
	
	public void selectInfoWindowAction() throws Exception {
		setFormData("count", getFormData("windowCount"));
		setFormData("pageCount", getFormData("windowPageCount"));
		setFormData("pageNumber", getFormData("windowPageNumber"));
		setFormData("pageFrom", getFormData("windowPageFrom"));
		setFormData("pageTo", getFormData("windowPageTo"));
		setFormData("pageIndex", getFormData("windowPageIndex"));
		
		setFormData("q_validFlag", "1");
		initPageByQueryDataList("info_V", getFormDatas(), "datas");
		
		setFormData("windowCount", getFormData("count"));
		setFormData("windowPageCount", getFormData("pageCount"));
		setFormData("windowPageNumber", getFormData("pageNumber"));
		setFormData("windowPageFrom", getFormData("pageFrom"));
		setFormData("windowPageTo", getFormData("pageTo"));
		setFormData("windowPageIndex", getFormData("pageIndex"));
		
		setFormData("queryInfoTypeSelect", getQueryInfoTypeSelect());
	}
	
	public void selectIconWindowAction() throws Exception {
		
		Hashtable<String, String> k = new Hashtable<String, String>();
		k.put("validFlag", "1");
		k.put("imageTypeID", "1");
		setJSPData("datas", DBProxy.query(getConnection(), "systemImage", k));
	}
	
	public void addLinkWindowAction() throws Exception {
		setFormData("dataAlias", getFormData("old_dataAlias"));
    	setFormData("dataLink", getFormData("old_dataLink"));
    	setFormData("isTarget", getFormData("old_isTarget"));
		
		setFormData("isTargetRadio", makeRadioElementString("isTarget", getConstantValues(getConnection(), 
				"c_yesOrNot"), "c_yesOrNotID", "c_yesOrNotName", ""));
    }
	
}
