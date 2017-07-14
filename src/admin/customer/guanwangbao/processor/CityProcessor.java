package admin.customer.guanwangbao.processor;

import java.util.Hashtable;

import simpleWebFrame.config.Module;
import simpleWebFrame.database.DBProxy;
import simpleWebFrame.web.CheckList;
import simpleWebFrame.web.DataHandle;

import simpleWebFrame.web.validate.StringCheckItem;


public class CityProcessor extends BaseProcessor {
	public CityProcessor(Module module, DataHandle dataHandle) {
		super(module, dataHandle);
	}

	public void makeView() throws Exception {
		if (getFormData("action").equals("list")) {
			setJSPData("datas", DBProxy.query(getConnection(), "province"));
			
		} 
		else if (getFormData("action").equals("cityDefaultView")) {
			Hashtable<String, String> key = new Hashtable<String, String>();
			key.put("provinceID", getFormData("provinceID"));
			setJSPData("datas", DBProxy.query(getConnection(), "city", key));
			
		}
		else if (getFormData("action").equals("townDefaultView")) {
			Hashtable<String, String> key = new Hashtable<String, String>();
			key.put("cityID", getFormData("cityID"));
			setJSPData("datas", DBProxy.query(getConnection(), "town", key));
		}
		
	}
	
	public void defaultViewAction() throws Exception  {
		listAction();
	}
	
	public void provinceAddViewAction() throws Exception {
		String[] items = {"provinceID", "name"};
		clearDatas(items);
		
	}
	
	public boolean provinceConfirmActionCheck() throws Exception {
		CheckList list = getChecklist();
		list.addCheckItem(new StringCheckItem ("name", "省份名称", true));
		return list.check();
		
	}
	
	public void provinceConfirmAction() throws Exception {
		confirmValue("province");
		listAction();
	}
	
	public void provinceEditViewAction() throws Exception {
		getData("province", DATA_TYPE_TABLE);
	}
	
	public void provinceDisableAction() throws Exception {
		changeValidFlag("province", "0");
	}

	public void provinceEnableAction() throws Exception {
		changeValidFlag("province", "1");
	}
	
	public void cityDefaultViewAction() throws Exception  {
		
	}
	
	public void cityAddViewAction() throws Exception {
		String[] items = {"cityID", "name"};
		clearDatas(items);
		
	}
	
	public boolean cityConfirmActionCheck() throws Exception {
		CheckList list = getChecklist();
		list.addCheckItem(new StringCheckItem ("name", "城市名称", true));
		return list.check();
		
	}
	
	public void cityConfirmAction() throws Exception {
		confirmValue("city");
		setFormData("action", "cityDefaultView");
		
	}
	
	public void cityEditViewAction() throws Exception {
		getData("city", DATA_TYPE_TABLE);
		
	}
	
	public void cityDisableAction() throws Exception {
		changeValidFlag("city", "0");
		setFormData("action", "cityDefaultView");
	}
	
	public void cityEnableAction() throws Exception {
		changeValidFlag("city", "1");
		setFormData("action", "cityDefaultView");
		
	}
	
	public void townDefaultViewAction() throws Exception {
		
	}
	
	public void townAddViewAction() throws Exception {
		String[] items = {"townID", "name"};
		clearDatas(items);
		
	}
	
	public boolean townConfirmActionCheck() throws Exception {
		CheckList list = getChecklist();
		list.addCheckItem(new StringCheckItem ("name", "区域名称", true));
		return list.check();
		
	}
	
	public void townConfirmAction() throws Exception {
		confirmValue("town");
		setFormData("action", "townDefaultView");
	}
	
	public void townDisableAction() throws Exception {
		changeValidFlag("town", "0");
		setFormData("action", "townDefaultView");
	}
	
	public void townEnableAction() throws Exception {
		changeValidFlag("town", "1");
		setFormData("action", "townDefaultView");
		
	}
	
	public void townEditViewAction() throws Exception {
		getData("town", DATA_TYPE_TABLE);
		
	}
}
