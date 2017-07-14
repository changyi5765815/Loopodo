package admin.customer.guanwangbao.tool;

import java.io.File;
import java.sql.Connection;

import simpleWebFrame.config.AppConfig;
import simpleWebFrame.database.DBConnectionPool;
import simpleWebFrame.log.AppLogger;

public class UpdateTool {
	public UpdateTool() {
		File f = new File("tmp.txt");
		String appRoot = f.getAbsolutePath();
		appRoot = appRoot.replaceAll("tmp.txt", "") + "applicationRoot";
		try {
			AppLogger.getInstance().init(appRoot);
			AppConfig.getInstance().init(appRoot);
			
			Connection con = DBConnectionPool.getInstance().getConnection();
			update(con);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public void update(Connection con) throws Exception {
	}
	
	
	public static void main(String[] args) {
		new UpdateTool();
	}

}
