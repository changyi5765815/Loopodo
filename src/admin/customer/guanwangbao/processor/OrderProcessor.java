package admin.customer.guanwangbao.processor;

import java.util.Hashtable;
import java.util.Vector;

import javax.servlet.http.Cookie;

import simpleWebFrame.config.Module;
import simpleWebFrame.database.DBProxy;
import simpleWebFrame.database.IndexGenerater;
import simpleWebFrame.log.AppLogger;
import simpleWebFrame.util.DateTimeUtil;
import simpleWebFrame.util.PriceUtil;
import simpleWebFrame.util.StringUtil;
import simpleWebFrame.web.CheckList;
import simpleWebFrame.web.DataHandle;
import simpleWebFrame.web.validate.IntegerCheckItem;
import simpleWebFrame.web.validate.PriceCheckItem;
import simpleWebFrame.web.validate.StringCheckItem;
import admin.customer.guanwangbao.AppKeys;
import admin.customer.guanwangbao.AppUtil;
import admin.customer.guanwangbao.LocalDataCache;
import admin.customer.guanwangbao.RandomCodeGenerator;
import admin.customer.guanwangbao.tool.ExcelUtils;
import admin.customer.guanwangbao.tool.KuaiDiNiaoAPI;
import admin.customer.guanwangbao.tool.MessageUtil;
import admin.customer.guanwangbao.tool.StockBillTool;
import admin.customer.guanwangbao.tool.SupplierAmountTool;
import admin.customer.guanwangbao.tool.UserMoneyTool;

import com.alibaba.fastjson.JSON;


public class OrderProcessor extends BaseProcessor {
	public OrderProcessor(Module module, DataHandle dataHandle) {
		super(module, dataHandle);
	}
	
	public void makeView() throws Exception {
	if (getFormData("action").equals("list")) {
			String q_fromOrderTime = getFormData("q_fromOrderTime");
			String q_toOrderTime = getFormData("q_toOrderTime");
			if (!getFormData("q_fromOrderTime").equals("")) {
				setFormData("q_fromOrderTime", getFormData("q_fromOrderTime") + " 00:00:00");
			}
			if (!getFormData("q_toOrderTime").equals("")) {
				setFormData("q_toOrderTime", getFormData("q_toOrderTime") + " 23:59:59");
			}

			if (getFormData("operationName").equals("")) {
				setFormData("operationName", "quanBuDingDan");
			}
			String operationName = getFormData("operationName");
			String q_statusIDString = getQ_statusIDString(operationName);
			String[] status = StringUtil.split(q_statusIDString, ", ");
			String extendSQL = "";
			
			Vector<String> values = new Vector<String>();
			for (int i = 0; i < status.length; i++) {
				extendSQL += "or status = ? ";
				values.add(status[i]);
			}
			
			if (!extendSQL.equals("")) {
				extendSQL = extendSQL.replaceFirst("or", "");
				extendSQL = " (" + extendSQL + " )";
			}
			
			if (!operationName.equals("quanBuDingDan") && !operationName.equals("yiChangDingDan")) {
				setFormData("q_exceptionFlag", "0");
			}
			
			if (operationName.equals("yiChangDingDan")) {
				setFormData("q_exceptionFlag", "1");
			}
			
//			待发货的订单中只显示那些未发生退款的订单
			if (operationName.equals("faHuoWanCheng")) {
				setFormData("q_refundStatus", "0");
			}
			String sortSql = "order by shopOrderID desc";
			
			initPageByQueryDataList("shopOrder_V", getFormDatas(), "datas", extendSQL, values, sortSql);
			
			setFormData("q_fromOrderTime", q_fromOrderTime);
			setFormData("q_toOrderTime", q_toOrderTime);
			setFormData("orderStatusSelect", makeSelectElementString("q_statusID", DBProxy.query(
					getConnection(), "c_orderStatus"), "c_orderStatusID",
					"c_orderStatusName", "", "", true, "", ""));
			setFormData("exceptionFlagSelect", makeSelectElementString("q_exceptionFlag", DBProxy.query(
					getConnection(), "c_yesOrNot"), "c_yesOrNotID",
					"c_yesOrNotName", "", "", true, "", ""));
			setFormData("queryOrderGroupSelect", makeSelectElementString("q_statusID", 
					LocalDataCache.getInstance().getTableDatas("c_orderStatus"), 
					"c_orderStatusID", "c_orderStatusName", ""));
		}
		
		if (!getFormData("action").equals("list")) { 
			setFormData("queryConditionHtml", makeQueryConditionHtml("shopOrder_V"));
		}
	}
	
	public void setExceptionWindowAction() throws Exception {
    	setFormData("queryExceptionTypeSelect", makeSelectElementString("exceptionTypeID", 
				LocalDataCache.getInstance().getTableDatas("c_exceptionType"), "c_exceptionTypeID", "c_exceptionTypeName", ""));
    }
	
	public void setExceptionOrderAction() throws Exception {
		CheckList list = getChecklist();
		list.addCheckItem(new IntegerCheckItem("exceptionTypeID", "问题类型", true));
		list.addCheckItem(new StringCheckItem("exceptionNote", "问题描述", true, 100));
		if (!list.check()) {
			return;
		}
		Hashtable<String, String> key = new Hashtable<String, String>();
		key.put("shopOrderID", getFormData("shopOrderID"));
		Hashtable<String, String> shopOrder = DBProxy.query(getConnection(), "shopOrder", key).get(0);
		if ("1".equals(shopOrder.get("exceptionFlag"))) {
			setAjaxJavascript("alert('该订单已经为问题订单,不需要重复执行此操作')");
			return;
		}
		Hashtable<String, String> value = new Hashtable<String, String>();
		value.put("exceptionTypeID", getFormData("exceptionTypeID"));
		value.put("exceptionNote", getFormData("exceptionNote"));
		value.put("exceptionFlag", "1");
		DBProxy.update(getConnection(), "shopOrder", key, value);
		
		setAjaxJavascript("closeInfoWindow();postModuleAndAction('order', 'defaultView')");
	}
	
	public void defaultViewAction() throws Exception {
		listAction();
	}
	
	private String getQ_statusIDString(String operationName) {
		String q_statusIDString = "";
		if (operationName.equals("zhiWeiYiFuKuan")) {
			return "1";//未付款
		} else if (operationName.equals("daiPeiHuo")) {
			return "2";//待配货
		} else if (operationName.equals("faHuoWanCheng")) {
			return "8";//待发货
		} else if (operationName.equals("queRenShouHuo")) {
			return "3,4";//已发货,已签收
		} else if (operationName.equals("jiaoYiWanCheng")) {
			return "5"; //交易成功
		} else if (operationName.equals("jiaoYiGuanBi")) {
			return "6"; //交易关闭
		} else if (operationName.equals("daiShenHe")) {
			return AppKeys.ORDER_STATUS_WAITAUDIT;
		}else if (operationName.equals("daiZiTi")) {
			return AppKeys.ORDER_STATUS_WAITZT;
		}
		return q_statusIDString;
	}
	
	public void searchAction() throws Exception {
		setFormData("pageIndex", "1");
		listAction();
	}
	
	public void detailViewAction() throws Exception {
		Hashtable<String, String> key = new Hashtable<String, String>();
		key.put("shopOrderID", getFormData("shopOrderID"));
		Vector<Hashtable<String, String>> datas = DBProxy.query(getConnection(), "shopOrder_v", key);
		setFormData(datas.get(0));
		/*
		if (getFormData("rebateFlag").equals("1")) {
			String rebateInfo = getFormData("rebateInfo");
			if (!rebateInfo.equals("")) {
				Hashtable<String, String> rebateData = JSON.parseObject(rebateInfo, new TypeReference<Hashtable<String, String>>(){});
				if (rebateData.get("rebateToUserID1") != null && !rebateData.get("rebateToUserID1").equals("")) {
					setFormData("rebateToUserID1", rebateData.get("rebateToUserID1"));
					setFormData("rebateToUserName1", getUserNameByID(rebateData.get("rebateToUserID1")));
					setFormData("rebateAmount1", rebateData.get("rebateAmount1"));
				}
				if (rebateData.get("rebateToUserID2") != null && !rebateData.get("rebateToUserID2").equals("")) {
					setFormData("rebateToUserID2", rebateData.get("rebateToUserID2"));
					setFormData("rebateToUserName2", getUserNameByID(rebateData.get("rebateToUserID2")));
					setFormData("rebateAmount2", rebateData.get("rebateAmount2"));
				}
				if (rebateData.get("rebateToUserID3") != null && !rebateData.get("rebateToUserID3").equals("")) {
					setFormData("rebateToUserID3", rebateData.get("rebateToUserID3"));
					setFormData("rebateToUserName3", getUserNameByID(rebateData.get("rebateToUserID3")));
					setFormData("rebateAmount3", rebateData.get("rebateAmount3"));
				}
			}
		}
		*/
		Vector<Hashtable<String, String>> itemDatas = DBProxy.query(getConnection(), "orderProduct_V", key);
		
		StringBuffer sb = new StringBuffer();
		for (int i = 0; i < itemDatas.size(); i++) {
			Hashtable<String, String> orderProduct = itemDatas.get(i);
    		sb.append(",").append(orderProduct.get("userFootTypeDataID"));
		}
		
		setJSPData("itemDatas", itemDatas);
	}
	
	public void solveExceptionAction() throws Exception {
		Hashtable<String, String> key = new Hashtable<String, String>();
		Hashtable<String, String> value = new Hashtable<String, String>();
		key.put("shopOrderID", getFormData("shopOrderID"));
		Hashtable<String, String> shopOrder = DBProxy.query(getConnection(), "shopOrder", key).get(0);
		if (!shopOrder.get("exceptionFlag").equals("1")) {
			setErrorMessage("该订单不为问题订单或问题已经处理，不能执行此操作");
			return;
		}
		value.put("exceptionFlag", "0");
		value.put("exceptionNote", "");
		value.put("exceptionTypeID", "");
		DBProxy.update(getConnection(), "shopOrder", key, value);

		listAction();
	}	
	
	public void payShopOrderWindowAction() throws Exception {
		Hashtable<String, String> k = new Hashtable<String, String>();
    	k.put("validFlag", "1");
    	Vector<Hashtable<String, String>> datas = 
    		DBProxy.query(getConnection(), "payType", k);
		setFormData("payTypeSelect", makeSelectElementString("payTypeID", datas, "payTypeID", "name", ""));
	}
	
	public void payShopOrderAction() throws Exception {
		CheckList list = getChecklist();
		list.addCheckItem(new IntegerCheckItem("payTypeID", "支付方式", true));
		list.addCheckItem(new StringCheckItem("transactionNum", "支付平台交易号", true));
		if (!list.check()) {
			return;
		}
		Hashtable<String, String> k = new Hashtable<String, String>();
		k.put("shopOrderID", getFormData("shopOrderID"));
		Vector<Hashtable<String, String>> shopOrders = DBProxy.query(getConnection(), "shopOrder", k);
		if (shopOrders.size() == 0) {
			setAjaxInfoMessage("该订单不存在");
			return;
		}
		
		Hashtable<String, String> shopOrder = shopOrders.get(0);
		if (!shopOrder.get("status").equals(AppKeys.ORDER_STATUS_UNPAY)) {
			setAjaxInfoMessage("该订单状态不为[待付款],操作失败");
			return;
		}
		if (shopOrder.get("exceptionFlag").equals("1")) {
			setAjaxInfoMessage("该订单为异常订单,操作失败");
			return;
		}
		
		Hashtable<String, String> shopOrderV = new Hashtable<String, String>();
		shopOrderV.put("status", AppKeys.ORDER_STATUS_DAIPEIHUO);
		float canRefundAmount = Float.parseFloat(shopOrder.get("canRefundAmount")) + 
			Float.parseFloat(shopOrder.get("needPayMoney"));
		String payTime = DateTimeUtil.getCurrentDateTime();
		shopOrderV.put("payAmount", shopOrder.get("needPayMoney"));
		shopOrderV.put("payTime", payTime);
		shopOrderV.put("payFlag", "1");
		shopOrderV.put("canRefundAmount", canRefundAmount + "");
		shopOrderV.put("canRefundBankMoney", Float.parseFloat(shopOrder.get("needPayMoney")) + ""); //更新订单可退金额
		shopOrderV.put("payTypeID", getFormData("payTypeID"));
		shopOrderV.put("transactionNum", getFormData("transactionNum"));
		setAjaxJavascript("alert('操作成功');closeInfoWindow();postModuleAndAction('order', 'defaultView')");
		int count = DBProxy.update(getConnection(), "shopOrder", k, shopOrderV);
		
		if (count == 0) {
			return;
		}
		
		if (!shopOrder.get("supplierID").equals("") && !shopOrder.get("payWayID").equals("99")) {
			String supplierAmount = String.valueOf(Double.valueOf(shopOrder.get("accountMoney")) 
//					+ Double.valueOf(shopOrder.get("cardAmount")) 
					+ Double.valueOf(shopOrder.get("needPayMoney")));
			SupplierAmountTool.plusLockAmount(getConnection(), "", shopOrder.get("supplierID"), 
					supplierAmount, shopOrder.get("shopOrderID"), "");
			
			Hashtable<String, String> shopOrderK = new Hashtable<String, String>();
			shopOrderK.put("shopOrderID", getFormData("shopOrderID"));
			Hashtable<String, String> v = new Hashtable<String, String>();
			v.put("supplierAmount", supplierAmount);
			DBProxy.update(getConnection(), "shopOrder", shopOrderK, v);
		}
		
		if(shopOrder.get("wholeSitePromotionFlag").equals("1") && shopOrder.get("promotionActiveTypeID").equals("2")) {//TODO
			BaseProcessor.insertPromotion(getConnection(), shopOrder, shopOrderV.get("payTime"));
		}
		StockBillTool.minStockBillByUpdateOrder(getConnection(), "1",  shopOrder.get("shopOrderID"), false);
		
		BaseProcessor.updateUserShoppingInfo(getConnection(), shopOrder.get("userID"), 0, 1, 
				Double.parseDouble(shopOrder.get("needPayMoney")), "", 0, 0, "");
		UserMoneyTool.updateShopUserShoppingInfo(getConnection(), shopOrder.get("userID"), shopOrder.get("supplierID"), 1, 1, Double.valueOf(shopOrder.get("needPayMoney")), payTime, 0, (!shopOrder.get("cardID").equals("") ? 1 : 0), "");
	}
	
	
	public void finishPeiHuoAction() throws Exception {
		Hashtable<String, String> key = new Hashtable<String, String>();
		key.put("shopOrderID", getFormData("shopOrderID"));
		Hashtable<String, String> shopOrder = DBProxy.query(getConnection(), "shopOrder", key).get(0);
		
		if (!shopOrder.get("status").equals(AppKeys.ORDER_STATUS_DAIPEIHUO)) {
			setErrorMessage("订单状态为:[待配货]的状态下才能执行此操作");
            return;
		}
		if (!"0".equals(shopOrder.get("refundStatus"))) {
			setErrorMessage("该订单已经申请退款，不能执行此操作");
            return;
		}
		Hashtable<String, String> v = new Hashtable<String, String>();
		if (shopOrder.get("ztFlag").equals("1")) {
			v.put("status", AppKeys.ORDER_STATUS_WAITZT);
			v.put("ztCode", getFormData("shopOrderID") + RandomCodeGenerator.generateCodeString(6));
			//发送自提码短信
			Hashtable<String, String> shopK = new Hashtable<String, String>();
			shopK.put("shopID", shopOrder.get("shopID"));
			Hashtable<String, String> shop = DBProxy.query(getConnection(), "shop_V", shopK).get(0);
			String address = shop.get("provinceName") + "-" + shop.get("cityName") + "-" + shop.get("townName") + "-" + shop.get("address");
			String[] paras = {"蜜品会", shopOrder.get("shopOrderID"), address, v.get("ztCode")};
			MessageUtil.sendMessage(shopOrder.get("mobile"), paras, AppKeys.SMS_ZT_TEMPID);
		} else {
			v.put("status", AppKeys.ORDER_STATUS_DAIFAHUO);
		}
		DBProxy.update(getConnection(), "shopOrder", key, v);
		
		setInfoMessage("配货完成");
		listAction();
	}
	
	
	public void orderDeliveryWindowAction() throws Exception {
		setFormData("devlieryTypeSelect", makeSelectElementString("deliveryTypeID", 
				LocalDataCache.getInstance().getTableDatas("deliveryType"), "deliveryTypeID", "name", ""));
    }
	
	public void faHuoAction() throws Exception {
		CheckList list = getChecklist();
		list.addCheckItem(new StringCheckItem("deliveryTypeID", "物流公司", true));
		list.addCheckItem(new StringCheckItem("deliveryCode", "物流单号", true));
		if (!list.check()) {
			return;
		}
		
		Hashtable<String, String> key = new Hashtable<String, String>();
		key.put("shopOrderID", getFormData("shopOrderID"));
		Hashtable<String, String> shopOrder = DBProxy.query(getConnection(), "shopOrder", key).get(0);
		
		if (!shopOrder.get("status").equals(AppKeys.ORDER_STATUS_DAIFAHUO)) {
			setErrorMessage("订单状态为:[待发货]的状态下才能执行此操作");
            return;
		}
		if (!"0".equals(shopOrder.get("refundStatus"))) {
			setErrorMessage("该订单已经申请退款，不能执行此操作");
            return;
		}

		Hashtable<String, String> v = new Hashtable<String, String>();
		v.put("deliveryTypeID", getFormData("deliveryTypeID"));
		v.put("deliveryCode", getFormData("deliveryCode"));
		v.put("deliveryTime", DateTimeUtil.getCurrentDateTime());
		long deliveryTimeMills = System.currentTimeMillis();
		v.put("deliveryTimeMills", deliveryTimeMills + "");
		v.put("autoReviceGoodsDeadTimeMills", 
				(deliveryTimeMills + AppKeys.AUTO_REC_DAY) + "");
		v.put("status", AppKeys.ORDER_STATUS_DAISHOUHUO);
		
		DBProxy.update(getConnection(), "shopOrder", key, v);
		
		if(!v.get("deliveryTypeID").equals("") 
				&& !v.get("deliveryCode").equals("")) {
			shopOrder.putAll(v);
			inserDeliveryRouter(shopOrder);
		}
		
		setAjaxJavascript("alert('发货完成');closeInfoWindow();postModuleAndAction('order','list')");
	}
	
	private void inserDeliveryRouter(Hashtable<String, String> shopOrder) {
		try {
			Hashtable<String, String> town1 = LocalDataCache.getInstance().getTableDataByID("town", shopOrder.get("townID"));
			Hashtable<String, String> city1 = LocalDataCache.getInstance().getTableDataByID("city", 
					town1.get("cityID") != null ? town1.get("cityID").toString() : "");
			Hashtable<String, String> deliveryTypeData = 
					LocalDataCache.getInstance().getTableDataByID("deliveryType", shopOrder.get("deliveryTypeID"));
			
			if (deliveryTypeData.get("code").equals("")) {
				return;
			}
			
			String to = city1.get("name");
			Hashtable<String, String> deliveryRouterKV = new Hashtable<String, String>();
			deliveryRouterKV.put("deliveryRouterID", IndexGenerater.getTableIndex("deliveryRouter", getConnection()));
			deliveryRouterKV.put("shopOrderID", shopOrder.get("shopOrderID"));
			deliveryRouterKV.put("userID", shopOrder.get("userID"));
			deliveryRouterKV.put("logisticsCompanyName", deliveryTypeData.get("name"));
			deliveryRouterKV.put("logisticsCompanyCode",deliveryTypeData.get("code"));
			deliveryRouterKV.put("deliveryCode", shopOrder.get("deliveryCode"));
			deliveryRouterKV.put("salt", RandomCodeGenerator.generateCode(20));
			boolean res = KuaiDiNiaoAPI.orderTracesSubByJson(deliveryRouterKV.get("logisticsCompanyCode"),
					deliveryRouterKV.get("deliveryCode"), to, deliveryRouterKV.get("salt"));
			
			deliveryRouterKV.put("subscribeFlag", res ? "1" : "0");
			deliveryRouterKV.put("exceptionFlag", "0");
			deliveryRouterKV.put("recFlag", "0");
			
			DBProxy.insert(getConnection(), "deliveryRouter", deliveryRouterKV);
			
		} catch (Exception e) {
			AppLogger.getInstance().errorLog("快递100订阅失败", e);
		}
	}
	
	public void acceptOrderAction() throws Exception {
		listAction();
		Hashtable<String, String> key = new Hashtable<String, String>();
		key.put("shopOrderID", getFormData("shopOrderID"));
		Hashtable<String, String> shopOrder = DBProxy.query(getConnection(), "shopOrder", key).get(0);
		if (!shopOrder.get("status").equals(AppKeys.ORDER_STATUS_DAISHOUHUO)) {
			setErrorMessage("订单状态为:[待确认收货]的状态下才能执行此操作");
			return;
		}
		
		if ("1".equals(shopOrder.get("returnGoodsStatus"))) {
			setErrorMessage("该订单为退货中订单，无法进行此操作");
			return;
		}
		
		Hashtable<String, String> value = new Hashtable<String, String>();
		value.put("receiveGoodsTime", DateTimeUtil.getCurrentDateTime());
		value.put("status", AppKeys.ORDER_STATUS_YISHOUHUO);
		long reviceTimeMills = System.currentTimeMillis();
		value.put("autoFinishDeadTimeMills", 
				(reviceTimeMills + AppKeys.AUTO_FINISH_DAY) + "");
	
		DBProxy.update(getConnection(), "shopOrder", key, value);
		
		setInfoMessage("确认收货完成");
		
		listAction();
	}	
	
	
	public void orderAuditWindowAction() throws Exception {
		Hashtable<String, String> key = new Hashtable<String, String>();
    	key.put("shopOrderID", getFormData("shopOrderID"));
    	Hashtable<String, String> shopOrder = DBProxy.query(getConnection(), "shopOrder", key).get(0);
    	if (!shopOrder.get("status").equals(AppKeys.ORDER_STATUS_WAITAUDIT)) {
    		setAjaxJavascript("alert('订单的状态不为[待审核]')");
    		setReDispath();
    		return;
    	}
	}
	
	public void auditAction() throws Exception {
		CheckList list = getChecklist();
		list.addCheckItem(new IntegerCheckItem("auditStatus", "审核结果", true));
		if (getFormData("auditStatus").equals("0")) {
			list.addCheckItem(new StringCheckItem("auditNote", "审核备注", true));
		}
		if (!list.check()) {
			return;
		}
		Hashtable<String, String> key = new Hashtable<String, String>();
    	key.put("shopOrderID", getFormData("shopOrderID"));
    	Hashtable<String, String> shopOrder = DBProxy.query(getConnection(), "shopOrder", key).get(0);
    	if (!shopOrder.get("status").equals(AppKeys.ORDER_STATUS_WAITAUDIT)) {
    		setAjaxJavascript("alert('订单的状态不为[待审核]')");
    		return;
    	}
    	
    	String status = getFormData("auditStatus").equals("1") ? AppKeys.ORDER_STATUS_DAIPEIHUO : AppKeys.ORDER_STATUS_CLOSE;
    	Hashtable<String, String> v = new Hashtable<String, String>();
    	v.put("status", status);
    	v.put("auditNote", getFormData("auditNote"));
    	DBProxy.update(getConnection(), "shopOrder", key, v);
    	
//    	if (status.equals(AppKeys.ORDER_STATUS_CLOSE)) {
//    		if (Float.parseFloat(shopOrder.get("canRefundAmount")) > 0.00f) {
//				UserMoneyTool.plusUserMoney(getConnection(), shopOrder.get("userID"), shopOrder.get("supplierID"),
//						shopOrder.get("canRefundAmount"), "2", shopOrder.get("shopOrderID"));
//			}
//    	}
    	
    	setAjaxJavascript("alert('操作成功');closeInfoWindow();postModuleAndAction('order', 'list')");
	}
	
	
	public void finishZTAction() throws Exception {
		Hashtable<String, String> key = new Hashtable<String, String>();
		key.put("shopOrderID", getFormData("shopOrderID"));
		Hashtable<String, String> shopOrder = DBProxy.query(getConnection(), "shopOrder", key).get(0);
		
		if (!shopOrder.get("status").equals(AppKeys.ORDER_STATUS_WAITZT)) {
			setErrorMessage("订单状态为:[待自提]的状态下才能执行此操作");
            return;
		}
		Hashtable<String, String> v = new Hashtable<String, String>();
		v.put("receiveGoodsTime", DateTimeUtil.getCurrentDateTime());
		v.put("status", AppKeys.ORDER_STATUS_YISHOUHUO);
		long reviceTimeMills = System.currentTimeMillis();
		v.put("autoFinishDeadTimeMills", 
				(reviceTimeMills + AppKeys.AUTO_FINISH_DAY) + "");
		DBProxy.update(getConnection(), "shopOrder", key, v);
		setInfoMessage("自提完成");
		listAction();
	}
	
	public void deliveryInfoWindowAction() throws Exception {
		Hashtable<String, String> key = new Hashtable<String, String>();
		key.put("shopOrderID", getFormData("shopOrderID"));
		Vector<Hashtable<String, String>> deliveryRouters = DBProxy.query(getConnection(), "deliveryRouter", key);
		if (deliveryRouters.size() > 0) {
			Hashtable<String, String> deliveryRouter = deliveryRouters.get(0);
			String info = deliveryRouter.get("info");
			String recFlag = deliveryRouter.get("recFlag");
			setFormData("recFlag", recFlag);
			if (!info.equals("")) {
				Vector<Hashtable<String, Object>> routers = null;
				try {
					routers = JSON.parseObject(info, Vector.class);
				} catch (Exception e) {}
				if (routers != null) {
					setJSPData("routers", routers);
				}
			}
		}
	}
	
	
	public void exportOrderWindowAction() throws Exception {
		setFormData("shopOrderColumns-1", "," + getCookieData("columnGroup1").replace("$", ",") + ",");
		setFormData("shopOrderColumns-2", "," + getCookieData("columnGroup2").replace("$", ",") + ",");
		setFormData("shopOrderColumns-3", "," + getCookieData("columnGroup3").replace("$", ",") + ",");
		setFormData("shopOrderColumns-4", "," + getCookieData("columnGroup4").replace("$", ",") + ",");
		setFormData("shopOrderColumns-5", "," + getCookieData("columnGroup5").replace("$", ",") + ",");
		setFormData("shopOrderColumns-6", "," + getCookieData("columnGroup6").replace("$", ",") + ",");
	}
	
	public void exportAction() throws Exception {
		String columnGroup1 = getFormData("shopOrderColumns-1");
		String columnGroup2 = getFormData("shopOrderColumns-2");
		String columnGroup3 = getFormData("shopOrderColumns-3");
		String columnGroup4 = getFormData("shopOrderColumns-4");
		String columnGroup5 = getFormData("shopOrderColumns-5");
		String columnGroup6 = getFormData("shopOrderColumns-6");
		
		String columns = "," + columnGroup1 + "," + columnGroup2 + "," + columnGroup3 + "," + columnGroup4 + "," + columnGroup5 + "," + columnGroup6 + ",";
		
		String[] columnArray = StringUtil.split(columns, ",");
		if (columnArray.length == 0) {
			setAjaxJavascript("alert('请选择要导出的列');$('#confirmBut').css('display', '');$('#hasNotSend_img').css('display', 'none');");
			return;
		}
		
		Cookie columnGroup1Cookie = new Cookie("columnGroup1", columnGroup1.replace(",", "$"));
		Cookie columnGroup2Cookie = new Cookie("columnGroup2", columnGroup2.replace(",", "$"));
		Cookie columnGroup3Cookie = new Cookie("columnGroup3", columnGroup3.replace(",", "$"));
		Cookie columnGroup4Cookie = new Cookie("columnGroup4", columnGroup4.replace(",", "$"));
		Cookie columnGroup5Cookie = new Cookie("columnGroup5", columnGroup5.replace(",", "$"));
		Cookie columnGroup6Cookie = new Cookie("columnGroup6", columnGroup6.replace(",", "$"));
		columnGroup1Cookie.setMaxAge(30 * 24 * 60 * 60);
		columnGroup2Cookie.setMaxAge(30 * 24 * 60 * 60);
		columnGroup3Cookie.setMaxAge(30 * 24 * 60 * 60);
		columnGroup4Cookie.setMaxAge(30 * 24 * 60 * 60);
		columnGroup5Cookie.setMaxAge(30 * 24 * 60 * 60);
		columnGroup6Cookie.setMaxAge(30 * 24 * 60 * 60);
		setCookieData(columnGroup1Cookie);
		setCookieData(columnGroup2Cookie);
		setCookieData(columnGroup3Cookie);
		setCookieData(columnGroup4Cookie);
		setCookieData(columnGroup5Cookie);
		setCookieData(columnGroup6Cookie);
		
		Vector<String> exportColumnsInfo = new Vector<String>();
		int mergeColumnNumber = 0;
		int productInfoNumber = 0;
		for (int i = 0; i < columnArray.length; ++i) {
			String tmpColumn = columnArray[i];
			
			if (!tmpColumn.equals("productID") && !tmpColumn.equals("productName") && !tmpColumn.equals("propName") && !tmpColumn.equals("price")
				&& !tmpColumn.equals("settlementPrice") && !tmpColumn.equals("number") && !tmpColumn.equals("numberAndPrice")) {
				mergeColumnNumber++;
			}
			
			if (tmpColumn.equals("shopOrderID")) {
				exportColumnsInfo.add("订单编号-" + tmpColumn);
			} else if (tmpColumn.equals("sourceType")) {
				exportColumnsInfo.add("订单来源-" + tmpColumn);
			} else if (tmpColumn.equals("orderTime")) {
				exportColumnsInfo.add("下单时间-" + tmpColumn);
			} else if (tmpColumn.equals("status")) {
				exportColumnsInfo.add("订单状态-" + tmpColumn);
			} else if (tmpColumn.equals("note")) {
				exportColumnsInfo.add("用户备注-" + tmpColumn);
			} else if (tmpColumn.equals("auditNote")) {
				exportColumnsInfo.add("审核备注-" + tmpColumn);
			} else if (tmpColumn.equals("shouHuoRen")) {
				exportColumnsInfo.add("收货人-" + tmpColumn);
			} else if (tmpColumn.equals("mobile")) {
				exportColumnsInfo.add("收货人手机-" + tmpColumn);
			} else if (tmpColumn.equals("phone")) {
				exportColumnsInfo.add("收货人电话-" + tmpColumn);
			} else if (tmpColumn.equals("address")) {
				exportColumnsInfo.add("收货人地址-" + tmpColumn);
			} else if (tmpColumn.equals("postalCode")) {
				exportColumnsInfo.add("收货人邮编-" + tmpColumn);
			} else if (tmpColumn.equals("payType")) {
				exportColumnsInfo.add("支付方式-" + tmpColumn);
			} else if (tmpColumn.equals("payTime")) {
				exportColumnsInfo.add("支付时间-" + tmpColumn);
			} else if (tmpColumn.equals("deliveryType")) {
				exportColumnsInfo.add("送货方式-" + tmpColumn);
			} else if (tmpColumn.equals("productMoney")) {
				exportColumnsInfo.add("商品总金额-" + tmpColumn);
			} else if (tmpColumn.equals("invoiceTitle")) {
				exportColumnsInfo.add("发票抬头-" + tmpColumn);
			} else if (tmpColumn.equals("deliveryMoney")) {
				exportColumnsInfo.add("运费-" + tmpColumn);
			} else if (tmpColumn.equals("cutMoney1")) {
				exportColumnsInfo.add("满减金额-" + tmpColumn);
			} else if (tmpColumn.equals("cutMoney2")) {
				exportColumnsInfo.add("满赠金额-" + tmpColumn);
			} else if (tmpColumn.equals("accountMoney")) {
				exportColumnsInfo.add("余额支付-" + tmpColumn);
			} else if (tmpColumn.equals("cardAmount")) {
				exportColumnsInfo.add("优惠券支付-" + tmpColumn);
			} else if (tmpColumn.equals("totalPrice")) {
				exportColumnsInfo.add("订单总金额-" + tmpColumn);
			} else if (tmpColumn.equals("payAmount")) {
				exportColumnsInfo.add("实收金额-" + tmpColumn);
			} else if (tmpColumn.equals("productID")) {
				productInfoNumber++;
				exportColumnsInfo.add("编码-" + tmpColumn);
			} else if (tmpColumn.equals("productName")) {
				productInfoNumber++;
				exportColumnsInfo.add("名称-" + tmpColumn);
			} else if (tmpColumn.equals("propName")) {
				productInfoNumber++;
				exportColumnsInfo.add("销售属性-" + tmpColumn);
			} else if (tmpColumn.equals("price")) {
				productInfoNumber++;
				exportColumnsInfo.add("价格-" + tmpColumn);
			} else if (tmpColumn.equals("settlementPrice")) {
				productInfoNumber++;
				exportColumnsInfo.add("结算价-" + tmpColumn);
			} else if (tmpColumn.equals("number")) {
				productInfoNumber++;
				exportColumnsInfo.add("数量-" + tmpColumn);
			} else if (tmpColumn.equals("numberAndPrice")) {
				productInfoNumber++;
				exportColumnsInfo.add("总价-" + tmpColumn);
			}
		}
		
		if (!getFormData("q_fromOrderTime").equals("")) {
			setFormData("q_fromOrderTime", getFormData("q_fromOrderTime") + " 00:00:00");
		}
		if (!getFormData("q_toOrderTime").equals("")) {
			setFormData("q_toOrderTime", getFormData("q_toOrderTime") + " 23:59:59");
		}

		if (getFormData("operationName").equals("")) {
			setFormData("operationName", "quanBuDingDan");
		}
		String operationName = getFormData("operationName");
		String q_statusIDString = getQ_statusIDString(operationName);
		String[] status = StringUtil.split(q_statusIDString, ", ");
		String extendSQL = "";
		
		Vector<String> values = new Vector<String>();
		for (int i = 0; i < status.length; i++) {
			extendSQL += "or status = ? ";
			values.add(status[i]);
		}
		
		if (!extendSQL.equals("")) {
			extendSQL = extendSQL.replaceFirst("or", "");
			extendSQL = " (" + extendSQL + " )";
		}
		
		if (!operationName.equals("quanBuDingDan") && !operationName.equals("yiChangDingDan")) {
			setFormData("q_exceptionFlag", "0");
		}
		
		if (operationName.equals("yiChangDingDan")) {
			setFormData("q_exceptionFlag", "1");
		}
		if (operationName.equals("faHuoWanCheng")) {
			setFormData("q_refundStatus", "0");
		}
		String sortSql = "order by shopOrderID desc";
		
		initPageByQueryDataList("shopOrder_V", getFormDatas(), "datas", extendSQL, values, sortSql);
		
		Vector<Hashtable<String, String>> exportShopOrders = new Vector<Hashtable<String,String>>();
		
		int pageCount = Integer.parseInt(getFormData("pageCount"));
		Vector<Hashtable<String, String>> firstPageDatas = (Vector<Hashtable<String, String>>) getJSPData("datas");
		exportShopOrders.addAll(firstPageDatas);
		
		for (int i = 2; i <= pageCount; ++i) {
			setFormData("pageIndex", i + "");
			initPageByQueryDataList("shopOrder_V", getFormDatas(), "datas", extendSQL, values, sortSql);
			Vector<Hashtable<String, String>> curPageDatas = (Vector<Hashtable<String, String>>) getJSPData("datas");
			exportShopOrders.addAll(curPageDatas);
		}
		
		if (exportShopOrders.size() == 0) {
			setAjaxJavascript("$('#confirmBut').css('display', '');$('#hasNotSend_img').css('display', 'none');alert('无订单数据');");
			return;
		}
		
		String fileName = null;
		if (productInfoNumber == 0) {
			dealData(exportShopOrders);
			
			fileName = ExcelUtils.export("导出订单", exportColumnsInfo, exportShopOrders);
		} else {
			Vector<Hashtable<String, String>> exportDatas = dealDataWithMergeCells(exportShopOrders);
			Vector<Integer> mergeLines = new Vector<Integer>();
			for (int i = 0; i < mergeColumnNumber; i++) {
				mergeLines.add(i);
			}
			fileName = ExcelUtils.exportTableDataWithMergeCells("导出订单", exportColumnsInfo, exportDatas, mergeLines, "shopOrderID");
		}
		
		if(fileName == null) {
			setAjaxJavascript("alert('导出失败，请重试');$('#confirmBut').css('display', '');$('#hasNotSend_img').css('display', 'none');");
			return;
		}
		String fileDirName = "default/tmp";
		String downLoadDir = "location.href='/download?dir=" + fileDirName + "&fileName=" + fileName + "'";
		setAjaxJavascript(downLoadDir + ";$('#confirmBut').css('display', '');$('#hasNotSend_img').css('display', 'none');");
	}
	
	private void dealData(Vector<Hashtable<String, String>> datas) throws Exception {
		for (int i = 0; i < datas.size(); ++i) {
			Hashtable<String, String> data = datas.get(i);
			
			Hashtable<String, String> area = AppUtil.getArea(data.get("townID"));
			String address =  area.get("provinceName") + area.get("cityName") + area.get("townName") + data.get("address");
			
			String payType = data.get("payWayID").equals("1") ? "在线支付" : data.get("payWayID").equals("99") ? "货到付款" : "";
			if (data.get("payWayID").equals("1")) { 
				String payTypeName = LocalDataCache.getInstance().getTableDataColumnValue("payType", data.get("payTypeID"), "name");
				if (!payTypeName.equals("")) {
					payType += ("(" + payTypeName + ")");
				}
			}
			data.put("payType", payType);
			
			String deliveryType = data.get("ztFlag").equals("1") ? "自提" : 
				LocalDataCache.getInstance().getTableDataColumnValue("deliveryType", data.get("deliveryTypeID"), "name");
			data.put("deliveryType", deliveryType);
			
			data.put("invoiceTitle", data.get("invoiceFlag").equals("1") ? data.get("invoiceTitle") : "不开发票");
			
			String cutMoney1 = data.get("wholeSitePromotionFlag").equals("1") && !data.get("promotionActiveTypeID").equals("2") ? data.get("cutMoney") : "0.00";//TODO
			String cutMoney2 = data.get("wholeSitePromotionFlag").equals("1") && data.get("promotionActiveTypeID").equals("2") ? data.get("cutMoney") : "0.00";//TODO
			data.put("cutMoney1", cutMoney1);
			data.put("cutMoney2", cutMoney2);
			
			String shopOrderSourceType = LocalDataCache.getInstance().getTableDataColumnValue("c_shopOrderSourceType", 
					data.get("sourceTypeID"), "c_shopOrderSourceTypeName");
			data.put("sourceType", shopOrderSourceType);
			data.put("status", LocalDataCache.getInstance().getTableDataColumnValue("c_orderStatus", data.get("status"), "c_orderStatusName"));
			data.put("address", address);
		}
	}
	
	private Vector<Hashtable<String, String>> dealDataWithMergeCells(Vector<Hashtable<String, String>> shopOrders) throws Exception {
		Vector<Hashtable<String, String>> exportDatas = new Vector<Hashtable<String,String>>();
		Hashtable<String, Vector<Hashtable<String,String>>> orderItemDatas = getOrderItemDatas(shopOrders);
		for (int i = 0; i < shopOrders.size(); ++i) {
			Hashtable<String, String> data = shopOrders.get(i);
			
			Hashtable<String, String> area = AppUtil.getArea(data.get("townID"));
			String address =  area.get("provinceName") + area.get("cityName") + area.get("townName") + data.get("address");
			
			String payType = data.get("payWayID").equals("1") ? "在线支付" : data.get("payWayID").equals("99") ? "货到付款" : "";
			if (data.get("payWayID").equals("1")) { 
				String payTypeName = LocalDataCache.getInstance().getTableDataColumnValue("payType", data.get("payTypeID"), "name");
				if (!payTypeName.equals("")) {
					payType += ("(" + payTypeName + ")");
				}
			}
			data.put("payType", payType);
			
			String deliveryType = data.get("ztFlag").equals("1") ? "自提" : 
				LocalDataCache.getInstance().getTableDataColumnValue("deliveryType", data.get("deliveryTypeID"), "name");
			data.put("deliveryType", deliveryType);
			
			data.put("invoiceTitle", data.get("invoiceFlag").equals("1") ? data.get("invoiceTitle") : "不开发票");
			
			String cutMoney1 = data.get("wholeSitePromotionFlag").equals("1") && !data.get("promotionActiveTypeID").equals("2") ? data.get("cutMoney") : "0.00";//TODO
			String cutMoney2 = data.get("wholeSitePromotionFlag").equals("1") && data.get("promotionActiveTypeID").equals("2") ? data.get("cutMoney") : "0.00";//TODO
			data.put("cutMoney1", cutMoney1);
			data.put("cutMoney2", cutMoney2);
			
			String shopOrderSourceType = LocalDataCache.getInstance().getTableDataColumnValue("c_shopOrderSourceType", 
					data.get("sourceTypeID"), "c_shopOrderSourceTypeName");
			data.put("sourceType", shopOrderSourceType);
			data.put("status", LocalDataCache.getInstance().getTableDataColumnValue("c_orderStatus", data.get("status"), "c_orderStatusName"));
			data.put("address", address);
			
			String shopOrderID = data.get("shopOrderID");
			Hashtable<String, String> itemKey = new Hashtable<String, String>();
			itemKey.put("shopOrderID", shopOrderID);
			Vector<Hashtable<String, String>> itemV = orderItemDatas.get(shopOrderID);
			data.put("mergeCellsLineNumber", String.valueOf(itemV.size()));
			for (int j = 0; j < itemV.size(); j++) {
				Hashtable<String, String> data2 = new Hashtable<String, String>();
				if (j == 0) {
					data2.putAll(data);
				}
				Hashtable<String, String> itemData = itemV.get(j);
				data2.put("productID", itemData.get("productID"));
				data2.put("productName", itemData.get("name"));
				data2.put("propName", itemData.get("propName"));
				data2.put("price", itemData.get("price"));
				data2.put("settlementPrice", itemData.get("settlementPrice"));
				data2.put("number", itemData.get("number"));
				data2.put("numberAndPrice", PriceUtil.multiPrice(data2.get("price").toString(), Integer.parseInt(data2.get("number").toString())));
				
				exportDatas.add(data2);
			}
		}
		return exportDatas;
	}
	
	private Hashtable<String, Vector<Hashtable<String, String>>> getOrderItemDatas(Vector<Hashtable<String, String>> shopOrders) throws Exception {
		Hashtable<String, Vector<Hashtable<String, String>>> itemDatas = new Hashtable<String, Vector<Hashtable<String,String>>>();
		Vector<String> keys = new Vector<String>();
		StringBuffer sb = new StringBuffer();
		for (int i = 0; i < shopOrders.size(); i++) {
			if (i == 0 || (i % 100 == 0)) {
				sb.append("(?");
			} else {
				sb.append(",?");
			}
			keys.add(shopOrders.get(i).get("shopOrderID"));
			if (((i + 1) % 100 == 0) || (i == (shopOrders.size() - 1))) {
				sb.append(")");
				String preparedSql = "select * from orderProduct_V where shopOrderID in";
				preparedSql += sb.toString();
				Vector<Hashtable<String, String>> datas = DBProxy.query(getConnection(), "orderProduct_V", preparedSql, keys);
				for (int j = 0; j < datas.size(); j++) {
					if (itemDatas.get(datas.get(j).get("shopOrderID")) == null) {
						Vector<Hashtable<String, String>> tmpDatas = new Vector<Hashtable<String,String>>();
						tmpDatas.add(datas.get(j));
						itemDatas.put(datas.get(j).get("shopOrderID"), tmpDatas);
					} else {
						itemDatas.get(datas.get(j).get("shopOrderID")).add(datas.get(j));
					}
				}
				sb.delete(0, sb.length());
				keys.clear();
			}
		}
		return itemDatas;
	}
	
	public void changeOrderPriceWindowAction() throws Exception {
		Hashtable<String, String> key = new Hashtable<String, String>();
		key.put("shopOrderID", getFormData("shopOrderID"));
		Vector<Hashtable<String, String>> datas = DBProxy.query(getConnection(), "shopOrder", key);
		if (datas.size() == 0) {
			setAjaxJavascript("alert('订单不存在');");
			return;
		}
		setFormData("oldTotalPrice", datas.get(0).get("oldTotalPrice"));
	}
	
	public void changeOrderPriceAction() throws Exception {
		CheckList list = getChecklist();
		list.addCheckItem(new PriceCheckItem("inputTotalPrice", "修改后订单总价", true));
		if (!list.check()) {
			return;
		}
		
		String shopOrderID = getFormData("shopOrderID");
		Hashtable<String, String> key = new Hashtable<String, String>();
		key.put("shopOrderID", shopOrderID);
		Vector<Hashtable<String, String>> datas = DBProxy.query(getConnection(), "shopOrder", key);
		if (datas.size() == 0) {
			setAjaxJavascript("alert('订单不存在');");
			return;
		}
		
		if (!datas.get(0).get("status").equals(AppKeys.ORDER_STATUS_UNPAY) 
				&& !datas.get(0).get("status").equals(AppKeys.ORDER_STATUS_WAITAUDIT)) {
			setAjaxJavascript("alert('只有待付款和待审核的订单才能修改价格');");
			return;
		}
		String inputTotalPrice = getFormData("inputTotalPrice");
		String oldTotalPice = datas.get(0).get("oldTotalPrice");
		String changePriceFlag = "1";
		if (Float.parseFloat(oldTotalPice) == Float.parseFloat(inputTotalPrice)) {
			changePriceFlag = "0";
		}
		String sql = "update shopOrder set changePriceFlag = ?, totalPrice = ?";
		Vector<String> v = new Vector<String>();
		v.add(changePriceFlag);
		v.add(inputTotalPrice);
		String differencePrice = "0";
		if (Float.parseFloat(inputTotalPrice) > Float.parseFloat(oldTotalPice)) {
			differencePrice = PriceUtil.minusPrice(inputTotalPrice, oldTotalPice);
			sql += ", needPayMoney = needPayMoney + ?";
			v.add(differencePrice);
		} else if (Float.parseFloat(inputTotalPrice) < Float.parseFloat(oldTotalPice)) {
			differencePrice = PriceUtil.minusPrice(oldTotalPice, inputTotalPrice);
			sql += ", needPayMoney = needPayMoney - ?";
			v.add(differencePrice);
		} else {
			differencePrice = datas.get(0).get("oldNeedPayMoney");
			sql += ", needPayMoney = ?";
			v.add(differencePrice);
		}
		sql += " where shopOrderID = ?";
		v.add(shopOrderID);
		DBProxy.update(getConnection(), "shopOrder", sql, v);
		setAjaxJavascript("closeInfoWindow();alert('修改成功');postModuleAndAction('order','detailView');");
	}
	
}