package admin.customer.guanwangbao.tool;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.StringReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.sql.Connection;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.List;

import org.jdom.input.SAXBuilder;

import simpleWebFrame.database.DBProxy;
import simpleWebFrame.database.IndexGenerater;
import simpleWebFrame.log.AppLogger;
import simpleWebFrame.util.DateTimeUtil;
import ytx.org.apache.http.HttpResponse;
import ytx.org.apache.http.client.methods.HttpGet;
import ytx.org.apache.http.impl.client.DefaultHttpClient;
import admin.customer.guanwangbao.LocalDataCache;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.TypeReference;
import com.cloopen.rest.sdk.CCPRestSmsSDK;

@SuppressWarnings("deprecation")
public class MessageUtil {
	public static Hashtable<String, String> sendMessage(String mobile, String[] paras, String templateID) throws Exception {
		HashMap<String, Object> result = null;
		CCPRestSmsSDK restAPI = new CCPRestSmsSDK();
		
		LocalDataCache localDataCache = LocalDataCache.getInstance();
		
		restAPI.init(localDataCache.getSysConfig("SMSHost"), localDataCache.getSysConfig("SMSPort"));
		
		restAPI.setAccount(localDataCache.getSysConfig("SMSAccount"), localDataCache.getSysConfig("SMSToken"));
		
		restAPI.setAppId(localDataCache.getSysConfig("SMSAppID"));
		
		result = restAPI.sendTemplateSMS(mobile, templateID , paras);
		
		boolean sendResult = false;
		String statusCode = result.get("statusCode") == null ? "" : result.get("statusCode").toString();
		String statusMsg = result.get("statusMsg") == null ? "" : result.get("statusMsg").toString();
		if("000000".equals(statusCode)) {
			sendResult = true;
		} else {
			AppLogger.getInstance().infoLog(result + "\t错误码=" + statusCode + " 错误信息= " + statusMsg);
			sendResult = false;
		}
		
		Hashtable<String, String> sendResultMap = new Hashtable<String, String>();
		sendResultMap.put("sendStatus", sendResult ? "2" : "9");
		sendResultMap.put("statusCode", statusCode);
		sendResultMap.put("statusMsg", statusMsg);
		sendResultMap.put("sendTime", DateTimeUtil.getCurrentDateTime());
		
		return sendResultMap;
	}
	
	@SuppressWarnings({ "deprecation", "resource" })
	public static Hashtable<String, String> sendMessage(String mobiles, String content, String sendTime) {
		Hashtable<String, String> sendResultMap = new Hashtable<String, String>();
		sendResultMap.put("sendStatus", "9");
		sendResultMap.put("statusCode", "Faild");
		sendResultMap.put("statusMsg", "");
		
		LocalDataCache localDataCache = LocalDataCache.getInstance();
		try {
			 String PostData = "account=" + localDataCache.getSysConfig("SMSAccount") + "&password=" 
					 + localDataCache.getSysConfig("SMSToken") + "&mobile=" + mobiles + "&content=" 
					 + java.net.URLEncoder.encode(content, "utf-8");
			 String ret = SMS(PostData, "http://sms.106jiekou.com/utf8/sms.aspx");
			 if ("100".equals(ret)) {
				 sendResultMap.put("sendStatus", "2");
			 }
		} catch (Exception e) {
			AppLogger.getInstance().errorLog("和信通发送短信失败", e);
		} 
		
		return sendResultMap;
	}
	
	public static org.jdom.Element toJDOMElement(String xmlString) throws Exception {
		StringReader sr = new StringReader(xmlString);
		SAXBuilder saxb = new SAXBuilder();
		org.jdom.Document doc = saxb.build(sr);
		org.jdom.Element root = doc.getRootElement();
		
		return root;
	}
	
	public static void insertSmsLog(Connection con, String mobile, String templateID, 
			String smsLogTypeID, String[] paras, Hashtable<String, String> sendResult, String smsPrice) throws Exception {
		Hashtable<String, String> kv = new Hashtable<String, String>();
		kv.put("smsLogID", IndexGenerater.getTableIndex("smsLog", con));
		kv.put("mobile", mobile);
		kv.put("paras", toString(paras));
		kv.put("templateID", templateID);
		kv.put("smsLogTypeID", smsLogTypeID);
		kv.put("addTime", DateTimeUtil.getCurrentDateTime());
		kv.put("smsPrice", smsPrice);
		kv.putAll(sendResult);
		DBProxy.insert(con, "smsLog", kv);
	}
	
	private static String SMS(String postData, String postUrl) {
        try {
            //发送POST请求
            URL url = new URL(postUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
            conn.setRequestProperty("Connection", "Keep-Alive");
            conn.setUseCaches(false);
            conn.setDoOutput(true);

            conn.setRequestProperty("Content-Length", "" + postData.length());
            OutputStreamWriter out = new OutputStreamWriter(conn.getOutputStream(), "UTF-8");
            out.write(postData);
            out.flush();
            out.close();

            //获取响应状态
            if (conn.getResponseCode() != HttpURLConnection.HTTP_OK) {
                System.out.println("connect failed!");
                return "";
            }
            //获取响应内容体
            String line, result = "";
            BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream(), "utf-8"));
            while ((line = in.readLine()) != null) {
                result += line + "\n";
            }
            in.close();
            return result;
        } catch (IOException e) {
            e.printStackTrace(System.out);
        }
        return "";
    }
	
	public static void insertSmsLog(Connection con, String mobile, String content, 
			String smsLogTypeID, Hashtable<String, String> sendResult, String smsPrice) throws Exception {
		Hashtable<String, String> kv = new Hashtable<String, String>();
		kv.put("smsLogID", IndexGenerater.getTableIndex("smsLog", con));
		kv.put("mobile", mobile);
		kv.put("content", content);
		kv.put("smsLogTypeID", smsLogTypeID);
		kv.put("addTime", DateTimeUtil.getCurrentDateTime());
		kv.put("smsPrice", smsPrice);
		kv.putAll(sendResult);
		DBProxy.insert(con, "smsLog", kv);
	}
	
	public static String toString(String[] paras) {
		return JSON.toJSONString(paras);
	}
	
	public static String[] toStringArray(String json) {
		String[] b = JSON.parseObject(json, new TypeReference<String[]>(){});
		return b;
	}
	
	public static void main(String[] args) {
		System.out.println(sendMessage("15811510908", "【官网宝】官网宝推出了新一轮的降价促销打折活动，登录我们的官网首页即可参与活动，http://demo.guanwangbao.com", ""));;
	}
}
