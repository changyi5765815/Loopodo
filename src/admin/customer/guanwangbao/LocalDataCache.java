package admin.customer.guanwangbao;

import java.lang.reflect.Field;
import java.sql.Connection;
import java.util.Hashtable;
import java.util.Vector;

import simpleWebFrame.database.DBConnectionPool;
import simpleWebFrame.database.DBProxy;
import simpleWebFrame.log.AppLogger;
import simpleWebFrame.util.StringUtil;

public class LocalDataCache {
	private static String[] baseDataTables = {
		"c_userType", "town", "c_userSourceType", "c_userLevel", "c_userMoneyHistoryType", "c_userLevel", "skuPropValue", "c_exceptionType", "c_transactionStatus",  
		"city", "province", "c_payTypeDisplayType", "c_transactionType", "c_refundStatus", "c_returnGoodsStatus", "deliveryType", "c_promotionActiveType", "c_cardSourceType", 
		"helpPageType", "c_productTag", "c_groupBuyType", "c_groupBuyStatus", "infoType", "skuProp", "c_stockInType", "c_stockOutType", 
		"bigType", "smallType", "tinyType", "c_orderStatus", "c_refundType", "c_returnGoodsType", "c_logisticsCompany", "c_productAuditStatus",
		"payType", "c_shopOrderSourceType", "c_bannerGroup", "c_supplierStatus", "c_companyDepartment", "c_companyScale",
		"c_companyIndustry", "c_companyNature", "c_supplierTag", "c_questionFeedBackLogType", "c_infoAuditType", 
		"c_supplierMode", "supplierMainProduct", "supplierLevel", "commentDimension", "c_shopReputation", "c_smtpHost"
	};
	
	
	private static LocalDataCache instance = new LocalDataCache();
	public static Vector<Hashtable<String, String>> nullDatas = new Vector<Hashtable<String, String>>();
	public static Hashtable<String, String> nullData = new Hashtable<String, String>();
	private Hashtable<String, Vector<Hashtable<String, String>>> tableDatas;
	private Hashtable<String, Hashtable<String, Hashtable<String, String>>> tableDataHash;
	
	private Vector<Hashtable<String, String>> provinces;
	private Hashtable<String, Hashtable<String, String>> provinceHash;
	
	private Hashtable<String, Vector<Hashtable<String, String>>> provinceCitys;
	private Hashtable<String, Hashtable<String, String>> cityHash;
	
	private Hashtable<String, Vector<Hashtable<String, String>>> cityTowns;
	private Hashtable<String, Hashtable<String, String>> townHash;
	
	private Vector<Hashtable<String, String>> menus;
	private Hashtable<String, Hashtable<String, String>> menuHash;
	
	private Vector<Hashtable<String, String>> bigSystemModules;
	private Vector<Hashtable<String, String>> smallSystemModules;
	private Hashtable<String, Vector<Hashtable<String, String>>> smallSystemModuleHash;

	
	private Vector<Hashtable<String, String>> bigType;
	private Hashtable<String, Hashtable<String, String>> bigTypeHash;
	private Hashtable<String, Hashtable<String, String>> allTypeHash;
	private Hashtable<String, Vector<Hashtable<String, String>>> smallTypeHash;
	private Hashtable<String, Hashtable<String, String>> smallTypeAllHash;
	private Hashtable<String, Vector<Hashtable<String, String>>> tinyTypeHash;
	private Hashtable<String, Hashtable<String, String>> tinyTypeAllHash;
	
	private Hashtable<String, String> sysConfigHash;
	
	private Hashtable<String, Vector<Hashtable<String, String>>> colorCssHash;
	
	private Vector<Hashtable<String, String>> skuProps;
	private Hashtable<String, Vector<Hashtable<String, String>>> skuPropValueHash;
	
	private Hashtable<String, Hashtable<String, String>> propertiesHash;
	private Hashtable<String, Hashtable<String, String>> propertiesValues;
	private Hashtable<String, Vector<Hashtable<String, String>>> propertiesValuesHash;
	private Hashtable<String, Vector<Hashtable<String, String>>> typePropertiesHash;
	
	private LocalDataCache() {
	}
	
	public static LocalDataCache getInstance() {
		return instance;
	}
	
	public synchronized void loadData() {
		Connection con = null;
		try {
			con = DBConnectionPool.getInstance().getConnection();
			loadBaseDatas(con);
			reloadCity(con);
			//reloadMenus(con);
			loadModules(con);
			reloadSysConfig(con);
			loadType(con);
			loadSkuPropValue(con);
			loadProperties(con);
			//loadColorCss(con);
		} catch (Exception e) {
			AppLogger.getInstance().errorLog("error happened when init load data", e);
		} finally {
			try {
				if (con != null) {
					con.close();
				}
			} catch (Exception e) {
			}
		}
	}
	
	private void loadBaseDatas(Connection con) throws Exception {
		tableDatas = new Hashtable<String, Vector<Hashtable<String,String>>>();
		tableDataHash = new Hashtable<String, Hashtable<String,Hashtable<String,String>>>();
		
		for (int i = 0; i < baseDataTables.length; ++i) {
			loadTableData(baseDataTables[i], con);
		}
	}
	
	private void loadTableData(String tableName, Connection con) throws Exception {
		Hashtable<String, String> key = new Hashtable<String, String>();
		String sortSql = "";
		if (tableName.equalsIgnoreCase("c_floorElementProp")) {
			sortSql = "order by sortIndex";
		} else if (tableName.equalsIgnoreCase("c_floorElementProp") || tableName.equals("c_colorCss")) {
			sortSql = "order by sortIndex";
		} else if (tableName.equalsIgnoreCase("infoType")) {
			key.put("deletedFlag", "0");
		} else if (tableName.equalsIgnoreCase("c_shopReputation")) {
			sortSql = "order by c_shopReputationValue desc";
			key.put("validFlag", "1");
		}
		
		Vector<Hashtable<String, String>> datas = DBProxy.query(con, tableName, key, sortSql);
		Hashtable<String, Hashtable<String, String>> datasHash = new Hashtable<String, Hashtable<String,String>>();
		Hashtable<String, String> tmpData;
		for (int i = 0; i < datas.size(); ++i) {
			tmpData = datas.get(i);
			if (tableName.equals("c_colorCss")) {
				datasHash.put(tmpData.get("c_colorCssClass"), tmpData);
			} else if (tableName.equals("webHost")) {
				datasHash.put(tmpData.get("webHostIP"), tmpData);
			} else if (tableName.equals("c_module")) {
				datasHash.put(tmpData.get("c_module"), tmpData);
			} else {
				datasHash.put(tmpData.get(tableName + "ID"), tmpData);
			}
		}
		tableDatas.put(tableName, datas);
		tableDataHash.put(tableName, datasHash);
	}

	private void loadType(Connection con) throws Exception {
		Hashtable<String, String> key = new Hashtable<String, String>();
		key.put("validFlag", "1");
		
		String orderSql = "order by sortIndex";
		
		bigType = DBProxy.query(con, "bigType", key, orderSql);
		
		bigTypeHash = new Hashtable<String, Hashtable<String,String>>();
		allTypeHash = new Hashtable<String, Hashtable<String,String>>();
		
		Vector<Hashtable<String, String>> smallType = DBProxy.query(con, "smallType", key, orderSql);
		Vector<Hashtable<String, String>> tinyType = DBProxy.query(con, "tinyType", key, orderSql);
		
		smallTypeAllHash = new Hashtable<String, Hashtable<String,String>>();
		smallTypeHash = new Hashtable<String, Vector<Hashtable<String, String>>>();

		tinyTypeAllHash = new Hashtable<String, Hashtable<String,String>>();
		tinyTypeHash = new Hashtable<String, Vector<Hashtable<String, String>>>();
		
		for (int i = 0; i < bigType.size(); i++) {
			bigTypeHash.put(bigType.get(i).get("bigTypeID"), bigType.get(i));
			smallTypeHash.put(bigType.get(i).get("bigTypeID"),
					new Vector<Hashtable<String, String>>());
			allTypeHash.put(bigType.get(i).get("bigTypeID"), bigType.get(i));
		}

		for (int i = 0; i < smallType.size(); i++) {
			Hashtable<String, String> data = smallType.get(i);
			smallTypeAllHash.put(data.get("smallTypeID"), data);
			if (smallTypeHash.get(data.get("bigTypeID")) != null) {
				smallTypeHash.get(data.get("bigTypeID")).add(data);
				tinyTypeHash.put(data.get("smallTypeID"),
						new Vector<Hashtable<String, String>>());
			}
			allTypeHash.put(data.get("smallTypeID"), data);
		}
		
		for (int i = 0; i < tinyType.size(); i++) {
			Hashtable<String, String> data = tinyType.get(i);
			tinyTypeAllHash.put(data.get("tinyTypeID"), data);
			if (tinyTypeHash.get(data.get("smallTypeID")) != null) {
				tinyTypeHash.get(data.get("smallTypeID")).add(data);
			}
			allTypeHash.put(data.get("tinyTypeID"), data);
		}
	}
	
	public void loadColorCss(Connection con) throws Exception {
		colorCssHash = new Hashtable<String, Vector<Hashtable<String,String>>>();
		
		Vector<Hashtable<String, String>> colorCssDatas = getTableDatas("c_colorCss");
		for (int i = 0; i < colorCssDatas.size(); ++i) {
			Hashtable<String, String> data = colorCssDatas.get(i);
			String colorCssTypeID = data.get("c_colorCssTypeID");
			if (colorCssHash.get(colorCssTypeID) == null) {
				colorCssHash.put(colorCssTypeID, new Vector<Hashtable<String,String>>());
			}
			colorCssHash.get(colorCssTypeID).add(data);
		}
	}
	
	private void reloadCity(Connection con) throws Exception {
		provinces = DBProxy.query(con, "province");
		provinceHash = new Hashtable<String, Hashtable<String,String>>();
		provinceCitys = new Hashtable<String, Vector<Hashtable<String,String>>>();
		for (int i = 0; i < provinces.size(); i++) {
			provinceHash.put(provinces.get(i).get("provinceID"), provinces
					.get(i));
			provinceCitys.put(provinces.get(i).get("provinceID"),
					new Vector<Hashtable<String, String>>());
			
		}
		
		cityHash = new Hashtable<String, Hashtable<String,String>>();
		cityTowns = new Hashtable<String, Vector<Hashtable<String,String>>>();
		Vector<Hashtable<String, String>> cities = DBProxy.query(con, "city");
		for (int i = 0; i < cities.size(); i++) {
			Hashtable<String, String> city = cities.get(i);
			cityHash.put(city.get("cityID"), city);
			Vector<Hashtable<String, String>> datas = provinceCitys.get(city.get("provinceID"));
			if (datas != null) {
				datas.add(city);
			}
			cityTowns.put(city.get("cityID"), new Vector<Hashtable<String,String>>());
		}
		
		townHash = new Hashtable<String, Hashtable<String,String>>();
		Vector<Hashtable<String, String>> towns = DBProxy.query(con, "town");
		for (int i = 0; i < towns.size(); i++) {
			Hashtable<String, String> town = towns.get(i);
			townHash.put(town.get("townID"), town);
			Vector<Hashtable<String, String>> datas = cityTowns.get(town.get("cityID"));
			if (datas != null) {
				datas.add(town);
			}
		}
	}
	
	public void reloadMenus(Connection con) throws Exception {
		menuHash = new Hashtable<String, Hashtable<String,String>>();
		String sql = "select * from menu where validFlag = ? order by sortIndex";
		Vector<String> value = new Vector<String>();
		value.add("1");
		menus = DBProxy.query(con, "menu", sql, value);
		
		for (int i = 0; i < menus.size(); i++) {
			menuHash.put(menus.get(i).get("menuID"), menus.get(i));
		}
	}
	
	public void loadModules(Connection con) throws Exception {
		bigSystemModules = DBProxy.query(con, "c_bigSystemModule");
		smallSystemModules = DBProxy.query(con, "c_systemModule");
		smallSystemModuleHash = new Hashtable<String, Vector<Hashtable<String,String>>>();
		
		for (int i = 0; i < smallSystemModules.size(); ++i) {
			Hashtable<String, String> data = smallSystemModules.get(i);
			String bigSystemModuleID = data.get("c_bigSystemModuleID");
			if (smallSystemModuleHash.get(bigSystemModuleID) == null) {
				smallSystemModuleHash.put(bigSystemModuleID, new Vector<Hashtable<String,String>>());
			}
			smallSystemModuleHash.get(bigSystemModuleID).add(data);
		}
	}
	
	/**
	 * 加载系统参数配置
	 * @param con
	 * @throws Exception
	 */
	public void reloadSysConfig(Connection con) throws Exception {
		Vector<Hashtable<String, String>> sysConfigs = DBProxy.query(con, "sysConfig");
		sysConfigHash = new Hashtable<String, String>();
		for (int i = 0; i < sysConfigs.size(); ++i) {
			Hashtable<String, String> tmp = sysConfigs.get(i);
			String name = tmp.get("name");
			String value = tmp.get("value");
			sysConfigHash.put(name, value);
		}
		
		AppKeys.setSysConfig(sysConfigHash);
	}
	
	public Vector<Hashtable<String, String>> getProvinces() {
		return provinces;
	}
	
	public Vector<Hashtable<String, String>> getCitiesByProvinceID(String provinceID) {
		Vector<Hashtable<String, String>> datas = provinceCitys.get(provinceID);
		if (datas == null) {
			datas = nullDatas;
		}
		return datas;
	}
	
	public Vector<Hashtable<String, String>> getTownsByCityID(String cityID) {
		Vector<Hashtable<String, String>> datas = cityTowns.get(cityID);
		if (datas == null) {
			datas = nullDatas;
		}
		return datas;
	}
	
	public Hashtable<String, String> getTableDataByID(String tableName, String id) {
		Hashtable<String, String> data = getTableDatasHash(tableName).get(id);
		if (data == null) {
			return new Hashtable<String, String>();
		}
		return data;
	}
	
	public String getTableDataColumnValue(String tableName, String id, String column) {
		Hashtable<String, String> data = getTableDataByID(tableName, id);
		if (tableName.equals("c_module")) {
			return data.get(column) == null ? id : data.get(column);
		} else {
			return data.get(column) == null ? "" : data.get(column);
		}
	}
	
	public String getTableDataColumnsValue(String tableName, String ids, String column) {
		String[] id = StringUtil.split(ids, ", ");
		StringBuffer sbf = new StringBuffer();
		int index = 0;
		for (int i = 0; i < id.length; ++i) {
			Hashtable<String, String> data = getTableDataByID(tableName, id[i]);
			String tmpColumnValue = data.get(column) == null ? "" : data.get(column);
			if (!tmpColumnValue.equals("")) {
				if (index != 0) {
					sbf.append(",").append(tmpColumnValue);
				} else {
					sbf.append(tmpColumnValue);
				}
				index++;
			}
		}
		
		return sbf.toString();
	}
	
	public Hashtable<String, String> getCity(String cityID) {
		return cityHash.get(cityID);
	}
	
	public Hashtable<String, String> getProvince(String provinceID) {
		return provinceHash.get(provinceID);
	}
	
	public Hashtable<String, String> getTown(String townID) {
		return townHash.get(townID);
	}
	
	public Vector<Hashtable<String, String>> getTableDatas(String tableName) {
		return tableDatas.get(tableName);
	}
	
	public Hashtable<String, Hashtable<String, String>> getTableDatasHash(String tableName) {
		return tableDataHash.get(tableName);
	}
	
	public Vector<Hashtable<String, String>> getMenus() {
		return menus == null ? new Vector<Hashtable<String,String>>() : menus;
	}
	
	public Vector<Hashtable<String, String>> getMenusByLevel(int level) {
		Vector<Hashtable<String, String>> menus2 = new Vector<Hashtable<String,String>>();
		for (Hashtable<String, String> menu : this.menus) {
			if(menu.get("level").equals(level + "")) {
				menus2.add(menu);
			}
		}
		return menus2;
	}
	
	public Hashtable<String, String> getMenusByID(String menuID) {
		return menuHash.get(menuID);
	}
	
	public void clear() throws Exception {
		//将所有的的dataCache下的变量置为null
		Class clazz = LocalDataCache.class;
		Field[] field = clazz.getDeclaredFields();
		for (int i = field.length-1 ; i >= 0; i-- ) {
			field[i].setAccessible(true);//设置true,使其不在检查访问修饰符。
			field[i].set(instance, null);
		}
		instance = null;
	}

	public Vector<Hashtable<String, String>> getBigSystemModules() {
		return bigSystemModules;
	}

	public Vector<Hashtable<String, String>> getSmallSystemModules() {
		return smallSystemModules;
	}
	
	public Vector<Hashtable<String, String>> getSmallSystemModules(String bigSystemModuleID) {
		return smallSystemModuleHash.get(bigSystemModuleID) == null ? 
				new Vector<Hashtable<String,String>>(): smallSystemModuleHash.get(bigSystemModuleID);
	}

	public Vector<Hashtable<String, String>> getBigTypes() {
		return bigType;
	}
	
	public Hashtable<String, String> getBigType(String bigTypeID) {
		return bigTypeHash.get(bigTypeID);
	}
	public Hashtable<String, String> getType(String ID) {
		return allTypeHash.get(ID);
	}
	public Hashtable<String,Hashtable<String, String>> getallTypeHashs() {
		return allTypeHash;
	}
	
	public Hashtable<String, String> getSmallType(String smallTypeID) {
		return smallTypeAllHash.get(smallTypeID);
	}
	
	public Hashtable<String, String> getTinyType(String tinyTypeID) {
		return tinyTypeAllHash.get(tinyTypeID);
	}
	
	public Vector<Hashtable<String, String>> getSmallTypesByBigTypeID(String bigTypeID) {
		if (smallTypeHash.get(bigTypeID) == null) {
			return new Vector<Hashtable<String,String>>();
		}
		return smallTypeHash.get(bigTypeID);
	}
	
	public Vector<Hashtable<String, String>> getTinyTypesBySmallTypeID(String smallTypeID) {
		if (tinyTypeHash.get(smallTypeID) == null) {
			return new Vector<Hashtable<String,String>>();
		}
		return tinyTypeHash.get(smallTypeID);
	}
	
	public String getSysConfig(String key) {
		return sysConfigHash.get(key) == null 
			? "" : sysConfigHash.get(key);
	}
	
	public Hashtable<String, String> getSysConfigs() {
		return sysConfigHash;
	}
	
	public Vector<Hashtable<String, String>> getColorCss(String colorCssTypeID) {
		return colorCssHash.get(colorCssTypeID) == null ? 
				new Vector<Hashtable<String,String>>() : colorCssHash.get(colorCssTypeID);
	}
	
	public Vector<Hashtable<String, String>> getSkuProps() {
		return skuProps;
	}
	
	public Vector<Hashtable<String, String>> getSkuPropValues(String skuPropID) {
		return skuPropValueHash.get(skuPropID) == null ? new Vector<Hashtable<String,String>>() : skuPropValueHash.get(skuPropID);
	}
	
	private void loadSkuPropValue(Connection con) throws Exception {
		skuProps = DBProxy.query(con, "skuProp", new Hashtable<String, String>(), "order by sortIndex");
		skuPropValueHash = new Hashtable<String, Vector<Hashtable<String,String>>>();
		Vector<Hashtable<String, String>> skuPropValues = 
			DBProxy.query(con, "skuPropValue", new Hashtable<String, String>(), "order by sortIndex");
		
		for (int i = 0; i < skuPropValues.size(); ++i) {
			Hashtable<String, String> skuPropValue = skuPropValues.get(i);
			Vector<Hashtable<String, String>> datas = skuPropValueHash.get(skuPropValue.get("skuPropID"));
			if (datas == null) {
				datas = new Vector<Hashtable<String,String>>();
				skuPropValueHash.put(skuPropValue.get("skuPropID"), datas);
			}
			datas.add(skuPropValue);
		}
	}
	
	private void loadProperties(Connection con) throws Exception {
		propertiesHash = new Hashtable<String, Hashtable<String,String>>();
		propertiesValues = new Hashtable<String, Hashtable<String,String>>();
		propertiesValuesHash = new Hashtable<String, Vector<Hashtable<String,String>>>();
		typePropertiesHash = new Hashtable<String, Vector<Hashtable<String,String>>>();
		
		Hashtable<String, String> key = new Hashtable<String, String>();
		key.put("validFlag", "1");
		
		Vector<Hashtable<String, String>> propertiesDatas = 
			DBProxy.query(con, "properties", key, "order by sortIndex");
		
		for (int i = 0; i < propertiesDatas.size(); ++i) {
			//if (propertiesDatas.get(i).get("validFlag").equals("1")) {
			propertiesHash.put(propertiesDatas.get(i).get("propertiesID"), propertiesDatas.get(i));
				
			key.put("propertiesID", propertiesDatas.get(i).get("propertiesID"));
			Vector<Hashtable<String, String>> propertiesValuesVec = DBProxy.query(con, "propertiesValue", key);
			for (Hashtable<String, String> propertiesValue : propertiesValuesVec) {
				propertiesValues.put(propertiesValue.get("propertiesValueID"), propertiesValue);
			}
			propertiesValuesHash.put(propertiesDatas.get(i).get("propertiesID"), propertiesValuesVec);
				
			Vector<Hashtable<String, String>> datas = typePropertiesHash.get(propertiesDatas.get(i).get("bigTypeID") + ":" + propertiesDatas.get(i).get("smallTypeID") + ":" + propertiesDatas.get(i).get("tinyTypeID"));
			if (datas == null) {
				datas = new Vector<Hashtable<String,String>>();
				typePropertiesHash.put(propertiesDatas.get(i).get("bigTypeID") + ":" + propertiesDatas.get(i).get("smallTypeID") + ":" + propertiesDatas.get(i).get("tinyTypeID"), datas);
			}
			datas.add(propertiesDatas.get(i));			
		}
		//}
	}
	
	public Vector<Hashtable<String,String>> getPropertiesByType(String key) {
		return typePropertiesHash.get(key) == null 
			? new Vector<Hashtable<String,String>>() : typePropertiesHash.get(key);
	}
	
	public Vector<Hashtable<String, String>> getTypeProperties(String bigTypeID, String smallTypeID, String tinyTypeID) throws Exception {
					
		Vector<Hashtable<String, String>> properties = new Vector<Hashtable<String,String>>();
		properties.addAll(LocalDataCache.getInstance().getPropertiesByType("::"));
		properties.addAll(LocalDataCache.getInstance().getPropertiesByType(bigTypeID + "::"));
		properties.addAll(LocalDataCache.getInstance().getPropertiesByType(bigTypeID + ":" + smallTypeID + ":"));
		properties.addAll(LocalDataCache.getInstance().getPropertiesByType(bigTypeID + ":" + smallTypeID + ":" + tinyTypeID));
		return properties;
	}
	
	public Vector<Hashtable<String,String>> getPropertiesValuesByPropertiesID(String key) {
		return propertiesValuesHash.get(key) == null 
			? new Vector<Hashtable<String,String>>() : propertiesValuesHash.get(key);
	}
	
	public Hashtable<String, String> getProperteisValue(String propertiesValueID) {
		return propertiesValues.get(propertiesValueID) == null 
			? new Hashtable<String, String>() : propertiesValues.get(propertiesValueID);
	}
	
}
