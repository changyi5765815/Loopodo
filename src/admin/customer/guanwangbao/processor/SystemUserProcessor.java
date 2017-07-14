package admin.customer.guanwangbao.processor;

import java.util.Hashtable;

import simpleWebFrame.config.Module;
import simpleWebFrame.database.DBProxy;
import simpleWebFrame.util.MD5Util;
import simpleWebFrame.web.CheckList;
import simpleWebFrame.web.DataHandle;
import simpleWebFrame.web.validate.IntegerCheckItem;
import simpleWebFrame.web.validate.PasswordCheckItem;
import simpleWebFrame.web.validate.StringCheckItem;
import admin.customer.guanwangbao.AppKeys;

public class SystemUserProcessor extends BaseProcessor {
	public SystemUserProcessor(Module module, DataHandle dataHandle) {
		super(module, dataHandle);
	}

	public void makeView() throws Exception {
		String action = getFormData("action");
		if (action.equals("list")) {
			setJSPData("datas", DBProxy.query(getConnection(), "systemUser_V",
					new Hashtable<String, String>()));
		} else {
			setFormData("systemRoleSelect", getSystemRoleSelect());
		}
	}
	
	public void defaultViewAction() throws Exception {
		listAction();
	}
	
	public void addViewAction() throws Exception {
		String[] items = {"systemUserID", "userID", "userName", "systemRoleID", "password", "password2"};
		clearDatas(items);
	}
	
	public void editViewAction() throws Exception {
		getData("systemUser", DATA_TYPE_TABLE);
	}
	
	public void confirmAction() throws Exception {
		if (getFormData("systemUserID").equals("")) {
			setFormData("password", MD5Util.MD5(getFormData("password")));
		}
		confirmValue("systemUser");
		listAction();
	}
	
	public boolean confirmActionCheck() throws Exception {
		CheckList list = getChecklist();
		if (getFormData("systemUserID").equals("")) {
			list.addCheckItem(new StringCheckItem("userID", "用户帐号", true));
			list.addCheckItem(new PasswordCheckItem("password", getFormData("password2"), "密码"));
		}
		list.addCheckItem(new StringCheckItem("userName", "姓名", true));
		list.addCheckItem(new IntegerCheckItem("systemRoleID", "系统角色", true));
		if (list.check()) {
			if (getFormData("systemUserID").equals("")) {
				String extendSql = "";
				if (!getFormData("systemUserID").equals("")) {
					extendSql = " and systemUserID != '" + getFormData("systemUserID") + "'";
				}
				Hashtable<String, String> key = new Hashtable<String, String>();
				key.put("userID", getFormData("userID"));
				if (DBProxy.query(getConnection(), "systemUser", key, extendSql).size() > 0) {
					setErrorMessage("该用户帐号已经存在");
					setFocusItem("userID");
					return false;
				}
			}
		}
		else {
			return false;
		}
		return true;
	}
	
	public String getSystemRoleSelect() throws Exception {
		Hashtable<String, String> key = new Hashtable<String, String>();
		return makeSelectElementString("systemRoleID", DBProxy.query(
				getConnection(), "systemRole", key), "systemRoleID",
				"name", "");
	}
	
	public void resetSystemUserPasswordWindowAction() throws Exception {
	}
	
	public void resetSystemUserPasswordAction() throws Exception {
		CheckList list = getChecklist();
		list.addCheckItem(new PasswordCheckItem("password", getFormData("password2"), "密码"));
		if (!list.check()) {
			return;
		}
		
		Hashtable<String, String> key = new Hashtable<String, String>();
		key.put("systemUserID", getFormData("systemUserID"));
		Hashtable<String, String> value = new Hashtable<String, String>();
		value.put("password", MD5Util.MD5(getFormData("password")));
		DBProxy.update(getConnection(), "systemUser", key, value);
		setFormData(AppKeys.AJAX_RESULT, "alert('密码已重置');closeWindow();");
	}
}
