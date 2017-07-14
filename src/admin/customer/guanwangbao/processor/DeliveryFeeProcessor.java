package admin.customer.guanwangbao.processor;

import java.util.Hashtable;

import simpleWebFrame.config.Module;
import simpleWebFrame.database.DBProxy;
import simpleWebFrame.web.CheckList;
import simpleWebFrame.web.DataHandle;
import simpleWebFrame.web.validate.PriceCheckItem;
import admin.customer.guanwangbao.LocalDataCache;

public class DeliveryFeeProcessor extends BaseProcessor {

	public DeliveryFeeProcessor(Module module, DataHandle dataHandle) {
		super(module, dataHandle);
	}

	@Override
	public void makeView() throws Exception {

	}
	
	public void defaultViewAction() throws Exception {
		setFormData("fee", LocalDataCache.getInstance().getSysConfig("fee"));
		setFormData("freeAmount", LocalDataCache.getInstance().getSysConfig("freeAmount"));
	}
	
	public boolean confirmActionCheck() throws Exception {
		CheckList list = getChecklist();
		list.addCheckItem(new PriceCheckItem("fee", "运费", true));
		list.addCheckItem(new PriceCheckItem("freeAmount", "包邮消费金额", true));
		return list.check();
	}

	public void confirmAction() throws Exception {
		Hashtable<String, String> key = new Hashtable<String, String>();
		Hashtable<String, String> value = new Hashtable<String, String>();
		
		key.put("name", "fee");
		value.put("value", getFormData("fee"));
		DBProxy.update(getConnection(), "sysConfig", key, value);
		
		key.put("name", "freeAmount");
		value.put("value", getFormData("freeAmount"));
		DBProxy.update(getConnection(), "sysConfig", key, value);
		
		LocalDataCache.getInstance().reloadSysConfig(getConnection());
		
		setInfoMessage("保存成功");
	}
}
