package admin.customer.guanwangbao.processor;

import java.util.Hashtable;
import java.util.Vector;

import admin.customer.guanwangbao.LocalDataCache;

import simpleWebFrame.config.Module;
import simpleWebFrame.database.DBProxy;
import simpleWebFrame.web.CheckList;
import simpleWebFrame.web.DataHandle;
import simpleWebFrame.web.validate.PriceCheckItem;

public class UserDiscountRateProcessor extends BaseProcessor {

	public UserDiscountRateProcessor(Module module, DataHandle dataHandle) {
		super(module, dataHandle);
	}

	@Override
	public void makeView() throws Exception {
		String action = getFormData("action");
		if ("list".equals(action)) {
			/* 会员等级 */
			Vector<Hashtable<String, String>> datas = LocalDataCache.getInstance().getTableDatas("c_userLevel");
			
			/* 折扣率 */
			String sql = "select * from sysConfig where name like ?";
			Vector<String> key = new Vector<String>();
			key.add("level_DiscountRate");
			Vector<Hashtable<String, String>> sysConfigs = DBProxy.query(getConnection(), "sysConfig", sql, key);
			
			/* 会员等级添加对应折扣率 */
			for (Hashtable<String, String> data : datas) {
				String userLevelID = data.get("c_userLevelID");
				String sysConfigName = "level" + userLevelID + "DiscountRate";
				
				for (Hashtable<String, String> sysConfig : sysConfigs) {
					if (sysConfigName.equals(sysConfig.get("name"))) {
						data.put("levelDiscountRate", sysConfig.get("value"));
					}
				}
			}
			
			setJSPData("datas", datas);
		}
	}

	public void defaultViewAction() throws Exception  {
		listAction();
	}
	
	public boolean confirmActionCheck() throws Exception  {
		Vector<Hashtable<String, String>> datas = LocalDataCache.getInstance().getTableDatas("c_userLevel");
		CheckList list = getChecklist();
		for (int i = 0; i < datas.size(); i++) {
			list.addCheckItem(new PriceCheckItem("level" + datas.get(i).get("c_userLevelID") + "DiscountRate", datas.get(i).get("c_userLevelName") + "折扣率", false));
		}
		return list.check();
	}
	
	public void confirmAction() throws Exception  {
		Vector<Hashtable<String, String>> datas = LocalDataCache.getInstance().getTableDatas("c_userLevel");
		
		Hashtable<String, String> key = new Hashtable<String, String>();
		Hashtable<String, String> value = new Hashtable<String, String>();
		for (Hashtable<String, String> data : datas) {
			key.put("name", "level" + data.get("c_userLevelID") + "DiscountRate");
			value.put("value", getFormData("level" + data.get("c_userLevelID") + "DiscountRate"));
			DBProxy.update(getConnection(), "sysConfig", key, value);
		}
		
		listAction();
		setInfoMessage("更新成功！");
	}
}
