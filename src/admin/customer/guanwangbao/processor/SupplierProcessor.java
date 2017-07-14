package admin.customer.guanwangbao.processor;

import simpleWebFrame.config.Module;
import simpleWebFrame.web.CheckList;
import simpleWebFrame.web.DataHandle;
import simpleWebFrame.web.validate.StringCheckItem;

public class SupplierProcessor extends BaseProcessor {
	public SupplierProcessor(Module module, DataHandle dataHandle) {
		super(module, dataHandle);
	}
	
	public void makeView() throws Exception {
		if (getFormData("action").equals("list")) {
			setJSPData("datas", getDatas("supplier"));
		}
	}
	
	public void defaultViewAction() throws Exception {
		listAction();
	}
	
	public void addViewAction() throws Exception {
		String[] fileds = {"supplierID"};
		clearDatas(fileds);
	}
	
	public void editViewAction() throws Exception {
		getData("supplier", DATA_TYPE_TABLE);
	}
	
	public boolean confirmActionCheck() throws Exception {
		CheckList list = getChecklist();
		list.addCheckItem(new StringCheckItem("name", "供应商名称", true));
		return list.check();
	}
	
	public void confirmAction() throws Exception {
		confirmValue("supplier");
		listAction();
	}

}
