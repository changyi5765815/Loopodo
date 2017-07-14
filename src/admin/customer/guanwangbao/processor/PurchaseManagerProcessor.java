package admin.customer.guanwangbao.processor;

import java.util.Hashtable;
import java.util.Vector;

import simpleWebFrame.config.Module;
import simpleWebFrame.database.DBProxy;
import simpleWebFrame.database.IndexGenerater;
import simpleWebFrame.util.DateTimeUtil;
import simpleWebFrame.web.CheckList;
import simpleWebFrame.web.DataHandle;
import simpleWebFrame.web.validate.IntegerCheckItem;
import simpleWebFrame.web.validate.MobileCheckItem;
import simpleWebFrame.web.validate.PhoneNumberCheckItem;
import simpleWebFrame.web.validate.PriceCheckItem;
import simpleWebFrame.web.validate.StringCheckItem;

public class PurchaseManagerProcessor extends BaseProcessor {
	public PurchaseManagerProcessor(Module module, DataHandle dataHandle) {
		super(module, dataHandle);
	}
	
	@Override
	public void makeView() throws Exception {
		if (getFormData("action").equals("list")) {
			String q_fromAddTime = getFormData("q_fromAddTime");
			String q_toAddTime = getFormData("q_toAddTime");
			if (!getFormData("q_fromAddTime").equals("")) {
				setFormData("q_fromAddTime", getFormData("q_fromAddTime") + " 00:00:00");
			}
			if (!getFormData("q_toAddTime").equals("")) {
				setFormData("q_toAddTime", getFormData("q_toAddTime") + " 23:59:59");
			}
			setFormData("q_deletedFlag", "0");
			Hashtable<String, String> formDatas = getFormDatas();
			initPageByQueryDataList("purchase", formDatas, "datas", "", 
					new Vector<String>(), "order by purchaseID desc");
			
			setFormData("q_fromAddTime", q_fromAddTime);
			setFormData("q_toAddTime", q_toAddTime);
		} else {
			setFormData("queryConditionHtml", makeQueryConditionHtml("purchase"));
		}
	}

	public void defaultViewAction() throws Exception {
		listAction();
	}
	
	public void editViewAction() throws Exception {
		getData("purchase", DATA_TYPE_TABLE);
		
		Hashtable<String, String> k = new Hashtable<String, String>();
		k.put("purchaseID", getFormData("purchaseID"));
		k.put("deletedFlag", "0");
		Vector<Hashtable<String, String>> purchaseItems = DBProxy.query(getConnection(), "purchaseItem", k);
		setJSPData("purchaseItems", purchaseItems);
	}
	
	public void auditPurchaseWindowAction() throws Exception {
	}
	
	public void auditPurchaseAction() throws Exception {
		CheckList list = getChecklist();
		list.addCheckItem(new IntegerCheckItem("auditStatus", "审核结果", true));
		if (!list.check()) {
			return;
		}
		
		Hashtable<String, String> k = new Hashtable<String, String>();
		k.put("purchaseID", getFormData("purchaseID"));
		k.put("validFlag", "1");
		Vector<Hashtable<String, String>> products = DBProxy.query(getConnection(), "purchase", k);
		if (products.size() == 0) {
			setAjaxInfoMessage("采购单不存在或已删除");
			return;
		}
		
		Hashtable<String, String> purchase = products.get(0);
		if (!purchase.get("auditStatus").equals("0")) {
			setAjaxInfoMessage("采购单审核状态不为[待审核]，无法进行此操作");
			return;
		}
		
		Hashtable<String, String> v = new Hashtable<String, String>();
		v.put("auditStatus", getFormData("auditStatus").equals("1") ? "1" : "2");
		v.put("auditNote", getFormData("auditNote"));
		v.put("auditTime", DateTimeUtil.getCurrentDateTime());
		DBProxy.update(getConnection(), "purchase", k, v);
		
		insertAuditLog("4", getFormData("auditStatus").equals("0") ? "不通过" : "通过", getFormData("auditNote"), purchase.get("purchaseID"));
		
		setAjaxJavascript("closeInfoWindow();postModuleAndAction('purchaseManager', 'list')");
	}
	
	public void deletePurchaseAction() throws Exception {
		Hashtable<String, String> key = new Hashtable<String, String>();
		key.put("purchaseID", getFormData("purchaseID"));
		
		Hashtable<String, String> value = new Hashtable<String, String>();
		value.put("deletedFlag", "1");
		DBProxy.update(getConnection(), "purchase", key, value);
		listAction();
	}
	
	public void addQuoteWindowAction() throws Exception {
	}
	
	public void addQuoteAction() throws Exception {
		CheckList list = getChecklist();
		list.addCheckItem(new PriceCheckItem("price", "价格", true));
		list.addCheckItem(new StringCheckItem("linkMan", "联系人", true));
		list.addCheckItem(new MobileCheckItem("mobile", "手机号码", true));
		list.addCheckItem(new PhoneNumberCheckItem("phone", "电话", false));
		if (!list.check()) {
			return;
		}
		
		Hashtable<String, String> key = new Hashtable<String, String>();
		key.put("purchaseID", getFormData("purchaseID"));
		key.put("auditStatus", "1");
		key.put("validFlag", "1");
		Vector<Hashtable<String, String>> purchases = DBProxy.query(getConnection(), "purchase", key);
		if (purchases.size() == 0) {
			setAjaxInfoMessage("采购单不存在或者审核状态不为[通过]，请刷新页面后重试");
			return;
		}
		
		Hashtable<String, String> purchase = purchases.get(0);
		
		Hashtable<String, String> value = new  Hashtable<String, String>();
		value.put("quoteID", IndexGenerater.getTableIndex("quote", getConnection()));
		value.put("purchaseID", getFormData("purchaseID"));
		value.put("userID", purchase.get("userID"));
		value.put("price", getFormData("price"));
		value.put("type", "1");
		value.put("linkMan", getFormData("linkMan"));
		value.put("mobile", getFormData("mobile"));
		value.put("phone", getFormData("phone"));
		value.put("addTime", DateTimeUtil.getCurrentDateTime());
		value.put("info", getFormData("info"));
		value.put("adoptFlag", "0");
		value.put("validFlag", "1");
		DBProxy.insert(getConnection(), "quote", value);
		
		Hashtable<String, String> purchaseV = new Hashtable<String, String>();
		purchaseV.put("quoteFlag", "1");
		DBProxy.update(getConnection(), "purchase", key, purchaseV);
		
		setAjaxJavascript("closeInfoWindow();postModuleAndAction('purchaseManager', 'list')");
	}
	
	public void quoteListAction() throws Exception {
		Hashtable<String, String> key = new Hashtable<String, String>();
		key.put("purchaseID", getFormData("purchaseID"));
		key.put("deletedFlag", "0");
		
		initPageByQueryDataList2("quote", key, "datas", "", new Vector<String>(), "");
		
		Vector<Hashtable<String, String>> purchaseItems = DBProxy.query(getConnection(), "purchaseItem_V", key);
		setJSPData("purchaseItems", purchaseItems);
	}
	
	public void deleteQuoteAction() throws Exception {
		Hashtable<String, String> key = new Hashtable<String, String>();
		key.put("quoteID", getFormData("quoteID"));
		key.put("purchaseID", getFormData("purchaseID"));
		
		Hashtable<String, String> value = new Hashtable<String, String>();
		value.put("deletedFlag", "1");
		DBProxy.update(getConnection(), "quote", key, value);
		quoteListAction();
	}
}
