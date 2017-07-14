package admin.customer.guanwangbao.processor;

import java.util.Hashtable;

import simpleWebFrame.config.Module;
import simpleWebFrame.database.DBProxy;
import simpleWebFrame.web.CheckList;
import simpleWebFrame.web.DataHandle;
import simpleWebFrame.web.validate.StringCheckItem;

public class HelpPageTypeProcessor extends BaseProcessor {

	public HelpPageTypeProcessor(Module module, DataHandle dataHandle) {
		super(module, dataHandle);
	}

	
	@Override
	public void makeView() throws Exception {
		if (getFormData("action").equals("list")) {
			setJSPData("datas", DBProxy.query(getConnection(), "helpPageType", new Hashtable<String, String>()));
		} 
	}
	
	public void defaultViewAction() throws Exception {
		listAction();
	}
	
	public void addViewAction() throws Exception {
		String[] items = {"helpPageTypeID"};
		clearDatas(items);
	}
	
	public void editViewAction() throws Exception {
		getData("helpPageType", DATA_TYPE_TABLE);
	}
	
	public boolean confirmActionCheck() throws Exception {
		CheckList list = getChecklist();
		list.addCheckItem(new StringCheckItem("helpPageTypeName", "分组名称", true));

		return list.check();
	}
	
	public void confirmAction() throws Exception {
		confirmValue("helpPageType");
		listAction();
	}
	
	public void disableAction() throws Exception {
		super.disableAction();
	}
	
	public void enableAction() throws Exception {
		super.enableAction();
	}

	public void deleteAction() throws Exception {
		deleteSiteDatas("helpPageType");
		
		Hashtable<String, String> key = new Hashtable<String, String>();
		key.put("helpPageTypeID", getFormData("helpPageTypeID"));
		Hashtable<String, String> value = new Hashtable<String, String>();
		value.put("helpPageTypeID", "");
		DBProxy.update(getConnection(), "helpPage", key, value);
		
		listAction();
	}
}
