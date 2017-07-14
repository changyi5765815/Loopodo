package admin.customer.guanwangbao.processor;

import admin.customer.guanwangbao.AppKeys;
import admin.customer.guanwangbao.LocalDataCache;
import simpleWebFrame.config.AppConfig;
import simpleWebFrame.config.Module;
import simpleWebFrame.database.EntityCache;
import simpleWebFrame.util.HttpUtil;
import simpleWebFrame.web.ConstantCache;
import simpleWebFrame.web.DataHandle;

public class ReloadCacheProcessor extends BaseProcessor {

	public ReloadCacheProcessor(Module module, DataHandle dataHandle) {
		super(module, dataHandle);
	}

	@Override
	public void makeView() throws Exception {

	}
	
	
	public void reloadCacheAction() throws Exception {
		AppConfig.getInstance().reload();
		EntityCache.getInstance().clear();
		ConstantCache.getInstance().clear();
		LocalDataCache.getInstance().loadData();
		
		String info = "后台缓存已经重置成功;";

		String systemUserID = getLoginedUserInfo().get("systemUserID");
		String password = getLoginedUserInfo().get("password");
		
		String recacheUrl = "/bussinessEntry?module=recache&action=recache&recacheSystemUserID=" 
			+ systemUserID + "&recachePassword=" + password;
		
		String resWWW = HttpUtil.getURLHTMLContent("", 80, "utf-8", "http://" + AppKeys.DOMAIN_WWW + recacheUrl);
		if (resWWW.indexOf("true") != -1) {
			info += "重启前台成功!";
		} else {
			info += "重启前台失败!";
		}
		setInfoMessage(info);
	}

}
