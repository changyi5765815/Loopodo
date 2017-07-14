package admin.customer.guanwangbao.processor;

import java.util.Hashtable;
import java.util.Vector;

import simpleWebFrame.config.Module;
import simpleWebFrame.database.DBProxy;
import simpleWebFrame.web.DataHandle;
import admin.customer.guanwangbao.AppKeys;

public class OrderReportProcessor extends BaseProcessor {
	public OrderReportProcessor(Module module, DataHandle dataHandle) {
		super(module, dataHandle);
	}
	
	public void makeView() throws Exception {
		if (getFormData("action").equals("list")) {
			int pageIndex = 1;
			try {
				pageIndex = Integer.parseInt(getFormData("pageIndex"));
				if (pageIndex < 1) {
					pageIndex = 1;
				}
			} catch (Exception e) {
				pageIndex = 1;
			}
			
			Vector<String> keys = new Vector<String>();
			StringBuilder conditionSql = getConditionSql(keys);
			Vector<String> havingKeys = new Vector<String>();
			StringBuilder havingSql = getHavingSql(havingKeys);
			String conditionSqlStr = "";
			if (conditionSql.length() > 0) {
				conditionSqlStr = conditionSql.toString().replaceFirst(" and ", " where ");
			}
			String havingSqlStr = "";
			if (!havingSql.toString().equals("")) {
				havingSqlStr = havingSql.toString().replaceFirst(" and ", " having ");
			}
			
			
			int count = getCount(conditionSqlStr, havingSqlStr, keys, havingKeys);
			int pageNumber = 20;
			int pageCount = count / pageNumber + (count % pageNumber > 0 ? 1 : 0);
			
			if (pageIndex > pageCount && pageCount > 0) {
				pageIndex = pageCount;
			}
			setFormData("pageIndex", String.valueOf(pageIndex));
			
			Vector<Hashtable<String, String>> datas = getDatas(conditionSqlStr, havingSqlStr, keys, havingKeys, pageIndex, pageNumber);
			
			setJSPData("datas", datas);
			setJumpPageInfo(count, pageNumber);
		}  else if(getFormData("action").equals("list2")) {
			int pageIndex = 1;
			try {
				pageIndex = Integer.parseInt(getFormData("pageIndex"));
				if (pageIndex < 1) {
					pageIndex = 1;
				}
			} catch (Exception e) {
				pageIndex = 1;
			}
			
			Vector<String> keys = new Vector<String>();
			StringBuilder conditionSql = getConditionSql2(keys);
			Vector<String> havingKeys = new Vector<String>();
			StringBuilder havingSql = getHavingSql2(havingKeys);
			String conditionSqlStr = "";
			if (conditionSql.length() > 0) {
				conditionSqlStr = conditionSql.toString().replaceFirst(" and ", " where ");
			}
			String havingSqlStr = "";
			if (!havingSql.toString().equals("")) {
				havingSqlStr = havingSql.toString().replaceFirst(" and ", " having ");
			}
			
			
			int count = getCount2(conditionSqlStr, havingSqlStr, keys, havingKeys);
			int pageNumber = 20;
			int pageCount = count / pageNumber + (count % pageNumber > 0 ? 1 : 0);
			
			if (pageIndex > pageCount && pageCount > 0) {
				pageIndex = pageCount;
			}
			setFormData("pageIndex", String.valueOf(pageIndex));
			
			Vector<Hashtable<String, String>> datas = getDatas2(conditionSqlStr, havingSqlStr, keys, havingKeys, pageIndex, pageNumber);
			
			setJSPData("datas", datas);
			setJumpPageInfo(count, pageNumber);
		}  else if(getFormData("action").equals("list3")) {
			getDatas3();
		}
	}

	public void defaultViewAction() throws Exception {
		listAction();
	}
	
	public void list2Action() throws Exception {
		
	}
	public void list3Action() throws Exception {
		
	}
	
	private StringBuilder getConditionSql(Vector<String> keys) throws Exception {
		StringBuilder conditionSql = new StringBuilder();
		
		if (!"".equals(getFormData("q_fromOrderTime"))) {
			conditionSql.append(" and orderTime >= ? ");
			keys.add(getFormData("q_fromOrderTime") + " 00:00:00");
		}
		
		if (!"".equals(getFormData("q_toOrderTime"))) {
			conditionSql.append(" and orderTime <= ? ");
			keys.add(getFormData("q_toOrderTime") + " 23:59:59");
		}
		
		if (!"".equals(getFormData("q_supplierID"))) {
			conditionSql.append(" and supplierID = ? ");
			keys.add(getFormData("q_supplierID"));
		}
		
		return conditionSql;
	}
	
	private StringBuilder getConditionSql2(Vector<String> keys) throws Exception {
		StringBuilder conditionSql = new StringBuilder(" and shopOrderStatus in (?,?,?,?,?)");
		keys.add(AppKeys.ORDER_STATUS_DAIPEIHUO);
		keys.add(AppKeys.ORDER_STATUS_DAIFAHUO);
		keys.add(AppKeys.ORDER_STATUS_DAISHOUHUO);
		keys.add(AppKeys.ORDER_STATUS_YISHOUHUO);
		keys.add(AppKeys.ORDER_STATUS_SUCCEED);
		
		if (!"".equals(getFormData("q_fromOrderTime"))) {
			conditionSql.append(" and orderTime >= ? ");
			keys.add(getFormData("q_fromOrderTime") + " 00:00:00");
		}
		
		if (!"".equals(getFormData("q_toOrderTime"))) {
			conditionSql.append(" and orderTime <= ? ");
			keys.add(getFormData("q_toOrderTime") + " 23:59:59");
		}
		
		if (!"".equals(getFormData("q_supplierID"))) {
			conditionSql.append(" and supplierID = ? ");
			keys.add(getFormData("q_supplierID"));
		}
		
		return conditionSql;
	}
	
	private StringBuilder getOrderConditionSql2(Vector<String> keys) throws Exception {
		StringBuilder conditionSql = new StringBuilder(" where a.status in (?,?,?,?,?) ");
		keys.add(AppKeys.ORDER_STATUS_DAIPEIHUO);
		keys.add(AppKeys.ORDER_STATUS_DAIFAHUO);
		keys.add(AppKeys.ORDER_STATUS_DAISHOUHUO);
		keys.add(AppKeys.ORDER_STATUS_YISHOUHUO);
		keys.add(AppKeys.ORDER_STATUS_SUCCEED);
		
		if (!"".equals(getFormData("q_fromOrderTime"))) {
			conditionSql.append(" and a.orderTime >= ? ");
			keys.add(getFormData("q_fromOrderTime") + " 00:00:00");
		}
		
		if (!"".equals(getFormData("q_toOrderTime"))) {
			conditionSql.append(" and a.orderTime <= ? ");
			keys.add(getFormData("q_toOrderTime") + " 23:59:59");
		}
		if (!"".equals(getFormData("q_supplierID"))) {
			conditionSql.append(" and a.supplierID = ? ");
			keys.add(getFormData("q_supplierID"));
		}
		return conditionSql;
	}
	
	private StringBuilder getaddConditionSql2(Vector<String> keys) throws Exception {
		StringBuilder conditionSql = new StringBuilder("");
		
		if (!"".equals(getFormData("q_fromOrderTime"))) {
			conditionSql.append(" and addTime >= ? ");
			keys.add(getFormData("q_fromOrderTime") + " 00:00:00");
		}
		
		if (!"".equals(getFormData("q_toOrderTime"))) {
			conditionSql.append(" and addTime <= ? ");
			keys.add(getFormData("q_toOrderTime") + " 23:59:59");
		}
		if (!"".equals(getFormData("q_supplierID"))) {
			conditionSql.append(" and supplierID = ? ");
			keys.add(getFormData("q_supplierID"));
		}
		return conditionSql;
	}
	
	private StringBuilder getHavingSql(Vector<String> keys) throws Exception {
		StringBuilder havingSql = new StringBuilder();
		
		if (!"".equals(getFormData("q_orderNumFrom"))) {
			havingSql.append(" and count(shopOrderID) >= " + getFormData("q_orderNumFrom") + " ");
		}
		if (!"".equals(getFormData("q_orderNumTo"))) {
			havingSql.append(" and count(shopOrderID) <= " + getFormData("q_orderNumTo") + " ");
		}
		
		if (!"".equals(getFormData("q_orderMoneyFrom"))) {
			havingSql.append(" and sum(totalPrice) >= " + getFormData("q_orderMoneyFrom") + " ");
		}
		if (!"".equals(getFormData("q_orderMoneyTo"))) {
			havingSql.append(" and sum(totalPrice) <= " + getFormData("q_orderMoneyTo") + " ");
		}
		
		return havingSql;
	}
	
	private StringBuilder getHavingSql2(Vector<String> keys) throws Exception {
		StringBuilder havingSql = new StringBuilder();
		
		return havingSql;
	}
	
	private int getCount(String conditionSql, String havingSql, Vector<String> keys, Vector<String> havingKeys) throws Exception {
		int count = 0;
		
		String countSql = "select count(t.orderTime) as count from (select left(orderTime, 10) as orderTime from shopOrder "
			+ conditionSql + " group by left(orderTime, 10)" + havingSql + ")t ";
		
		keys.addAll(havingKeys);
		
		Vector<Hashtable<String, String>> counts = DBProxy.query(getConnection(), "count_V", countSql, keys);
		 
		if (counts.size() == 0) {
			return count;
		}
		
		try {
			count = Integer.parseInt(counts.get(0).get("COUNT"));
		} catch (Exception e) {
			count = 0;
		}
		
		return count;
	}
	
	private int getCount2(String conditionSql, String havingSql, Vector<String> keys, Vector<String> havingKeys) throws Exception {
		int count = 0;
		
		String countSql = "select count(t.productID) as count from (select productID from orderProduct_V "
			+ conditionSql + " group by productID " + havingSql + ")t ";
		
		keys.addAll(havingKeys);
		
		Vector<Hashtable<String, String>> counts = DBProxy.query(getConnection(), "count_V", countSql, keys);
		
		if (counts.size() == 0) {
			return count;
		}
		
		try {
			count = Integer.parseInt(counts.get(0).get("COUNT"));
		} catch (Exception e) {
			count = 0;
		}
		
		return count;
	}
	
	private Vector<Hashtable<String, String>> getDatas(String conditionSql, String havingSql, Vector<String> keys, Vector<String> havingKeys, int pageIndex, int pageNumber) throws Exception {
		StringBuilder dataSql = new StringBuilder();
		Vector<String> keysVec = new Vector<String>();
		
		dataSql.append("select left(orderTime, 10) as orderTime, count(shopOrderID) as totalOrderNum, ");
		dataSql.append("count(if(status=?,true,null)) as status1Num, count(if(status=?,true,null)) as status2Num, ");
		keysVec.add(AppKeys.ORDER_STATUS_UNPAY);
		keysVec.add(AppKeys.ORDER_STATUS_DAIPEIHUO);
		dataSql.append("count(if(status=?,true,null)) as status3Num, count(if(status=?,true,null)) as status4Num, count(if(status=?,true,null)) as status5Num, ");
		keysVec.add(AppKeys.ORDER_STATUS_DAISHOUHUO);
		keysVec.add(AppKeys.ORDER_STATUS_YISHOUHUO);
		keysVec.add(AppKeys.ORDER_STATUS_SUCCEED);
		dataSql.append("count(if(status=?,true,null)) as status6Num, count(if(status=?,true,null)) as status7Num, count(if(status=?,true,null)) as status8Num ");
		keysVec.add(AppKeys.ORDER_STATUS_CLOSE);
		keysVec.add(AppKeys.ORDER_STATUS_WAITAUDIT);
		keysVec.add(AppKeys.ORDER_STATUS_DAIFAHUO);
//		StringBuffer sb = new StringBuffer();
//		if (!"".equals(getFormData("q_orderNumFrom"))) {
//			sb.append(" and totalOrderNum >= '" + getFormData("q_orderNumTo") + "' ");
//		}
//		
//		if (!"".equals(getFormData("q_orderNumTo"))) {
//			sb.append(" and totalOrderNum <= '" + getFormData("q_orderNumTo") + "' ");
//		}
		dataSql.append(", sum(totalPrice) as sumPrice from shopOrder " + conditionSql);
		
		keysVec.addAll(keys);
		dataSql.append(" group by left(orderTime, 10) " + havingSql + " order by orderTime desc ");
		keysVec.addAll(havingKeys);
		
		return DBProxy.query(getConnection(), "orderReport_V", dataSql.toString(), keysVec, pageIndex - 1, pageNumber);
		
	}
	
	private Vector<Hashtable<String, String>> getDatas2(String conditionSql, String havingSql, Vector<String> keys, Vector<String> havingKeys, int pageIndex, int pageNumber) throws Exception {
		StringBuilder dataSql = new StringBuilder();
		Vector<String> keysVec = new Vector<String>();
		
		dataSql.append("select" 
				+ " supplierID, "
				+ " supplierName, productID, name, ");
		dataSql.append("sum(number) as totalNum ");
		dataSql.append(", sum(price * number) as sumPrice from orderProduct_V " + conditionSql);
		
		keysVec.addAll(keys);
		dataSql.append(" group by productID " + havingSql + " order by orderTime desc ");
		keysVec.addAll(havingKeys);
		
		return DBProxy.query(getConnection(), "orderReport2_V", dataSql.toString(), keysVec, pageIndex - 1, pageNumber);
	}
	
	private void getDatas3() throws Exception {
		Vector<String> keys = new Vector<String>();
		// 总sql语句
		String sql = "select t.supplierName, t.supplierID, if(t.countShopOrder, t.countShopOrder, 0) as countShopOrder,if(t.countRefund, t.countRefund, 0) as countRefund, if(t.countRet,t.countRet,0 ) as countRet  from ( ";
		// 成交订单总数
		StringBuilder orderConditionSql2 = getOrderConditionSql2(keys);
		String sonSql = " select s.supplierID, s.countShopOrder, s.supplierName, t2.countRefund, g.countRet from (select count(a.shopOrderID) as countShopOrder, a.supplierID, a.supplierName from shopOrder_V a " 
			+ orderConditionSql2 + " group by a.supplierID ) s";
		StringBuilder getaddConditionSql2 = getaddConditionSql2(keys);
		
		// 退货单总数
		String refundSql = " left join (select count(refundID) as countRefund , supplierID from refund " +  getaddConditionSql2.toString().replaceFirst("and", "where") + " group by supplierID ) t2 on(s.supplierID = t2.supplierID)";
		StringBuilder getaddConditionSql22 = getaddConditionSql2(keys);
		// 退货单总数
		String returnGoodsSql = " left join( select count(returngoodsID) as countRet, supplierID from returngoods " +  getaddConditionSql22.toString().replaceFirst("and", "where") + " group by supplierID ) g on (s.supplierID = g.supplierID)";
		sql = sql + sonSql + refundSql + returnGoodsSql + ") t";
		
		int count = 0;
		
		String countSql = "select count(*) as count from (" + sql + ") tk ";
		
		Vector<Hashtable<String, String>> counts = DBProxy.query(getConnection(), "count_V", countSql, keys);
		
		try {
			count = Integer.parseInt(counts.get(0).get("COUNT"));
		} catch (Exception e) {
			count = 0;
		}
		int pageNumber = 20;
		int pageCount = count / pageNumber + (count % pageNumber > 0 ? 1 : 0);
		
		int pageIndex = 1;
		try {
			pageIndex = Integer.parseInt(getFormData("pageIndex"));
			if (pageIndex < 1) {
				pageIndex = 1;
			}
		} catch (Exception e) {
			pageIndex = 1;
		}
		if (pageIndex > pageCount && pageCount > 0) {
			pageIndex = pageCount;
		}
		
		setFormData("pageIndex", String.valueOf(pageIndex));
		Vector<Hashtable<String, String>> datas = DBProxy.query(getConnection(), "orderReport3_V", sql, keys, pageIndex - 1, pageNumber);
		setJSPData("datas", datas);
		setJumpPageInfo(count, pageNumber);
	}

}
