package admin.customer.guanwangbao.processor;

import simpleWebFrame.config.Module;
import simpleWebFrame.database.DBProxy;
import simpleWebFrame.web.CheckList;
import simpleWebFrame.web.DataHandle;
import simpleWebFrame.web.validate.DateCheckItem;
import simpleWebFrame.web.validate.DoubleCheckItem;
import simpleWebFrame.web.validate.IntegerCheckItem;
import simpleWebFrame.web.validate.StringCheckItem;

public class AppInfoProcessor extends BaseProcessor {

	public AppInfoProcessor(Module module, DataHandle dataHandle) {
		super(module, dataHandle);
	}

	@Override
	public void makeView() throws Exception {
		if (getFormData("action").equals("list"));
		setJSPData("datas", DBProxy.query(getConnection(), "appInfo"));
	}
	
	public void defaultViewAction() throws Exception {
		listAction();
	}
	
	public void addViewAction() throws Exception {
		String[] items = {"appInfoID"};
		clearDatas(items);
	}
	
	public boolean confirmActionCheck() throws Exception {
		CheckList list = getChecklist();
		list.addCheckItem(new StringCheckItem("name", "应用名称", true));
		list.addCheckItem(new IntegerCheckItem("appTypeID", "客户端类型", true));
		list.addCheckItem(new IntegerCheckItem("userTypeID", "用户类型", true));
		list.addCheckItem(new DateCheckItem("updateDate", "更新日期", true));
		list.addCheckItem(new DoubleCheckItem("versionNumber", "版本号", true));
		return list.check();
	}
	
	public void confirmAction() throws Exception {
		getFormData("appInfoID");
		confirmValue("appInfo");
		listAction();
	}
	
	public void editViewAction() throws Exception {
		getData("appInfo", DATA_TYPE_TABLE);
	}
}
