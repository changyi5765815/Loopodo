package admin.customer.guanwangbao.processor;

import java.util.Hashtable;

import simpleWebFrame.config.Module;
import simpleWebFrame.database.DBProxy;
import simpleWebFrame.database.IndexGenerater;
import simpleWebFrame.web.CheckList;
import simpleWebFrame.web.DataHandle;
import simpleWebFrame.web.validate.IntegerCheckItem;
import simpleWebFrame.web.validate.StringCheckItem;

public class SkuPropProcessor extends BaseProcessor {

	public SkuPropProcessor(Module module, DataHandle dataHandle) {
		super(module, dataHandle);
	}

	@Override
	public void makeView() throws Exception {
		if (getFormData("action").equals("list")) {
			initPageByQueryDataList("skuProp", getFormDatas(), "datas");
		} else if (getFormData("action").equals("propertiesValueDefaultView")) {
			Hashtable<String, String> key = new Hashtable<String, String>();
			key.put("skuPropID", getFormData("skuPropID"));
			setJSPData("datas", DBProxy.query(getConnection(), "skuPropValue", key));
		}
		
		if (!getFormData("action").equals("list")) {
			setFormData("queryConditionHtml", makeQueryConditionHtml("skuProp"));
		}
	}
	
	public void defaultViewAction() throws Exception {
		listAction();
	}
	
	public void addViewAction() throws Exception {
		String[] items = {"skuPropID"};
		clearDatas(items);
	}
	
	
	public void editViewAction() throws Exception {
		getData("skuProp", DATA_TYPE_TABLE);
	}
	
	public boolean confirmActionCheck() throws Exception {
		CheckList list = getChecklist();
		list.addCheckItem(new StringCheckItem("name", "属性名", true));
		list.addCheckItem(new IntegerCheckItem("allowImageFlag", "是否允许自定义图片", true));
		list.addCheckItem(new IntegerCheckItem("sortIndex", "排序值", false));
		
		if (list.check()) {
			if (getFormData("name").indexOf(",") != -1 || getFormData("name").indexOf(":") != -1) {
				setErrorMessage("属性名不能包含英文,号和英文:号");
				return false;
			}
		}
		return list.check();
	}
	
	public void confirmAction() throws Exception {		
		confirmValue("skuProp");
		listAction();
	}
	
	public void propertiesValueDefaultViewAction() throws Exception {
	}
	
	public void propertiesValueDisableAction() throws Exception {
		changeValidFlag("skuPropValue", "0");
		
		setFormData("action", "propertiesValueDefaultView");
	}
	
	public void propertiesValueEnableAction() throws Exception {
		changeValidFlag("skuPropValue", "1");
		
		setFormData("action", "propertiesValueDefaultView");
	}
	
	public void propertiesValueAddViewAction() throws Exception {
		String[] items = {"skuPropValueID"};
		clearDatas(items);
	}
	
	public void propertiesValueEditViewAction() throws Exception {
		Hashtable<String, String> key = new Hashtable<String, String>();
		key.put("skuPropValueID", getFormData("skuPropValueID"));
		key.put("skuPropID", getFormData("skuPropID"));
		Hashtable<String, String> propertiesValue = DBProxy.query(getConnection(), "skuPropValue", key).get(0);
		setFormData(propertiesValue);
	}
	
	public boolean propertiesValueConfirmActionCheck() throws Exception {
		CheckList list = getChecklist();
		list.addCheckItem(new StringCheckItem("name", "属性值", true));
		list.addCheckItem(new IntegerCheckItem("sortIndex", "排序值", false));
		if (list.check()) {
			if (getFormData("name").indexOf(",") != -1 || getFormData("name").indexOf(":") != -1) {
				setErrorMessage("属性值不能包含英文,号和英文:号");
				return false;
			}
		}
		return list.check();
	}
	
	public void propertiesValueConfirmAction() throws Exception {
		if (!getFormData("skuPropValueID").equals("")) {
			Hashtable<String, String> key = new Hashtable<String, String>();
			key.put("skuPropValueID", getFormData("skuPropValueID"));
			
			DBProxy.update(getConnection(), "skuPropValue", key, getFormDatas());
		} else {
			Hashtable<String, String> values = new Hashtable<String, String>();
			values.put("skuPropValueID", IndexGenerater.getTableIndex("skuPropValue", getConnection()));
			values.put("skuPropID", getFormData("skuPropID"));
			values.put("name", getFormData("name"));
			values.put("validFlag", "1");
			values.put("sortIndex", getFormData("sortIndex"));
			
			DBProxy.insert(getConnection(), "skuPropValue", values);
		}
	
		setFormData("action", "propertiesValueDefaultView");
	}

}
