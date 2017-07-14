package admin.customer.guanwangbao.processor;

import java.util.Hashtable;
import java.util.Vector;

import admin.customer.guanwangbao.LocalDataCache;

import simpleWebFrame.config.Module;
import simpleWebFrame.database.DBProxy;
import simpleWebFrame.util.MD5Util;
import simpleWebFrame.web.CheckList;
import simpleWebFrame.web.DataHandle;
import simpleWebFrame.web.FrameKeys;
import simpleWebFrame.web.validate.RandomStringCheckItem;

public class AdminLoginProcessor extends BaseProcessor {
	public AdminLoginProcessor(Module module, DataHandle dataHandle) {
		super(module, dataHandle);
	}
	
	public void makeView() throws Exception {
	}
	
	public void defaultViewAction() throws Exception {
		if (isUserLogined()) {
			loginAction();
		}
		else {
			setFormData("adminUserName","");
		}
	}
	
	public void loginAction() throws Exception {
		setControlData("INIT_FUNCTION", "location.href='admin';");
	}
	
	public boolean loginActionCheck() throws Exception {
		CheckList list = getChecklist();
		if(LocalDataCache.getInstance().getSysConfig("useVerifyFlag").equals("1")) {
			list.addCheckItem(new RandomStringCheckItem(
					"randomString", "验证码", (String) getSessionData(FrameKeys.RANDOM_STRING)));
		}
		if (!list.check()) {
			return false;
		}
		
		Hashtable<String, String> key = new Hashtable<String, String>();
		key.put("userID", getFormData("adminUserName"));
		Vector<Hashtable<String, String>> users = DBProxy.query(
				getConnection(), "systemUserValid_V", key);
		if (users.size() > 0) {
			if (!MD5Util.MD5(getFormData("adminPassword")).equals(users.get(0).get("password"))) {
				setErrorMessage("错误的密码");
				setFocusItem("password");
				return false;
			}
			setLoginedUserInfo(users.get(0));
			return true;
		} 
		
		setErrorMessage("错误的用户名");
		setFocusItem("adminUserName");
		return false;
	}
	
	public void logoffAction() {
		removeLoginedUserInfo();
	}
}
