package admin.customer.guanwangbao.processor;

import simpleWebFrame.config.Module;
import simpleWebFrame.database.DBProxy;
import simpleWebFrame.web.CheckList;
import simpleWebFrame.web.DataHandle;
import simpleWebFrame.web.validate.StringCheckItem;

public class KeywordProcessor extends BaseProcessor {

	public KeywordProcessor(Module module, DataHandle dataHandle) {
		super(module, dataHandle);
	}

	public void makeView() throws Exception {
		if (getFormData("action").equals("list")) {
			setJSPData("datas", DBProxy.query(getConnection(), "keyword"));
		}
	}

	public void defaultViewAction()  throws Exception {
		listAction();
	}
	
	public void keywordAddViewAction() throws Exception {
		String[] items = {"keywordID", "name"};
		clearDatas(items);
		
	}
	
	public boolean keywordConfirmActionCheck() throws Exception {
		CheckList list = getChecklist();
		list.addCheckItem(new StringCheckItem ("name", "关键字名称", true));
		return list.check();
		
	}
	
	public void keywordConfirmAction() throws Exception {
		confirmValue("keyword");
		listAction();
	}
	
	public void keywordEditViewAction() throws Exception {
		getData("keyword", DATA_TYPE_TABLE);
	}
	
	public void keywordDisableAction() throws Exception {
		changeValidFlag("keyword", "0");
		
	}
	
	public void keywordEnableAction() throws Exception {
		changeValidFlag("keyword", "1");
	}
	
	public void deleteAction() throws Exception {
		deleteData("keyword");
		listAction();
	}
	
}
