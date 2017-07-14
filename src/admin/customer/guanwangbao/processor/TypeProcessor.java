package admin.customer.guanwangbao.processor;

import java.io.File;
import java.util.Hashtable;

import admin.customer.guanwangbao.AppKeys;
import simpleWebFrame.config.Module;
import simpleWebFrame.database.DBProxy;
import simpleWebFrame.web.CheckList;
import simpleWebFrame.web.DataHandle;
import simpleWebFrame.web.validate.StringCheckItem;

public class TypeProcessor extends BaseProcessor {
	public TypeProcessor(Module module, DataHandle dataHandle) {
		super (module, dataHandle);
	}
	
	public void makeView() throws Exception {
		if (getFormData("action").equals("list")) {
			setJSPData("datas", DBProxy.query(getConnection(), "bigType"));
		} 
	}
	
	public void defaultViewAction() throws Exception {
		listAction();
	}
	
	public void addViewAction() throws Exception {
		String[] items = {"bigTypeID", "name"};
		clearDatas(items);
	}
	
	public boolean confirmActionCheck() throws Exception {
		CheckList list = getChecklist();
		list.addCheckItem(new StringCheckItem("name", "大分类名称", true));
		return list.check();
	}
	
	public void confirmAction() throws Exception {
		
		confirmValue("bigType");
		
		if (!getFormData("bigTypeID").equals("")) {
			String dirName = "product";
			String imageDir = AppKeys.UPLOAD_FILE_PATH + File.separator
							+ dirName + File.separator;
			String bigTypeDir = imageDir + getFormData("bigTypeID");
			File bigTypeFile = new File(bigTypeDir);
			if (!bigTypeFile.exists()) {
				bigTypeFile.mkdirs();
			}
		} 
		
		listAction();
	}
	
	public void editViewAction() throws Exception {
		getData("bigType", DATA_TYPE_TABLE);
		setFormData("selectedValues", getFormData("relatedParameterIDs"));
	}
	
	public void disableAction() throws Exception {
		changeValidFlag("bigType", "0");
	}
	
	public void enableAction() throws Exception {
		changeValidFlag("bigType", "1");
	}
	
	
	
	public void smallTypeDefaultViewAction() throws Exception {
		setFormData("action", "smallTypeDefaultView");
		Hashtable<String, String> key = new Hashtable<String, String>();
		key.put("bigTypeID", getFormData("bigTypeID"));
		setJSPData("datas", DBProxy.query(getConnection(), "smallType", key));
	}
	
	public void smallTypeAddViewAction() throws Exception {
		String[] items = {"name", "smallTypeID"};
		clearDatas(items);
	}
	
	public boolean smallTypeConfirmActionCheck() throws Exception {
		CheckList list = getChecklist();
		list.addCheckItem(new StringCheckItem("name", "小分类名称", true));
		return list.check();
	}
	
	public void smallTypeConfirmAction() throws Exception {
		confirmValue("smallType");
		smallTypeDefaultViewAction();
	}
	
	public void smallTypeEditViewAction() throws Exception {
		getData("smallType", DATA_TYPE_TABLE);
	}
	
	public void smallTypeDisableAction() throws Exception {
		changeValidFlag("smallType", "0", false);
		smallTypeDefaultViewAction();
	}
	
	public void smallTypeEnableAction() throws Exception {
		changeValidFlag("smallType", "1", false);
		smallTypeDefaultViewAction();
	}
	
	
	
	public void tinyTypeDefaultViewAction() throws Exception {
		setFormData("action", "tinyTypeDefaultView");
		Hashtable<String, String> key = new Hashtable<String, String>();
		key.put("smallTypeID", getFormData("smallTypeID"));
		setJSPData("datas", DBProxy.query(getConnection(), "tinyType", key));
	}
	
	public void tinyTypeAddViewAction() throws Exception {
		String[] items = {"name", "tinyTypeID"};
		clearDatas(items);
	}
	
	public boolean tinyTypeConfirmActionCheck() throws Exception {
		CheckList list = getChecklist();
		list.addCheckItem(new StringCheckItem("name", "细分类名称", true));
		return list.check();
	}
	
	public void tinyTypeConfirmAction() throws Exception {
		confirmValue("tinyType");
		tinyTypeDefaultViewAction();
	}
	
	public void tinyTypeEditViewAction() throws Exception {
		getData("tinyType", DATA_TYPE_TABLE);
	}
	
	public void tinyTypeDisableAction() throws Exception {
		changeValidFlag("tinyType", "0", false);
		tinyTypeDefaultViewAction();
	}
	
	public void tinyTypeEnableAction() throws Exception {
		changeValidFlag("tinyType", "1", false);
		tinyTypeDefaultViewAction();
	}
}
