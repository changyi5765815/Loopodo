package admin.customer.guanwangbao.processor;

import java.util.Hashtable;
import java.util.Vector;

import simpleWebFrame.config.Module;
import simpleWebFrame.database.DBProxy;
import simpleWebFrame.web.DataHandle;

public class ShopUserProcessor extends BaseProcessor {
	public ShopUserProcessor(Module module, DataHandle dataHandle) {
		super(module, dataHandle);
	}

	public void makeView() throws Exception {
		if (getFormData("action").equals("list")) {
			String sortSql = "order by addTime desc";

			setFormData("q_memberFlag", "1");
			initPageByQueryDataList("shopUser_V", getFormDatas(), "datas", "", 
					new Vector<String>(), sortSql);
		} 
		if (getFormData("action").equals("defaultView2")) {
			String sortSql = "order by addTime desc";
			setFormData("q_shopID", getLoginedUserInfo().get("supplierID"));
			setFormData("q_memberFlag", "0");
			initPageByQueryDataList("shopUser_V", getFormDatas(), "datas", " auditStatus = '1' ", 
					new Vector<String>(), sortSql);
		} 
		if (!getFormData("action").equals("list")) {
			setFormData("queryConditionHtml", makeQueryConditionHtml("shopUser_V"));
		}
	}

	public void defaultViewAction() throws Exception {
		listAction();
	}
	
	public void editViewAction() throws Exception {
		Hashtable<String, String> k = new Hashtable<String, String>();
		k.put("shopUserID", getFormData("userID"));
		k.put("shopID", getFormData("supplierID"));
		setFormData(DBProxy.query(getConnection(), "shopUser_V", k).get(0));
	}
	
}
