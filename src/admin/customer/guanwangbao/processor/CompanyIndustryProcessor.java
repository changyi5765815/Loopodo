package admin.customer.guanwangbao.processor;

import java.util.Hashtable;
import java.util.Vector;

import simpleWebFrame.config.Module;
import simpleWebFrame.database.DBProxy;
import simpleWebFrame.database.IndexGenerater;
import simpleWebFrame.web.CheckList;
import simpleWebFrame.web.DataHandle;
import simpleWebFrame.web.validate.StringCheckItem;

public class CompanyIndustryProcessor extends BaseProcessor {
	
	public CompanyIndustryProcessor(Module module, DataHandle dataHandle) {
		super(module, dataHandle);
	}	
	public void makeView() throws Exception {
		if(getFormData("action").equals("list")) {
			setJSPData("datas", DBProxy.query(getConnection(), "c_companyIndustry"));
		} else if (getFormData("action").equals("mainProductList")) {
			String companyIndustryID = getFormData("c_companyIndustryID");
			String sql1 = "select * from supplierMainProduct where companyIndustryID = ? and deletedFlag = ?";
			Vector<String> values1 = new Vector<String>();
			values1.add(companyIndustryID);
			values1.add("0");
			Vector<Hashtable< String, String>> datas1 = 
				DBProxy.query(getConnection(), "supplierMainProduct", sql1, values1);
			
			setJSPData("datas1", datas1);
		}
	}
	
	public void defaultViewAction()  throws Exception {
		listAction();
	}
	
	public void companyIndustryAddViewAction() throws Exception {
		String[] items = {"c_companyIndustryID", "c_companyIndustryName"};
		clearDatas(items);
	}
	public void supplierMainProductAddViewAction() throws Exception {
		String companyIndustryID = getFormData("c_companyIndustryID");
		Hashtable<String, String> key = new Hashtable<String, String>();
		key.put("supplierMainProductID", IndexGenerater.getTableIndex("supplierMainProduct", getConnection()));
		key.put("companyIndustryID", companyIndustryID);
		key.put("name", getFormData("data"));
	}
	
	
	public boolean companyIndustryConfirmActionCheck() throws Exception {
		CheckList list = getChecklist();
		list.addCheckItem(new StringCheckItem ("c_companyIndustryName", "主营店铺行业", true));
		boolean result = list.check();
		
		if (!result) {
			return result;
		}else {
			String sql = "select * from c_companyIndustry where c_companyIndustryName = ?";
			Vector<String> sqlKV = new Vector<String>();
			sqlKV.add(getFormData("c_companyIndustryName"));
			
			if (!getFormData("c_companyIndustryID").equals("")) {
			sql += " and c_companyIndustryID != ?";
				sqlKV.add("c_companyIndustryID");
			}
			Vector<Hashtable<String, String>> supplierMainVector = DBProxy.query(getConnection(), "c_companyIndustry", sql, sqlKV);
			
			if (supplierMainVector.size() > 0) {
				setErrorMessage("已经存在这个店铺主营产品!");
				return false;
			} else {
				return true;
			}
			
		}
	}
	
	public void mainProductListAction() throws Exception {
		
	}
	
	public boolean mainProductConfirmActionCheck() throws Exception {
		CheckList list = getChecklist();
		list.addCheckItem(new StringCheckItem ("name", "主营产品名称", true));
		boolean result = list.check();
		
		return result;
	}
	
	public void mainProductConfirmAction() throws Exception {
		String c_companyIndustryID = getFormData("c_companyIndustryID");
		setFormData("companyIndustryID", c_companyIndustryID);
		setFormData("supplierMainProductID", IndexGenerater.getTableIndex("supplierMainProduct", getConnection()));
		DBProxy.insert(getConnection(), "supplierMainProduct", getFormDatas());
		setFormData("action", "mainProductList");
	}
	
	public void companyIndustryConfirmAction() throws Exception {
		confirmValue("c_companyIndustry");
		listAction();
	}
	
	public void companyIndustryEditViewAction() throws Exception {
		getData("c_companyIndustry", DATA_TYPE_TABLE);
	}
	
	public void deleteAction() throws Exception {
		deleteData("c_companyIndustry");
		listAction();
	}
}
