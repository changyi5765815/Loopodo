package admin.customer.guanwangbao.processor;

import simpleWebFrame.config.AppConfig;
import simpleWebFrame.config.Module;
import simpleWebFrame.database.EntityCache;
import simpleWebFrame.log.AppLogger;
import simpleWebFrame.util.HttpUtil;
import simpleWebFrame.util.StringUtil;
import simpleWebFrame.web.ConstantCache;
import simpleWebFrame.web.DataHandle;
import admin.customer.guanwangbao.AppKeys;
import admin.customer.guanwangbao.LocalDataCache;

public class RecacheProcessor extends BaseProcessor {
	public RecacheProcessor(Module module, DataHandle dataHandle) {
		super(module, dataHandle);
	}
	
	public void makeView() throws Exception {
	}
	
	public void reloadCacheAction() throws Exception {
		AppConfig.getInstance().reload();
		EntityCache.getInstance().clear();
		ConstantCache.getInstance().clear();
		
		LocalDataCache.getInstance().loadData();
		
		StringBuffer sbf = new StringBuffer();
		
		String[] www_HostPort = StringUtil.split(LocalDataCache.getInstance().getSysConfig("www.HostPort"), ",");
		for (int i = 0; i < www_HostPort.length; ++i) {
			String[] host_port = StringUtil.split(www_HostPort[i], ":");
			String host = host_port[0];
			String port = "80";
			if (host_port.length > 1) {
				port = host_port[1];
			}
			String recacheUrl = "http://" + host + ":" + port 
				+ "/bussinessEntry?module=recache&action=reloadLocalCache"
				+ "&recacheSystemUserID=" + getLoginedUserInfo().get("systemUserID") 
				+ "&recachePassword=" + getLoginedUserInfo().get("password");
			try {
				String res = HttpUtil.getURLHTMLContent("", Integer.parseInt(port), "utf-8", recacheUrl);
				if (res.indexOf("true") != -1) {
					String msg = "重启前台" + www_HostPort[i] + "缓存成功;";
					sbf.append(msg);
				} else {
					String msg = "重启前台" + www_HostPort[i] + "缓存失败;";
					sbf.append(msg);
				}
			} catch (Exception e) {
				String msg = "重启前台" + www_HostPort[i] + "缓存失败;";
				sbf.append(msg);
				AppLogger.getInstance().errorLog(msg, e);
			}
		}
		
		String[] wap_HostPort = StringUtil.split(LocalDataCache.getInstance().getSysConfig("wap.HostPort"), ",");
		for (int i = 0; i < wap_HostPort.length; ++i) {
			String[] host_port = StringUtil.split(wap_HostPort[i], ":");
			String host = host_port[0];
			String port = "80";
			if (host_port.length > 1) {
				port = host_port[1];
			}
			String recacheUrl = "http://" + host + ":" + port 
				+ "/bussinessEntry?module=recache&action=reloadLocalCache"
				+ "&recacheSystemUserID=" + getLoginedUserInfo().get("systemUserID") 
				+ "&recachePassword=" + getLoginedUserInfo().get("password");
			try {
				String res = HttpUtil.getURLHTMLContent("", Integer.parseInt(port), "utf-8", recacheUrl);
				if (res.indexOf("true") != -1) {
					String msg = "重启wap前台" + www_HostPort[i] + "缓存成功;";
					sbf.append(msg);
				} else {
					String msg = "重启wap前台" + www_HostPort[i] + "缓存失败;";
					sbf.append(msg);
				}
			} catch (Exception e) {
				String msg = "重启wap前台" + www_HostPort[i] + "缓存失败;";
				sbf.append(msg);
				AppLogger.getInstance().errorLog(msg, e);
			}
		}
		
//		setFormData(AppKeys.AJAX_RESULT, "alert('" + sbf + "');");
//		setAjaxJavascript("alert('" + sbf + "');");
		setInfoMessage(sbf.toString());
	}
}
