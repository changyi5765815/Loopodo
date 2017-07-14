package admin.customer.guanwangbao;

import java.util.Hashtable;

import simpleWebFrame.config.AppConfig;
import simpleWebFrame.log.AppLogger;


public class AppKeys {
	public static String AJAX_RESULT = "AJAX_RESULT";
	
	public static String UPLOAD_FILE_PATH = "";
	
	public static String DOMAIN = "";
	public static String DOMAIN_ADMIN = "";
	public static String DOMAIN_WWW = "";
	public static String DOMAIN_WAP = "";
	public static String DOMAIN_CONSOLE = "";
	public static String DOMAIN_SHOP = "";
	public static String DOMAIN_AGENTCONSOLE = "";
	public static String Domain_API = "";//yangruizhi add 2015-07-27
	
	public static int IMAGE_SIZE_MIDDEN = 200;
	public static int IMAGE_SIZE_LARGE = 400;
	public static int IMAGE_SIZE_SMALL = 100;
	public static int IMAGE_SIZE_LIST = 250;
	
	public static int SKU_IMAGE_SIZE_SMALL = 60;
	
	public static int INFORMATION_IMAGE_SIZE = 160;
	public static int SOLUTION_IMAGE_SIZE = 150;
	
	public static int MAX_PRODUCT_IMAGES = 10;
	
	public static int FLOORTEMP_IMAGE_SIZE = 300;
	
	public static String DEFAULT_MENUID = "1000";
	
	public static String DEFAULT_ICPNum = "08001464";
	
	public static String SERVICE_PHONE = "";
	
	public static String ORDER_SQL = "orderSql";
	
	public static String ORDER_STATUS_UNPAY = "1";
	public static String ORDER_STATUS_WAITAUDIT = "7";
	public static String ORDER_STATUS_DAIPEIHUO = "2";
	public static String ORDER_STATUS_DAIFAHUO = "8";
	public static String ORDER_STATUS_DAISHOUHUO = "3";
	public static String ORDER_STATUS_YISHOUHUO = "4";
	public static String ORDER_STATUS_SUCCEED = "5";
	public static String ORDER_STATUS_CLOSE = "6";
	public static String ORDER_STATUS_WAITZT = "20";
	
	public static int THEME_IMAGE_SIZE = 300;
	public static int CASES_IMAGE_SIZE = 300;
	
	public static int SUPPLIER_THEME_IMAGE_SIZE = 400;
	
	public static String HELPPAGE_TYPE_98 = "98"; 
	
	public static String FLOOR_POSITION_TYPE_HEADER = "10";
	public static String FLOOR_POSITION_TYPE_MIDDLE = "20";
	public static String FLOOR_POSITION_TYPE_FOOTER = "30";
	
	public static String PAY_TYPE_ID_ALIPAY_JSDZ = "1";
	public static String PAY_TYPE_ID_ALIPAY_JSDZ_WAP = "3";
	public static String PAY_TYPE_ID_ALIPAY_DBJY = "5";
	public static String PAY_TYPE_ID_ALIPAY_APP = "7";
	public static String PAY_TYPE_ID_ALIPAY_SBZ = "10";
	public static String PAY_TYPE_ID_99BILL = "15";
	public static String PAY_TYPE_ID_YEEDPAY = "20";
	public static String PAY_TYPE_ID_WEIXIN_APP = "15";
	public static String PAY_TYPE_ID_WEIXIN = "25";
	public static String PAY_TYPE_ID_TENCENT = "30";
	
	public static String THIRD_SERVICE_SMS = "1003";
	
	public static String SERVICE_300_MONTH = "1004";
	public static String SERVICE_500_MONTH = "1005";
	public static String SERVICE_300_YEAR = "1006";
	public static String SERVICE_500_YEAR = "1007";
	public static String SERVICE_100_MONTH = "1009";
	public static String SERVICE_100_YEAR = "1010";
	public static String SERVICE_UP = "1008";
	public static String SERVICE_UP2 = "1011";
	public static String SERVICE_SHOPDEVICECODE = "1012";
	
	public static String CARD_SOURCE_WHOLE_PROMOTION = "1"; //全站促销满赠
	public static String CARD_SOURCE_REGISTER = "2"; //注册赠送
	public static String CARD_SOURCE_SHOPPING = "3"; //购物赠送
	public static String CARD_SOURCE_OFFLINE = "4"; //线下导流赠送
	public static String CARD_SOURCE_SYSTEM = "5"; //系统赠送
	
	public static String SMS_ZT_TEMPID = "65033"; //自提码
	public static double SMSPRICE = 0.10;
	
	public static String SMS_ONLINE_CARD_TEMPID = "53413"; //线上优惠券短信模板
	
	//public static long AUTO_REC_DAY = 7 * 24 * 60 * 60 * 1000;  //订单由已发货状态自动变更为已签收状态的默认天数
	
	//public static long AUTO_FINISH_DAY = 7 * 24 * 60 * 60 * 1000;  //订单由已签收状态自动变更为已完成状态的默认天数
	
	public static long AUTO_REC_DAY = 10 * 60 * 1000;
	
	public static long AUTO_FINISH_DAY = 10 * 60 * 1000;
	
	public static String wx_temp_msg_fahuo_id = "";//微信模板消息发送发货通知给用户
	public static String accessToken = "";
	
	public static String SUPPLIER_STATUS_WAIT_AUDIT = "10";
	public static String SUPPLIER_STATUS_VALID = "20";
	public static String SUPPLIER_STATUS_UNVALID = "30";
	public static String SUPPLIER_STATUS_AUDIT_NOTPASS = "90";
	
	public static String SMS_TEMP_DAOHUOTONGZHI = "";
	
	static {
	}
	
	static void setSysConfig(Hashtable<String, String> sysConfigHash) {
		try {
			DOMAIN = sysConfigHash.get("domain");
			DOMAIN_WWW = sysConfigHash.get("wwwDomain");
			DOMAIN_WAP = sysConfigHash.get("wapDomain");
			DOMAIN_ADMIN = sysConfigHash.get("adminDomain");
			DOMAIN_CONSOLE = sysConfigHash.get("consoleDomain");
			DOMAIN_SHOP = sysConfigHash.get("shopDomain");
			DOMAIN_AGENTCONSOLE = sysConfigHash.get("agentConsoleDomain");
			Domain_API = sysConfigHash.get("apiDomain");
			SERVICE_PHONE = sysConfigHash.get("servicePhone");
			UPLOAD_FILE_PATH = AppConfig.getInstance().getParameterConfig().getParameter("uploadDir");
		} catch (Exception e) {
			AppLogger.getInstance().errorLog("初始化系统参数错误,系统暂时获取默认设置参数");
		}
	}

	static void setUploadFilePath(String path) {
		UPLOAD_FILE_PATH = path;
	}
}
