package admin.customer.guanwangbao.processor;

import java.net.URLDecoder;
import java.util.Hashtable;
import java.util.Vector;

import simpleWebFrame.config.Module;
import simpleWebFrame.database.DBProxy;
import simpleWebFrame.web.DataHandle;
import admin.customer.guanwangbao.AppUtil;
import admin.customer.guanwangbao.LocalDataCache;

public class PrintDeliveryProcessor extends BaseProcessor {
	public PrintDeliveryProcessor(Module module, DataHandle dataHandle) {
		super(module, dataHandle);
	}

	@Override
	public void makeView() throws Exception {
	}
	
	public void printViewAction() throws Exception {
		String deliveryFromAddress = URLDecoder.decode(getFormData("deliveryFromAddress"), "UTF-8");
		String deliveryFromCompany = URLDecoder.decode(getFormData("deliveryFromCompany"), "UTF-8");
		String deliveryFromPerson = URLDecoder.decode(getFormData("deliveryFromPerson"), "UTF-8");
		String deliveryFromPhone = URLDecoder.decode(getFormData("deliveryFromPhone"), "UTF-8");
		String deliveryFromPostal = URLDecoder.decode(getFormData("deliveryFromPostal"), "UTF-8");
		
		updateSysConfig("deliveryFromAddress", deliveryFromAddress);
		updateSysConfig("deliveryFromCompany", deliveryFromCompany);
		updateSysConfig("deliveryFromPerson", deliveryFromPerson);
		updateSysConfig("deliveryFromPhone", deliveryFromPhone);
		updateSysConfig("deliveryFromPostal", deliveryFromPostal);
		
		String shopOrderID = getFormData("shopOrderID");
		Hashtable<String, String> key = new Hashtable<String, String>();
		key.put("shopOrderID", shopOrderID);
		Vector<Hashtable<String, String>> datas = DBProxy.query(getConnection(), "shopOrder_V", key);
		if (datas.size() == 0) {
			setFormData("error", "该订单已被删除,请刷新订单页面");
			return;
		}
		
		String shouHuoRen = datas.get(0).get("shouHuoRen");
		String provinceName = datas.get(0).get("provinceName");
		String cityName = datas.get(0).get("cityName");
		String townName = datas.get(0).get("townName");
		String address = provinceName + " " + cityName + " " + townName;
		String addressNext = datas.get(0).get("address");
		String mobile = datas.get(0).get("mobile");
		String postalCode = datas.get(0).get("postalCode");
		
		key.remove("deleteFlag");
		setJSPData("itemDatas", DBProxy.query(getConnection(), "orderProduct_V", key));
		
		String address_1 = "";
		String address_2 = "";
		if (deliveryFromAddress.length() > 20) {
			address_1 = deliveryFromAddress.substring(0, 20);
			address_2 = deliveryFromAddress.substring(20);
		} else {
			address_1 = deliveryFromAddress;
		}
		
		String deliveryFromCompanyPosition = "";
		String deliveryFromAddressPosition = "";
		String deliveryFromAddressNextPosition = "";
		String deliveryFromPersonPosition = "";
		String deliveryFromPhonePosition = "";
		String deliveryFromPostalPosition = "";
		
		String shouHuoRenPosition = "";
		String addressPosition = "";
		String addressNextPosition = "";
		String mobilePosition = "";
		String postalCodePosition = "";
		
		String deliveryTypeID = datas.get(0).get("deliveryTypeID");
		String deliveryTypeCode = LocalDataCache.getInstance().getTableDataColumnValue("deliveryType", deliveryTypeID, "code");
		String deliveryTypeImage = AppUtil.getImageURL("deliveryTypeImage", LocalDataCache.getInstance().getTableDataColumnValue("deliveryType", deliveryTypeID, "image"), 0);
		if ("SF".equals(deliveryTypeCode)) {
			deliveryFromCompanyPosition = "108:135:260:20";
			deliveryFromPersonPosition = "300:135:260:20";
			deliveryFromPhonePosition = "280:215:260:20";
			deliveryFromAddressPosition = "108:165:290:20";
			if (!address_2.equals("")) {
				deliveryFromAddressNextPosition = "108:195:290:20";
			}
			deliveryFromPostalPosition = "";
			deliveryFromPostal = "";
			
			shouHuoRenPosition = "320:260:260:20";
			mobilePosition = "280:380:260:20";
			addressPosition = "108:290:290:20";
			addressNextPosition = "108:320:290:20";
			postalCodePosition = ""; 
			postalCode = "";
		} else if ("ZTO".equals(deliveryTypeCode)) {	
			deliveryFromCompanyPosition = "148:220:260:20";
			deliveryFromPersonPosition = "152:125:260:20";
			deliveryFromPhonePosition = "152:260:260:20";
			deliveryFromAddressPosition = "152:155:290:20";
			if (!address_2.equals("")) {
				deliveryFromAddressNextPosition = "152:185:290:20";
			}
			deliveryFromPostalPosition = "320:260:260:20";
			
			shouHuoRenPosition = "515:125:260:20";
			mobilePosition = "515:260:260:20";
			addressPosition = "515:155:290:60";
			addressNextPosition = "515:185:290:60";
			postalCodePosition = "683:260:260:20";
		} else if ("STO".equals(deliveryTypeCode)) {	
			deliveryTypeImage = "shenTong.jpg";
			deliveryFromCompanyPosition = "122:135:260:20";
			deliveryFromPersonPosition = "122:95:260:20";
			deliveryFromPhonePosition = "158:240:260:20";
			deliveryFromAddressPosition = "122:165:290:20";
			if (!address_2.equals("")) {
				deliveryFromAddressNextPosition = "122:205:290:20";
			}
			deliveryFromPostalPosition = "";
			deliveryFromPostal = "";
			
			shouHuoRenPosition = "495:100:260:20";
			mobilePosition = "510:240:260:20";
			addressPosition = "495:165:290:60";
			addressNextPosition = "495:205:290:60";
			postalCodePosition = "";
			postalCode = "";
		} else if ("YTO".equals(deliveryTypeCode)) {	
			deliveryFromCompanyPosition = "115:128:260:20";
			deliveryFromPersonPosition = "115:106:260:20";
			deliveryFromPhonePosition = "158:225:260:20";
			deliveryFromAddressPosition = "115:153:289:20";
			if (!address_2.equals("")) {
				deliveryFromAddressNextPosition = "115:173:289:20";
			}
			deliveryFromPostalPosition = "360:225:260:20";
			
			shouHuoRenPosition = "490:111:260:20";
			mobilePosition = "520:225:260:20";
			addressPosition = "490:153:289:60";
			addressNextPosition = "490:173:289:60";
			postalCodePosition = "735:225:65:20";
		} else if ("YD".equals(deliveryTypeCode)) {	
			deliveryFromCompanyPosition = "152:135:260:20";
			deliveryFromPersonPosition = "152:110:260:20";
			deliveryFromPhonePosition = "265:212:230:20";
			deliveryFromAddressPosition = "152:160:289:20";
			if (!address_2.equals("")) {
				deliveryFromAddressNextPosition = "152:188:289:20";
			}
			deliveryFromPostalPosition = "152:212:260:20";
			
			shouHuoRenPosition = "465:105:260:20";
			mobilePosition = "600:212:260:20";
			addressPosition = "465:160:289:60";
			addressNextPosition = "465:188:289:60";
			postalCodePosition = "470:212:65:20";
		} else if ("QFKD".equals(deliveryTypeCode)) {	
			// 全峰快递暂时没有照片
		} else if ("EMS".equals(deliveryTypeCode)) {	
			deliveryFromCompanyPosition = "190:160:260:20";
			deliveryFromPersonPosition = "152:130:260:20";
			deliveryFromPhonePosition = "300:130:260:20";
			deliveryFromAddressPosition = "140:185:289:20";
			if (!address_2.equals("")) {
				deliveryFromAddressNextPosition = "140:210:289:20";
			}
			deliveryFromPostalPosition = "315:255:65:20";
			
			shouHuoRenPosition = "515:130:260:20";
			mobilePosition = "660:130:260:20";
			addressPosition = "510:185:289:20";
			addressNextPosition = "510:210:289:20";
			postalCodePosition = "668:255:65:20";
		} else if ("HHTT".equals(deliveryTypeCode)) {	
			deliveryFromCompanyPosition = "175:148:260:20";
			deliveryFromPersonPosition = "150:118:260:20";
			deliveryFromPhonePosition = "300:240:230:20";
			deliveryFromAddressPosition = "120:180:289:20";
			if (!address_2.equals("")) {
				deliveryFromAddressNextPosition = "120:205:289:20";
			}
			deliveryFromPostalPosition = "";
			deliveryFromPostal = "";
			
			shouHuoRenPosition = "520:120:260:20";
			mobilePosition = "520:240:260:60";
			addressPosition = "490:180:289:60";
			addressNextPosition = "490:205:289:60";
			postalCodePosition = ""; 
			postalCode = "";
		} else if ("ZJS".equals(deliveryTypeCode)) {	
			deliveryFromCompanyPosition = "150:155:260:20";
			deliveryFromPersonPosition = "150:125:260:20";
			deliveryFromPhonePosition = "150:240:260:20";
			deliveryFromAddressPosition = "150:190:289:20";
			if (!address_2.equals("")) {
				deliveryFromAddressNextPosition = "150:220:289:20";
			}
			deliveryFromPostalPosition = "";
			deliveryFromPostal = "";
			
			shouHuoRenPosition = "510:130:260:20";
			mobilePosition = "500:240:260:20";
			addressPosition = "470:190:289:60";
			addressNextPosition = "470:210:289:60";
			postalCodePosition = ""; 
			postalCode = "";
		} else if ("YZPY".equals(deliveryTypeCode)) {	
			deliveryFromCompanyPosition = "130:115:260:20";
			deliveryFromPersonPosition = "130:90:260:20";
			deliveryFromPhonePosition = "270:85:260:20";
			deliveryFromAddressPosition = "120:140:310:20";
			if (!address_2.equals("")) {
				address_1 = deliveryFromAddress;
				deliveryFromAddressNextPosition = "";
				address_2 = "";
			}
			deliveryFromPostalPosition = "320:160:260:20";
			
			shouHuoRenPosition = "130:200:260:20";
			mobilePosition = "270:195:260:20";
			addressPosition = "130:245:289:20";
			addressNextPosition = "130:265:289:20";
			postalCodePosition = "325:285:260:20";
		}
		
		setFormData("deliveryTypeImage", deliveryTypeImage);
		
		setFormData("deliveryFromCompany", deliveryFromCompany);
		setFormData("deliveryFromPerson", deliveryFromPerson);
		setFormData("deliveryFromPhone", deliveryFromPhone);
		setFormData("deliveryFromAddress", address_1);
		setFormData("deliveryFromAddressNext", address_2);
		setFormData("deliveryFromPostal", deliveryFromPostal);
		
		setFormData("shouHuoRen", shouHuoRen);
		setFormData("address", address);
		setFormData("addressNext", addressNext);
		setFormData("mobile", mobile);
		setFormData("postalCode", postalCode);
		
		setFormData("deliveryFromCompanyPosition", deliveryFromCompanyPosition);
		setFormData("deliveryFromPersonPosition", deliveryFromPersonPosition);
		setFormData("deliveryFromPhonePosition", deliveryFromPhonePosition);
		setFormData("deliveryFromAddressPosition", deliveryFromAddressPosition);
		setFormData("deliveryFromAddressNextPosition", deliveryFromAddressNextPosition);
		setFormData("deliveryFromPostalPosition", deliveryFromPostalPosition);
		
		setFormData("shouHuoRenPosition", shouHuoRenPosition);
		setFormData("mobilePosition", mobilePosition);
		setFormData("addressPosition", addressPosition);
		setFormData("addressNextPosition", addressNextPosition);
		setFormData("postalCodePosition", postalCodePosition);
	}
	
	public void orderDeliveryPrintWindowAction() throws Exception {
		setFormData("deliveryFromCompany", LocalDataCache.getInstance().getSysConfig("deliveryFromCompany"));
		setFormData("deliveryFromAddress", LocalDataCache.getInstance().getSysConfig("deliveryFromAddress"));
		setFormData("deliveryFromPerson", LocalDataCache.getInstance().getSysConfig("deliveryFromPerson"));
		setFormData("deliveryFromPhone", LocalDataCache.getInstance().getSysConfig("deliveryFromPhone"));
		setFormData("deliveryFromPostal", LocalDataCache.getInstance().getSysConfig("deliveryFromPostal"));
	}
	
	private void updateSysConfig(String key, String value) throws Exception {
		Hashtable<String, String> k1 = new Hashtable<String, String>();
		k1.put("name", key);
		Hashtable<String, String> v1 = new Hashtable<String, String>();
		v1.put("value", value);
		DBProxy.update(getConnection(), "sysConfig", k1, v1);
	}
}
