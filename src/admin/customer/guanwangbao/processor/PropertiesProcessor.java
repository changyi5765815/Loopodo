package admin.customer.guanwangbao.processor;

import java.util.Hashtable;
import java.util.Vector;

import simpleWebFrame.config.Module;
import simpleWebFrame.database.DBProxy;
import simpleWebFrame.database.IndexGenerater;
import simpleWebFrame.web.CheckList;
import simpleWebFrame.web.DataHandle;
import simpleWebFrame.web.validate.IntegerCheckItem;
import simpleWebFrame.web.validate.StringCheckItem;

public class PropertiesProcessor extends BaseProcessor{
	public PropertiesProcessor(Module module, DataHandle dataHandle) {
			super (module, dataHandle);
	}
	
	public void makeView() throws Exception {
		if (getFormData("action").equals("list")) {
			initPageByQueryDataList("properties", getFormDatas(), "datas", "", new Vector<String>(), "order by propertiesID desc");
			setFormData("queryProductTypeSelect", getQueryProductTypeSelect());
		} else if (getFormData("action").equals("addView") 
				|| getFormData("action").equals("confirm") || getFormData("action").equals("editView")) {
			setFormData("productTypeSelect", getProductTypeSelect());
		} else if (getFormData("action").equals("propertiesValueDefaultView")) {
			Hashtable<String, String> key = new Hashtable<String, String>();
			key.put("propertiesID", getFormData("propertiesID"));
			setJSPData("datas", DBProxy.query(getConnection(), "propertiesValue", key, "order by validFlag desc, sortIndex asc"));
		}
		
		if (!getFormData("action").equals("list")) {
			setFormData("queryConditionHtml", makeQueryConditionHtml("properties"));
		}
	}
	
	public void defaultViewAction() throws Exception {
		listAction();
	}
	
	public void addViewAction() throws Exception {
		String[] items = {"propertiesID"};
		clearDatas(items);
	}
	
	public void propertiesValueAddViewAction() throws Exception {
		String[] items = {"propertiesValueID"};
		clearDatas(items);
	}
	
	public boolean confirmActionCheck() throws Exception {
		CheckList list = getChecklist();
		list.addCheckItem(new StringCheckItem("name", "属性名", true));
		list.addCheckItem(new IntegerCheckItem("propTypeID", "类型", true));
		list.addCheckItem(new IntegerCheckItem("salePropFlag", "是否是销售属性", true));
		list.addCheckItem(new IntegerCheckItem("searchPropFlag", "是否是搜索属性", true));
		
		if (list.check()) {
			if (!getFormData("propTypeID").equals("2") && getFormData("salePropFlag").equals("1")) {
				setErrorMessage("只有多选属性才能为销售属性");
				return false;
			}
			if (getFormData("propTypeID").equals("3") && !getFormData("searchPropFlag").equals("0")) {
				setErrorMessage("手动输入属性不能作为搜索属性");
				return false;
			}
			
			if (getFormData("name").indexOf(",") != -1 || getFormData("name").indexOf(":") != -1) {
				setErrorMessage("属性名不能包含,号和:号");
				return false;
			}
		}
		return list.check();
	}
	
	public void confirmAction() throws Exception {		
		confirmValue("properties");
		listAction();
	}
	
	public void editViewAction() throws Exception {
		getData("properties", DATA_TYPE_TABLE);
	}
	
	public void propertiesValueDefaultViewAction() throws Exception {
	}
	
	public boolean propertiesValueConfirmActionCheck() throws Exception {
		CheckList list = getChecklist();
		list.addCheckItem(new StringCheckItem("name", "属性值", true));
		if (list.check()) {
			if (getFormData("name").indexOf(",") != -1 || getFormData("name").indexOf(":") != -1) {
				setErrorMessage("属性值不能包含,号和:号");
				return false;
			}
		}
		return list.check();
	}
	
	public void propertiesValueConfirmAction() throws Exception {
		if (!getFormData("propertiesValueID").equals("")) {
			Hashtable<String, String> key = new Hashtable<String, String>();
			key.put("propertiesValueID", getFormData("propertiesValueID"));
			Hashtable<String, String> value = new Hashtable<String, String>();
			value.put("name", getFormData("name"));
			
			DBProxy.update(getConnection(), "propertiesValue", key, value);
		} else {
			Hashtable<String, String> values = new Hashtable<String, String>();
			values.put("propertiesValueID", IndexGenerater.getTableIndex("propertiesValue", getConnection()));
			values.put("propertiesID", getFormData("propertiesID"));
			values.put("name", getFormData("name"));
			values.put("validFlag", "1");
			values.put("sortIndex", "9999");
			
			DBProxy.insert(getConnection(), "propertiesValue", values);
		}
		setFormData("action", "propertiesValueDefaultView");
	}
	
	public void propertiesValueEditViewAction() throws Exception {
		Hashtable<String, String> key = new Hashtable<String, String>();
		key.put("propertiesValueID", getFormData("propertiesValueID"));
		key.put("propertiesID", getFormData("propertiesID"));
		Hashtable<String, String> propertiesValue = DBProxy.query(getConnection(), "propertiesValue", key).get(0);
		
		setFormData(propertiesValue);
	}
	
	public void propertiesValueDisableAction() throws Exception {
		Hashtable<String, String> key = new Hashtable<String, String>();
		key.put("propertiesValueID", getFormData("propertiesValueID"));
		Hashtable<String, String> value = new Hashtable<String, String>();
		value.put("validFlag", "0");
		DBProxy.update(getConnection(), "propertiesValue", key, value);
		
		setFormData("action", "propertiesValueDefaultView");
	}
	
	public void propertiesValueEnableAction() throws Exception {
		Hashtable<String, String> key = new Hashtable<String, String>();
		key.put("propertiesValueID", getFormData("propertiesValueID"));
		Hashtable<String, String> value = new Hashtable<String, String>();
		value.put("validFlag", "1");
		DBProxy.update(getConnection(), "propertiesValue", key, value);

		setFormData("action", "propertiesValueDefaultView");
	}
}