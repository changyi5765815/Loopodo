package admin.customer.guanwangbao.tool;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import simpleWebFrame.util.DateTimeUtil;

public class LogQueue {
	private static LogQueue instance = new LogQueue();
	
	private List<Map<String, String>> logs = new ArrayList<Map<String,String>>();
	
	
	private LogQueue() {
	}
	
	public static LogQueue getInstance() {
		 return instance;
	}
	
	public void log(String sessionID, String systemUserID, String systemUserName, String module, String action,
			String ip, String os, String browser, String browserVersion) {
		Map<String, String> log = new HashMap<String, String>();
		log.put("sessionID", sessionID);
		log.put("systemUserID", systemUserID);
		log.put("systemUserName", systemUserName);
		log.put("module", module);
		log.put("action", action);
		log.put("ip", ip);
		log.put("os", os);
		log.put("browser", browser);
		log.put("browserVersion", browserVersion);
		log.put("logTime", DateTimeUtil.getCurrentDateTime());
		
		logs.add(log);
	}
	
	public List<Map<String, String>> getLogs() {
		return logs;
	}
	
	public void clear() throws Exception {
		Class clazz = LogQueue.class;
		Field[] field = clazz.getDeclaredFields();
		for (int i = field.length-1 ; i >= 0; i-- ) {
			field[i].setAccessible(true);//设置true,使其不在检查访问修饰符。
			field[i].set(instance, null);
		}
		instance = null;
	}
}
