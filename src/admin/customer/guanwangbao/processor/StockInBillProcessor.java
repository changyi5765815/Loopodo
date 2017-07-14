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
//public class StockInBillProcessor extends BaseProcessor {
//
//	public StockInBillProcessor(Module module, DataHandle dataHandle) {
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
//			initPageByQueryDataList("stockInBill", getFormDatas(),  "datas", "", new Vector<String>(), "order by addTime desc");
//			
//			setFormData("q_fromAddTime", q_fromAddTime);
//			setFormData("q_toAddTime", q_toAddTime);
//			
//			setFormData("queryStockInTypeSelect", getQueryStockInTypeSelect());
//		} else if (getFormData("action").equals("addView") 
//				|| getFormData("action").equals("editView")
//				|| getFormData("action").equals("confirm")) {
//			
//			setFormData("stockInTypeSelect", getStockInTypeSelect());
//		} else if (getFormData("action").equals("stockInBillItemList")) {
//			Hashtable<String, String> key = new Hashtable<String, String>();
//			key.put("stockInBillID", getFormData("stockInBillID"));
//			setJSPData("datas", DBProxy.query(getConnection(), "stockInBillItem_V", key));
//		} 
//	}
//	
//	public void defaultViewAction() throws Exception {
//		listAction();
//	}
//	
//	public void addViewAction() throws Exception {
//		String[]items = {"stockInBillID", "hasSelectedValues"};
//		clearDatas(items);
//		
//		setFormData("stockInTypeID", "1");
//	}
//	
//	public String getQueryStockInTypeSelect() throws Exception {
//		return makeSelectElementString("q_stockInTypeID", LocalDataCache.getInstance().getTableDatas("c_stockInType"), "c_stockInTypeID", "c_stockInTypeName", "");
//	}
//	
//	public String getStockInTypeSelect() throws Exception {
//		Vector<Hashtable<String, String>> stockInTypes = new Vector<Hashtable<String,String>>();
//		Vector<Hashtable<String, String>> tmpStockInTypes = LocalDataCache.getInstance().getTableDatas("c_stockInType");
//		for (int i = 0; i < tmpStockInTypes.size(); i++) {
//			Hashtable<String, String> tmpStockInType = tmpStockInTypes.get(i);
//			if (!tmpStockInType.get("c_stockInTypeID").equals("4")) {
//				stockInTypes.add(tmpStockInType);
//			}
//		}
//		
//		return makeSelectElementString("stockInTypeID", stockInTypes, "c_stockInTypeID", "c_stockInTypeName", "");
//	}
//	
//	public void stockInBillItemListAction() throws Exception {
//		setFormData("action", "stockInBillItemList");
//	}
//	
//	public void addStockInBillAction() throws Exception {
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
//						alertStr += "alert('skuID为"+ skuID +"的本次入库数量的输入不正确！');";
//						break;
//					}
//					if (Integer.parseInt(getFormData(key)) < 1) {
//						alertStr += "alert('skuID为"+ skuID +"的本次入库数量的输入不正确！');";
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
//			updSkus.add(skuData);
//			skuData.put("updStock", getFormData(keyForm));
//			skuData.put("updNote", getFormData(skuID + "_note"));
//		}
//		if (!alertStr.equals("")) {
//			setAjaxJavascript(alertStr);
//			return;
//		}
//		
//		
//		StockBillTool.plusStockBill(getConnection(), "", "0", getFormData("stockInTypeID"), getFormData("relateID"), getLoginedUserInfo().get("systemUserID"), 
//				getLoginedUserInfo().get("userName"), updSkus);
//		
//		setAjaxJavascript("postModuleAndAction('stockInBill','defaultView');");
//	}
//}
