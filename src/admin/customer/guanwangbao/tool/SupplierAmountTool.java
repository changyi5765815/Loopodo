package admin.customer.guanwangbao.tool;

import java.sql.Connection;
import java.util.Hashtable;
import java.util.Vector;

import simpleWebFrame.database.DBProxy;
import simpleWebFrame.database.IndexGenerater;
import simpleWebFrame.util.DateTimeUtil;

public class SupplierAmountTool {
	/**
	 * 订单收入
	 */
	public static String SUPPLIER_AMOUNTLOG_TYPE_IN_ORDER = "10";
	/**
	 * 提现支出
	 */
	public static String SUPPLIER_AMOUNTLOG_TYPE_OUT_CASH = "20";
	
	/**
	 * 增加供应商账户中的锁定金额（订单支付后（包括使用优惠券支付、余额支付、在线支付、置为已付款）调用）
	 * 货到付款订单无需调用
	 * @param con
	 * @param siteID
	 * @param supplierID
	 * @param amount
	 * @param dataID
	 * @param info
	 * @return
	 * @throws Exception
	 */
	public static boolean plusLockAmount(Connection con,String siteID,
			String supplierID, String amount, String dataID, String info) throws Exception {
		String sql = "update supplier set lockAmount = lockAmount + ? where supplierID = ?";
		Vector<String> values = new Vector<String>();
		values.add(amount);
		values.add(supplierID);
		int updateCount = DBProxy.update(con, "supplier", sql, values);
		return updateCount > 0;
	}
	
	/**
	 * 减少锁定金额（订单退款完成、退货完成、取消订单时候调用）
	 * 货到付款订单无需调用
	 * @param con
	 * @param siteID
	 * @param supplierID
	 * @param amount
	 * @param dataID
	 * @param info
	 * @return
	 * @throws Exception
	 */
	public static boolean minLockAmount(Connection con,String siteID,
			String supplierID, String amount, String dataID, String info) throws Exception {
		String sql = "update supplier set lockAmount = lockAmount - ? where supplierID = ? and lockAmount >= ?";
		Vector<String> values = new Vector<String>();
		values.add(amount);
		values.add(supplierID);
		values.add(amount);
		int updateCount = DBProxy.update(con, "supplier", sql, values);
		return updateCount > 0;
	}
	
	/**
	 * 锁定金额转换成可提现金额（订单完成时候调用）
	 * 货到付款订单无需调用
	 * @param con 数据库连接
	 * @param siteID 网站ID
	 * @param supplierID 供应商ID
	 * @param amount 转换金额
	 * @param dataID 关联数据ID
	 * @param info 笨猪
	 * @return 更新记录数
	 * @throws Exception
	 */
	public static boolean lockAmount2CanCashAmount(Connection con,String siteID,
			String supplierID, String amount, String dataID, String info) throws Exception {
		String sql = "update supplier set lockAmount = lockAmount - ?, canCashAmount = canCashAmount + ? "
				+ "where supplierID = ? and lockAmount >= ?";
		Vector<String> p = new Vector<String>();
		p.add(amount);
		p.add(amount);
		p.add(supplierID);
		p.add(amount);
		int updateCount = DBProxy.update(con, "supplier", sql, p);
		if (updateCount > 0) {
			insertSupplierAmountLog(con, "", supplierID, SUPPLIER_AMOUNTLOG_TYPE_IN_ORDER, amount, dataID, info);
		}
		
		return updateCount > 0;
	}
	
	/**
	 * 可提现金额转换为提现中金额（申请提现时候调用）
	 * @param con
	 * @param siteID
	 * @param supplierID
	 * @param amount
	 * @param dataID
	 * @param info
	 * @return
	 * @throws Exception
	 */
	public static boolean canCashAmount2CashingAmount(Connection con,String siteID,
			String supplierID, String amount, String dataID, String info) throws Exception {
		String sql = "update supplier set canCashAmount = canCashAmount - ?, cashingAmount = cashingAmount + ? "
				+ "where supplierID = ? and canCashAmount >= ?";
		Vector<String> p = new Vector<String>();
		p.add(amount);
		p.add(amount);
		p.add(supplierID);
		p.add(amount);
		int updateCount = DBProxy.update(con, "supplier", sql, p);
		
		return updateCount > 0;
	}
	
	/**
	 * 提现中金额转换为已提现金额（提现打款完成后调用）
	 * @param con
	 * @param siteID
	 * @param supplierID
	 * @param amount
	 * @param dataID
	 * @param info
	 * @return
	 * @throws Exception
	 */
	public static boolean cashingAmount2HasCashAmount(Connection con,String siteID,
			String supplierID, String amount, String dataID, String info) throws Exception {
		String sql = "update supplier set cashingAmount = cashingAmount - ?, hasCashAmount = hasCashAmount + ? "
				+ "where supplierID = ? and cashingAmount >= ?";
		Vector<String> p = new Vector<String>();
		p.add(amount);
		p.add(amount);
		p.add(supplierID);
		p.add(amount);
		int updateCount = DBProxy.update(con, "supplier", sql, p);
		if (updateCount > 0) {
			insertSupplierAmountLog(con, "", supplierID, SUPPLIER_AMOUNTLOG_TYPE_OUT_CASH, amount, dataID, info);
		}
		
		return updateCount > 0;
	}
	
	
	public static void insertSupplierAmountLog(Connection con, String siteID, String supplierID, 
			String supplierAmountLogTypeID, String amount, String dataID, String info) throws Exception {
		Hashtable<String, String> key = new Hashtable<String, String>();
		key.put("supplierAmountLogID", IndexGenerater.getTableIndex("supplierAmountLog", con));
		key.put("supplierID", supplierID);
		key.put("supplierAmountLogTypeID", supplierAmountLogTypeID);
		key.put("dataID", dataID);
		key.put("amount", amount);
		key.put("addTime", DateTimeUtil.getCurrentDateTime());
		key.put("info", info);
		
		DBProxy.insert(con, "supplierAmountLog", key);
	}
}
