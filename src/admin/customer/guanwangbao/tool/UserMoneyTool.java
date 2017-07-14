package admin.customer.guanwangbao.tool;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.Hashtable;
import java.util.Vector;

import simpleWebFrame.database.DBConnectionPool;
import simpleWebFrame.database.DBProxy;
import simpleWebFrame.database.IndexGenerater;
import simpleWebFrame.log.AppLogger;
import simpleWebFrame.util.DateTimeUtil;

public class UserMoneyTool {
	public static int minusUserMoney(Connection con, String userID, String supplierID, String costMoney, 
			String userMoneyHistoryTypeID, String relatedID) throws Exception {
		String sql = "update shopUser set shopUserMoney = shopUserMoney - ? where shopUserID = ? and shopID = ? and shopUserMoney >= ?";
		Vector<String> values = new Vector<String>();
		values.add(costMoney);
		values.add(userID);
		values.add(supplierID);
		values.add(costMoney);
		int updateCount = DBProxy.update(con, "shopUser", sql, values);
		
		if (updateCount > 0) {
			insertUserMoneyHistory(con, userMoneyHistoryTypeID, costMoney, userID, supplierID, relatedID);
		}
		return updateCount;
	}
	
	public static int plusUserMoney(Connection con, String userID, String supplierID, String plusMoney, 
			String userMoneyHistoryTypeID, String relatedID) throws Exception {
		String sql = "update shopUser set shopUserMoney = shopUserMoney + ? where shopUserID = ? and shopID = ?";
		Vector<String> values = new Vector<String>();
		values.add(plusMoney);
		values.add(userID);
		values.add(supplierID);
		int updateCount = DBProxy.update(con, "shopUser", sql, values);
		
		if (updateCount > 0) {
			updateUserLevel(con, supplierID, userID);
			insertUserMoneyHistory(con, userMoneyHistoryTypeID, plusMoney, userID, supplierID, relatedID);
		}
		
		return updateCount;
	}
	
	public static void insertUserMoneyHistory(Connection con, String userMoneyHistoryType, String money, 
			String userID, String supplierID, String relatedID) throws Exception {
		Hashtable<String, String> key = new Hashtable<String, String>();
		key.put("userMoneyHistoryID", IndexGenerater.getTableIndex("userMoneyHistory", con));
		key.put("userID", userID);
		key.put("shopID", supplierID);
		key.put("relatedID", relatedID);
		key.put("userMoneyHistoryTypeID", userMoneyHistoryType);
		key.put("money", money);
		key.put("addTime", DateTimeUtil.getCurrentDateTime());
		
		DBProxy.insert(con, "userMoneyHistory", key);
	}
	
	public static Hashtable<String, String> getShopUser(String supplierID, String userID) throws SQLException {
		Connection conn = null;
		Vector<Hashtable<String, String>> shopUsers = new Vector<Hashtable<String,String>>();
		try {
			conn = DBConnectionPool.getInstance().getConnection();
			Hashtable<String, String> k = new Hashtable<String, String>();
			k.put("shopID", supplierID);
			k.put("shopUserID", userID);
			shopUsers = DBProxy.query(conn, "shopUser", k);
			if (shopUsers.size() == 0) {
				k.put("addTime", DateTimeUtil.getCurrentDateTime());
				DBProxy.insert(conn, "shopUser", k);
				k.remove("addTime");
				shopUsers = DBProxy.query(conn, "shopUser", k);
			}
		} catch (Exception e) {} finally {
			if(conn != null) {
				try {
					conn.close();
				} catch (SQLException e) {}
			}
		}
		if (shopUsers.size() == 0) {
			return new Hashtable<String, String>();
		}
		return shopUsers.get(0);
	}
	
	public static void updateShopUserShoppingInfo(Connection con, String userID, String supplierID, 
			int orderCount, int payOrderCount, double consumeAmount, String lastShoppingTime,
			int moneyCardCount, int consumeCardCount, String lastGetCardTime) throws Exception {
		String sql = "update shopUser ";
		
		String setSql = "";
		Vector<String> p = new Vector<String>();
		if (orderCount > 0) {
			setSql += ", shopOrderCount = shopOrderCount + ?";
			p.add(orderCount + "");
		}
		if (payOrderCount > 0) {
			setSql += ", shopPayOrderCount = shopPayOrderCount + ?";
			p.add(payOrderCount + "");
		}
		if (consumeAmount > 0) {
			setSql += ", shopConsumeAmount = shopConsumeAmount + ?";
			p.add(consumeAmount + "");
		}
		if (lastShoppingTime != null && !lastShoppingTime.equals("")) {
			setSql += ", shopLastShoppingTime = ?";
			p.add(lastShoppingTime);
		}
		if (moneyCardCount > 0) {
			setSql += ", shopMoneyCardCount = shopMoneyCardCount + ?";
			p.add(moneyCardCount + "");
		}
		if (consumeCardCount > 0) {
			setSql += ", shopConsumeCardCount = shopConsumeCardCount + ?";
			p.add(consumeCardCount + "");
		}
		if (lastGetCardTime != null && !lastGetCardTime.equals("")) {
			setSql += ", lastGetCardTime = ?";
			p.add(lastGetCardTime);
		}
		if (setSql.equals("")) {
			return;
		}
		sql = sql + setSql.replaceFirst(",", "set") + " where shopUserID = ? and shopID = ? ";
		p.add(userID);
		p.add(supplierID);
		DBProxy.update(con, "shopUser", sql, p);
		updateUserLevel(con, supplierID, userID);
	}
	
	public static void updateUserLevel(Connection con, String supplierID, String userID) throws Exception {
		try {
			Hashtable<String, String> k = new Hashtable<String, String>();
			k.put("shopUserID", userID);
			k.put("shopID", supplierID);
			Vector<Hashtable<String, String>> users = DBProxy.query(con, "shopUser", k);
			Hashtable<String, String> k2 = new Hashtable<String, String>(); 
			k2.put("shopID", supplierID);
			Vector<Hashtable<String, String>> levels = DBProxy.query(con, "shopUserLevel", k2, "order by systemLevelID");
			if (users.size() > 0 && levels.size() > 0) {
				Hashtable<String, String> user = users.get(0);
				String shopConsumeAmount = user.get("shopConsumeAmount");
				
				int newLevelID = -1;
				
				boolean stopFlag = false;
				for (int i = 0; i < levels.size(); ++i) {
					String minColumn = "minLimitMoney";
					String maxColumn = "maxLimitMoney";
					Hashtable<String, String> userLevel = levels.get(i);
					
					String minLimitMoney = userLevel.get(minColumn) == null ? "" : userLevel.get(minColumn) ;
					String maxLimitMoney = userLevel.get(maxColumn) == null ? "" : userLevel.get(maxColumn);
					System.out.println(minLimitMoney);
					System.out.println(maxLimitMoney);
					int curLevelID = -1;
					int level = Integer.valueOf(userLevel.get("systemLevelID"));
					if (!minLimitMoney.equals("") && !maxLimitMoney.equals("") 
							&& Double.parseDouble(shopConsumeAmount) >= Double.parseDouble(minLimitMoney) 
							&& Double.parseDouble(shopConsumeAmount) <= Double.parseDouble(maxLimitMoney)) {
						curLevelID = level;
						stopFlag = true;
					} else if (!minLimitMoney.equals("") && maxLimitMoney.equals("") 
							&& Double.parseDouble(shopConsumeAmount) >= Double.parseDouble(minLimitMoney)) {
						curLevelID = level;
					} else if (minLimitMoney.equals("") && !maxLimitMoney.equals("") 
							&& Double.parseDouble(shopConsumeAmount) <= Double.parseDouble(maxLimitMoney)) {
						curLevelID = level;
					}
					
					if (curLevelID > newLevelID) {
						newLevelID = curLevelID;
					}
					
					if (stopFlag) {
						break;
					}
				}
				
				if (newLevelID > -1 && String.valueOf(newLevelID).compareTo(user.get("shopUserLevelID")) > 0) {
					Hashtable<String, String> v = new Hashtable<String, String>();
					v.put("shopUserLevelID", newLevelID + "");
					DBProxy.update(con, "shopUser", k, v);
				}
			}
		} catch (Exception e) {
			AppLogger.getInstance().errorLog("updateUserLevel error", e);
		}
	}
	
}
