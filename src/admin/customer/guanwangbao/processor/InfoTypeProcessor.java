package admin.customer.guanwangbao.processor;

import java.util.Hashtable;

import simpleWebFrame.config.Module;
import simpleWebFrame.database.DBProxy;
import simpleWebFrame.web.CheckList;
import simpleWebFrame.web.DataHandle;
import simpleWebFrame.web.validate.StringCheckItem;

public class InfoTypeProcessor extends BaseProcessor {

	public InfoTypeProcessor(Module module, DataHandle dataHandle) {
		super(module, dataHandle);
	}

	
	@Override
	public void makeView() throws Exception {
		if (getFormData("action").equals("list")) {
			Hashtable<String, String> k = new Hashtable<String, String>(); 
			k.put("deletedFlag", "0");
			setJSPData("datas", DBProxy.query(getConnection(), "infoType", k));
		} 
	}
	
	public void defaultViewAction() throws Exception {
		listAction();
	}
	
	public void addViewAction() throws Exception {
		String[] items = {"infoTypeID"};
		clearDatas(items);
	}
	
	public void editViewAction() throws Exception {
		getData("infoType", DATA_TYPE_TABLE);
	}
	
	public boolean confirmActionCheck() throws Exception {
		CheckList list = getChecklist();
		list.addCheckItem(new StringCheckItem("name", "名称", true));
		return list.check();
	}
	
	public void confirmAction() throws Exception {
		confirmValue("infoType");
		listAction();
	}
	
	public void deleteAction() throws Exception {
		Hashtable<String, String> k = new Hashtable<String, String>();
		k.put("infoTypeID", getFormData("infoTypeID"));
		Hashtable<String, String> v = new Hashtable<String, String>();
		v.put("deletedFlag", "1");
		DBProxy.update(getConnection(), "infoType", k, v);
		
		listAction();
	}
}
