package admin.customer.guanwangbao.weixin;

import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Hashtable;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSocketFactory;
import javax.net.ssl.TrustManager;


import simpleWebFrame.log.AppLogger;
import weixin.popular.api.MenuAPI;
import weixin.popular.bean.BaseResult;
import ytx.org.apache.http.HttpResponse;
import ytx.org.apache.http.client.HttpClient;
import ytx.org.apache.http.client.methods.HttpGet;
import ytx.org.apache.http.impl.client.DefaultHttpClient;

import admin.customer.guanwangbao.tool.WeiXinAccessTokenTool;

import com.alibaba.fastjson.JSON;



@SuppressWarnings("deprecation")
public class APITool {
	/**
	 * 创建菜单
	 * @param accessToken
	 * @param menuJson
	 * @return
	 */
	public static boolean createMenu(String siteID, String appID, String appSecret, String menuJson) {
		String accessToken = WeiXinAccessTokenTool.getAccess_token(appID, appSecret);
		BaseResult result = MenuAPI.menuCreate(accessToken, menuJson);
		if (!result.getErrcode().equals("0")) {
			AppLogger.getInstance().infoLog("create menu :" +  menuJson);
			AppLogger.getInstance().infoLog("create menu fail:" +  result.getErrcode() + "-" +  result.getErrmsg());
		}
        return result.getErrcode().equals("0");
	}
	
	/**
	 * 创建菜单
	 * @param accessToken
	 * @param menuJson
	 * @return
	 */
	public static void deleteMenu(String siteID, String appID, String appSecret) {
		String accessToken = WeiXinAccessTokenTool.getAccess_token(appID, appSecret);
		MenuAPI.menuDelete(accessToken);
	}
	
	/**
	 * 上传多媒体
	 * @param accessToken
	 * @param menuJson
	 * @return
	 */
	public static Map uploadMedia(String siteID, String appID, String appSecret, String type, String imagePath) throws Exception {
		String accessToken = WeiXinAccessTokenTool.getAccess_token(appID, appSecret);
		String url = Config.UPLOAD_MEDIA_URL 
			+ "?access_token=" + accessToken + "&type=" + type;
		String response = uploadImage2(url, imagePath);
		
		System.out.println("uploadMedia：" + response);
		
		 return parseUploadNewsResult(response);  
	}
	
	/**
	 * 上传图片
	 * @param accessToken
	 * @param menuJson
	 * @return
	 */
	public static String uploadLocalInfoImage(String siteID, String appID, String appSecret, String imagePath) throws Exception {
		String accessToken = WeiXinAccessTokenTool.getAccess_token(appID, appSecret);
		String url = Config.UPLOAD_IMG_URL 
			+ "?access_token=" + accessToken;
		String response = uploadImage2(url, imagePath);
		
		System.out.println("uploadImage：" + response);
		
		 Map result = parseUploadNewsResult(response);
		 
		 return result.get("url") == null ? "" : result.get("url").toString();
	}
	
	/**
	 * 上传图片
	 * @param accessToken
	 * @param menuJson
	 * @return
	 */
	public static String uploadRemoteInfoImage(String siteID, String appID, String appSecret, String imageUrl) throws Exception {
		String accessToken = WeiXinAccessTokenTool.getAccess_token(appID, appSecret);
		String url = Config.UPLOAD_IMG_URL 
			+ "?access_token=" + accessToken;
		String response = uploadRemoteImage(url, imageUrl);
		
		System.out.println("uploadImage：" + response);
		
		 Map result = parseUploadNewsResult(response);
		 
		 return result.get("url") == null ? "" : result.get("url").toString();
	}
	
	/**
	 * 上传图文消息
	 * @param accessToken
	 * @param menuJson
	 * @return
	 */
	public static Map uploadNews(String siteID, String appID, String appSecret, String newsJson) throws Exception {
		AppLogger.getInstance().infoLog("uploadNews newsJson：" + newsJson);
		String accessToken = WeiXinAccessTokenTool.getAccess_token(appID, appSecret);
		String url = Config.UPLOAD_NEWS_URL 
			+ "?access_token=" + accessToken;
		String response = httpsRequest(url, "POST", newsJson);
		
		System.out.println("uploadNews：" + response);
		
        return parseUploadNewsResult(response);  
	}
	

	/**
	 * 群发图文消息
	 * @param accessToken
	 * @param menuJson
	 * @return
	 */
	public static Map sendNews(String siteID, String appID, String appSecret, String contentJson) throws Exception {
		String accessToken = WeiXinAccessTokenTool.getAccess_token(appID, appSecret);
		String url = Config.SEND_NEWS_URL 
			+ "?access_token=" + accessToken;
		String response = httpsRequest(url, "GET", contentJson);
		
        return parseUploadNewsResult(response);  
	}
	
	/**
	 * 获取菜单
	 * @param accessToken
	 * @param menuJson
	 * @return
	 */
	public static Vector<Button> getMenu(String siteID, String appID, String appSecret) throws Exception {
		String accessToken = WeiXinAccessTokenTool.getAccess_token(appID, appSecret);
		String url = Config.MENU_GET_URL 
			+ "?access_token=" + accessToken;
		String response = httpsRequest(url, "GET", "");
		
        return parseGetMenuResult(response);  
	}
	
	private static Vector<Button> parseGetMenuResult(String json) throws Exception {
		Map map = JSON.parseObject(json);
		map = (Map) map.get("menu");
		List datas = (List) map.get("button");
		Vector<Button> buttons = new Vector<Button>();
		for (int i = 0; i < datas.size(); i++) {
			Map data = (Map) datas.get(i);
			Button b = new Button();
			b.setData(data);
			buttons.add(b);
		}
		return buttons;
	}
	
	private static Map parseUploadNewsResult(String json) throws Exception {
		Map map = JSON.parseObject(json);
		return map;
	}
	
	/** 
     * 发起https请求并获取结果 
     *  
     * @param requestUrl 请求地址 
     * @param requestMethod 请求方式（GET、POST） 
     * @param outputStr 提交的数据 
     * @return AccessToken 
     */ 
	public static String httpsRequest(String requestUrl, String requestMethod, String outputStr) {  
        StringBuffer buffer = new StringBuffer();  
        try {  
            // 创建SSLContext对象，并使用我们指定的信任管理器初始化  
            TrustManager[] tm = { new X509TrustManager() };  
            SSLContext sslContext = SSLContext.getInstance("SSL", "SunJSSE");  
            sslContext.init(null, tm, new java.security.SecureRandom());  
            // 从上述SSLContext对象中得到SSLSocketFactory对象  
            SSLSocketFactory ssf = sslContext.getSocketFactory();  
  
            URL url = new URL(requestUrl);  
            HttpsURLConnection httpUrlConn = (HttpsURLConnection) url.openConnection();  
            httpUrlConn.setSSLSocketFactory(ssf);  
  
            httpUrlConn.setDoOutput(true);  
            httpUrlConn.setDoInput(true);  
            httpUrlConn.setUseCaches(false);  
            // 设置请求方式（GET/POST）  
            httpUrlConn.setRequestMethod(requestMethod);  
  
            if ("GET".equalsIgnoreCase(requestMethod)) {
                httpUrlConn.connect();  
            }
  
            if (outputStr != null && !outputStr.equals("")) {  
                OutputStream outputStream = httpUrlConn.getOutputStream();  
                outputStream.write(outputStr.getBytes("UTF-8"));  
                outputStream.close();  
            }  
  
            InputStream inputStream = httpUrlConn.getInputStream();  
            InputStreamReader inputStreamReader = new InputStreamReader(inputStream, "utf-8");  
            BufferedReader bufferedReader = new BufferedReader(inputStreamReader);  
  
            String str = null;  
            while ((str = bufferedReader.readLine()) != null) {  
                buffer.append(str);  
            }  
            bufferedReader.close();  
            inputStreamReader.close();  
            // 释放资源  
            inputStream.close();  
            inputStream = null;  
            httpUrlConn.disconnect(); 
        } catch (Exception e) {  
        }  
        return buffer.toString();
    }  
	
	public static String uploadImage2(String url,String filePath) throws IOException {
		File file = new File(filePath);
		if (!file.exists() || !file.isFile()) {
			throw new IOException("文件不存在");
		}
		String fileName = file.getName();
		DataInputStream in = new DataInputStream(new FileInputStream(file));
		
		return uploadImage2(url, fileName, in);
	}
	
	public static String uploadRemoteImage(String url,String fileUrl) throws IOException {
		String fileName = fileUrl.substring(fileUrl.lastIndexOf("/") + 1);
		
		@SuppressWarnings("resource")
		HttpClient httpclient = new DefaultHttpClient();
		HttpGet get = new HttpGet(fileUrl);
		HttpResponse response = httpclient.execute(get);
		InputStream in = response.getEntity().getContent();
		httpclient.getConnectionManager().shutdown();
		
		return uploadImage2(url, fileName, in);
	}
	
	public static String uploadImage2(String url, String fileName, InputStream in) throws IOException {
		String result = null;

		URL urlObj = new URL(url);
		HttpURLConnection con = (HttpURLConnection) urlObj.openConnection();

		con.setRequestMethod("POST");
		con.setDoInput(true);
		con.setDoOutput(true);
		con.setUseCaches(false);

		con.setRequestProperty("Connection", "Keep-Alive");
		con.setRequestProperty("Charset", "UTF-8");

		String BOUNDARY = "----------" + System.currentTimeMillis();
		con.setRequestProperty("Content-Type", "multipart/form-data; boundary="
				+ BOUNDARY);

		StringBuilder sb = new StringBuilder();
		sb.append("--");
		sb.append(BOUNDARY);
		sb.append("\r\n");
		sb.append("Content-Disposition: form-data;name=\"file\";filename=\""
				+ fileName + "\"\r\n");
		sb.append("Content-Type:application/octet-stream\r\n\r\n");

		byte[] head = sb.toString().getBytes("utf-8");

		OutputStream out = new DataOutputStream(con.getOutputStream());
		out.write(head);

		int bytes = 0;
		byte[] bufferOut = new byte[1024];
		while ((bytes = in.read(bufferOut)) != -1) {
			out.write(bufferOut, 0, bytes);
		}
		in.close();

		byte[] foot = ("\r\n--" + BOUNDARY + "--\r\n").getBytes("utf-8");

		out.write(foot);

		out.flush();
		out.close();

		StringBuffer buffer = new StringBuffer();
		BufferedReader reader = null;
		try {
			reader = new BufferedReader(new InputStreamReader(
					con.getInputStream()));
			String line = null;
			while ((line = reader.readLine()) != null) {
				buffer.append(line);
			}
			if (result == null) {
				result = buffer.toString();
			}
		} catch (IOException e) {
			e.printStackTrace();
			throw new IOException("数据读取异常");
		} finally {
			if (reader != null) {
				reader.close();
			}

		}

		return result;
	}
	
	public static String createWeixinMenu(Vector<Button> buttons) throws Exception {
		Hashtable<String, Vector<Hashtable<String, Object>>> weixinMenuStringH = new Hashtable<String, Vector<Hashtable<String, Object>>>();
		Vector<Hashtable<String, Object>> weixinMenu = new Vector<Hashtable<String,Object>>();
		
		for (int i = 0; i < buttons.size(); i++) {
			Button b = buttons.get(i);
			Hashtable h = new Hashtable<String, Object>();
			Map data = b.getData();
			if (data.get("sub_button") != null) {
				data.remove("sub_button");
			}
			if (b.getSubButtons().size() != 0) {
				Vector<Object> submenus = new Vector<Object>();
				for (int j = 0; j < b.getSubButtons().size(); j++) {
					submenus.add(b.getSubButtons().get(j).getData());
				}
				h.put("sub_button", submenus);
			}
			h.putAll(data);
			weixinMenu.add(h);
		}
		
		weixinMenuStringH.put("button", weixinMenu);
		return JSON.toJSONString(weixinMenuStringH);
	}
}
