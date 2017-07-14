package admin.customer.guanwangbao.processor;

import java.util.Hashtable;
import java.util.Vector;

import simpleWebFrame.config.Module;
import simpleWebFrame.database.DBProxy;
import simpleWebFrame.database.IndexGenerater;
import simpleWebFrame.util.StringUtil;
import simpleWebFrame.web.DataHandle;


public class InfoCollectionProcessor extends BaseProcessor {
	public InfoCollectionProcessor(Module module, DataHandle dataHandle) {
		super(module, dataHandle);
	}
	
	@Override
	public void makeView() throws Exception {
		if (getFormData("action").equals("list")) {
			setJSPData("datas", DBProxy.query(getConnection(), "infoCollection"));
		}
		else if (getFormData("action").equals("collectionItemList")) {
			Hashtable<String, String> k = new Hashtable<String, String>();
			k.put("infoCollectionID", getFormData("infoCollectionID"));
			Vector<Hashtable<String, String>> datas = DBProxy.query(getConnection(), "infoCollectionItem_V", k);
			setJSPData("datas", datas);
		} 
	}

	public void defaultViewAction() throws Exception {
		listAction();
	}
	
	public void collectionItemListAction() throws Exception {
	}
	
	public void addInfoAction() throws Exception {
		String selectedVlues = getFormData("selectedValues");
		String[] productIDs = StringUtil.split(selectedVlues, ", ");
		
		for (int i = 0; i < productIDs.length; ++i) {
			String productIDTmp = productIDs[i];
			String sql = "select count(*) as COUNT from infoCollectionItem where infoCollectionID = ? and infoID = ?";
			Vector<String> values = new Vector<String>();
			values.add(getFormData("infoCollectionID"));
			values.add(productIDTmp);
			
			if (DBProxy.query(getConnection(), "count_V", sql, values).get(0).get("COUNT").equals("0")) {
				Hashtable<String, String> key = new Hashtable<String, String>();
				key.put("infoCollectionItemID", IndexGenerater.getTableIndex("infoCollectionItem", getConnection()));
				key.put("infoCollectionID", getFormData("infoCollectionID"));
				key.put("infoID", productIDTmp);
				
				DBProxy.insert(getConnection(), "infoCollectionItem", key);
			}
		}
		
		setFormData("action", "collectionItemList");
	}
	
	public void deleteItemAction() throws Exception {
		setFormData("action", "collectionItemList");
		
		Hashtable<String, String> k = new Hashtable<String, String>();
		k.put("infoCollectionItemID", getFormData("infoCollectionItemID"));
		DBProxy.delete(getConnection(), "infoCollectionItem", k);
	}
}
