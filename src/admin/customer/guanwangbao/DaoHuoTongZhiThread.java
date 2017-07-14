package admin.customer.guanwangbao;

import java.sql.Connection;
import java.util.Hashtable;
import java.util.Vector;

import simpleWebFrame.database.DBConnectionPool;
import simpleWebFrame.database.DBProxy;
import simpleWebFrame.log.AppLogger;
import simpleWebFrame.util.DateTimeUtil;
import admin.customer.guanwangbao.tool.MessageUtil;

public class DaoHuoTongZhiThread extends Thread {
	private static DaoHuoTongZhiThread instance = new DaoHuoTongZhiThread();
	private static boolean isRunning = true;
	
	private DaoHuoTongZhiThread() {
	}
	
	public static DaoHuoTongZhiThread getInstance() {
		return instance;
	}
	
	public void run() {
		while (isRunning) {
			try {
				sleep(5 * 1000);
				autoUpdShopOrderStatus();
			} catch (Exception e) {
				AppLogger.getInstance().errorLog("ShopOrderThread run error", e);
			}
		}
	}
	
	public void autoUpdShopOrderStatus() throws Exception {
		Connection con = null;
		try {
			con = DBConnectionPool.getInstance().getConnection();
			con.setAutoCommit(false);
			String curDate = DateTimeUtil.getCurrentDate();
			String sql = "select * from productNotify_V where expireDate > ? and stock > 0 limit 0, 1";
			Vector<String> p = new Vector<String>();
			p.add(curDate);
			Vector<Hashtable<String, String>> shopOrders = DBProxy.query(con, "productNotify_V", sql, p);
			for (int i = 0; i < shopOrders.size(); ++i) {
				Hashtable<String, String> data = shopOrders.get(i);
				String mobile = data.get("notifyMobile");
				String name = data.get("name");
				String productID = data.get("productID");
				String userID = data.get("userID");
				
				String[] paras = {name};
				MessageUtil.sendMessage(mobile, paras, AppKeys.SMS_TEMP_DAOHUOTONGZHI);
				
				String sqlDel = "delete from productNotify where productID = ? and useID = ? and notifyMobile = ?";
				Vector<String> pDel = new Vector<String>();
				pDel.add(productID);
				pDel.add(userID);
				pDel.add(mobile);
				DBProxy.update(con, "productNotify", sqlDel, pDel);
			}
			con.commit();
		} catch (Exception e) {
			AppLogger.getInstance().errorLog("ShopOrderThread autoUpdShopOrderStatus error", e);
			con.rollback();
		} finally {
			try {
				if (con != null) {
					con.close();
				}
			} catch (Exception e2) {}
		}
	}
	
	public void stopRunning() {
		isRunning = false;
	}
	
	public void beginRunning() {
		isRunning = true;
	}
}
