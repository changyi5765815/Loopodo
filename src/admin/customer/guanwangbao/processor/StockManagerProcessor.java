//package admin.customer.guanwangbao.processor;
//
//import java.util.Hashtable;
//import java.util.Vector;
//
//import admin.customer.guanwangbao.AppKeys;
//import admin.customer.guanwangbao.tool.StockBillTool;
//
//import simpleWebFrame.config.Module;
//import simpleWebFrame.database.DBProxy;
//import simpleWebFrame.util.StringUtil;
//import simpleWebFrame.web.CheckList;
//import simpleWebFrame.web.DataHandle;
//import simpleWebFrame.web.validate.IntegerCheckItem;
//
//public class StockManagerProcessor extends BaseProcessor {
//	public StockManagerProcessor(Module module, DataHandle dataHandle) {
//		super(module, dataHandle);
//	}
//	
//	@Override
//	public void makeView() throws Exception {
//		if (getFormData("action").equals("list") || getFormData("action").equals("updateStockNumber")) {
//			setFormData("q_deletedFlag", "0");
//			initPageByQueryDataList("sku_V", getFormDatas(), 
//					"datas", "", new Vector<String>(), getFormData(AppKeys.ORDER_SQL));
//			
//			setFormData("queryProductTypeSelect", getQueryProductTypeSelect());
//			setFormData("queryBrandSelect", getQueryBrandSelect());
//		} 
//	}
//
//	public void defaultViewAction() throws Exception {
//		listAction();
//	}
//	
//	public boolean updateStockNumberActionCheck() throws Exception {
//		CheckList list = getChecklist();
//		Hashtable<String, String> formDatas = getFormDatas();
//		String productK = "";
//		for(String key : formDatas.keySet()) {
//			if(key.startsWith(getFormData("skuID") + "_") && key.endsWith("_stock")) {
//				productK = key;
//				list.addCheckItem(new IntegerCheckItem(key, "库存数量", true));
//			}
//		}
//		if (!list.check()) {
//			return false;
//		}
//		if (Integer.parseInt(getFormData(productK)) < 0) {
//			setErrorMessage("库存数量不能为负值！");
//			return false;
//		}
//		
//		return list.check();
//	}
//	
//	public void updateStockNumberAction() throws Exception { 
//		Hashtable<String, String> key = new Hashtable<String, String>();
//		String skuID = getFormData("skuID");
//		Hashtable<String, String> formDatas = getFormDatas();
//		String keys = "";
//		for(String key1 : formDatas.keySet()) {
//			if(key1.startsWith(skuID + "_") && key1.endsWith("_stock")) {
//				keys = key1;
//			}
//		}
//		key.put("skuID", skuID);
//		Hashtable<String, String> productData = DBProxy.query(getConnection(), "sku", key).get(0);
//		String oldStockNumber = productData.get("stock");
//		String newStockNumber = getFormData(keys);
//		Vector<Hashtable<String, String>> datas = new Vector<Hashtable<String,String>>();
//		if (Integer.parseInt(newStockNumber) > Integer.parseInt(oldStockNumber)) {
//			productData.put("updStock", (Integer.parseInt(newStockNumber) - Integer.parseInt(oldStockNumber)) + "");
//			datas.add(productData);
//			StockBillTool.plusStockBill(getConnection(), "", "0", "4", "", getLoginedUserInfo().get("systemUserID"), 
//					getLoginedUserInfo().get("userName"), datas);
//		} else if (Integer.parseInt(newStockNumber) < Integer.parseInt(oldStockNumber)) {
//			productData.put("updStock", (Integer.parseInt(oldStockNumber) - Integer.parseInt(newStockNumber)) + "");
//			datas.add(productData);
//			StockBillTool.minusStockBill(getConnection(), "", "0", "4", "", getLoginedUserInfo().get("systemUserID"), 
//					getLoginedUserInfo().get("userName"), datas);
//		} 
//		
//		listAction();
//	}
//	
//	public void updateProductStockAction() throws Exception {
//		CheckList list = getChecklist();
//		list.addCheckItem(new IntegerCheckItem("stockNumber", "总库存量", true));
//		if (!list.check()) {
//			setErrorMessageAndFocusItem();
//			return;
//		}
//		
//		Hashtable<String, String> key = new Hashtable<String, String>();
//		key.put("productID", getFormData("productID"));
//		Hashtable<String, String> value = new Hashtable<String, String>();
//		value.put("stockNumber", getFormData("stockNumber"));
//		DBProxy.update(getConnection(), "product", key, value);
//		setAjaxInfoMessage("产品总库存量已更新！");
//	}
//	
//	public void updateProductStockNumberAction() throws Exception { 
//		String selectedValues = getFormData("selectedValues");
//		if (selectedValues.equals("")) {
//			setAjaxJavascript("alert('请选择商品！');");
//			return;
//		}
//		
//		String[] skuIDArray = StringUtil.split(selectedValues, ",， ");  
//		String errorProductIDs = "";
//		Hashtable<String, String> formDatas = getFormDatas();
//		Vector<Hashtable<String, String>> plusStockSkuDatas = new Vector<Hashtable<String,String>>();
//		Vector<Hashtable<String, String>> minStockSkuDatas = new Vector<Hashtable<String,String>>();
//		for (int i = 0; i < skuIDArray.length; i++) { 
//			Hashtable<String, String> key = new Hashtable<String, String>();
//			String skuID = skuIDArray[i];
//			String formDataK = "";
//			for(String key1 : formDatas.keySet()) {
//				if(key1.startsWith(skuID + "_") && key1.endsWith("_stock")) {
//					formDataK = key1;
//				}
//			}
//			key.put("skuID", skuID);
//			Hashtable<String, String> productData = DBProxy.query(getConnection(), "sku_V", key).get(0);
//			
//			if (!IntegerCheckItem.isInteger(getFormData(formDataK))) {
//				errorProductIDs += (errorProductIDs.equals("") ? "" : ",") + skuID;
//				continue;
//			}
//			if (Integer.parseInt(getFormData(formDataK)) < 0) { 
//				errorProductIDs += (errorProductIDs.equals("") ? "" : ",") + skuID;
//				continue;
//			}
//			
//			String oldStockNumber = productData.get("stock");
//			String newStockNumber = getFormData(formDataK);
//			
//			
//			if (Integer.parseInt(newStockNumber) > Integer.parseInt(oldStockNumber)) {
//				productData.put("updStock", (Integer.parseInt(newStockNumber) - Integer.parseInt(oldStockNumber)) + "");
//				productData.put("updNote", "");
//				plusStockSkuDatas.add(productData);
//			} else if (Integer.parseInt(newStockNumber) < Integer.parseInt(oldStockNumber)) {
//				productData.put("updStock", (Integer.parseInt(oldStockNumber) - Integer.parseInt(newStockNumber)) + "");
//				productData.put("updNote", "");
//				minStockSkuDatas.add(productData);
//			} 
//		}
//		
//		StockBillTool.plusStockBill(getConnection(), "", "0", "4", "", getLoginedUserInfo().get("systemUserID"), 
//				getLoginedUserInfo().get("userName"), plusStockSkuDatas);
//	
//		StockBillTool.minusStockBill(getConnection(), "", "0", "4", "", getLoginedUserInfo().get("systemUserID"), 
//				getLoginedUserInfo().get("userName"), minStockSkuDatas);
//		
//		errorProductIDs = errorProductIDs.equals("") ? "" : ("alert('skuID为("+ errorProductIDs + ")的商品库存量的输入不正确');");
//		setAjaxJavascript(errorProductIDs + "alert('更新成功');postModuleAndAction('stockManager','defaultView');");
//	}
//}
