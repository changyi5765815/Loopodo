package admin.customer.guanwangbao.processor;

import java.util.Hashtable;
import java.util.Vector;

import simpleWebFrame.config.Module;
import simpleWebFrame.database.DBProxy;
import simpleWebFrame.web.DataHandle;
import admin.customer.guanwangbao.tool.ExcelUtils;
import admin.customer.guanwangbao.tool.SupplierAmountTool;

public class SupplierAmountReportProcessor extends BaseProcessor {
	public SupplierAmountReportProcessor(Module module, DataHandle dataHandle) {
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
			String conditionSqlStr = "";
			if (conditionSql.length() > 0) {
				conditionSqlStr = conditionSql.toString().replaceFirst(" and ", " where ");
			}
			String dateLen = getFormData("q_dateFlag").equals("0") ? "7" : "10";
			
			int count = getCount(conditionSqlStr, keys, havingKeys, dateLen);
			int pageNumber = 20;
			int pageCount = count / pageNumber + (count % pageNumber > 0 ? 1 : 0);
			
			if (pageIndex > pageCount && pageCount > 0) {
				pageIndex = pageCount;
			}
			setFormData("pageIndex", String.valueOf(pageIndex));
			
			Vector<Hashtable<String, String>> datas = getDatas(conditionSqlStr, keys, havingKeys, pageIndex, pageNumber, dateLen);
			
			setJSPData("datas", datas);
			setJumpPageInfo(count, pageNumber);
		} 
	}

	public void defaultViewAction() throws Exception {
		listAction();
	}
	
	private StringBuilder getConditionSql(Vector<String> keys) throws Exception {
		StringBuilder conditionSql = new StringBuilder();
		
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
	
	private int getCount(String conditionSql, Vector<String> keys, Vector<String> havingKeys, String dateLen) throws Exception {
		int count = 0;
		
		String countSql = "select count(t.addTime) as count from (select left(addTime, " + dateLen + ") as addTime from supplierAmountLog "
			+ conditionSql + " group by left(addTime, " + dateLen + "), supplierID )t ";
		
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
	
	private Vector<Hashtable<String, String>> getDatas(String conditionSql, Vector<String> keys, Vector<String> havingKeys, int pageIndex, int pageNumber, String dateLen) throws Exception {
		StringBuilder dataSql = new StringBuilder();
		Vector<String> keysVec = new Vector<String>();
		
		dataSql.append("select LEFT (addTime, " + dateLen + ") AS addTime, supplierID, name, ");
		dataSql.append("sum(IF(supplierAmountLogTypeID = ?, amount, 0)) AS amountIn, ");
		keysVec.add(SupplierAmountTool.SUPPLIER_AMOUNTLOG_TYPE_IN_ORDER);
		dataSql.append("sum(IF(supplierAmountLogTypeID = ?, amount, 0)) AS amountOut ");
		keysVec.add(SupplierAmountTool.SUPPLIER_AMOUNTLOG_TYPE_OUT_CASH);
		
		dataSql.append(" from supplierAmount_V " + conditionSql);
		
		keysVec.addAll(keys);
		dataSql.append(" group by left(addTime, " + dateLen + "), supplierID order by addTime desc ");
		keysVec.addAll(havingKeys);
		
		return DBProxy.query(getConnection(), "supplierAmountReport_V", dataSql.toString(), keysVec, pageIndex - 1, pageNumber);
	}

	public void exportAction() throws Exception {
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
		String conditionSqlStr = "";
		if (conditionSql.length() > 0) {
			conditionSqlStr = conditionSql.toString().replaceFirst(" and ", " where ");
		}
		String dateLen = getFormData("q_dateFlag").equals("0") ? "7" : "10";
		
		StringBuilder dataSql = new StringBuilder();
		Vector<String> keysVec = new Vector<String>();
		
		dataSql.append("select LEFT (addTime, " + dateLen + ") AS addTime, supplierID, name, ");
		dataSql.append("sum(IF(supplierAmountLogTypeID = ?, amount, 0)) AS amountIn, ");
		keysVec.add(SupplierAmountTool.SUPPLIER_AMOUNTLOG_TYPE_IN_ORDER);
		dataSql.append("sum(IF(supplierAmountLogTypeID = ?, amount, 0)) AS amountOut ");
		keysVec.add(SupplierAmountTool.SUPPLIER_AMOUNTLOG_TYPE_OUT_CASH);
		
		dataSql.append(" from supplierAmount_V " + conditionSqlStr);
		
		keysVec.addAll(keys);
		dataSql.append(" group by left(addTime, " + dateLen + "), supplierID order by addTime desc ");
		keysVec.addAll(havingKeys);
		
		Vector<Hashtable<String, String>> datas = DBProxy.query(getConnection(), "supplierAmountReport_V", dataSql.toString(), keysVec);
		if(datas.size() == 0) {
			setAjaxJavascript("alert('没有可导出数据')");
			return;
		}
		String[] excelHeaders = {"日期-addTime", "店铺-name", "收入-amountIn", "支出-amountOut"}; 
		String fileName = ExcelUtils.export(excelHeaders, datas);
		String fileDirName = "default/tmp";
		String downLoadDir = "location.href='/download?dir=" + fileDirName + "&fileName=" + fileName + "'";
		setAjaxJavascript(downLoadDir);
	}
	
}
