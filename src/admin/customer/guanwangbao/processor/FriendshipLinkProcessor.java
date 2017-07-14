package admin.customer.guanwangbao.processor;

import simpleWebFrame.config.Module;
import simpleWebFrame.web.CheckList;
import simpleWebFrame.web.DataHandle;
import simpleWebFrame.web.validate.StringCheckItem;


public class FriendshipLinkProcessor extends BaseProcessor {
	public FriendshipLinkProcessor(Module module, DataHandle dataHandle) {
		super(module, dataHandle);
	}

	public void makeView() throws Exception {
		if (getFormData("action").equals("list")) {
			initPageByQueryDataList("friendshipLink", getFormDatas(), "datas");
		}
	}
	
	public void defaultViewAction() throws Exception  {
		listAction();
	}
	
	public void addViewAction() throws Exception {
		String[] items = {"friendshipLinkID", "name", "link"};
		clearDatas(items);
	}
	
	public boolean confirmActionCheck() throws Exception {
		CheckList list = getChecklist();
		list.addCheckItem(new StringCheckItem ("friendshipLinkTypeID", "分类", true));
		list.addCheckItem(new StringCheckItem ("name", "名称", true));
		return list.check();
	}
	
	public void confirmAction() throws Exception {
		confirmValue("friendshipLink");
		listAction();
	}
	
	public void editViewAction() throws Exception {
		getData("friendshipLink", DATA_TYPE_TABLE);
	}
}
