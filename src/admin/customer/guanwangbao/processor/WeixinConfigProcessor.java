package admin.customer.guanwangbao.processor;

import java.util.Hashtable;
import java.util.Vector;

import admin.customer.guanwangbao.AppKeys;
import admin.customer.guanwangbao.LocalDataCache;

import simpleWebFrame.config.Module;
import simpleWebFrame.database.DBProxy;
import simpleWebFrame.web.CheckList;
import simpleWebFrame.web.DataHandle;
import simpleWebFrame.web.validate.StringCheckItem;
import weixin.popular.api.TokenAPI;
import weixin.popular.bean.Token;

public class WeixinConfigProcessor extends BaseProcessor {

	public WeixinConfigProcessor(Module module, DataHandle dataHandle) {
		super(module, dataHandle);
	}

	public void makeView() throws Exception {
		setFormData("weixinAppID", LocalDataCache.getInstance().getSysConfig("weixinAppID"));
		setFormData("weixinAppSecret", LocalDataCache.getInstance().getSysConfig("weixinAppSecret"));
	}
	
	public void defaultViewAction() throws Exception {
	}
	
	public boolean confirmActionCheck() throws Exception {
		CheckList list = getChecklist();
		list.addCheckItem(new StringCheckItem ("weixinAppID", "AppID", true));
		list.addCheckItem(new StringCheckItem ("weixinAppSecret", "AppSecret", true));
		return list.check();
	}
	
	public void confirmAction() throws Exception {
		
		if (!checkConfig(getFormData("weixinAppID"), getFormData("weixinAppSecret"))) {
			setErrorMessage("无效的AppID");
			return;
		}
		
		Hashtable<String, String> k = new Hashtable<String, String>();
		Hashtable<String, String> v = new Hashtable<String, String>();
		
		k.put("name", "weixinAppID");
		v.put("value", getFormData("weixinAppID"));
		DBProxy.update(getConnection(), "sysConfig", k, v);
		
		k.put("name", "weixinAppSecret");
		v.put("value", getFormData("weixinAppSecret"));
		DBProxy.update(getConnection(), "sysConfig", k, v);
		
		LocalDataCache.getInstance().reloadSysConfig(getConnection());
		
		AppKeys.accessToken = "";
		
		setInfoMessage("保存成功！");
	}
	
	public void clearAction() throws Exception {
		
		String sql = "update sysConfig set value = null where name = ? or name = ?";
		Vector<String> v = new Vector<String>();
		v.add("weixinAppID");
		v.add("weixinAppSecret");
		
		DBProxy.update(getConnection(), "sysConfig", sql, v);
		
		LocalDataCache.getInstance().reloadSysConfig(getConnection());
		
		setInfoMessage("清除成功！");
	}
	
	private boolean checkConfig(String weixinAppID, String weixinAppSecret) {
		Token token = TokenAPI.token(weixinAppID, weixinAppSecret);
		if (token.getAccess_token() != null && !token.getAccess_token().equals("")) {
			return true;
		}
		
		return false;
	}
}
