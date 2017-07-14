package admin.customer.guanwangbao.processor;

import java.util.Hashtable;
import java.util.Vector;

import simpleWebFrame.config.Module;
import simpleWebFrame.database.DBProxy;
import simpleWebFrame.database.IndexGenerater;
import simpleWebFrame.util.StringUtil;
import simpleWebFrame.web.DataHandle;


public class CollectionProcessor extends BaseProcessor {
	public CollectionProcessor(Module module, DataHandle dataHandle) {
		super(module, dataHandle);
	}
	
	@Override
	public void makeView() throws Exception {
		if (getFormData("action").equals("list")) {
			setJSPData("datas", DBProxy.query(getConnection(), "collection"));
		} else if (getFormData("action").equals("collectionItemList")) {
			Hashtable<String, String> k = new Hashtable<String, String>();
			k.put("collectionID", getFormData("collectionID"));
			k.put("deletedFlag", "0");
			Vector<Hashtable<String, String>> datas = DBProxy.query(getConnection(), "collectionItem_V", k);
			setJSPData("datas", datas);
		} 
	}

	public void defaultViewAction() throws Exception {
		listAction();
	}
	
	public void collectionItemListAction() throws Exception {
	}
	
	public void addProductAction() throws Exception {
		String selectedVlues = getFormData("selectedValues");
		String[] productIDs = StringUtil.split(selectedVlues, ",");
		
		for (int i = 0; i < productIDs.length; ++i) {
			String productIDTmp = productIDs[i];
			String sql = "select count(*) as COUNT from collectionItem_V where collectionID = ? and productID = ? and deletedFlag = ?";
			Vector<String> values = new Vector<String>();
			values.add(getFormData("collectionID"));
			values.add(productIDTmp);
			values.add("0");
			
			if (DBProxy.query(getConnection(), "count_V", sql, values).get(0).get("COUNT").equals("0")) {
				Hashtable<String, String> key = new Hashtable<String, String>();
				key.put("collectionItemID", IndexGenerater.getTableIndex("collectionItem", getConnection()));
				key.put("collectionID", getFormData("collectionID"));
				key.put("productID", productIDTmp);
				
				DBProxy.insert(getConnection(), "collectionItem", key);
			}
		}
		
		setFormData("action", "collectionItemList");
	}
	
	public void deleteProductAction() throws Exception {
		setFormData("action", "collectionItemList");
		
		Hashtable<String, String> k = new Hashtable<String, String>();
		k.put("collectionItemID", getFormData("collectionItemID"));
		DBProxy.delete(getConnection(), "collectionItem", k);
	}
}
