package admin.customer.guanwangbao.processor;

import java.util.Hashtable;
import java.util.Vector;

import simpleWebFrame.config.Module;
import simpleWebFrame.database.DBProxy;
import simpleWebFrame.web.CheckList;
import simpleWebFrame.web.DataHandle;
import simpleWebFrame.web.validate.StringCheckItem;

public class BrandProcessor extends BaseProcessor {
	public BrandProcessor (Module module, DataHandle dataHandle) {
		super (module, dataHandle);
	}
	
	public void makeView() throws Exception {
		if (getFormData("action").equals("list")) {
			Hashtable<String, String> k = new Hashtable<String, String>(); 
			k.put("validFlag", "1");
			k.put("deletedFlag", "0");
			Vector<Hashtable<String, String>> datas = DBProxy.query(getConnection(), "brandType", k, "order by sortIndex");
			setFormData("queryBrandTypeSelect", makeSelectElementString("q_brandTypeID", datas, "brandTypeID", "name", ""));
			initPageByQueryDataList("brand", getFormDatas(), "datas", 
					"", new Vector<String>(), "order by brandID desc");
		}
	}
	
	public void defaultViewAction() throws Exception {
		listAction();
	}
	
	public void addViewAction() throws Exception {
		String[] items = {"name", "brandID"};
		clearDatas(items);
	}
	
	public void editViewAction() throws Exception {
		getData("brand", DATA_TYPE_TABLE);
	}
	
	public boolean confirmActionCheck() throws Exception {
		CheckList list = getChecklist();
		list.addCheckItem(new StringCheckItem("name", "品牌名称", true));
		boolean result =  list.check();
		
		if (!result) {
			return result;
		} else {
			String sql = "select * from brand where name = ?";
			Vector<String> sqlKV = new Vector<String>();
			sqlKV.add(getFormData("name"));

			if (!getFormData("brandID").equals("")) {
				sql += " and brandID != ?";
				sqlKV.add(getFormData("brandID"));
			}
			
			Vector<Hashtable<String, String>> brands =  DBProxy.query(getConnection(), "brand", sql, sqlKV);
			
			if (brands.size() > 0) {
				setErrorMessage("已经存在此品牌名称");
				return false;
			} else {
				return true;
			}				
		}
	}
	
	public void confirmAction() throws Exception {
		if (getFormData("brandID").equals("")) {
			setFormData("sellNumber", "0");
		}
		confirmValue("brand");
		
		listAction();
	}
}
