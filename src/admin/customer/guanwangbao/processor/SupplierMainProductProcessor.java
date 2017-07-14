package admin.customer.guanwangbao.processor;

import java.util.Hashtable;
import java.util.Vector;

import simpleWebFrame.config.Module;
import simpleWebFrame.database.DBProxy;
import simpleWebFrame.web.CheckList;
import simpleWebFrame.web.DataHandle;
import simpleWebFrame.web.validate.StringCheckItem;

public class SupplierMainProductProcessor extends BaseProcessor {
	public SupplierMainProductProcessor(Module module, DataHandle dataHandle) {
		super(module, dataHandle);
	}
	
	public void makeView() throws Exception {
		if(getFormData("action").equals("list")) {
			setJSPData("datas", DBProxy.query(getConnection(), "supplierMainProduct"));
		}
	}
	
	public void defaultViewAction()  throws Exception {
		listAction();
	}
	
	public void supplierMainProductAddViewAction() throws Exception {
		String[] items = {"supplierMainProductID", "name"};
		clearDatas(items);
	}
	
	public boolean supplierMainProductConfirmActionCheck() throws Exception {
		CheckList list = getChecklist();
		list.addCheckItem(new StringCheckItem ("name", "店铺分类名称", true));
		boolean result = list.check();
		
		if (!result) {
			return result;
		}else {
			String sql = "select * from supplierMainProduct where name = ?";
			Vector<String> sqlKV = new Vector<String>();
			sqlKV.add(getFormData("name"));
			
			if (!getFormData("supplierMainProductID").equals("")) {
			sql += " and supplierMainProductID != ?";
				sqlKV.add("supplierMainProductID");
			}
			Vector<Hashtable<String, String>> supplierMainVector = DBProxy.query(getConnection(), "supplierMainProduct", sql, sqlKV);
			
			if (supplierMainVector.size() > 0) {
				setErrorMessage("已经存在这个店铺主营产品!");
				return false;
			} else {
				return true;
			}
			
		}
	}
	
	public void supplierMainProductConfirmAction() throws Exception {
		confirmValue("supplierMainProduct");
		listAction();
	}
	
	public void supplierMainProductEditViewAction() throws Exception {
		getData("supplierMainProduct", DATA_TYPE_TABLE);
	}
	
	public void supplierMainProductDisableAction() throws Exception {
		changeValidFlag("supplierMainProduct", "0");
	}
	
	public void mainProductEnableAction() throws Exception {
		changeValidFlag("supplierMainProduct", "1");
	}
	
	public void deleteAction() throws Exception {
		deleteData("supplierMainProduct");
		listAction();
	}
}
