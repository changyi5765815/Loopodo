package admin.customer.guanwangbao;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.math.BigDecimal;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.sql.Connection;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Hashtable;
import java.util.Map;
import java.util.Vector;

import javax.imageio.ImageIO;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import simpleWebFrame.database.DBProxy;
import simpleWebFrame.util.DateTimeUtil;
import simpleWebFrame.util.PriceUtil;
import simpleWebFrame.util.StringUtil;


public class AppUtil {
	private static Hashtable<String, String> helpPageNameHash = new Hashtable<String, String>();
	public static boolean isPayFlag (String orderStatus, String payTypeID) {
		boolean payFlag = false;
		if (orderStatus.equals("5") || orderStatus.equals("7")) { 
			payFlag = true;
		} else {
			if (orderStatus.equals("3") || orderStatus.equals("4") || orderStatus.equals("9")) {//状态为9时指的是用户没签收订单退货的情况
				if (!payTypeID.equals("1002")) {
					payFlag = true;
				}
			}
		}
		
		return payFlag;
	}
	
	public static String getHelpPageUrl(String helpPageID) {
		return helpPageNameHash.get(helpPageID) == null ? "" : helpPageNameHash.get(helpPageID);
	}
	
	public static String splitString(String str, int count) throws Exception {
		int reInt = 0;
		String reStr = "";
		if (str == null) {
			return "";
		}
	
		char[] tempChar = str.toCharArray();
		int kk = 0;
		for (; (kk < tempChar.length && count > reInt); kk++) {
			String s1 = String.valueOf(tempChar[kk]);
			byte[] b = s1.getBytes("GBK");
			reInt += b.length;
			reStr += tempChar[kk];
		}
		return reStr + (kk == (tempChar.length) ? "" : "...");
	}
	
	public static String getOrderOperationTitle(String operationName) {
		String orderOperationTitle = "";
		
		if (operationName.equals("zhiWeiYiFuKuan")) {
			return "订单付款";
		} else if (operationName.equals("shenHeTongGuo")) {
			return "订单审核";
		} else if (operationName.equals("peiHuoWanCheng")) {
			return "订单配货";
		} else if (operationName.equals("faHuoWanCheng")) {
			return "订单发货";
		} else if (operationName.equals("queRenShouHuo")) {
			return "订单确认收货";
		} else if (operationName.equals("tuiKuan")) {
			return "订单退款";
		} else if (operationName.equals("quXiaoDingDan")) {
			return "订单取消";
		} else if (operationName.equals("daYinDingDan")) {
			return "订单打印";
		}
		
		return orderOperationTitle;
	}
	
	public static String getProductScore(String productPrice) {
		double dValue = Double.parseDouble(productPrice);
		int iValue =  (int) dValue;
		iValue = (iValue < dValue) ? (iValue + 1) : iValue;
		return iValue + "";
	}
	
	public static boolean showNeedPayMoneyFlag(String orderStatus, String payTypeID, String needPayMoney) {
		boolean showFlag = false;
		if (!isPayFlag(orderStatus, payTypeID, needPayMoney) && (orderStatus.equals("1") || orderStatus.equals("2") || orderStatus.equals("3") || orderStatus.equals("4") || orderStatus.equals("9"))) {
			showFlag = true; 
		}
		
		return showFlag;
	}
	
	public static String plusDate(int day) throws Exception {
		return plusDate(DateTimeUtil.getCurrentDate(), day);
	}
	
	public static String plusDate(String date, int day) throws Exception {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date d = sdf.parse(date);
		long curTimeMills = d.getTime();
		long toTimeMills = curTimeMills + (day * 24 * 60 * 60 * 1000L);
		Calendar c = Calendar.getInstance();
		c.setTimeInMillis(toTimeMills);
		
		Date resDate = c.getTime();
		return sdf.format(resDate);
	}
	
	public static String minDate(int day) throws Exception {
		return minDate(DateTimeUtil.getCurrentDate(), day);
	}
	
	public static String minDate(String date, int day) throws Exception {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date d = sdf.parse(date);
		long curTimeMills = d.getTime();
		long toTimeMills = curTimeMills - (day * 24 * 60 * 60 * 1000L);
		Calendar c = Calendar.getInstance();
		c.setTimeInMillis(toTimeMills);
		
		Date resDate = c.getTime();
		return sdf.format(resDate);
	}
	
	public static boolean isPayFlag (String orderStatus, String payTypeID, String needPayMoney) {
		if (Double.parseDouble(needPayMoney) <= 0) {
			return true;
		}
		
		boolean payFlag = false;
		if (orderStatus.equals("7")) { 
			payFlag = true;
		} else {
			if (orderStatus.equals("3") || orderStatus.equals("4") || orderStatus.equals("9")) {//状态3为待配货，4为待发货，9为时指的是待确认收货
				if (!payTypeID.equals("1000")) { // 1000为货到付款
					payFlag = true;
				}
			}
		}
		
		return payFlag;
	}	
	
	public static boolean isBeforeToday(String date) {
		return date.compareTo(DateTimeUtil.getCurrentDate()) < 0;
	}
	
	public static String formatBigMoney(String money) {
		StringBuffer sb = new StringBuffer();
		int count = 0;
		for (int i = money.length() - 1; i >= 0; i--) {
			sb.append(money.charAt(i));
			count++;
			if (count % 3 == 0) {
				sb.append(",");
			}
		}
		sb.reverse();
		String s = sb.toString();
		if (s.startsWith(",")) {
			s = s.substring(1);
		}
		return s;
	}
	
	/***
	 * 获取图片地址
	 * @param src 保存在数据库中的图片文件名
	 * @param type 图片的前缀  (如 type = 200  那么则获取的图片是  200_XXX的图片)
	 * @param dirName 图片保存的文件夹名  如 (league)
	 * @return
	 */
	public static String getImageURL(String dirName, String src, int type) {
		String image = "/images/none.jpg";
		if (src.startsWith("default") || src.startsWith("/default") ) {
			return "/uploadFile/" + src;
		} else if (src.startsWith("/uploadFile")) {
			return src;
		}
		if (src != null && !src.equals("")) {
			src = src.replace("\\", "/");
			String srcActual = src;
			String subDirName = "";
			int index = src.lastIndexOf("/");
			
			if (index != -1) {
				subDirName = src.substring(0, index + 1);
				srcActual = src.substring(index + 1);
			}

			if (type != 0) {
				image = "/uploadFile/" + subDirName + type + "_" + srcActual;
			}
			else {
				image = "/uploadFile/" + subDirName + srcActual;
			}
		} 
		
		return image;
	}
	
	public static String getProductImage(Hashtable<String, String> product, int type) {
		String image = product.get("mainImage");
		if (image == null) {
			image = product.get("image");
		}
		
		if (image == null) {
			return getImageURL("product/", image, type);
		}
		return getImageURL("product/", image, type);
	}
	
	public static String dealScriptContent(String script) {
		String str = script.replace("'", "\\'").replace("%", "\\%").replace("\r\n", "").replace("\n", "");
		return str;
	}
	
	public static void updShopOrderProductSellNumber(Connection con, String shopOrderID) {
		try {
			String sql = "select productID as count, sum(number - returnNumber) as sum from orderProduct where shopOrderID = ? group by productID";
			Vector<String> p = new Vector<String>();
			p.add(shopOrderID);
			
			Vector<Hashtable<String, String>> datas = DBProxy.query(con, "count_sum_V", sql, p);
			for (int i = 0; i < datas.size(); ++i) {
				Hashtable<String, String> data = datas.get(0);
				String productID = data.get("count");
				String sellNumber = data.get("sum");
				
				String sqlProduct = "update product set sellNumber = sellNumber + ? where productID = ?";
				Vector<String> pProduct = new Vector<String>();
				pProduct.add(sellNumber);
				pProduct.add(productID);
				DBProxy.update(con, "product", sqlProduct, pProduct);
			}
		} catch (Exception e) {
		}
	}
	
	public static Hashtable<String, Vector<Hashtable<String, String>>> getHelpPageHash(Vector<Hashtable<String, String>> helpPages) {
		Hashtable<String, Vector<Hashtable<String, String>>> helpTypeHash = 
			new Hashtable<String, Vector<Hashtable<String, String>>>();
		for (int i = 0; i < helpPages.size(); ++i) {
			Hashtable<String, String> helpPage = helpPages.get(i);
			String helpPageTypeID = helpPage.get("helpPageTypeID");
			
			if (helpTypeHash.get(helpPageTypeID) == null) {
				helpTypeHash.put(helpPageTypeID, new Vector<Hashtable<String,String>>());
			}
			
			helpTypeHash.get(helpPageTypeID).add(helpPage);
		}
		
		return helpTypeHash;
	}
	
	public static String getFileTypeName(String fileName) {
		int index = fileName.lastIndexOf(".");
		if (index != -1 && ((index + 1) < fileName.length())) {
			return fileName.substring(index + 1);
		}
		
		return "";
	}
	
	public static String getFileName(String fileName) {
		int index = fileName.lastIndexOf("/");
		if (index != -1 && ((index + 1) < fileName.length())) {
			return fileName.substring(index + 1);
		}
		
		return "";
	}
	
	public static String getDirName(String fileName) {
		int index = fileName.lastIndexOf("/");
		if (index != -1) {
			return fileName.substring(0, index);
		}
		
		return "";
	}
	
	public static String getIP(String domain) {
		InetAddress address = null;
		try {
			address = InetAddress.getByName(domain);
			return address.getHostAddress().toString();
		} catch (UnknownHostException e) {}
		
		return "";
	}
	
	public static Hashtable<String, String> getImageInfo(File f)
			throws Exception {
		if (!f.exists()) {
			throw new Exception("resize image don't exists : " + f.getName());
		}
		
		Hashtable<String, String> info = new Hashtable<String, String>();
		info.put("w", "0");
		info.put("w", "0");
		info.put("s", "0");
		
		InputStream in = null;
		try {
			in = new FileInputStream(f);
			BufferedImage src = ImageIO.read(in);   
	
			int width = src.getWidth(null);
			int height = src.getHeight(null);
			
			long size = f.length();
			
			info.put("w", width + "");
			info.put("h", height + "");
			info.put("s", size + "");
		} finally {
			if (in != null) {
				in.close();
			}
		}
		
		return info;
	}
	
	public static Hashtable<String, String> getArea(String townID) {
		Hashtable<String, String> area = new Hashtable<String, String>();
		area.put("townName", "");
		area.put("cityName", "");
		area.put("provinceName", "");
		Hashtable<String, String> town = LocalDataCache.getInstance().getTableDataByID("town", townID);
		if (!town.isEmpty()) {
			area.put("townName", town.get("name"));
			String cityID = town.get("cityID");
			Hashtable<String, String> city = LocalDataCache.getInstance().getTableDataByID("city", cityID);
			if (!city.isEmpty()) {
				area.put("cityName", city.get("name"));
				String provinceID = city.get("provinceID");
				Hashtable<String, String> province = LocalDataCache.getInstance().getTableDataByID("province", provinceID);
				if (!province.isEmpty()) {
					area.put("provinceName", province.get("name"));
				}
			}
		}
		
		return area;
	}
	
	/**
	 * 将data中的指定的字段值进行特殊字符转换处理
	 * @param columns 需要进行特殊字符转换的字段
	 * @param data 需要转换的数据
	 * @throws Exception
	 */
	public static void convertToHtml(String[] columns, 
			Map<String, String> data) throws Exception {
		for (int i = 0; i < columns.length; ++i) {
			if (data.get(columns[i]) != null && !data.get(columns[i]).equals("")) {
				data.put(columns[i], StringUtil.convertXmlChars(data.get(columns[i])));
			}
		}
	}
	
	public static void convertToHtml(String[] columns, 
			Vector<Hashtable<String, String>> datas) throws Exception {
		int size = datas.size();
		for (int j = 0; j < size; ++j) {
			Hashtable<String, String> data = datas.get(j);
			convertToHtml(columns, data);
		}
	}
	
	public static String getUrlDomains(String url) {
		if (url.equals("")) {
			return url;
		}
		int beginIndex = 0;
		int endIndex = url.length();
		
		boolean cutBegin = false;
		boolean cutEnd = false;
		if (url.startsWith("http://")) {
			beginIndex = url.indexOf("http://") + "http://".length();
			cutBegin = true;
		} else if (url.startsWith("https://")) {
			beginIndex = url.indexOf("https://") + "https://".length();
			cutBegin = true;
		}
		
		if (url.substring(beginIndex).indexOf("/") != -1) {
			endIndex = url.substring(beginIndex).indexOf("/") + beginIndex;
			cutEnd = true;
		} else if (url.substring(beginIndex).indexOf("?") != -1) {
			endIndex = url.substring(beginIndex).indexOf("?") + beginIndex;
			cutEnd = true;
		}
		
		if (!cutBegin && !cutEnd) {
			return url;
		}
		
		return url.substring(beginIndex, endIndex);
	}
	
	public static String generateWapHtml(String htmlContent) {
		Document doc = Jsoup.parse(htmlContent);
		
		Element body = doc.select("body").get(0);
		
		Elements chilren = body.children();
		
		Vector<Element> noChilrenElements = new Vector<Element>();
		getElementHasNoChilren(noChilrenElements, chilren);
		if (noChilrenElements.size() == 0) {
			return htmlContent;
		} else {
			body.empty();
			for (int i = 0; i < noChilrenElements.size(); ++i) {
				body.append("<div>" + noChilrenElements.get(i).outerHtml() + "</div>");
			}
			
			return body.html();
		}
	}
	
	public static void getElementHasNoChilren(Vector<Element> results, Elements elements) {
		if (elements == null || elements.size() == 0) {
			return;
		}
		for (int i = 0; i < elements.size(); ++i) {
			Element element = elements.get(i);
			Elements chilren = element.children();
			if (chilren == null || chilren.size() == 0 || chilren.select("img").size() == 0) {
				results.add(element);
			} else {
				getElementHasNoChilren(results, chilren);
			}
		}
	}
	
	public static String getDiscountPrice(String rate, String price, String discountFlag, String discountLogID) {
		if(rate.equals("")) {
			return PriceUtil.formatPrice(price);
		}
		if(discountLogID.equals("")) {
			return PriceUtil.formatPrice(price);
		}
		BigDecimal multiply = new BigDecimal(price).multiply(new BigDecimal(rate).divide(new BigDecimal(10)));
		return PriceUtil.formatPrice(multiply.toString());
	}
	
	public static boolean isDateTime(String dateTime) {
		if (dateTime.equals("")) {
			return false;
		}
		
		boolean checkResult = true;
		try {
			if (dateTime.length() == 19) {
				SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				format.parseObject(dateTime);
			} else {
				checkResult = false;
			}
		} catch (Exception e) {
			checkResult = false;
		}
		return checkResult;
	}
	
	public static long timeToMills(String time) throws Exception {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date = sdf.parse(time);
		Calendar c = Calendar.getInstance();
		c.setTime(date);
		
		return c.getTimeInMillis();
	}
	
	public static String getSelectString(String id, String checked, String valueAndView) {
		return getSelectString(id, checked, valueAndView, "", "form-control", true, "请选择");
	}
	
	/**
	 * 得到下拉框
	 * @param id 下拉框id
	 * @param checked 哪个被选中
	 * @param valueAndView 显示的数据
	 * @param javascript 更改执行的javascript
	 * @param className 样式名
	 * @param firstViewFlag 是否需要显示第一个默认值
	 * @param firstViewName 第一个默认值的显示名
	 * @return
	 */
	public static String getSelectString(String id, String checked, String valueAndView, String javascript, String className, boolean firstViewFlag, String firstViewName) {
		String[] split = StringUtil.split(valueAndView, ",");
		StringBuffer stringBuffer = new StringBuffer();
		stringBuffer.append("<select class='").append(className)
					.append("' name='")
					.append(id)
					.append("' id='")
					.append(id)
					.append("' onchange=" + javascript + ">");
		if (firstViewFlag) {
			stringBuffer.append("<option value=''>");
			stringBuffer.append(firstViewName);
			stringBuffer.append("</option>");
		}
		for (int i = 0; i < split.length; i++) {
			String[] split2 = StringUtil.split(split[i], ":");
			if (checked.equals(split2[0])) {
				stringBuffer.append("<option value='" + split2[0] + "' selected='selected'>" + split2[1] + "</option>");
			} else {
				stringBuffer.append("<option value='" + split2[0] + "'>" + split2[1] + "</option>");
			}
		}
		stringBuffer.append("</select>");
		return stringBuffer.toString();
	}
	
	
	/**
	 * @param date 当前时间
	 * @param format 时间格式
	 * @param type 类型（Calendar.DATE:天,Calendar.HOUR:小时,.....）
	 * @param num
	 * @return
	 * @throws Exception
	 */
	public static String getDateBefore(String date, String format, int type, int num) throws Exception {
		Calendar now = Calendar.getInstance();
		SimpleDateFormat simpleDateFormat = new SimpleDateFormat(format);
		now.setTime(simpleDateFormat.parse(date));
		now.set(type, now.get(type) + num);
		return simpleDateFormat.format(now.getTime());
	} 
	
	public static String dealLink(String link) {
		if (!link.equals("#") && !link.equals("") && !link.startsWith("/") 
				&& !link.startsWith("http:") && !link.startsWith("https:") && !link.startsWith("javascript")) {
			return "http://" + link;
		} else {
			return link;
		}
	}
	
	public static String getShopOrderReturnGoodsStatus(Connection con, 
			String shopOrderID) throws Exception {
		Hashtable<String, String> k = new Hashtable<String, String>();
		k.put("shopOrderID", shopOrderID);
		
		Vector<Hashtable<String, String>> orderProducts = 
			DBProxy.query(con, "orderProduct", k);
		
		String returnGoodsStatus = "0";
		for (int i = 0; i < orderProducts.size(); ++i) {
			Hashtable<String, String> data = orderProducts.get(i);
//			只要订单项中包含有退货中的商品,则将订单的退货状态更新为退货中
			if (data.get("status").equals("2")) {
				returnGoodsStatus = "1";
				break;
			} 
		}
		
		return returnGoodsStatus;
	}
	
	public static float getShopOrderProductAmount(Connection con, String shopOrderID) {
		try {
			String sql = "select sum((number - returnNumber) * price) as SUM from orderProduct where shopOrderID = ?";
			Vector<String> p = new Vector<String>();
			p.add(shopOrderID);
			
			Vector<Hashtable<String, String>> datas = DBProxy.query(con, "sum_V", sql, p);
			if (datas.size() > 0) {
				float point = Float.parseFloat(datas.get(0).get("SUM"));
				return point;
			}
		} catch (Exception e) {
		}
		
		return 0;
	}
	
	/**
	 * 根据时间获取团购秒杀状态
	 * @param startTime
	 * @param endTime
	 * @return
	 */
	public static String getGroupBuyStats(String startTime, String endTime) {
		String curTime = DateTimeUtil.getCurrentDateTime();
		if (startTime.compareTo(curTime) > 0) {
			return "2";
		} else if (endTime.compareTo(curTime) < 0) {
			return "4";
		} else {
			return "3";
		}
	}
	
	public static void main(String[] args) {
		System.out.println(getUrlDomains(""));
	}
	
	
}
