package admin.customer.guanwangbao.processor;

import java.util.Hashtable;
import java.util.Vector;

import simpleWebFrame.config.Module;
import simpleWebFrame.database.DBProxy;
import simpleWebFrame.web.CheckList;
import simpleWebFrame.web.DataHandle;
import simpleWebFrame.web.FrameKeys;
import simpleWebFrame.web.validate.MailAddressCheckItem;
import simpleWebFrame.web.validate.RandomStringCheckItem;
import simpleWebFrame.web.validate.StringCheckItem;
import admin.customer.guanwangbao.LocalDataCache;
import admin.customer.guanwangbao.tool.Mailer;
public class SysConfigProcessor extends BaseProcessor {
	public SysConfigProcessor(Module module, DataHandle dataHandle) {
		super(module, dataHandle);
	}
	
	public void makeView() throws Exception {
		if (getFormData("action").equals("list")) {
			Vector<Hashtable<String, String>> datas = DBProxy.query(getConnection(), "sysConfig");
			setJSPData("datas", datas);
		}
	}
	
	public void defaultViewAction() throws Exception {
		listAction();
	}
	public void list2Action() throws Exception {
		Vector<Hashtable<String, String>> datas = DBProxy.query(getConnection(), "sysConfig");
		for(Hashtable<String, String> data : datas) {
			setFormData(data.get("name"), data.get("value"));
		}
		String townID = getFormData("serviceTownID");
		if(!townID.equals("")) {
			Hashtable<String, String> town = LocalDataCache.getInstance().getTown(townID);
			setFormData("townID", townID);
			String cityID = town.get("cityID");
			setFormData("cityID", cityID);
			Hashtable<String, String> city = LocalDataCache.getInstance().getCity(cityID);
			String provinceID = city.get("provinceID");
			setFormData("provinceID", provinceID);
		}
		setFormData("selectTown", getCitySelect());
	}
	
	public void list3Action() throws Exception {
		Vector<Hashtable<String, String>> datas = DBProxy.query(getConnection(), "sysConfig");
		for(Hashtable<String, String> data : datas) {
			setFormData(data.get("name"), data.get("value"));
		}
		setFormData("c_smtpHostID", getFormData("mailServer.smtpHost"));
		setFormData("smtpHostSelect", getSmptHostSelect());
	}
	
	public void updateAction() throws Exception {
		listAction();
		
		String name = getFormData("name");
		String value = getFormData(name);
		
		if (name.equals("")) {
			setErrorMessage("请选择要修改的参数!");
			return;
		}
		
		
		Hashtable<String, String> key = new Hashtable<String, String>();
		key.put("name", name);
		Hashtable<String, String> values = new Hashtable<String, String>();
		values.put("value", value);
		
		DBProxy.update(getConnection(), "sysConfig", key, values);
		
		setErrorMessage("更新参数值成功,请重启缓存,切记!");
	}
	
	public void confirmAction() throws Exception {
		Hashtable<String, String> formDatas = getFormDatas();
		for(String key_ : formDatas.keySet()) {
			if(!(key_.equals("qqServiceNum") 
					|| key_.equals("servicePhone")
					|| key_.equals("serviceEmail")
					|| key_.equals("serviceTownID")
					|| key_.equals("serviceAddress")
					|| key_.equals("serviceQrCode")
					|| key_.equals("serviceWeiBolink")
					|| key_.equals("mailServer.smtpHost")
					|| key_.equals("mailServer.userName")
					|| key_.equals("mailServer.password")
					)) continue;
			if(formDatas.get(key_) == null)continue;
			Hashtable<String, String> key = new Hashtable<String, String>();
			key.put("name", key_);
			Hashtable<String, String> values = new Hashtable<String, String>();
			values.put("value", formDatas.get(key_));
			DBProxy.update(getConnection(), "sysConfig", key, values);
		}
		setAjaxJavascript("alert('保存成功！');postModuleAndAction('sysConfig','list2');");
	}
	
	public void confirm2Action() throws Exception {
		Hashtable<String, String> formDatas = getFormDatas();
		for(String key_ : formDatas.keySet()) {
			if(!(key_.equals("mailServer.smtpHost")
					|| key_.equals("mailServer.userName")
					|| key_.equals("mailServer.password")
			)) continue;
			if(formDatas.get(key_) == null)continue;
			Hashtable<String, String> key = new Hashtable<String, String>();
			key.put("name", key_);
			Hashtable<String, String> values = new Hashtable<String, String>();
			values.put("value", formDatas.get(key_));
			DBProxy.update(getConnection(), "sysConfig", key, values);
		}
		setAjaxJavascript("alert('保存成功！');postModuleAndAction('sysConfig','list3');");
	}
	
	public void testSendMailWindowAction() throws Exception {
		CheckList list = getChecklist();
		list.addCheckItem(new StringCheckItem("mailServer.smtpHost", "邮箱类型", true));
		list.addCheckItem(new MailAddressCheckItem("mailServer.userName", "邮箱账号", true));
		list.addCheckItem(new StringCheckItem("mailServer.password", "邮箱密码", true));
		
		if (!list.check()) {
			setReDispath();
			return;
		}
	}
	
	public void testSendMailAction() throws Exception {
		CheckList list = getChecklist();
		list.addCheckItem(new StringCheckItem("mailServer.smtpHost", "邮箱类型", true));
		list.addCheckItem(new MailAddressCheckItem("mailServer.userName", "邮箱账号", true));
		list.addCheckItem(new StringCheckItem("mailServer.password", "邮箱密码", true));
		
		list.addCheckItem(new MailAddressCheckItem("toMail", "收件人", true));
		list.addCheckItem(new StringCheckItem("subject", "邮件标题", true));
		list.addCheckItem(new StringCheckItem("body", "邮件内容", true));
		list.addCheckItem(new RandomStringCheckItem(
				"randomString", "验证码", (String) getSessionData(FrameKeys.RANDOM_STRING)));
		if (!list.check()) {
			return;
		}
		
		String stmpHost = getFormData("mailServer.smtpHost");
		String emaiAccount = getFormData("mailServer.userName");
		String emailPassword = getFormData("mailServer.password");
		
		boolean res = Mailer.sendHtmlMail(stmpHost, emaiAccount, emailPassword, "", getFormData("toMail"), getFormData("subject"), getFormData("body"));
		if (res) {
			setAjaxJavascript("alert('发送邮件成功');closeInfoWindow()");
		} else {
			setAjaxJavascript("alert('发送邮件失败，请检查邮箱类型，邮箱，密码是否填写正确')");
		}
	}
	
	public void sendEmailWindowAction() throws Exception {
		
	}
	
}
