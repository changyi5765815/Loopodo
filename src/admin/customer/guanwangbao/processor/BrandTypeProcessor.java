package admin.customer.guanwangbao.processor;

import java.util.Hashtable;
import java.util.Vector;

import simpleWebFrame.config.Module;
import simpleWebFrame.database.DBProxy;
import simpleWebFrame.web.CheckList;
import simpleWebFrame.web.DataHandle;
import simpleWebFrame.web.validate.StringCheckItem;

public class BrandTypeProcessor extends BaseProcessor {
	public BrandTypeProcessor (Module module, DataHandle dataHandle) {
		super (module, dataHandle);
	}
	
	public void makeView() throws Exception {
		if (getFormData("action").equals("list")) {
			Hashtable<String, String> key = new Hashtable<String, String>(); 
			key.put("deletedFlag", "0");
			Vector<Hashtable<String, String>> datas = DBProxy.query(getConnection(), "brandType", key);
			setJSPData("datas", datas);
		}
	}
	
	public void defaultViewAction() throws Exception {
		listAction();
	}
	
	public void addViewAction() throws Exception {
		String[] items = {"name", "brandTypeID"};
		clearDatas(items);
	}
	
	public void editViewAction() throws Exception {
		getData("brandType", DATA_TYPE_TABLE);
	}
	
	public boolean confirmActionCheck() throws Exception {
		CheckList list = getChecklist();
		list.addCheckItem(new StringCheckItem("name", "品牌分类名称", true));
		boolean result =  list.check();
		
		if (!result) {
			return result;
		} else {
			String sql = "select * from brandType where name = ?";
			Vector<String> sqlKV = new Vector<String>();
			sqlKV.add(getFormData("name"));

			if (!getFormData("brandTypeID").equals("")) {
				sql += " and brandTypeID != ?";
				sqlKV.add(getFormData("brandTypeID"));
			}
			
			Vector<Hashtable<String, String>> brandTypes =  DBProxy.query(getConnection(), "brandType", sql, sqlKV);
			
			if (brandTypes.size() > 0) {
				setErrorMessage("已经存在此品牌分类名称");
				return false;
			} else {
				return true;
			}				
		}
	}
	
	public void confirmAction() throws Exception {
		if (getFormData("brandTypeID").equals("")) {
			setFormData("validFlag", "1");
			setFormData("deletedFlag", "0");
		}
		confirmValue("brandType");
		
		listAction();
	}
}
