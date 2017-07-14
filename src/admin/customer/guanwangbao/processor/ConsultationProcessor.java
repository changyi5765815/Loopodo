package admin.customer.guanwangbao.processor;

import java.util.Hashtable;
import java.util.Vector;

import simpleWebFrame.config.Module;
import simpleWebFrame.database.DBProxy;
import simpleWebFrame.util.DateTimeUtil;
import simpleWebFrame.web.CheckList;
import simpleWebFrame.web.DataHandle;
import simpleWebFrame.web.validate.StringCheckItem;

public class ConsultationProcessor extends BaseProcessor {
	public ConsultationProcessor(Module module, DataHandle dataHandle) {
		super(module, dataHandle);
	}

	public void makeView() throws Exception {
		if(getFormData("action").equals("list")) {
			initPageByQueryDataList("consultation_V", getFormDatas(), "datas", "", new Vector<String>(), "order by replyFlag, postTime desc");
		}
		
	}
	
	public void defaultViewAction() throws Exception {
		listAction();
	}
	public void replyConsultationWindowAction() throws Exception {
		String consultationID = getFormData("consultationID");
		Hashtable<String, String> k = new Hashtable<String, String>();
		k.put("consultationID", consultationID);
		Vector<Hashtable<String, String>> datas = DBProxy.query(getConnection(), "consultation_V", k);
		if(datas.size() == 0) {
			setAjaxJavascript("alert('找不到评论信息！');");
			setReDispath();
			return;
		}
		setFormData(datas.get(0));
	}
	
	public void saveReplyAction() throws Exception {
		CheckList checklist = getChecklist();
		checklist.addCheckItem(new StringCheckItem("replyContent", "回复内容", true));
		if(!checklist.check()) {
			return;
		}
		Hashtable<String, String> values = new Hashtable<String, String>();
		values.put("replyContent", getFormData("replyContent"));
		values.put("replyFlag", "1");
		values.put("replyTime", DateTimeUtil.getCurrentDateTime());
		values.put("siteManagerUserID", getLoginedUserInfo().get("systemUserID"));//TODO
		Hashtable<String, String> keys = new Hashtable<String, String>();
		keys.put("consultationID", getFormData("consultationID"));
		int update = DBProxy.update(getConnection(), "consultation", keys , values);
		if(update == 1) {
			setAjaxJavascript("closeInfoWindow();alert('回复成功');postModuleAndAction('consultation', 'defaultView');");
		} else {
			setAjaxJavascript("closeInfoWindow();alert('回复失败，请稍后再试');");
		}
	}
}
