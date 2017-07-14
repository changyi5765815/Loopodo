package admin.customer.guanwangbao.tool;

import java.sql.Connection;
import java.util.Hashtable;
import java.util.Vector;

import simpleWebFrame.database.DBProxy;
import simpleWebFrame.database.IndexGenerater;
import simpleWebFrame.util.DateTimeUtil;

public class UserPointTool {
	public static int minusUserPoint(Connection con, String userID, String costMoney, 
			String userPointHistoryTypeID, String relatedID, String info) throws Exception {
		String sql = "update user set point = point - ? where userID = ? and point >= ?";
		Vector<String> values = new Vector<String>();
		values.add(costMoney);
		values.add(userID);
		values.add(costMoney);
		int updateCount = DBProxy.update(con, "user", sql, values);
		
		if (updateCount > 0) {
			insertUserPointHistory(con, userPointHistoryTypeID, costMoney, userID, relatedID, info);
		}
		return updateCount;
	}
	
/*	public static int plusUserPoint(Connection con, String userID, String plusMoney, 
			String userPointHistoryTypeID, String relatedID) throws Exception {
		String sql = "update user set point = point + ? where userID = ?";
		Vector<String> values = new Vector<String>();
		values.add(plusMoney);
		values.add(userID);
		int updateCount = DBProxy.update(con, "user", sql, values);
		
		if (updateCount > 0) {
			insertUserPointHistory(con, userPointHistoryTypeID, plusMoney, userID, relatedID);
		}
		
		return updateCount;
	}*/
	
	public static int plusUserPoint(Connection con, String userID, String point, 
			String userPointHistoryTypeID, String relatedID, String info) throws Exception {
		String sql = "update user set point = point + ?, historyPoint = historyPoint + ? where userID = ?";
		Vector<String> values = new Vector<String>();
		values.add(point);
		values.add(point);
		values.add(userID);
		int updateCount = DBProxy.update(con, "user", sql, values);
		
		if (updateCount > 0) {
			insertUserPointHistory(con, userPointHistoryTypeID, point, userID, relatedID, info);
		}
		
		return updateCount;
	}
	
/*	public static void insertUserPointHistory(Connection con, String userPointHistoryType, String money, 
			String userID, String relatedID) throws Exception {
		Hashtable<String, String> key = new Hashtable<String, String>();
		key.put("userPointHistoryID", IndexGenerater.getTableIndex("userPointHistory", con));
		key.put("userID", userID);
		key.put("relatedID", relatedID);
		key.put("userPointHistoryTypeID", userPointHistoryType);
		key.put("point", money);
		key.put("addTime", DateTimeUtil.getCurrentDateTime());
		
		DBProxy.insert(con, "userPointHistory", key);
	}*/
	
	public static void insertUserPointHistory(Connection con, String userPointHistoryType, String money, 
			String userID, String relatedID, String info) throws Exception {
		Hashtable<String, String> key = new Hashtable<String, String>();
		key.put("userPointHistoryID", IndexGenerater.getTableIndex("userPointHistory", con));
		key.put("userID", userID);
		key.put("relatedID", relatedID);
		key.put("userPointHistoryTypeID", userPointHistoryType);
		key.put("point", money);
		key.put("addTime", DateTimeUtil.getCurrentDateTime());
		key.put("info", info);
		
		DBProxy.insert(con, "userPointHistory", key);
	}

}
