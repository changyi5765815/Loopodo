package admin.customer.guanwangbao.processor;

import simpleWebFrame.config.Module;
import simpleWebFrame.web.CheckList;
import simpleWebFrame.web.DataHandle;
import simpleWebFrame.web.validate.StringCheckItem;

public class ProductLevelProcessor extends BaseProcessor {
	public ProductLevelProcessor (Module module, DataHandle dataHandle) {
		super (module, dataHandle);
	}
	
	public void makeView() throws Exception {
		if (getFormData("action").equals("list")) {
			setJSPData("datas", getDatas("productLevel"));
		}
	}
	
	public void defaultViewAction() throws Exception {
		listAction();
	}
	
	public void addViewAction() throws Exception {
		String[] items = {"name", "productLevelID"};
		clearDatas(items);
	}
	
	public void editViewAction() throws Exception {
		getData("productLevel", DATA_TYPE_TABLE);
	}
	
	public boolean confirmActionCheck() throws Exception {
		CheckList list = getChecklist();
		list.addCheckItem(new StringCheckItem("name", "名称", true));
		return  list.check();
	}
	
	public void confirmAction() throws Exception {
		confirmValue("productLevel");
		listAction();
	}
	
	public void deleteAction() throws Exception {
		deleteData("productLevel");
		listAction();
	}
}
