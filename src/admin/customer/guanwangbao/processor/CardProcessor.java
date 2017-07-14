package admin.customer.guanwangbao.processor;

import java.util.Hashtable;
import java.util.Vector;

import admin.customer.guanwangbao.AppKeys;
import admin.customer.guanwangbao.tool.MessageUtil;

import simpleWebFrame.config.Module;
import simpleWebFrame.database.DBProxy;
import simpleWebFrame.util.StringUtil;
import simpleWebFrame.web.CheckList;
import simpleWebFrame.web.DataHandle;
import simpleWebFrame.web.validate.DateCheckItem;
import simpleWebFrame.web.validate.PriceCheckItem;
import simpleWebFrame.web.validate.StringCheckItem;

public class CardProcessor extends BaseProcessor {
	public CardProcessor(Module module, DataHandle dataHandle) {
		super(module, dataHandle);
	}
	
	public void makeView() throws Exception {
		String action = getFormData("action");
		if (action.equals("list")) {
			initPageByQueryDataList("card_V", getFormDatas(), "datas", 
					"", new Vector<String>(), "order by cardID desc");
		}
		if (!getFormData("action").equals("list")){ 
			setFormData("queryConditionHtml", makeQueryConditionHtml("card_V"));
		}
	}
	
	
	public void defaultViewAction() throws Exception {
		listAction();
	}
	
	public void addViewAction() throws Exception {
		setJSPData("users", new Vector<Hashtable<String, String>>());
	}
	
	public void sendCardToUsersAction() throws Exception {
		CheckList list = getChecklist();
		list.addCheckItem(new StringCheckItem("title", "优惠券名称", true));
		list.addCheckItem(new PriceCheckItem("money", "面值", true));
		list.addCheckItem(new PriceCheckItem("minBuyPrice", "最低消费金额", true));
		list.addCheckItem(new DateCheckItem("deadDate", "失效日期", true));
		if (!list.check()) {
			return;
		}
		
		String userIDs = getFormData("selectedValues");
		Vector<Hashtable<String, String>> users = new Vector<Hashtable<String,String>>();
		if (StringUtil.split(userIDs, ",").length > 0) {
			String sql = "select * from user where userID in (" + userIDs + ") and mobile is not null and deletedFlag = 0";
			Vector<String> p = new Vector<String>();
			users = DBProxy.query(getConnection(), "user", sql, p);
		}
		
		if (users.size() == 0) {
			setAjaxInfoMessage("请选择会员");
			return;
		}
		if (users.size() > 100) {
			setAjaxInfoMessage("一次最多能赠送100个会员");
			return;
		}
		
		String cardTypeID = "1";
		String title = getFormData("title");
		String money = getFormData("money");
		String	 minBuyPrice = getFormData("minBuyPrice");
		String deadDate = getFormData("deadDate");
		String source = AppKeys.CARD_SOURCE_SYSTEM;
		String relateID = "";
		Hashtable<String, String> sendResult = new Hashtable<String, String>();
		sendResult.put("sendStatus", "1");
		for (int i = 0; i < users.size(); ++i) {
			String userID = users.get(i).get("userID");
			String mobile = users.get(i).get("mobile");
			String code = insertCard(getConnection(), cardTypeID, title, money, minBuyPrice, deadDate, userID, source, relateID);
			String[] paras = {"", "（" + title + "）", money, code};
			MessageUtil.insertSmsLog(getConnection(), mobile, AppKeys.SMS_ONLINE_CARD_TEMPID, "3", paras, sendResult, AppKeys.SMSPRICE + "");
		}
		setAjaxJavascript("alert('优惠券群发成功');postModuleAndAction('card', 'list')");
	}
}