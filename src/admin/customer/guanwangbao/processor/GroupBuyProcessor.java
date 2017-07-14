package admin.customer.guanwangbao.processor;


import java.util.Hashtable;
import java.util.Vector;

import simpleWebFrame.config.Module;
import simpleWebFrame.database.DBProxy;
import simpleWebFrame.database.IndexGenerater;
import simpleWebFrame.util.DateTimeUtil;
import simpleWebFrame.util.StringUtil;
import simpleWebFrame.web.CheckList;
import simpleWebFrame.web.DataHandle;
import simpleWebFrame.web.validate.IntegerCheckItem;
import simpleWebFrame.web.validate.PriceCheckItem;
import simpleWebFrame.web.validate.StringCheckItem;
import admin.customer.guanwangbao.AppUtil;
import admin.customer.guanwangbao.LocalDataCache;

public class GroupBuyProcessor extends BaseProcessor {
	public GroupBuyProcessor(Module module, DataHandle dataHandle) {
		super(module, dataHandle);
	}

	public void makeView() throws Exception {
		if (getFormData("action").equals("list")) {
			setFormData("q_deletedFlag", "0");
			String extendSql = "";
			if(getFormData("operationName").equals("0")) {
				extendSql = "supplierID = '0' or supplierID is null";
			} else {
				extendSql = "supplierID != '0'";
			}

			initPageByQueryDataList("groupBuy_V", getFormDatas(), "datas", 
					extendSql, new Vector<String>(), "order by groupBuyID desc");			
		} else if (getFormData("action").equals("addView") 
				|| getFormData("action").equals("editView")
				|| getFormData("action").equals("confirm")) {
			setFormData("c_groupBuyTypeID", getFormData("groupBuyTypeID"));
			Vector<Hashtable<String, String>> c_groupBuyTypeDatas = LocalDataCache.getInstance().getTableDatas("c_groupBuyType");
			String groupBuyTypeSelect = makeSelectElementString("groupBuyTypeID", c_groupBuyTypeDatas, "c_groupBuyTypeID", "c_groupBuyTypeName", "", "form-control", true, "请选择", "");
			setFormData("groupBuyTypeSelect", groupBuyTypeSelect);
		} else if(getFormData("action").equals("zekouListView")) {
			Vector<String> v = new Vector<String>();
			v.add("1"); // 上下架
			v.add("0"); // 上下架
			v.add(getFormData("discountLogID")); 
			String querySql = "select * from product_V where validFlag = ? and deletedFlag = ? and discountLogID = ? order by discountRate desc";
			Vector<Hashtable<String, String>> datas = DBProxy.query(getConnection(), "product_V", querySql, v);
			setJSPData("datas", datas);
			String datasStr = getDatasStr(datas);
			setFormData("datasStr", datasStr);
		}  else if (getFormData("action").equals("discountLogView")) {
			String extendSql = "";
			if(!"".equals(getFormData("q_suppName"))){
				extendSql += " supplierName like '%" + getFormData("q_suppName") + "%' ";
			}
			

			initPageByQueryDataList("discountLog_v", getFormDatas(), "datas", extendSql, new Vector<String>(), "");			
		} 
		
		if (!getFormData("action").equals("list")) {
			setFormData("queryConditionHtml", makeQueryConditionHtml("groupBuy_V"));
		}
	}
	
	public void discountLogViewAction() throws Exception {
	
	}
	
	public void addDiscountViewAction() throws Exception {
		String[] clearFormDatas = {"discountLogID"};
		clearDatas(clearFormDatas);
	}
	
	public void editDiscountViewAction() throws Exception {
		getData("discountLog", DATA_TYPE_TABLE);
	}
	
	public void disable2Action() throws Exception {
		if(getFormData("table").equals("discountLog")) {
			changeValidFlag2(getFormData("table"), "0", false);
		} else if(getFormData("table").equals("product2")) {
			changeValidFlag2(getFormData("table"), "0", false);
		} else if(getFormData("table").equals("product")) {
			changeValidFlag2(getFormData("table"), "0", false);
		} else {
			returnResult(changeValidFlag2(getFormData("table"), "0", false));
		}
	}
	
	public void enable2Action() throws Exception {
		if(getFormData("table").equals("discountLog")) {
			changeValidFlag2(getFormData("table"), "1", false);
		} else if(getFormData("table").equals("product2")) {
			changeValidFlag2(getFormData("table"), "1", false);
		} else if(getFormData("table").equals("product")) {
			changeValidFlag2(getFormData("table"), "1", false);
		} else {
			returnResult(changeValidFlag2(getFormData("table"), "1", false));
		}
	}
	
	public boolean changeValidFlag2(String tableName, String validFlag,
			boolean setListAction) throws Exception {
		if(tableName.equals("product2")) {
			Hashtable<String, String> key = new Hashtable<String, String>();
			key.put("productID", getFormData("productID"));
			key.put("discountLogID", getFormData("discountLogID"));
			Hashtable<String, String> value = new Hashtable<String, String>();
			value.put("discountLogID", "");
			value.put("discountFlag", "0");
			value.put("tag", "");
			DBProxy.update(getConnection(), "product", key, value);
			setFormData("action", "zekouListView");
			return true;
		}
		if(tableName.equals("product")) {
			Hashtable<String, String> key = new Hashtable<String, String>();
			key.put("discountLogID", getFormData("discountLogID"));
			Hashtable<String, String> value = new Hashtable<String, String>();
			value.put("discountFlag", validFlag);
			DBProxy.update(getConnection(), tableName, key, value);
			setFormData("action", "zekouListView");
			return true;
		}
		if(tableName.equals("discountLog")) {
			Hashtable<String, String> key = new Hashtable<String, String>();
			key.put(tableName + "ID", getFormData(tableName + "ID"));
			Hashtable<String, String> value = new Hashtable<String, String>();
			value.put("validFlag", validFlag);
			DBProxy.update(getConnection(), tableName, key, value);
			
			Hashtable<String, String> values = new Hashtable<String, String>();
			values.put("discountFlag", validFlag);
			DBProxy.update(getConnection(), "product", key , values);
			
			setFormData("action", "discountLogView");
			return true;
		}
		if(tableName.equals("promotionActive") && validFlag.equals("1")) {
			Hashtable<String, String> k = new Hashtable<String, String>();
			k.put("validFlag", "1");
			Vector<Hashtable<String, String>> datas = DBProxy.query(getConnection(), "promotionActive", k);
			Hashtable<String, String> k3 = new Hashtable<String, String>();
			k3.put("promotionActiveID", getFormData("promotionActiveID"));
			Vector<Hashtable<String, String>> datas3 = DBProxy.query(getConnection(), "promotionActive", k3);
			Hashtable<String, String> data3 = new Hashtable<String, String>();
			if(datas3.size() != 0) {
				data3 = datas3.get(0);
			}
			// 全站促销中，满减活动 满赠活动 只能开其中一个
			if("1".equals(data3.get("promotionActiveTypeID")) || "2".equals(data3.get("promotionActiveTypeID"))) {
				for(int i = 0; i < datas.size(); i++) {
					Hashtable<String, String> data = datas.get(i);
					if("1".equals(data.get("promotionActiveTypeID")) || "2".equals(data.get("promotionActiveTypeID"))) {
						return false;
					}
				}
			}
			if(datas3.size() == 0) {
				setFormData("messageInfo", "无效的促销活动设置！");
				return false;
			} else {
				Hashtable<String, String> data = datas3.get(0);
				if("1".equals(data3.get("promotionActiveTypeID")) || "2".equals(data3.get("promotionActiveTypeID"))) {
					if(!IntegerCheckItem.isInteger(data.get("value")) && !IntegerCheckItem.isInteger(data.get("value2"))) {
						setFormData("messageInfo", "请先完善促销活动设置！");
						return false;
					}
				} else {
					if(!IntegerCheckItem.isInteger(data.get("value3")) && !IntegerCheckItem.isInteger(data.get("value2")) && !IntegerCheckItem.isInteger(data.get("value4"))) {
						setFormData("messageInfo", "请先完善活动信息设置！");
						return false;
					}
				}
			}
		}
		
		Hashtable<String, String> key = new Hashtable<String, String>();
		key.put(tableName + "ID", getFormData(tableName + "ID"));
		Hashtable<String, String> value = new Hashtable<String, String>();
		value.put("validFlag", validFlag);

		DBProxy.update(getConnection(), tableName, key, value);
		String action = "";
		if(tableName.equals("promotionActive")) {
			 action = "allPromotionListView";
			 allPromotionListViewAction();
			 setFormData("action", action);
			 return true;
		}
		setFormData("action", action);
		return true;
	}

		private void returnResult(boolean changeValidFlag2) throws Exception{
			if(!changeValidFlag2) {
				if(!getFormData("messageInfo").equals("")) {
					setErrorMessage(getFormData("messageInfo"));
				} else {
					setErrorMessage("已经有满赠/满减活动开启，不能再开启新的满赠/满减活动！");
				}
				allPromotionListViewAction();
				setFormData("action", "allSitePromotionListView");
			}
		}
		
		public void allPromotionListViewAction() throws Exception {
		}
		
		public void confirmDiscountViewAction() throws Exception {
			CheckList checklist = getChecklist();
			checklist.addCheckItem(new StringCheckItem("name", "名称", true));
			checklist.addCheckItem(new StringCheckItem("tag", "折扣标签", true));
			checklist.addCheckItem(new PriceCheckItem("discountRate", "折扣", true));
			if(!checklist.check()) {
				return;
			}
			Float discount = Float.valueOf(getFormData("discountRate"));
			if(discount < 0 || discount > 10) {
				setAjaxJavascript("alert('折扣数字为0~10之间');");
				return;
			}
			String discountLogID = getFormData("discountLogID");
			String currentDateTime = DateTimeUtil.getCurrentDateTime();
			if(discountLogID.equals("")) {
				Hashtable<String, String> values = new Hashtable<String, String>();
				values.put("discountLogID", IndexGenerater.getTableIndex("discountLog", getConnection()));
				values.put("name", getFormData("name"));
				values.put("tag", getFormData("tag"));
				values.put("discountRate", getFormData("discountRate"));
				values.put("addTime", currentDateTime);
				values.put("validFlag", "0");
				values.put("modifyTime", currentDateTime);
				values.put("systemUserID", getLoginedUserInfo().get("systemUserID"));
				DBProxy.insert(getConnection(), "discountLog", values);
			} else {
				Hashtable<String, String> keys = new Hashtable<String, String>();
				keys.put("discountLogID", discountLogID);
				
				Hashtable<String, String> values = new Hashtable<String, String>();
				values.put("name", getFormData("name"));
				values.put("tag", getFormData("tag"));
				values.put("discountRate", getFormData("discountRate"));
				DBProxy.update(getConnection(), "discountLog", keys , values);
				
				Hashtable<String, String> k = new Hashtable<String, String>();
				k.put("discountLogID", discountLogID);
				Vector<Hashtable<String, String>> datas = DBProxy.query(getConnection(), "discountLog", k );
				if(datas.size() == 0) {
					setAjaxJavascript("postModuleAndAction('groupBuy', 'discountLogView');");
					return;
				}
				
				Hashtable<String, String> discountLog = datas.get(0);
				
				String sql2 = "update product set discountRate = ? , discountFlag = ?, tag = ? where discountLogID = ?";
				Vector<String> v2 = new Vector<String>();
				v2.add(discountLog.get("discountRate"));
				v2.add(discountLog.get("validFlag"));
				v2.add(LocalDataCache.getInstance().getTableDataColumnValue("c_productTag", "3", "c_productTagName"));
				v2.add(discountLog.get("discountLogID"));
				DBProxy.update(getConnection(), "product", sql2, v2);
			}
			setAjaxJavascript("postModuleAndAction('groupBuy', 'discountLogView');");
		}
		
		public void deleteDiscountAction() throws Exception {
			String discountLogID = getFormData("discountLogID");
			Hashtable<String, String> keys = new Hashtable<String, String>();
			keys.put("discountLogID", discountLogID);
			DBProxy.delete(getConnection(), "discountLog", keys);
			
			Hashtable<String, String> key = new Hashtable<String, String>();
			key.put("discountLogID", discountLogID);
			
			Hashtable<String, String> value = new Hashtable<String, String>();
			value.put("discountLogID", "");
			value.put("discountFlag", "0");
			value.put("discountRate", "");
			value.put("tag", "");
			DBProxy.update(getConnection(), "product", key, value);
			setFormData("action", "discountLogView");
		}
		
		public void zekouListViewAction() throws Exception {
			
		}
		
		private String getDatasStr(Vector<Hashtable<String, String>> datas) {
			StringBuffer sb = new StringBuffer();
			for(int i = 0; i < datas.size(); i++) {
				Hashtable<String, String> data = datas.get(i);
				sb.append(",").append(data.get("productID"));
			}
			return sb.toString();
		}
		
		public void selectProductOfDiscountWindowAction() throws Exception {
			setFormData("count", getFormData("windowCount"));
			setFormData("pageCount", getFormData("windowPageCount"));
			setFormData("pageNumber", getFormData("windowPageNumber"));
			setFormData("pageFrom", getFormData("windowPageFrom"));
			setFormData("pageTo", getFormData("windowPageTo"));
			setFormData("pageIndex", getFormData("windowPageIndex"));
			
			Hashtable<String, String> key = new Hashtable<String, String>();
			key.put("q_productID", getFormData("q_productID2"));
			key.put("q_name", getFormData("q_name2"));
			key.put("q_bigTypeID", getFormData("q_bigTypeID2"));
			key.put("q_smallTypeID", getFormData("q_smallTypeID2"));
			key.put("q_tinyTypeID", getFormData("q_tinyTypeID2"));
			key.put("q_brandID", getFormData("q_brandID2"));
			key.put("q_validFlag", "1");
			key.put("q_deletedFlag", "0");
			setFormData(key);
			
			initPageByQueryDataList("product_V", getFormDatas(), "productDatas", " productID not in(0" + getFormData("datasStr") + ")", new Vector<String>(), "");
			
			setFormData("windowCount", getFormData("count"));
			setFormData("windowPageCount", getFormData("pageCount"));
			setFormData("windowPageNumber", getFormData("pageNumber"));
			setFormData("windowPageFrom", getFormData("pageFrom"));
			setFormData("windowPageTo", getFormData("pageTo"));
			setFormData("windowPageIndex", getFormData("pageIndex"));
			
			setFormData("queryProductTypeSelect3", getQueryProductTypeSelect3Action());
		}
		
		public void addProductAction() throws Exception {
			String selectedValues = getFormData("selectedValues");
			String[] split = StringUtil.split(selectedValues, ",");
			StringBuffer productSb = new StringBuffer();
			for(int i = 0; i < split.length; i++) {
				productSb.append(",").append(split[i]);
			}
			String discountLogID = getFormData("discountLogID");
			Hashtable<String, String> k = new Hashtable<String, String>();
			k.put("discountLogID", discountLogID);
			Vector<Hashtable<String, String>> datas = DBProxy.query(getConnection(), "discountLog", k );
			if(datas.size() == 0) {
				setAjaxJavascript("postModuleAndAction('groupBuy', 'discountLogView');");
				return;
			}
			
			Hashtable<String, String> discountLog = datas.get(0);
			String sql2 = "update product set discountRate = ? , discountFlag = ?, discountLogID = ?, tag = ? where productID in(0" + productSb + ")";
			Vector<String> v2 = new Vector<String>();
			v2.add(discountLog.get("discountRate"));
			v2.add(discountLog.get("validFlag"));
			v2.add(discountLog.get("discountLogID"));
			v2.add(LocalDataCache.getInstance().getTableDataColumnValue("c_productTag", "3", "c_productTagName"));
			DBProxy.update(getConnection(), "product", sql2, v2);
			setAjaxJavascript("postModuleAndAction('groupBuy', 'zekouListView');");
		}
		
		public void batchDisableDiscountProductAction() throws Exception {
			String selectedValues = getFormData("selectedValues2");
			if (selectedValues.equals("")) {
				setAjaxInfoMessage("请选择要删除的商品");
				return;
			}
			
			StringBuffer sb = new StringBuffer();
			sb.append("update product set discountLogID = null, discountFlag = ?, tag = null where discountLogID = ?");
			Vector<String> v = new Vector<String>();
			v.add("0");
			v.add(getFormData("discountLogID"));
			
			sb.append(" and productID in (");
			String[] ids = selectedValues.split(",");
			for (int i = 0; i < ids.length; i++) {
				sb.append(i == 0 ? "?" : ",?");
				v.add(ids[i]);
			}
			sb.append(")");
			String updateSql = sb.toString();
			DBProxy.update(getConnection(), "product", updateSql, v);
			setAjaxJavascript("postModuleAndAction('groupBuy', 'zekouListView');");
		}
		
		public void defaultViewAction() throws Exception {
			listAction();
		}
		
		public void addViewAction() throws Exception {
			String[] items = {"groupBuyID", "name"};
			clearDatas(items);
		}
		
		public void selectOneProductWindowAction() throws Exception {
			setFormData("count", getFormData("windowCount"));
			setFormData("pageCount", getFormData("windowPageCount"));
			setFormData("pageNumber", getFormData("windowPageNumber"));
			setFormData("pageFrom", getFormData("windowPageFrom"));
			setFormData("pageTo", getFormData("windowPageTo"));
			setFormData("pageIndex", getFormData("windowPageIndex"));
			
			Hashtable<String, String> key = new Hashtable<String, String>();
			key.put("q_productID", getFormData("q_productID2"));
			key.put("q_name", getFormData("q_name2"));
			key.put("q_bigTypeID", getFormData("q_bigTypeID2"));
			key.put("q_smallTypeID", getFormData("q_smallTypeID2"));
			key.put("q_tinyTypeID", getFormData("q_tinyTypeID2"));
			key.put("q_brandID", getFormData("q_brandID2"));
			key.put("q_validFlag", "1");
			key.put("q_deletedFlag", "0");
			setFormData(key);
			
			initPageByQueryDataList("product_V", getFormDatas(), "productDatas", " productID not in(0" + getGroupBuyStr() + ")", new Vector<String>(), "");
			
			setFormData("windowCount", getFormData("count"));
			setFormData("windowPageCount", getFormData("pageCount"));
			setFormData("windowPageNumber", getFormData("pageNumber"));
			setFormData("windowPageFrom", getFormData("pageFrom"));
			setFormData("windowPageTo", getFormData("pageTo"));
			setFormData("windowPageIndex", getFormData("pageIndex"));
			
			setFormData("queryProductTypeSelect3", getQueryProductTypeSelect3Action());
		}
		
		public String getGroupBuyStr() throws Exception {
			String sql = "select * from groupBuy_V where status in(? ,?) and deletedFlag = ?";
			Vector<String> v = new Vector<String>();
			v.add("2");
			v.add("3");
			v.add("0");
			Vector<Hashtable<String, String>> groupBuyDatas = DBProxy.query(getConnection(), "groupBuy", sql, v );
			StringBuffer sb = new StringBuffer();
			for(int i = 0; i < groupBuyDatas.size(); i++) {
				Hashtable<String, String> data = groupBuyDatas.get(i);
				sb.append(",").append(data.get("productID"));
			}
			return sb.toString();
		}
		
		public void confirmAction() throws Exception {
			CheckList list = getChecklist();
			list.addCheckItem(new IntegerCheckItem("productID", "商品", true));
			list.addCheckItem(new IntegerCheckItem("groupBuyTypeID", "促销活动类型", true));
			list.addCheckItem(new PriceCheckItem("price", "价格", true));
			list.addCheckItem(new IntegerCheckItem("stock", "促销数量", true));
			
			if (!list.check()) {
				return;
			}
			
			if (!AppUtil.isDateTime(getFormData("startTime"))) {
				setAjaxJavascript("alert('开始时间输入不正确')");
				return;
			}
			
			if (!AppUtil.isDateTime(getFormData("endTime"))) {
				setAjaxJavascript("alert('结束时间输入不正确')");
				return;
			}
			
			if (getFormData("startTime").compareTo(getFormData("endTime")) > 0) {
				setAjaxJavascript("alert('开始时间不能在结束时间之后')");
				return;
			}
			
			Hashtable<String, String> k = new Hashtable<String, String>();
			k.put("productID", getFormData("productID"));
			Vector<Hashtable<String, String>> products = 
				DBProxy.query(getConnection(), "product", k);
			if (products.size() == 0) {
				setAjaxJavascript("alert('不存在该商品')");
				return;
			}
			
			
			setFormData("startTimeMills", AppUtil.timeToMills(getFormData("startTime")) + "");
			setFormData("endTimeMills", AppUtil.timeToMills(getFormData("endTime")) + "");
			if (DateTimeUtil.getCurrentDateTime().compareTo(getFormData("startTime")) < 0) {
				setFormData("status", "2");
			} else if (DateTimeUtil.getCurrentDateTime().compareTo(getFormData("endTime")) > 0) {
				setFormData("status", "4");
			} else {
				setFormData("status", "3");
			}
			
			String groupBuyID = getFormData("groupBuyID");
			if(!checkProductInfoPromotion(getFormData("productID"), groupBuyID)) {
				return;
			}
			if (groupBuyID.equals("")) {
				groupBuyID = IndexGenerater.getTableIndex("groupBuy", getConnection());
				setFormData("groupBuyID", groupBuyID);
				setFormData("supplierID", products.get(0).get("supplierID"));
				setFormData("addTime", DateTimeUtil.getCurrentDateTime());
				DBProxy.insert(getConnection(), "groupBuy", getFormDatas());
			} else {
				Hashtable<String, String> k2 = new Hashtable<String, String>();
				k2.put("groupBuyID", getFormData("groupBuyID"));
				
				DBProxy.update(getConnection(), "groupBuy", k2, getFormDatas());
			}
			
			setAjaxJavascript("postModuleAndAction('groupBuy','defaultView')");
		}
		
		private boolean checkProductInfoPromotion(String productID, String groupBuyID) throws Exception {
			String sql = "select * from groupBuy_V where productID = ? and status in(? ,?) and deletedFlag = ?";
			Vector<String> v = new Vector<String>();
			v.add(productID);
			v.add("2");
			v.add("3");
			v.add("0");
			Vector<Hashtable<String, String>> groupBuyDatas = DBProxy.query(getConnection(), "groupBuy_V", sql, v );
			for(int i = 0; i < groupBuyDatas.size(); i++) {
				Hashtable<String, String> data = groupBuyDatas.get(i);
				if(!data.get("groupBuyID").equals(groupBuyID)) {
					setAjaxJavascript("alert('该商品已经参与了秒杀/特价活动。同一时间，同一商品只能参与一种秒杀或特价活动！')");
					return false;
				}
			}
			return true;
		}
		
		public void editViewAction() throws Exception {
			getData("groupBuy", DATA_TYPE_VIEW);
		}
}
