package admin.customer.guanwangbao.processor;

import java.util.Hashtable;
import java.util.Vector;

import simpleWebFrame.config.Module;
import simpleWebFrame.database.DBProxy;
import simpleWebFrame.database.IndexGenerater;
import simpleWebFrame.util.DateTimeUtil;
import simpleWebFrame.util.HTMLUtil;
import simpleWebFrame.web.CheckList;
import simpleWebFrame.web.DataHandle;
import simpleWebFrame.web.validate.StringCheckItem;

public class SinglePageProcessor extends BaseProcessor {
	public SinglePageProcessor(Module module, DataHandle dataHandle) {
		super(module, dataHandle);
	}

	public void makeView() throws Exception {
		if (getFormData("action").equals("list")) {
			Hashtable<String, String> key = new Hashtable<String, String>();
			setJSPData("datas", DBProxy.query(getConnection(), "singlePage", key, "order by singlePageID desc"));
		}
	}

	public void defaultViewAction()  throws Exception {
		listAction();
	}
	
	public void addViewAction() throws Exception {
		String[] items = {"singlePageID", "title"};
		clearDatas(items);
		
		if (!getFormData("singlePageTempID").equals("")) {
			Hashtable<String, String> k = new Hashtable<String, String>();
			k.put("singlePageTempID", getFormData("singlePageTempID"));
			Hashtable<String, String> singlePageTemp = DBProxy.query(getConnection(), "singlePageTemp", k).get(0);
			setFormData("title", singlePageTemp.get("title"));
			setFormData("content", singlePageTemp.get("content"));
		}
	}
	
	public void editViewAction() throws Exception {
		Hashtable<String, String> k = new Hashtable<String, String>();
		k.put("singlePageID", getFormData("singlePageID"));
		setFormData(DBProxy.query(getConnection(), "singlePageDetail_V", k).get(0));
	}
	
	public boolean confirmActionCheck() throws Exception {
		CheckList list = getChecklist();
		list.addCheckItem(new StringCheckItem ("title", "名称", true));
		list.addCheckItem(new StringCheckItem ("content", "内容", true));
		return list.check();
		
	}
	
	public void confirmAction() throws Exception {
		String curTime = DateTimeUtil.getCurrentDateTime();
		if (getFormData("singlePageID").equals("")) {
			setFormData("addTime", curTime);
		}
		setFormData("updateTime", curTime);
		
		String contentTxt = HTMLUtil.parseHtml(getFormData("content"));
		setFormData("contentTxt", contentTxt);
		if (getFormData("singlePageID").equals("")) {
			String singlePageID = IndexGenerater.getTableIndex("singlePage", getConnection());
			setFormData("singlePageID", singlePageID);
			setFormData("validFlag", "1");
			DBProxy.insert(getConnection(), "singlePage", getFormDatas());
			DBProxy.insert(getConnection(), "singlePageDetail", getFormDatas());
		} else {
			Hashtable<String, String> k = new Hashtable<String, String>();
			k.put("singlePageID", getFormData("singlePageID"));
			DBProxy.update(getConnection(), "singlePage", k, getFormDatas());
			DBProxy.update(getConnection(), "singlePageDetail", k, getFormDatas());
		}
		
		listAction();
	}
	
	public void selectSinglePageTempWindowAction() throws Exception {
		Vector<Hashtable<String, String>> datas = DBProxy.query(getConnection(), "singlePageTemp");
		setJSPData("datas", datas);
	}
}
