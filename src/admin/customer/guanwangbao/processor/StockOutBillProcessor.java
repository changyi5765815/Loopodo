//package admin.customer.guanwangbao.processor;
//
//import java.util.Hashtable;
//import java.util.Vector;
//
//import admin.customer.guanwangbao.LocalDataCache;
//import admin.customer.guanwangbao.tool.StockBillTool;
//
//import simpleWebFrame.config.Module;
//import simpleWebFrame.database.DBProxy;
//import simpleWebFrame.util.StringUtil;
//import simpleWebFrame.web.DataHandle;
//import simpleWebFrame.web.validate.IntegerCheckItem;
//
//public class StockOutBillProcessor extends BaseProcessor {
//
//	public StockOutBillProcessor(Module module, DataHandle dataHandle) {
//		super(module, dataHandle);
//	}
//
//	@Override
//	public void makeView() throws Exception {
//		if (getFormData("action").equals("list")) {
//			String q_fromAddTime = getFormData("q_fromAddTime");
//			String q_toAddTime = getFormData("q_toAddTime");
//			if (!getFormData("q_fromAddTime").equals("")) {
//				setFormData("q_fromAddTime", getFormData("q_fromAddTime") + " 00:00:00");
//			}
//			if (!getFormData("q_toAddTime").equals("")) {
//				setFormData("q_toAddTime", getFormData("q_toAddTime") + " 23:59:59");
//			}
//			initPageByQueryDataList("stockOutBill", getFormDatas(),  "datas", "", new Vector<String>(), "order by stockOutBillID desc");
//			
//			setFormData("q_fromAddTime", q_fromAddTime);
//			setFormData("q_toAddTime", q_toAddTime);
//			
//			setFormData("queryStockOutTypeSelect", getQueryStockOutTypeSelect());
//		} else if (getFormData("action").equals("addView") 
//				|| getFormData("action").equals("editView")
//				|| getFormData("action").equals("confirm")) {
//			
//			setFormData("stockOutTypeSelect", getStockOutTypeSelect());
//		} else if (getFormData("action").equals("stockOutBillItemList")) {
//			Hashtable<String, String> key = new Hashtable<String, String>();
//			key.put("stockOutBillID", getFormData("stockOutBillID"));
//			setJSPData("datas", DBProxy.query(getConnection(), "stockOutBillItem_V", key));
//		} 
//	}
//	
//	public void defaultViewAction() throws Exception {
//		listAction();
//	}
//	
//	public void addViewAction() throws Exception {
//		String[]items = {"stockOutBillID", "hasSelectedValues"};
//		clearDatas(items);
//		
//		setFormData("stockOutTypeID", "1");
//	}
//	
//	public String getQueryStockOutTypeSelect() throws Exception {
//		return makeSelectElementString("q_stockOutTypeID", 
//				LocalDataCache.getInstance().getTableDatas("c_stockOutType"), "c_stockOutTypeID", "c_stockOutTypeName", "");
//	}
//	
//	public String getStockOutTypeSelect() throws Exception {
//		Vector<Hashtable<String, String>> stockOutTypes = new Vector<Hashtable<String,String>>();
//		Vector<Hashtable<String, String>> tmpstockOutTypes = LocalDataCache.getInstance().getTableDatas("c_stockOutType");
//		for (int i = 0; i < tmpstockOutTypes.size(); i++) {
//			Hashtable<String, String> tmpstockOutType = tmpstockOutTypes.get(i);
//			if (!tmpstockOutType.get("c_stockOutTypeID").equals("4")) {
//				stockOutTypes.add(tmpstockOutType);
//			}
//		}
//		
//		return makeSelectElementString("stockOutTypeID", stockOutTypes, "c_stockOutTypeID", "c_stockOutTypeName", "");
//	}
//	
//	public void stockOutBillItemListAction() throws Exception {
//		setFormData("action", "stockOutBillItemList");
//	}
//	
//	public void addStockOutBillAction() throws Exception {
//		String hasSelectedValues = getFormData("hasSelectedValues");
//		String[] skuIDArray = StringUtil.split(hasSelectedValues, ",");
//		if (skuIDArray.length == 0) {
//			setAjaxJavascript("alert('请选择商品！');");
//			return;
//		}
//		String alertStr = "";
//		Hashtable<String, String> k = new Hashtable<String, String>();
//		Hashtable<String, String> formDatas2 = getFormDatas();
//		Vector<Hashtable<String, String>> updSkus = new Vector<Hashtable<String,String>>();
//		for (int i = 0; i < skuIDArray.length; i++) {
//			String skuID = skuIDArray[i];
//			String keyForm = "";
//			for(String key : formDatas2.keySet()) {
//				if (key.equals(skuID + "_number")) {
//					if (!IntegerCheckItem.isInteger(getFormData(key))) {
//						alertStr += "alert('skuID为"+ skuID +"的本次出库数量的输入不正确！');";
//						break;
//					}
//					if (Integer.parseInt(getFormData(key)) < 1) {
//						alertStr += "alert('skuID为"+ skuID +"的本次出库数量的输入不正确！');";
//						break;
//					}
//					keyForm = key;
//				}
//			}
//			
//			k.put("skuID", skuID);
//			Vector<Hashtable<String, String>> skuDatas = DBProxy.query(getConnection(), "sku_V", k);
//			if (skuDatas.size() == 0) {
//				alertStr += "alert('skuID为"+ skuID +"已被删除！');";
//				break;
//			}
//			Hashtable<String, String> skuData = skuDatas.get(0);
//			if (Integer.parseInt(getFormData(keyForm)) > Integer.parseInt(skuData.get("stock"))) {
//				alertStr += "alert('skuID为"+ skuID +"本次出库数量不能大于现有库存量！');";
//				break;
//			}
//			updSkus.add(skuData);
//			skuData.put("updStock", getFormData(keyForm));
//			skuData.put("updNote", getFormData(skuID + "_note"));
//		}
//		if (!alertStr.equals("")) {
//			setAjaxJavascript(alertStr);
//			return;
//		}
//		
//		StockBillTool.minusStockBill(getConnection(), "", "0", getFormData("stockOutTypeID"), getFormData("relateID"), getLoginedUserInfo().get("systemUserID"), 
//				getLoginedUserInfo().get("userName"), updSkus);
//		
//		setAjaxJavascript("postModuleAndAction('stockOutBill','defaultView');");
//	}
//}
