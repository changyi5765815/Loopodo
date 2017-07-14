package admin.customer.guanwangbao;

import java.sql.Connection;
import java.util.Hashtable;
import java.util.Vector;

import simpleWebFrame.database.DBConnectionPool;
import simpleWebFrame.database.DBProxy;
import simpleWebFrame.log.AppLogger;

public class GroupBuyThread extends Thread {
	private static GroupBuyThread instance = new GroupBuyThread();
	private static boolean isRunning = true;
	
	private GroupBuyThread() {
	}
	
	public static GroupBuyThread getInstance() {
		return instance;
	}
	
	public void run() {
		while (isRunning) {
			try {
				sleep(30 * 1000);
				doAction();
			} catch (Exception e) {
				AppLogger.getInstance().errorLog("GroupBuyThread run error", e);
			}
		}
	}
	
	public void doAction() throws Exception {
		Connection con = null;
		try {
			con = DBConnectionPool.getInstance().getConnection();
			String sql = "select * from groupBuy where (status = 2 and startTimeMills < ?) or (status = 3 and endTimeMills < ?) limit 0, 10";
			Vector<String> p = new Vector<String>();
			long curTimeMills = System.currentTimeMillis();
			p.add(curTimeMills + "");
			p.add(curTimeMills + "");
			Vector<Hashtable<String, String>> datas = DBProxy.query(con, "groupBuy", 
					sql, p);
			for (int i = 0; i < datas.size(); ++i) {
				Hashtable<String, String> data = datas.get(i);
				String status = AppUtil.getGroupBuyStats(data.get("startTime"), 
						data.get("endTime"));
				Hashtable<String, String> k = new Hashtable<String, String>();
				k.put("groupBuyID", data.get("groupBuyID"));
				Hashtable<String, String> v = new Hashtable<String, String>();
				v.put("status", status);
				DBProxy.update(con, "groupBuy", k, v);
			}
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
