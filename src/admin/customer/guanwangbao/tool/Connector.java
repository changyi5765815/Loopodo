package admin.customer.guanwangbao.tool;

import java.sql.Connection;
import java.sql.DriverManager;

import simpleWebFrame.config.AppConfig;

public class Connector {
	private static String mysqlUrl = "";
	private static String mysqlUsername = "";
	private static String mysqlPassword = "";
	
	static {
		try {
			Class.forName("com.mysql.jdbc.Driver")
				.newInstance();
			mysqlUrl = AppConfig.getInstance().getParameterConfig()
					.getParameter("database.url").replace("gwb", "information_schema");
			mysqlUsername = AppConfig.getInstance().getParameterConfig()
					.getParameter("database.userName");
			mysqlPassword = AppConfig.getInstance().getParameterConfig()
					.getParameter("database.password");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public static Connection getMySqlConnection() throws Exception {
		Connection conn = DriverManager.getConnection(mysqlUrl, mysqlUsername, mysqlPassword);
		return conn;
	}
}
