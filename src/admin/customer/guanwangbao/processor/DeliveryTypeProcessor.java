package admin.customer.guanwangbao.processor;

import simpleWebFrame.config.Module;
import simpleWebFrame.database.DBProxy;
import simpleWebFrame.web.CheckList;
import simpleWebFrame.web.DataHandle;
import simpleWebFrame.web.validate.StringCheckItem;

public class DeliveryTypeProcessor extends BaseProcessor {

	public DeliveryTypeProcessor(Module module, DataHandle dataHandle) {
		super(module, dataHandle);
	}

	@Override
	public void makeView() throws Exception {
		if (getFormData("action").equals("list")) {
			setJSPData("datas", DBProxy.query(getConnection(), "deliveryType"));
			
		}
	}
	
	public void defaultViewAction() throws Exception {
		listAction();
		
	}
	
	public void deliveryTypeAddViewAction() throws Exception {
		String[]items = {"deliveryTypeID", "name", "deliveryFee", "freeMinTotalPrice"};
		clearDatas(items);
	}
	
	public boolean deliveryTypeConfirmActionCheck() throws Exception {
		CheckList list = getChecklist();
		list.addCheckItem(new StringCheckItem("name", "投递方式名称", true));
		return list.check();
		
	}
	
	public void deliveryTypeConfirmAction() throws Exception {
		confirmValue("deliveryType");
		setFormData("action", "list");
	}
	
	public void deliveryTypeDisableAction() throws Exception {
		changeValidFlag("deliveryType", "0");
	}
	
	public void deliveryTypeEableAction() throws Exception {
		changeValidFlag("deliveryType", "1");
	}
	
	public void deliveryTypeEditViewAction() throws Exception {
		getData("deliveryType", DATA_TYPE_TABLE);
	}
	

}
