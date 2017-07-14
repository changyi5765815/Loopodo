package admin.customer.guanwangbao.processor;

import java.util.Hashtable;
import java.util.Vector;

import admin.customer.guanwangbao.LocalDataCache;
import simpleWebFrame.config.Module;
import simpleWebFrame.database.DBProxy;
import simpleWebFrame.web.CheckList;
import simpleWebFrame.web.DataHandle;
import simpleWebFrame.web.validate.StringCheckItem;

public class SystemRoleProcessor extends BaseProcessor {
	public SystemRoleProcessor(Module module, DataHandle dataHandle) {
		super(module, dataHandle);
	}

	public void makeView() throws Exception {
		String action = getFormData("action");
		if (action.equals("list")) {
			setJSPData("datas", DBProxy.query(getConnection(), "systemRole"));
		}
		else {
			setJSPData("systemModuleDatas", getConstantValues(getConnection(), "c_systemModule"));
		}
	}
	
	public void defaultViewAction() throws Exception {
		setFormData("pageIndex", "");
		listAction();
	}
	
	public void addViewAction() throws Exception {
		String[] items = {"systemRoleID", "name", "selectedValues"};
		clearDatas(items);
	}
	
	public void editViewAction() throws Exception {
		getData("systemRole", DATA_TYPE_TABLE);
	}
	
	public void confirmAction() throws Exception {
		String priority = "";
		Vector<Hashtable<String, String>> bigSystemModules = LocalDataCache.getInstance().getBigSystemModules();
		for (int i = 0; i < bigSystemModules.size(); i++) {
			priority += (getFormData("priority_" + bigSystemModules.get(i).get("c_bigSystemModuleID")) + ",");
		}
		setFormData("priority", priority);
		confirmValue("systemRole");
		listAction();
	}
	
	public boolean confirmActionCheck() throws Exception {
		CheckList list = getChecklist();
		list.addCheckItem(new StringCheckItem("name", "角色名称", true));
		return list.check();
	}
	
}
