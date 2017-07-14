package admin.customer.guanwangbao.processor;

import java.util.Hashtable;
import java.util.Vector;

import simpleWebFrame.config.Module;
import simpleWebFrame.database.DBProxy;
import simpleWebFrame.web.CheckList;
import simpleWebFrame.web.DataHandle;
import simpleWebFrame.web.validate.IntegerCheckItem;
import simpleWebFrame.web.validate.StringCheckItem;

public class ShopReputationProcessor extends BaseProcessor {
	public ShopReputationProcessor (Module module, DataHandle dataHandle) {
		super (module, dataHandle);
	}
	
	public void makeView() throws Exception {
		if (getFormData("action").equals("list")) {
			Hashtable<String, String> k = new Hashtable<String, String>(); 
			Vector<Hashtable<String, String>> datas = DBProxy.query(getConnection(), "c_shopReputation", k, "order by c_shopReputationValue");
			setJSPData("datas", datas);
		}
	}
	
	public void defaultViewAction() throws Exception {
		listAction();
	}
	
	public void addViewAction() throws Exception {
		String[] items = {"c_shopReputationName", "c_shopReputationID", "c_shopReputationValue"};
		clearDatas(items);
	}
	
	public void editViewAction() throws Exception {
		getData("c_shopReputation", DATA_TYPE_TABLE);
	}
	
	public boolean confirmActionCheck() throws Exception {
		CheckList list = getChecklist();
		list.addCheckItem(new StringCheckItem("c_shopReputationName", "信誉名称", true));
		list.addCheckItem(new IntegerCheckItem("c_shopReputationValue", "信誉值", true));
		boolean result =  list.check();
		
		if (!result) {
			return result;
		} else {
			String sql = "select * from c_shopReputation where c_shopReputationValue = ?";
			Vector<String> sqlKV = new Vector<String>();
			sqlKV.add(getFormData("c_shopReputationValue"));

			if (!getFormData("c_shopReputationID").equals("")) {
				sql += " and c_shopReputationID != ?";
				sqlKV.add(getFormData("c_shopReputationID"));
			}
			
			Vector<Hashtable<String, String>> c_shopReputations =  DBProxy.query(getConnection(), "c_shopReputation", sql, sqlKV);
			
			if (c_shopReputations.size() > 0) {
				setErrorMessage("已经存在此信誉值");
				return false;
			} else {
				return true;
			}				
		}
	}
	
	public void confirmAction() throws Exception {
		confirmValue("c_shopReputation");
		listAction();
	}
	
	public void disableAction() throws Exception {
		changeValidFlag("c_shopReputation", "0");
	}
	
	public void enableAction() throws Exception {
		changeValidFlag("c_shopReputation", "1");
	}
}
