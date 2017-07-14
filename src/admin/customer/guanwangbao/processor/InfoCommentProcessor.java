package admin.customer.guanwangbao.processor;

import java.util.Hashtable;
import java.util.Vector;

import simpleWebFrame.config.Module;
import simpleWebFrame.database.DBProxy;
import simpleWebFrame.web.DataHandle;

public class InfoCommentProcessor extends BaseProcessor {
	public InfoCommentProcessor(Module module, DataHandle dataHandle) {
		super(module, dataHandle);
	}

	public void makeView() throws Exception {
		if(getFormData("action").equals("list")) {
			setFormData("deletedFlag", "0");
			Hashtable<String, String> formDatas = getFormDatas();
			initPageByQueryDataList("infoComment_V", formDatas, "datas", "", 
					new Vector<String>(), "order by infoCommentID desc");
		}
	}
	
	public void defaultViewAction() throws Exception {
		listAction();
	}
	
	public void delInfoCommentAction() throws Exception {
		Hashtable<String, String> keys = new Hashtable<String, String>(); 
		keys.put("infoCommentID", getFormData("infoCommentID"));
		Vector<Hashtable<String, String>> datas = DBProxy.query(getConnection(), "infoComment", keys);
		if(datas.size() > 0) {
			Hashtable<String, String> values = new Hashtable<String, String>();
			values.put("deletedFlag", "1");
			DBProxy.update(getConnection(), "infoComment", keys, values);
			
			String updateInfoComment = "update info set commentCount = commentCount - ? where infoID = ?";
			Vector<String> values2 = new Vector<String>(); 
			values2.add("1");
			values2.add(datas.get(0).get("infoID"));
			DBProxy.update(getConnection(), "info", updateInfoComment, values2);
		}
		listAction();
	}
}
