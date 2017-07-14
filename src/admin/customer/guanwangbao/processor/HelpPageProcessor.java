package admin.customer.guanwangbao.processor;

import java.util.Hashtable;

import admin.customer.guanwangbao.AppUtil;
import admin.customer.guanwangbao.LocalDataCache;

import simpleWebFrame.config.Module;
import simpleWebFrame.database.DBProxy;
import simpleWebFrame.util.DateTimeUtil;
import simpleWebFrame.util.HTMLUtil;
import simpleWebFrame.web.CheckList;
import simpleWebFrame.web.DataHandle;
import simpleWebFrame.web.validate.IntegerCheckItem;
import simpleWebFrame.web.validate.StringCheckItem;

public class HelpPageProcessor extends BaseProcessor {
	public HelpPageProcessor(Module module, DataHandle dataHandle) {
		super(module, dataHandle);
	}
	
	@Override
	public void makeView() throws Exception {
		if (getFormData("action").equals("list")) { 
			setJSPData("datas", DBProxy.query(getConnection(), "helpPage"));
		} else {
			setFormData("helpPageTypeSelect", makeSelectElementString("helpPageTypeID", 
					LocalDataCache.getInstance().getTableDatas("helpPageType"), "helpPageTypeID", "helpPageTypeName", ""));
		}
	}
	public void defaultViewAction() throws Exception  {
		listAction();
	}
	
	public void deleteAction() throws Exception {
		Hashtable<String, String> key = new Hashtable<String, String>();
		key.put("helpPageID", getFormData("helpPageID"));
				
		DBProxy.delete(getConnection(), "helpPage", key);
		listAction();
	}
	
	public void addViewAction() throws Exception {
		String[] items = {"helpPageID"};
		clearDatas(items);
	}
	
	public void editViewAction() throws Exception {
		getData("helpPage", DATA_TYPE_TABLE);
	}
	
	public boolean confirmActionCheck() throws Exception {
		CheckList list = getChecklist();
		list.addCheckItem(new StringCheckItem("title", "标题", true));
		list.addCheckItem(new IntegerCheckItem("helpPageTypeID", "类型", true));
		list.addCheckItem(new StringCheckItem("content", "内容", true));
		return list.check();
	}
	
	public void confirmAction() throws Exception {
		String contentTxt = HTMLUtil.parseHtml(getFormData("content"));
		setFormData("contentTxt", contentTxt);
		setFormData("wapContent", AppUtil.generateWapHtml(getFormData("content")));
		
		String curTime = DateTimeUtil.getCurrentDateTime();
		if (getFormData("helpPageID").equals("")) {
			setFormData("addTime", curTime);
		}
		setFormData("updateTime", curTime);
		confirmValue("helpPage");
		
		listAction();
	}
}
