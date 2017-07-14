package admin.customer.guanwangbao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.List;
import java.util.Map;

import simpleWebFrame.database.DBConnectionPool;
import simpleWebFrame.log.AppLogger;
import admin.customer.guanwangbao.tool.LogQueue;

public class SystemSignLogThread extends Thread {
	private static SystemSignLogThread instance = new SystemSignLogThread();
	private static boolean isRunning = true;
	
	private SystemSignLogThread() {
	}
	
	public static SystemSignLogThread getInstance() {
		return instance;
	}
	
	public void run() {
		while (isRunning) {
			try {
				sleep(1 * 60 * 1000);
				insertLog( LogQueue.getInstance().getLogs());
			} catch (Exception e) {
				AppLogger.getInstance().errorLog("ShopOrderThread run error", e);
			}
		}
	}
	
	public void stopRunning() {
		isRunning = false;
	}
	
	public void beginRunning() {
		isRunning = true;
	}
	
	public void insertLog(List<Map<String, String>> logs) {
		Connection con = null;
		PreparedStatement preStm = null;
		try {
			String sql = "insert into systemUserLog(systemUserID, sessionID, module, action, os, browser, browserVersion, ip, logTime, systemUserName) values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
			con = DBConnectionPool.getInstance().getConnection();
			preStm = con.prepareStatement(sql);
			
			int size = logs.size();
			for (int i = 0; i < size; ++i) {
				preStm.setString(1, "".equals(logs.get(0).get("systemUserID")) ? null : logs.get(0).get("systemUserID"));
				preStm.setString(2, "".equals(logs.get(0).get("sessionID")) ? null : logs.get(0).get("sessionID"));
				preStm.setString(3, "".equals(logs.get(0).get("module")) ? null : logs.get(0).get("module"));
				preStm.setString(4, "".equals(logs.get(0).get("action")) ? null : logs.get(0).get("action"));
				preStm.setString(5, "".equals(logs.get(0).get("os")) ? null : logs.get(0).get("os"));
				preStm.setString(6, "".equals(logs.get(0).get("browser")) ? null : logs.get(0).get("browser"));
				preStm.setString(7, "".equals(logs.get(0).get("browserVersion")) ? null : logs.get(0).get("browserVersion"));
				preStm.setString(8, "".equals(logs.get(0).get("ip")) ? null : logs.get(0).get("ip"));
				preStm.setString(9, "".equals(logs.get(0).get("logTime")) ? null : logs.get(0).get("logTime"));
				preStm.setString(10, "".equals(logs.get(0).get("systemUserName")) ? null : logs.get(0).get("systemUserName"));
				
				preStm.addBatch();
				logs.remove(0);
			}
			
			preStm.executeBatch();
		} catch (Exception e) {
			AppLogger.getInstance().errorLog("insertLog error", e);
		} finally {
			try {
				if (preStm != null) {
					preStm.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (Exception e2) {}
		}
	}
	
}
