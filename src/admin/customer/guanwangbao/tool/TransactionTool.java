package admin.customer.guanwangbao.tool;

import java.sql.Connection;
import java.util.Hashtable;

import simpleWebFrame.database.DBProxy;
import simpleWebFrame.util.PriceUtil;
import simpleWebFrame.util.StringUtil;
import admin.customer.guanwangbao.AppKeys;

public class TransactionTool {
	public static String payTransaction(Connection con, Hashtable<String, String> transaction, String transactionID, 
			String payTypeID, String transactionNum, 
			String actualAmount, String payTime, String formData) throws Exception {
		Hashtable<String, String> k = new Hashtable<String, String>();
		k.put("transactionID", transactionID);
		Hashtable<String, String> v = new Hashtable<String, String>();

		String status = "";
		String rePayFlag = "";
		String refundAmount = "0";
		String proberlem = "";
		
		if (!transaction.get("status").equals("1")) {
			return ("交易单状态不为[待支付],无法进行此操作");
		}
		
		String relateIDs = transaction.get("relateIDs");
		
		float amount = Float.parseFloat(transaction.get("amount"));
		float actualAmountF = Float.parseFloat(actualAmount);
		// 如果实际支付的金额跟需要支付的金额不相等  则将该交易视为问题交易, 且对相关数据不做任何处理
		if (amount != actualAmountF) {
			rePayFlag = "1";
			refundAmount = actualAmount;
			proberlem = "实际支付的金额跟需要支付的金额不相等";
			status = "3";
		} else {
			String[] relateIDArray = StringUtil.split(relateIDs, ",");
			for (int i = 0; i < relateIDArray.length; ++i) {
				Hashtable<String, String> shopOrder = getShopOrder(con, relateIDArray[i]);
				if (shopOrder.get("status").equals(AppKeys.ORDER_STATUS_UNPAY)) {
					payShopOrder(con, transaction, shopOrder);
				} else {
					rePayFlag = "1";
					refundAmount = PriceUtil.plusPrice(refundAmount, shopOrder.get("needPayMoney"));
					proberlem += "订单[" + relateIDArray[i] + "]的状态不正确;";
				}
			}
			status = "3";
		}
		
		v.put("status", status);
		v.put("sitePayTypeID", payTypeID);//TODO
		v.put("payTime", payTime);
		v.put("transactionNum", transactionNum);
		v.put("actualAmount", actualAmount);
		v.put("formData", formData);
		v.put("rePayFlag", rePayFlag);
		v.put("refundAmount", refundAmount);
		v.put("proberlem", proberlem);
		DBProxy.update(con, "transaction", k, v);
		
		return proberlem;
	}
	
	private static Hashtable<String, String> getShopOrder(Connection con, String shopOrderID) throws Exception {
		Hashtable<String, String> k = new Hashtable<String, String>();
		k.put("shopOrderID", shopOrderID);
		
		return DBProxy.query(con, "shopOrder", k).get(0);
	}
	
	public static void payShopOrder(Connection con, Hashtable<String, String> transaction, Hashtable<String, String> shopOrder) throws Exception {
		Hashtable<String, String> shopOrderK = new Hashtable<String, String>();
		shopOrderK.put("shopOrderID", shopOrder.get("shopOrderID"));
		Hashtable<String, String> shopOrderV = new Hashtable<String, String>();
		shopOrderV.put("status", AppKeys.ORDER_STATUS_DAIPEIHUO);
		float canRefundAmount = Float.parseFloat(shopOrder.get("canRefundAmount")) + 
			Float.parseFloat(shopOrder.get("needPayMoney"));
		shopOrderV.put("payAmount", shopOrder.get("needPayMoney"));
		shopOrderV.put("payTime", transaction.get("payTime"));
		shopOrderV.put("payFlag", "1");
		shopOrderV.put("sitePayTypeID", transaction.get("sitePayTypeID"));//TODO
		shopOrderV.put("canRefundAmount", canRefundAmount + ""); //更新订单可退金额
		DBProxy.update(con, "shopOrder", shopOrderK, shopOrderV);
	}
}
