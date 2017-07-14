package admin.customer.guanwangbao;

import java.sql.Connection;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.Map;
import java.util.Vector;

import simpleWebFrame.database.DBConnectionPool;
import simpleWebFrame.database.DBProxy;
import simpleWebFrame.database.IndexGenerater;
import simpleWebFrame.log.AppLogger;

import com.alibaba.fastjson.JSON;

public class BatchThread extends Thread {
//	private static int index = 1000;
	private static int status = 0;
	public BatchThread() {
	}
	
	public void run() {
		if (status == 1) {
			return;
		}
		batch();
	}
	
	public void batch() {
//		batchInformationTypePath();
//		batchUpdateNavigationText();
//		batchFloors();
//		batchThemeFloor();
//		batchSiteProductType(); //执行前将siteDetailInfo中的batchNavFlag设置成0
//		batchSiteFooterFloor();
		
//		batchProductDefaultSku();
		
//		batchUpdateSiteWeixinAppID();
	}
	
	public void batchUpdateSiteWeixinAppID() {
		AppLogger.getInstance().infoLog("batchUpdateSiteWeixinAppID start!");
		status = 1;
		Connection con = null;
		try {
			con = DBConnectionPool.getInstance().getConnection();
			Hashtable<String, String> key = new Hashtable<String, String>();
			Vector<Hashtable<String, String>> datas = DBProxy.query(con, "siteDetailInfo", key);
			
			for (int i = 0; i < datas.size(); i++) {
				Hashtable<String, String> data = datas.get(i);
				Hashtable<String, String> k = new Hashtable<String, String>();
				k.put("siteID", data.get("siteID"));
				
				Map<String, Object> config = getSiteConfig(data.get("configJson"));
				Object weixinAppID = config.get("weixinAppID");
				Object weixinAppSecret = config.get("weixinAppSecret");
				
				Hashtable<String, String> v = new Hashtable<String, String>();
				if (weixinAppID != null) {
					v.put("weixinAppID", weixinAppID.toString());
					config.remove("weixinAppID");
				}
				if (weixinAppSecret != null) {
					v.put("weixinAppSecret", weixinAppSecret.toString());
					config.remove("weixinAppSecret");
				}
				if (!v.isEmpty()) {
					DBProxy.update(con, "site", k, v);
					
					Hashtable<String, String> v2 = new Hashtable<String, String>();
					v2.put("configJson", JSON.toJSONString(config));
					DBProxy.update(con, "siteDetailInfo", k, v2);
				}
			}
		} catch (Exception ex) {
			AppLogger.getInstance().errorLog("batch error", ex);
		} finally {
			try {
				if (con != null) {
					con.close();
				}
			} catch (Exception e2) {}
		}
		status = 0;
		AppLogger.getInstance().infoLog("batchUpdateSiteWeixinAppID end!");
	}
	
	private Map<String, Object> getSiteConfig(String configJson) throws Exception {
		Map dataHash = new HashMap<String, Object>();
		if (!configJson.equals("")) {
			dataHash = (Map) JSON.parse(configJson);
		}
		if (dataHash.get("siteName") == null) {
			dataHash.put("siteName", "");
		}
		if (dataHash.get("openProductTypeFlag") == null) {
			dataHash.put("openProductTypeFlag", "");
		}
		if (dataHash.get("topNavigation") == null) {
			dataHash.put("topNavigation", new Vector<Hashtable<String, String>>());
		}
		if (dataHash.get("mobileTopNavigation") == null) {
			dataHash.put("mobileTopNavigation", new Vector<Hashtable<String, String>>());
		}
		if (dataHash.get("bottomNavigation") == null) {
			dataHash.put("bottomNavigation", new Vector<Hashtable<String, String>>());
		}
		return dataHash;
	}
	
	public void batchProductDefaultSku() {
		AppLogger.getInstance().infoLog("batchInformation start!");
		status = 1;
		Connection con = null;
		try {
			con = DBConnectionPool.getInstance().getConnection();
			Hashtable<String, String> key = new Hashtable<String, String>();
			Vector<Hashtable<String, String>> datas = DBProxy.query(con, "product", key);
			
			for (int i = 0; i < datas.size(); i++) {
				Hashtable<String, String> data = datas.get(i);
				Hashtable<String, String> skuK = new Hashtable<String, String>();
				skuK.put("productID", data.get("productID"));
				Vector<Hashtable<String, String>> skus = DBProxy.query(con, "sku", skuK);
				if (skus.size() == 0) {
					insertDefaultSku(con, data.get("siteID"), data.get("productID"), 
							data.get("productCode"), data.get("stock"), data.get("price"));
				}
			}
		} catch (Exception ex) {
			AppLogger.getInstance().errorLog("batch error", ex);
		} finally {
			try {
				if (con != null) {
					con.close();
				}
			} catch (Exception e2) {}
		}
		status = 0;
		AppLogger.getInstance().infoLog("batchInformation end!");
	}
	
	public String insertDefaultSku(Connection con, String siteID, String productID, String productCode, String stock, String price) throws Exception {
		Hashtable<String, String> k = new Hashtable<String, String>();
		k.put("siteID", siteID);
		k.put("productID", productID);
		k.put("defaultFlag", "1");
		Vector<Hashtable<String, String>> skus = DBProxy.query(con, "sku", k);
		
		if (skus.size() == 0) {
			Hashtable<String, String> data = new Hashtable<String, String>();
			String newSkuID = IndexGenerater.getTableIndex("sku", con);
			data.put("skuID", newSkuID);
			data.put("siteID", siteID);
			data.put("productID", productID);
			data.put("props", "");
			data.put("stock", stock.equals("") ? "0" : stock);
//			data.put("barCode", productCode);
			data.put("price", price);
			data.put("validFlag", "1");
			data.put("defaultFlag", "1");
			DBProxy.insert(con, "sku", data);
			
			return newSkuID;
		} else {
			Hashtable<String, String> skuV = new Hashtable<String, String>();
			skuV.put("price", price);
			skuV.put("barCode", productCode);
			DBProxy.update(con, "sku", k, skuV);
			
			return skus.get(0).get("skuID");
		}
	}
	
	
}
