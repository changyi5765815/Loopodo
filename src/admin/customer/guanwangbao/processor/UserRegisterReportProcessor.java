package admin.customer.guanwangbao.processor;

import java.util.Hashtable;
import java.util.Vector;

import simpleWebFrame.config.Module;
import simpleWebFrame.database.DBProxy;
import simpleWebFrame.web.DataHandle;

public class UserRegisterReportProcessor extends BaseProcessor {
	public UserRegisterReportProcessor(Module module, DataHandle dataHandle) {
		super(module, dataHandle);
	}
	
	public void makeView() throws Exception {
		if (getFormData("action").equals("list")) {
			String baseSql = "select * from user where 1=1 ";
			String q_fromTime = "";
			String q_toTime = "";
			if (!getFormData("q_fromTime").equals("")) {
				q_fromTime = getFormData("q_fromTime") + " 00:00:00";
			}
			if (!getFormData("q_toTime").equals("")) {
				q_toTime = getFormData("q_toTime") + " 23:59:59";
			}
			
			StringBuffer querySql = new StringBuffer("");
			Vector<String> param = new Vector<String>();
			
			if (!q_fromTime.equals("")) {
				querySql.append(" and registerTime >= ?");
				param.add(q_fromTime);
			}
			if (!q_toTime.equals("")) {
				querySql.append(" and registerTime <= ?");
				param.add(q_toTime);
			}
			
			String sellNumberSql = "select count(a.userID) as userRegisterCount, left(a.registerTime, 10) as registerTime" +
								" from (" + baseSql + querySql.toString() + ")" +
								" as a group by left(a.registerTime, 10) order by registerTime desc";
			int pageNumber = 20;
			String sellNumberSqlCount = "select count(a.userRegisterCount) as count from (" + sellNumberSql + ") as a";
			int count = Integer.parseInt(DBProxy.query(getConnection(), "count_V", sellNumberSqlCount, param).get(0).get("COUNT"));
			initPageIndex();
			setJumpPageInfo(count, pageNumber);
			
			String sqlPage = sellNumberSql + " limit " + (Integer.parseInt(getFormData("pageIndex")) - 1) * pageNumber + ", " + pageNumber + "";
			Vector<Hashtable<String, String>> value = DBProxy.query(getConnection(), "userRegister_Sum_V", sqlPage, param);
			setJSPData("datas", value);
			
			Hashtable<String, Hashtable<String, String>> orderDayCountHash = new Hashtable<String, Hashtable<String,String>>();
			
			setJSPData("orderDayCountHash", orderDayCountHash);

		} 
	}

	public void defaultViewAction() throws Exception {
		listAction();
	}
	
}
