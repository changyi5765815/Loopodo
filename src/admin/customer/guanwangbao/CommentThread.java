package admin.customer.guanwangbao;

import java.sql.Connection;
import java.util.Hashtable;
import java.util.Vector;

import simpleWebFrame.database.DBConnectionPool;
import simpleWebFrame.database.DBProxy;
import simpleWebFrame.database.IndexGenerater;
import simpleWebFrame.log.AppLogger;
import simpleWebFrame.util.DateTimeUtil;
import simpleWebFrame.util.PriceUtil;
import simpleWebFrame.web.validate.IntegerCheckItem;

public class CommentThread extends Thread {
	private static CommentThread instance = new CommentThread();
	private static boolean isRunning = true;
	
	private CommentThread() {
	}
	
	public static CommentThread getInstance() {
		return instance;
	}
	
	public void run() {
		while (isRunning) {
			String commentDeadDay = LocalDataCache.getInstance().getSysConfig("commentDeadDay");
			if(IntegerCheckItem.isInteger(commentDeadDay) && Integer.valueOf(commentDeadDay) > 0) {
				try {
					autoUpdComment();
				} catch (Exception e) {
					AppLogger.getInstance().errorLog("CommentThread run error", e);
				}
			}
			
			String commentDeadDay2 = LocalDataCache.getInstance().getSysConfig("commentDeadDay2");
			if(IntegerCheckItem.isInteger(commentDeadDay2) && Integer.valueOf(commentDeadDay2) > 0) {
				try {
					autoUpdComment2();
				} catch (Exception e) {
					AppLogger.getInstance().errorLog("CommentThread run error", e);
				}
			}
			try {
				sleep(1 * 60 * 1000);
			} catch (InterruptedException e) {
			}
		}
	}
	
	public void autoUpdComment() throws Exception {
		Connection con = null;
		try {
			con = DBConnectionPool.getInstance().getConnection();
			con.setAutoCommit(false);
			long curMills = System.currentTimeMillis();
			String sql = "select * from orderProduct_V where " +
					"autoCommentFlag = '0' and commentFlag = '0' and autoCommentTimeMills <= " + curMills + " limit 0, 1";
			Vector<Hashtable<String, String>> orderProducts = DBProxy.query(con, "orderProduct_V", sql, new Vector<String>());
			for(int i = 0; i < orderProducts.size(); i++) {
				Hashtable<String, String> orderProduct = orderProducts.get(i);
				AppLogger.getInstance().infoLog("自动好评shopOrderID ==" + orderProduct.get("shopOrderID"));
				String openAutoGoodCommentFlag = LocalDataCache.getInstance().getSysConfig("openAutoGoodCommentFlag");
				// 是否开启自动好评，如果没开启，则将评论置为不可评论，如果开启则设置好评
				if(openAutoGoodCommentFlag.equals("1")) {
					Hashtable<String, String> k = new Hashtable<String, String>(); 
					k.put("shopOrderID", orderProduct.get("shopOrderID"));
					Hashtable<String, String> shopOrder = DBProxy.query(con, "shopOrder_V", k).get(0);
					String userID = shopOrder.get("userID");
					Hashtable<String, String> kv = new Hashtable<String, String>();
					kv.put("commentID", IndexGenerater.getTableIndex("comment", con));
					kv.put("orderProductID", orderProduct.get("orderProductID"));
					kv.put("userID", userID);
					kv.put("showUserName", shopOrder.get("userNick"));
					kv.put("productID", orderProduct.get("productID"));
					kv.put("orderTime", orderProduct.get("orderTime"));
					kv.put("price", orderProduct.get("price"));
					kv.put("number", orderProduct.get("number"));
					kv.put("propName", orderProduct.get("propName"));
					kv.put("postTime", DateTimeUtil.getCurrentDateTime());
					kv.put("commentScore", "5");
					kv.put("serviceScore", "5");
					kv.put("deliveryScore", "5");
					kv.put("deliveryServiceScore", "5");
					kv.put("commentContent", "评论超时，系统自动好评");
					kv.put("validFlag", "1");
					kv.put("auditFlag", LocalDataCache.getInstance().getSysConfig("commentAudtiFlag").equals("1") ? "0" : "1");
					kv.put("replyFlag", "0");
					// 只有审核通过之后才能设置追评
					String commentDeadDay2 = LocalDataCache.getInstance().getSysConfig("commentDeadDay2");
					if(IntegerCheckItem.isInteger(commentDeadDay2) && Integer.valueOf(commentDeadDay2) > 0 && kv.get("auditFlag").equals("1")) {
						long toTimeMills = System.currentTimeMillis() + (Integer.valueOf(commentDeadDay2) * 24 * 60 * 60 * 1000L);
						kv.put("autoComment2TimeMills", toTimeMills + "");
						kv.put("autoComment2Flag", "0"); // 设置追评
					}
					DBProxy.insert(con, "comment", kv);
					
					Hashtable<String, String> key = new Hashtable<String, String>();
					key.put("orderProductID", orderProduct.get("orderProductID"));
					Hashtable<String, String> value = new Hashtable<String, String>();
					value.put("commentFlag", "1");
					value.put("autoCommentFlag", "1"); // 到期
					DBProxy.update(con, "orderProduct", key, value);
					// 评论不需要审核时直接设置好评
					if(!LocalDataCache.getInstance().getSysConfig("commentAudtiFlag").equals("1")) {
						plusProductCommentCount(orderProduct.get("productID"), "5", con);
						updateSupplierCommentInfo(orderProduct.get("supplierID"), "5", "5", "5", con);
					}
				} else {
					Hashtable<String, String> key = new Hashtable<String, String>();
					key.put("orderProductID", orderProduct.get("orderProductID"));
					Hashtable<String, String> value = new Hashtable<String, String>();
					value.put("autoCommentFlag", "1"); // 到期
					DBProxy.update(con, "orderProduct", key, value);
				}
			}
			con.commit();
		} catch (Exception e) {
			AppLogger.getInstance().errorLog("CommentThread autoUpdComment error", e);
			con.rollback();
		} finally {
			try {
				if (con != null) {
					con.close();
				}
			} catch (Exception e2) {}
		}
	}
	/**
	 * 将可追评的评论设置为追评失效
	 * @throws Exception
	 */
	public void autoUpdComment2() throws Exception {
		Connection con = null;
		try {
			con = DBConnectionPool.getInstance().getConnection();
			con.setAutoCommit(false);
			long curMills = System.currentTimeMillis();
			String sql = "update comment set autoComment2Flag = '2' where autoComment2Flag = '0' and autoComment2TimeMills <= " + curMills + "";
			DBProxy.update(con, "comment", sql, new Vector<String>());
			con.commit();
		} catch (Exception e) {
			AppLogger.getInstance().errorLog("CommentThread autoUpdComment error", e);
			con.rollback();
		} finally {
			try {
				if (con != null) {
					con.close();
				}
			} catch (Exception e2) {}
		}
	}

	private void plusProductCommentCount(String productID, String score, Connection con) throws Exception {
		Vector<String> pValues = new Vector<String>();
		String addBetterScore = "0";
		String addMediumScore = "0";
		String addWorseScore = "0";
		if (score.equals("1")) {
			addWorseScore = "1";
		} else if (score.equals("5")) {
			addBetterScore = "1";
		} else {
			addMediumScore = "1";
		}
		
		pValues.add(addBetterScore);
		pValues.add(addMediumScore);
		pValues.add(addWorseScore);
		pValues.add(score);
		pValues.add(productID);
		
		DBProxy.update(con, "product", "update product set betterScore = betterScore + ?, mediumScore = mediumScore + ?, " +
				"worseScore = worseScore + ?, commentPoint = commentPoint + ?, commentTimes = commentTimes + 1 where productID = ?", pValues);
	}
	private void updateSupplierCommentInfo(String supplierID, String commentScore, String serviceScore, String deliveryScore, Connection con) throws Exception {
		int commentScorePercent = Integer.parseInt(LocalDataCache.getInstance().getTableDataColumnValue("commentDimension", "commentScore", "percent"));
		int serviceScorePercent = Integer.parseInt(LocalDataCache.getInstance().getTableDataColumnValue("commentDimension", "serviceScore", "percent"));
		int deliveryScorePercent = Integer.parseInt(LocalDataCache.getInstance().getTableDataColumnValue("commentDimension", "deliveryScore", "percent"));
		
		double totalScore = (Double.parseDouble(commentScore) * commentScorePercent / 100.00D) 
				+ (Double.parseDouble(serviceScore) * serviceScorePercent / 100.00D)
				+ (Double.parseDouble(deliveryScore) * deliveryScorePercent / 100.00D);
		
		
		String sql = "update supplier set totalScore = totalScore + ?, commentScore = commentScore + ?, serviceScore = serviceScore + ?, deliveryScore = deliveryScore + ?,"
				+ "commentTimes = commentTimes + 1 where supplierID = ?";
		Vector<String> p = new Vector<String>();
		p.add(PriceUtil.formatPrice(totalScore + ""));
		p.add(commentScore);
		p.add(serviceScore);
		p.add(deliveryScore);
		p.add(supplierID);
		DBProxy.update(con, "supplier", sql, p);
		
		Hashtable<String, String> supplierK = new Hashtable<String, String>();
		supplierK.put("supplierID", supplierID);
		Hashtable<String, String> supplier = DBProxy.query(con, "supplier", supplierK).get(0);
		
		double totalScoreD = Double.parseDouble(supplier.get("totalScore"));
		double commentScoreD = Double.parseDouble(supplier.get("commentScore"));
		double serviceScoreD = Double.parseDouble(supplier.get("serviceScore"));
		double deliveryScoreD = Double.parseDouble(supplier.get("deliveryScore"));
		int commentTimes = Integer.parseInt(supplier.get("commentTimes"));
		
		double totalScoreAvgD = totalScoreD / commentTimes;
		double commentScoreAvgD = commentScoreD / commentTimes;
		double serviceScoreAvgD = serviceScoreD / commentTimes;
		double deliveryScoreAvgD = deliveryScoreD / commentTimes;
		
		Hashtable<String, String> supplierV = new Hashtable<String, String>();
		supplierV.put("totalScoreAvg", PriceUtil.formatPrice(totalScoreAvgD + ""));
		supplierV.put("commentScoreAvg", PriceUtil.formatPrice(commentScoreAvgD + ""));
		supplierV.put("serviceScoreAvg", PriceUtil.formatPrice(serviceScoreAvgD + ""));
		supplierV.put("deliveryScoreAvg", PriceUtil.formatPrice(deliveryScoreAvgD + ""));
		DBProxy.update(con, "supplier", supplierK, supplierV);
		
	}
	public void stopRunning() {
		isRunning = false;
	}
	
	public void beginRunning() {
		isRunning = true;
	}
}
