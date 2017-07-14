package admin.customer.guanwangbao.processor;

import java.util.Hashtable;
import java.util.Vector;

import simpleWebFrame.config.Module;
import simpleWebFrame.web.DataHandle;

public class SystemUserLogProcessor extends BaseProcessor {
	public SystemUserLogProcessor(Module module, DataHandle dataHandle) {
		super(module, dataHandle);
	}

	public void makeView() throws Exception {
		if (getFormData("action").equals("list")) {
			initPageByQueryDataList("systemUserLog", new Hashtable<String, String>(), "datas", "", new Vector<String>(), "order by systemUserLogID desc");
		}
	}
	
	public void defaultViewAction() throws Exception {
		listAction();
	}
	
}
