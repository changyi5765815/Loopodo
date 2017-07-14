package admin.customer.guanwangbao.processor;

import java.util.Hashtable;
import java.util.Vector;

import simpleWebFrame.config.Module;
import simpleWebFrame.database.DBProxy;
import simpleWebFrame.web.DataHandle;
import admin.customer.guanwangbao.LocalDataCache;

public class QuestionFeedBackProcessor extends BaseProcessor {
	public QuestionFeedBackProcessor(Module module, DataHandle dataHandle) {
		super(module, dataHandle);
	}
	
	@Override
	public void makeView() throws Exception {
		 Hashtable<String, String> formDatas = getFormDatas();
		if (getFormData("action").equals("list")) {
			setFormData("q_deletedFlag", "0");
			initPageByQueryDataList("questionFeedBackLog", formDatas, "datas",  
					"", new Vector<String>(), "order by questionFeedBackLogID desc");
			Vector<Hashtable<String, String>> datas = LocalDataCache.getInstance().getTableDatas("c_questionFeedBackLogType");
			Hashtable<String, Hashtable<String, String>> data = new Hashtable<String, Hashtable<String,String>>();
			for(int i = 0; i < datas.size(); i++) {
				Hashtable<String, String> data3 = datas.get(i);
				data.put(data3.get("c_questionFeedBackLogTypeID"), data3);
			}
			setJSPData("data", data);
		}
		
		if (!getFormData("action").equals("list")) {
			setFormData("queryConditionHtml", makeQueryConditionHtml("questionFeedBackLog"));
		}
	}

	public void defaultViewAction() throws Exception {
		listAction();
	}

	public void editViewAction() throws Exception {
		getData("questionFeedBackLog", DATA_TYPE_TABLE);
		Vector<Hashtable<String, String>> datas = LocalDataCache.getInstance().getTableDatas("c_questionFeedBackLogType");
		Hashtable<String, Hashtable<String, String>> data = new Hashtable<String, Hashtable<String,String>>();
		for(int i = 0; i < datas.size(); i++) {
			Hashtable<String, String> data3 = datas.get(i);
			data.put(data3.get("c_questionFeedBackLogTypeID"), data3);
		}
		setJSPData("data", data);
	}

	public void disableAction() throws Exception {
		changeValidFlag("questionFeedBackLog", "0");
	}
	
	public void enableAction() throws Exception {
		changeValidFlag("questionFeedBackLog", "1");
		
	}

	public void deleteQuestionFeedBackLogAction() throws Exception {
		String questionFeedBackLogID = getFormData("questionFeedBackLogID");
		Hashtable<String, String> keys = new Hashtable<String, String>();
		keys.put("questionFeedBackLogID", questionFeedBackLogID);
		Hashtable<String, String> values = new Hashtable<String, String>(); 
		values.put("deletedFlag", "1");
		DBProxy.update(getConnection(), "questionFeedBackLog", keys, values);
		listAction();
	}
}
