package admin.customer.guanwangbao.processor;

import java.util.Hashtable;
import java.util.Vector;

import admin.customer.guanwangbao.AppKeys;
import admin.customer.guanwangbao.AppUtil;
import admin.customer.guanwangbao.LocalDataCache;
import admin.customer.guanwangbao.weixin.APITool;
import admin.customer.guanwangbao.weixin.Button;

import simpleWebFrame.config.Module;
import simpleWebFrame.log.AppLogger;
import simpleWebFrame.web.CheckList;
import simpleWebFrame.web.DataHandle;
import simpleWebFrame.web.validate.StringCheckItem;

public class WeixinMenuProcessor extends NavigationProcessor {

	public WeixinMenuProcessor(Module module, DataHandle dataHandle) {
		super(module, dataHandle);
	}

	public void makeView() throws Exception {
		Vector<Button> buttons = new Vector<Button>();
		try {
			AppLogger.getInstance().infoLog(LocalDataCache.getInstance().getSysConfig("weixinAppID") + "-" + LocalDataCache.getInstance().getSysConfig("weixinAppSecret"));
			buttons = APITool.getMenu("", LocalDataCache.getInstance().getSysConfig("weixinAppID"), LocalDataCache.getInstance().getSysConfig("weixinAppSecret"));
		} catch (Exception e) {
			AppLogger.getInstance().errorLog("get weixin menu error", e);
		}
		
		setJSPData("buttons", buttons);
	}

	public void defaultViewAction()  throws Exception {
		listAction();
		if (!finishSetWeixinConfig()) {
			setErrorMessage("请先配置微信公众号集成帐号！");
			dispatch("weixinConfig", "defaultView");
		}
	}
	
	public void confirmWeixinMenu() throws Exception {
		Vector<Button> buttons = new Vector<Button>();
		try {
			buttons = APITool.getMenu("", LocalDataCache.getInstance().getSysConfig("weixinAppID"), LocalDataCache.getInstance().getSysConfig("weixinAppSecret"));
		} catch (Exception e) {
			AppLogger.getInstance().errorLog("get weixin menu error", e);
		}
		
		String weixinMenu = APITool.createWeixinMenu(buttons);
		boolean successFlag = APITool.createMenu("", LocalDataCache.getInstance().getSysConfig("weixinAppID"), LocalDataCache.getInstance().getSysConfig("weixinAppSecret"), weixinMenu);
		
		if (successFlag) {
			setErrorMessage("成功发布到微信");
		} else {
			setErrorMessage("发布失败，请重新发布");
		}
		
		listAction();
	}

	public void deleteAction() throws Exception {
		Vector<Button> buttons = new Vector<Button>();
		try {
			buttons = APITool.getMenu("", LocalDataCache.getInstance().getSysConfig("weixinAppID"), LocalDataCache.getInstance().getSysConfig("weixinAppSecret"));
			String selectMenuName = getFormData("selectMenuName");
			
			for (int i = 0; i < buttons.size(); i++) {
				Button b = buttons.get(i);
				if (b.getName().equals(selectMenuName)) {
					buttons.remove(i);
					break;
				}
				for (int j = 0; j < b.getSubButtons().size(); j++) {
					if (b.getSubButtons().get(j).getName().equals(selectMenuName)) {
						b.getSubButtons().remove(j);
						if (b.getSubButtons().size() == 0) {
							b.getData().put("type", "click");
							b.getData().put("key", b.getData().get("name"));
						}
						break;
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		if (buttons.size() == 0) {
			APITool.deleteMenu("", LocalDataCache.getInstance().getSysConfig("weixinAppID"), LocalDataCache.getInstance().getSysConfig("weixinAppSecret"));
		} else {
			String weixinMenu = APITool.createWeixinMenu(buttons);
			boolean successFlag = APITool.createMenu("", LocalDataCache.getInstance().getSysConfig("weixinAppID"), LocalDataCache.getInstance().getSysConfig("weixinAppSecret"), weixinMenu);
			
			if (!successFlag) {
				setErrorMessage("删除失败，稍后请重试！");
			}
		}
		
		
		
		listAction();
	}
	
	public void addWeixinMenuAction() throws Exception {
    	CheckList list = getChecklist();
    	list.addCheckItem(new StringCheckItem("dataAlias", "菜单名", true));
    	list.addCheckItem(new StringCheckItem("dataLink", "链接", true));
    	
    	if(!list.check()) {
    		return;
    	}
    	
    	if (getFormData("dataLink").startsWith("#")) {
    		setInfoMessage("添加不成功，菜单链接不能以#号开头！");
			return;
    	}

		Vector<Button> buttons = new Vector<Button>();
		try {
			buttons = APITool.getMenu("", LocalDataCache.getInstance().getSysConfig("weixinAppID"), LocalDataCache.getInstance().getSysConfig("weixinAppSecret"));
		} catch (Exception e) {
			AppLogger.getInstance().errorLog("get weixin menu error", e);
		}
		
		String navigationTypeID = getFormData("navigationTypeID");
		String name = getFormData("dataAlias");
		String editMenuName = getFormData("editMenuName");
		if (!editMenuName.equals(name)) {
			for (int i = 0; i < buttons.size(); i++) {
				Button b = buttons.get(i);
				if (name.equals(b.getName())) {
					setInfoMessage("添加不成功，有重名菜单！");
					return;
				}
				for (int j = 0; j < b.getSubButtons().size(); j++) {
					if (name.equals(b.getSubButtons().get(j).getName())) {
						setInfoMessage("添加不成功，有重名菜单！");
						return;
					}
				}
			}
		}
		
		if (!editMenuName.equals("")) {
			Hashtable<String, String> data = new Hashtable<String, String>();
			data.put("name", getFormData("dataAlias"));
			if (navigationTypeID.equals("13")) {
				data.put("type", "click");
				data.put("key", getFormData("dataLink"));
			} else {
				data.put("type", "view");
				String url = AppUtil.dealLink(getFormData("dataLink"));
				if (url.startsWith("/")) {
					url = "http://" + AppKeys.DOMAIN_WWW + url;
				} 
				data.put("url", url);
			}
			
			for (int i = 0; i < buttons.size(); i++) {
				Button b = buttons.get(i);
				if (editMenuName.equals(b.getName())) {
					b.setData(data);
					break;
				}
				for (int j = 0; j < b.getSubButtons().size(); j++) {
					if (editMenuName.equals(b.getSubButtons().get(j).getName())) {
						b.getSubButtons().get(j).setData(data);
						break;
					}
				}
			}
		} else {
			Button newButton = new Button();
			Hashtable<String, String> data = new Hashtable<String, String>();
			data.put("name", getFormData("dataAlias"));
			if (navigationTypeID.equals("13")) {
				data.put("type", "click");
				data.put("key", getFormData("dataLink"));
			} else {
				data.put("type", "view");
				String url = AppUtil.dealLink(getFormData("dataLink"));
				if (url.startsWith("/")) {
					url = "http://" + LocalDataCache.getInstance().getSysConfig("domain") + url;
				} 
				data.put("url", url);
			}
			newButton.setData(data);
			
			String parentName = getFormData("selectMenuName");
			if (parentName.equalsIgnoreCase("")) {
				if (buttons.size() >= 3) {
					setAjaxInfoMessage("一级菜单不能超过3个");
					return;
				} else {
					buttons.add(newButton);
				}
			} else {
				for (int i = 0; i < buttons.size(); i++) {
					Button b = buttons.get(i);
					if (b.getName().equals(parentName)) {
						if (b.getSubButtons().size() >= 5) {
							setInfoMessage("该菜单的子菜单数量不能超过5！");
							return;
						} else {
							b.getSubButtons().add(newButton);
							break;
						}
					}
				}
			}
		}
		
		String weixinMenu = APITool.createWeixinMenu(buttons);
		AppLogger.getInstance().infoLog(weixinMenu + "=========");
		boolean successFlag = APITool.createMenu("", LocalDataCache.getInstance().getSysConfig("weixinAppID"), LocalDataCache.getInstance().getSysConfig("weixinAppSecret"), weixinMenu);
		
		if (successFlag) {
			setAjaxJavascript("closeInfoWindow();postModuleAndAction('weixinMenu','list');");
		} else {
			setInfoMessage("发布失败，请稍后重新发布");
			return;
		}
    	
	}
}
