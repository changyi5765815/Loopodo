package admin.customer.guanwangbao.processor;

import java.util.Hashtable;
import java.util.Vector;

import simpleWebFrame.config.Module;
import simpleWebFrame.database.DBProxy;
import simpleWebFrame.web.CheckList;
import simpleWebFrame.web.DataHandle;
import simpleWebFrame.web.validate.StringCheckItem;

public class SupplierLevelProcessor extends BaseProcessor {
	public SupplierLevelProcessor(Module module, DataHandle dataHandle) {
		super(module, dataHandle);
	}
	
	public void makeView() throws Exception {
		if (getFormData("action").equals("list")) {
			setJSPData("datas", DBProxy.query(getConnection(), "supplierLevel"));
		}
	}

	public void defaultViewAction()  throws Exception {
		listAction();
	}
	
	public void supplierLevelAddViewAction() throws Exception {
		String[] items = {"supplierLevelID", "name"};
		clearDatas(items);
	}
	
	public boolean supplierLevelConfirmActionCheck() throws Exception {
		CheckList list = getChecklist();
		list.addCheckItem(new StringCheckItem ("name", "关键字名称", true));
		boolean result = list.check();
		
		if (!result) {
		return result;	
		} else {
			String sql = "select * from supplierlevel where name = ?";
			Vector<String> sqlKV = new Vector<String>();
			sqlKV.add(getFormData("name"));
			
			if (!getFormData("supplierLevelID").equals("")) {
				sql += " and supplierLevelID != ?";
				sqlKV.add(getFormData("supplierLevelID"));
			}
			Vector<Hashtable<String, String>> suppVectors = DBProxy.query(getConnection(), "supplierLevel", sql, sqlKV);
			
			if (suppVectors.size() > 0) {
				setErrorMessage("已经存在此店铺等级");
				return false;
			} else {
				return true;
			}
		}
	}
	
	public void supplierLevelConfirmAction() throws Exception {
		confirmValue("supplierLevel");
		listAction();
	}
	
	public void supplierLevelEditViewAction() throws Exception {
		getData("supplierLevel", DATA_TYPE_TABLE);
	}
	
	public void supplierLevelDisableAction() throws Exception {
		changeValidFlag("supplierLevel", "0");
	}
	
	public void supplierLevelEnableAction() throws Exception {
		changeValidFlag("supplierLevel", "1");
	}
	
	public void deleteAction() throws Exception {
		deleteData("supplierLevel");
		listAction();
	}
	

}
