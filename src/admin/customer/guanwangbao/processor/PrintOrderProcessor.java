package admin.customer.guanwangbao.processor;

import java.util.Hashtable;
import java.util.Vector;

import simpleWebFrame.config.Module;
import simpleWebFrame.database.DBProxy;
import simpleWebFrame.web.DataHandle;

public class PrintOrderProcessor extends BaseProcessor {

	public PrintOrderProcessor(Module module, DataHandle dataHandle) {
		super(module, dataHandle);
	}

	@Override
	public void makeView() throws Exception {
	}
	
	public void defaultViewAction() throws Exception {
	}
	
	public void printViewAction() throws Exception {
		Hashtable<String, String> key = new Hashtable<String, String>();
		key.put("shopOrderID", getFormData("shopOrderID"));
		Vector<Hashtable<String, String>> datas = DBProxy.query(getConnection(), "shopOrder", key);
		
		setFormData(datas.get(0));
		setJSPData("itemDatas", DBProxy.query(getConnection(), "orderProduct_V", key));
		
		String userID = getFormData("userID");
		Hashtable<String, String> uKey = new Hashtable<String, String>();
		uKey.put("userID", userID);
		setFormData("email",DBProxy.query(getConnection(), "user", uKey).get(0).get("email"));
	}
}
