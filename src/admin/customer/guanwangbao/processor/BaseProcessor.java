package admin.customer.guanwangbao.processor;

import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.sql.Connection;
import java.util.Calendar;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.Vector;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;

import jxl.Workbook;
import jxl.format.Border;
import jxl.format.Colour;
import jxl.format.VerticalAlignment;
import jxl.write.Label;
import jxl.write.WritableCellFormat;
import jxl.write.WritableFont;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;
import nl.bitwalker.useragentutils.UserAgent;
import simpleWebFrame.config.AppConfig;
import simpleWebFrame.config.Module;
import simpleWebFrame.config.QueryCondition;
import simpleWebFrame.config.QueryDataList;
import simpleWebFrame.database.DBProxy;
import simpleWebFrame.database.IndexGenerater;
import simpleWebFrame.log.AppLogger;
import simpleWebFrame.util.DateTimeUtil;
import simpleWebFrame.util.FileUtil;
import simpleWebFrame.util.PictureUtil;
import simpleWebFrame.util.SimpleFileReader;
import simpleWebFrame.util.StringUtil;
import simpleWebFrame.web.AbstractModuleProcessor;
import simpleWebFrame.web.CheckList;
import simpleWebFrame.web.DataHandle;
import simpleWebFrame.web.FrameKeys;
import simpleWebFrame.web.validate.IntegerCheckItem;
import weixin.popular.api.MessageAPI;
import weixin.popular.bean.templatemessage.TemplateMessage;
import weixin.popular.bean.templatemessage.TemplateMessageItem;
import admin.customer.guanwangbao.AppKeys;
import admin.customer.guanwangbao.AppUtil;
import admin.customer.guanwangbao.LocalDataCache;
import admin.customer.guanwangbao.RandomCodeGenerator;
import admin.customer.guanwangbao.tool.LogQueue;
import admin.customer.guanwangbao.tool.WeiXinAccessTokenTool;

import com.alibaba.fastjson.JSON;

public abstract class BaseProcessor extends AbstractModuleProcessor {
	public BaseProcessor(Module module, DataHandle dataHandle) {
		super(module, dataHandle);
	}

	public void startProcess() throws Exception {
		log();
	}
	
	public void log() {
		if (getFormData("module").startsWith("crossDomain")) {
			return;
		}
		HttpServletRequest request = getRequest();
		Hashtable<String, String> userAnentInfo = getUserAgentInfo();
		LogQueue.getInstance().log(request.getSession().getId(), getLoginedUserInfo().get("systemUserID"), getLoginedUserInfo().get("userName"), 
				getFormData("module"), getFormData("action"), getClusterRequestIPInfo(), 
				userAnentInfo.get("os"), userAnentInfo.get("browser"), userAnentInfo.get("browserVersion"));
	}
	
	public void endProcess() throws Exception {
		if (getFormData("requestType").equals("1")) {
			dispatch("ajax.jsp");
		} else if (getFormData("requestType").equals("2")) {
			if (getFormData("reDispatch").equals("1")) {
				dispatch("ajax.jsp");
			} else {
				dispatch("/popUpWindow/" + getFormData("action") + ".jsp");
			}
		} else if (getFormData("requestType").equals("3") || getFormData("requestType").equals("4")) {
			if (getFormData("reDispatch").equals("1")) {
				dispatch("ajax.jsp");
			} 
		}
	}
	
	public String getClusterRequestIPInfo() {
		if (getRequest().getHeader("X-Real-IP") != null) {
			return getRequest().getHeader("X-Real-IP");
		}
		return super.getRequestIPInfo();
	}

	public Hashtable<String, String> getUserAgentInfo() {
		Hashtable<String, String> info = new Hashtable<String, String>();
		info.put("os", "");
		info.put("browser", "");
		info.put("browserVersion", "");
		
		try {
			UserAgent userAgent = UserAgent.parseUserAgentString(getRequest().getHeader("User-Agent"));
			String browser = userAgent.getBrowser().toString();
			String browserVersion = userAgent.getBrowserVersion().toString();
			String os = userAgent.getOperatingSystem().toString();
			info.put("os", os);
			info.put("browser", browser);
			info.put("browserVersion", browserVersion);
		} catch (Exception e) {}
		
		return info;
	}
	
	public void listAction() throws Exception {
		setFormData("action", "list");
	}

	public Vector<Hashtable<String, String>> getDatasInIDArray(String[] arrayID, 
			String tableOrViewName, String idColumnName, Hashtable<String, String> key) throws Exception {
		Vector<Hashtable<String, String>> datas = null;
		
		if (arrayID != null && arrayID.length > 0) {
			StringBuffer sb = new StringBuffer();
			sb.append("select * from ");
			sb.append(tableOrViewName);
			sb.append(" where ");
			sb.append(idColumnName);
			sb.append(" in (");
			
			Vector<String> values = new Vector<String>();
			for (int i = 0; i < arrayID.length; ++i) {
				sb.append(i == 0 ? "?" : ",?");
				values.add(arrayID[i]);
			}
			
			sb.append(")");
			
			Iterator<String> iter = key.keySet().iterator();
			while (iter.hasNext()) {
				String keyName = iter.next();
				String keyValue = key.get(keyName);
				sb.append(" and ");
				sb.append(keyName);
				sb.append(" = ? ");
				values.add(keyValue);
			}
			
			String sql = sb.toString();
			datas = DBProxy.query(getConnection(), tableOrViewName, sql, values);
		}
		
		return datas == null ? new Vector<Hashtable<String,String>>() : datas;
	}
	
	public int getCountValue(String tableOrViewName, String countColumn, 
			Hashtable<String, String> condition) throws Exception {
		String prepareSql = "select count(" + countColumn + ") as COUNT from " + tableOrViewName;
		
		Iterator<String> iter = condition.keySet().iterator();
		String key;
		String value;
		Vector<String> values = new Vector<String>();
		while (iter.hasNext()) {
			key = iter.next();
			value = condition.get(key);
			prepareSql += (" and " + key + " = ?");
			values.add(value);
		}
		
		prepareSql = prepareSql.replaceFirst("and", "where");
		
		String count = DBProxy.query(getConnection(), "count_V", 
				prepareSql, values).get(0).get("COUNT");
		
		return count.equals("") ? 0 : Integer.parseInt(count);
	}
	
	public Vector<String> getValueNotInVector(String[] values, 
			Vector<Hashtable<String, String>> datas, String key) {
		Vector<String> result = new Vector<String>();
		for (int i = 0; i < values.length; i++) {
			String tmpID = values[i];
			int j = 0;
			for (; j < datas.size(); j++) {
				Hashtable<String, String> tmpData = datas.get(j);
				if (tmpID.equals(tmpData.get(key))) {
					break;
				}
			}
			
			if (j == datas.size()) {
				result.add(tmpID);
			}
		}
		
		return result;
	}
	
	public String confirmValue2(String tableName) throws Exception {
		String id = tableName + "ID";
		
		String idValue = "";
		if (getFormData(id).equals("")) {
			idValue = IndexGenerater.getTableIndex(tableName,
					getConnection());
			setFormData(id, idValue);
			setFormData("validFlag", "1");

			DBProxy.insert(getConnection(), tableName, getFormDatas());
		} else {
			Hashtable<String, String> key = new Hashtable<String, String>();
			idValue = getFormData(id);
			key.put(id, getFormData(id));

			DBProxy.update(getConnection(), tableName, key, getFormDatas());
		}
		
		return idValue;
	}
	
	public void changeValidFlag(String tableName, String validFlag)
			throws Exception {
		changeValidFlag(tableName, validFlag, true);
	}

	public void changeValidFlag(String tableName, String validFlag,
			boolean setListAction) throws Exception {
		Hashtable<String, String> key = new Hashtable<String, String>();
		key.put(tableName + "ID", getFormData(tableName + "ID"));

		Hashtable<String, String> value = new Hashtable<String, String>();
		value.put("validFlag", validFlag);

		DBProxy.update(getConnection(), tableName, key, value);
		if (setListAction) {
			listAction();
		}
	}
	
	public void disableAction() throws Exception {
		changeValidFlag(getFormData("module"), "0");
	}
	
	public void enableAction() throws Exception {
		changeValidFlag(getFormData("module"), "1");
	}
	
	public boolean normalImageCheck() throws Exception {
		Vector<File> fileDatas = getUploadFiles();
		if (fileDatas.size() == 0) {
			setErrorMessage("请上传一张正确的图片");
			return false;
		} 
		
		for (int i = 0; i < fileDatas.size(); ++i) {
			if (!isImageFile(fileDatas.get(i))) {
				deleteAllUploadFile(fileDatas);
				setErrorMessage("只能上传图片文件");
				return false;
			}
		}
		
		return true;
	}
	
	private void deleteAllUploadFile(Vector<File> files) throws Exception {
		for (int i = 0; i < files.size(); ++i) {
			files.get(i).delete();
		}
	}
	
	public boolean isImageFile(File f) {
		String fileName = f.getName().toLowerCase();
		if (!fileName.endsWith(".jpeg") && !fileName.endsWith(".gif")
				&& !fileName.endsWith(".png") && !fileName.endsWith(".logo")
				&& !fileName.endsWith(".jpg")) {
			f.delete();
			return false;
		}
		return true;
	}
	
	public boolean isXSLFileORFTLFile(File f) {
		String fileName = f.getName().toLowerCase();
		if (!fileName.endsWith(".xsl") && !fileName.endsWith(".ftl")) {
			f.delete();
			return false;
		}
		return true;
	}
	
	public String getProductTypeSelect() throws Exception {
		Hashtable<String, String> key = new Hashtable<String, String>();
		key.put("validFlag", "1");
		String bigTypeString = makeSelectElementString("bigTypeID", 
				DBProxy.query(getConnection(), "bigType", key, " and bigTypeID != '9999'"), 
				"bigTypeID", "name", "doAction('selectProductType')");
		
		key.clear();
		key.put("bigTypeID", getFormData("bigTypeID"));
		key.put("validFlag", "1");
		String smallTypeString = makeSelectElementString("smallTypeID", 
				DBProxy.query(getConnection(), "smallType", key), 
				"smallTypeID", "name", "doAction('selectProductType')");
		
		if (smallTypeString.indexOf("selected") < 0) {
			setFormData("smallTypeID", "");
		}
		
		key.clear();
		key.put("smallTypeID", getFormData("smallTypeID"));
		key.put("validFlag", "1");
		String tinyTypeString = makeSelectElementString("tinyTypeID", 
				DBProxy.query(getConnection(), "tinyType", key), 
				"tinyTypeID", "name", "");
		
		return bigTypeString + " " + smallTypeString + " " + tinyTypeString;
	}
	
	public String getProductTypeSelect2() throws Exception {
		Hashtable<String, String> key = new Hashtable<String, String>();
		
		String function = "refreshItem('prop')";
		
		
		String bigTypeString = makeSelectElementString("bigTypeID", 
				DBProxy.query(getConnection(), "bigType", key, ""), 
				"bigTypeID", "name", "doAction('selectProductType2')");
		
		key.clear();
		key.put("bigTypeID", getFormData("bigTypeID"));
		String smallTypeString = makeSelectElementString("smallTypeID", 
				DBProxy.query(getConnection(), "smallType", key), 
				"smallTypeID", "name", "doAction('selectProductType2')");
		
		if (smallTypeString.indexOf("selected") < 0) {
			setFormData("smallTypeID", "");
		}
		
		key.clear();
		key.put("smallTypeID", getFormData("smallTypeID"));
		String tinyTypeString = makeSelectElementString("tinyTypeID", 
				DBProxy.query(getConnection(), "tinyType", key), 
				"tinyTypeID", "name", function);
		return bigTypeString + " " + smallTypeString + " " + tinyTypeString;
	}
	
	public String getQueryProductTypeSelect() throws Exception {
		Hashtable<String, String> key = new Hashtable<String, String>();
		key.put("validFlag", "1");
		String bigTypeString = makeSelectElementString("q_bigTypeID", 
				DBProxy.query(getConnection(), "bigType", key, " and bigTypeID != '9999'"), 
				"bigTypeID", "name", "doAction('selectQueryProductType')");
		
		key.clear();
		key.put("bigTypeID", getFormData("q_bigTypeID"));
		key.put("validFlag", "1");
		String smallTypeString = makeSelectElementString("q_smallTypeID", 
				DBProxy.query(getConnection(), "smallType", key), 
				"smallTypeID", "name", "doAction('selectQueryProductType')");
		
		if (smallTypeString.indexOf("selected") < 0) {
			setFormData("q_smallTypeID", "");
		}
		
		key.clear();
		key.put("smallTypeID", getFormData("q_smallTypeID"));
		key.put("validFlag", "1");
		String tinyTypeString = makeSelectElementString("q_tinyTypeID", 
				DBProxy.query(getConnection(), "tinyType", key), 
				"tinyTypeID", "name", "");

		return bigTypeString + smallTypeString + tinyTypeString;
	}
	
	public String getQueryProductTypeSelect2() throws Exception {
		Hashtable<String, String> key = new Hashtable<String, String>();
		key.put("validFlag", "1");
		String bigTypeString = makeSelectElementString("bigTypeID", 
				DBProxy.query(getConnection(), "bigType", key, " and bigTypeID != '9999'"), 
				"bigTypeID", "name", "doAction('selectQueryProductType2')");
		
		key.clear();
		key.put("bigTypeID", getFormData("bigTypeID"));
		key.put("validFlag", "1");
		String smallTypeString = makeSelectElementString("smallTypeID", 
				DBProxy.query(getConnection(), "smallType", key), 
				"smallTypeID", "name", "doAction('selectQueryProductType2')");
		
		if (smallTypeString.indexOf("selected") < 0) {
			setFormData("smallTypeID", "");
		}
		
		key.clear();
		key.put("smallTypeID", getFormData("smallTypeID"));
		key.put("validFlag", "1");
		String tinyTypeString = makeSelectElementString("tinyTypeID", 
				DBProxy.query(getConnection(), "tinyType", key), 
				"tinyTypeID", "name", "refreshItem('product','refreshprop','prop')");

		return bigTypeString + smallTypeString + tinyTypeString;
	}
	
	public String getQueryProductTypeSelect2Action() throws Exception {
		Hashtable<String, String> key = new Hashtable<String, String>();
		key.put("validFlag", "1");
		String bigTypeString = makeSelectElementString("bigTypeID", 
				DBProxy.query(getConnection(), "bigType", key, " and bigTypeID != '9999'"), 
				"bigTypeID", "name", "doAction('selectQueryProductType2')");
		
		key.clear();
		key.put("bigTypeID", getFormData("bigTypeID"));
		key.put("validFlag", "1");
		String smallTypeString = makeSelectElementString("smallTypeID", 
				DBProxy.query(getConnection(), "smallType", key), 
				"smallTypeID", "name", "doAction('selectQueryProductType2')");
		
		if (smallTypeString.indexOf("selected") < 0) {
			setFormData("smallTypeID", "");
		}
		
		key.clear();
		key.put("smallTypeID", getFormData("smallTypeID"));
		key.put("validFlag", "1");
		String tinyTypeString = makeSelectElementString("tinyTypeID", 
				DBProxy.query(getConnection(), "tinyType", key), 
				"tinyTypeID", "name", "refreshItem('product', 'refreshprop', 'prop')");

		return bigTypeString + smallTypeString + tinyTypeString;
	}
	
	public String getQueryProductTypeSelect3Action() throws Exception {
		Hashtable<String, String> key = new Hashtable<String, String>();
		key.put("validFlag", "1");
		String bigTypeString = makeSelectElementString("q_bigTypeID2", 
				DBProxy.query(getConnection(), "bigType", key, " and bigTypeID != '9999'"), 
				"bigTypeID", "name", "doAction('selectQueryProductType3')");
		
		key.clear();
		key.put("bigTypeID", getFormData("q_bigTypeID2"));
		key.put("validFlag", "1");
		String smallTypeString = makeSelectElementString("q_smallTypeID2", 
				DBProxy.query(getConnection(), "smallType", key), 
				"smallTypeID", "name", "doAction('selectQueryProductType3')");
		
		if (smallTypeString.indexOf("selected") < 0) {
			setFormData("smallTypeID", "");
		}
		
		key.clear();
		key.put("smallTypeID", getFormData("q_smallTypeID2"));
		key.put("validFlag", "1");
		String tinyTypeString = makeSelectElementString("q_tinyTypeID2", 
				DBProxy.query(getConnection(), "tinyType", key), 
				"tinyTypeID", "name", "");

		return bigTypeString + smallTypeString + tinyTypeString;
	}
	
	public void initPageByQueryDataList(String queryDataListName, Hashtable<String, String> condition, 
			String jspDataName)  throws Exception {
		int pageIndex = 1;
		try {
			pageIndex = Integer.parseInt(getFormData("pageIndex"));
			if (pageIndex < 1) {
				pageIndex = 1;
			}
		} catch (Exception e) {
			pageIndex = 1;
		}
		
		int count = getDataListCount(queryDataListName, condition);
		int pageNumber = getPageNumber(queryDataListName);
		int pageCount = count / pageNumber + (count % pageNumber > 0 ? 1 : 0);
		
		if (pageIndex > pageCount && pageCount > 0) {
			pageIndex = pageCount;
		}
		setFormData("pageIndex", String.valueOf(pageIndex));
		
		Vector<Hashtable<String, String>> datas = getDataListDatas(queryDataListName, condition);
		if (count > 0 && datas.size() == 0 && pageIndex > 1) {
			pageIndex = pageIndex - 1;
			setFormData("pageIndex", String.valueOf(pageIndex));
			datas = getDataListDatas(queryDataListName, condition);
		}
		
		setJSPData(jspDataName, datas);
		setJumpPageInfo(count, pageNumber);
	}
	
	public String makeQueryConditionHtml(String queryDataListName) throws Exception {
		QueryDataList queryDataList = AppConfig.getInstance().getQueryDataListConfig().getQueryDataList(queryDataListName);
		Vector<QueryCondition> conditionList = queryDataList.getListConditions();
		
		String queryConditionHtml = "";
		StringBuffer sb = new StringBuffer();
		for (int i = 0; i < conditionList.size(); ++i) {
			String expressionName = conditionList.get(i).getExpression();
			expressionName = expressionName.substring(expressionName.indexOf("$") + 1, 
					expressionName.lastIndexOf("$"));
			sb.append("<input type=\"hidden\" name=\"" + expressionName + "\" id=\"" 
					+ expressionName + "\" value=\"" + getFormData(expressionName) + "\" />");
		}
		queryConditionHtml = sb.toString();
		return queryConditionHtml;
	}
	
	public void clearQueryCondition(String queryDataListName) throws Exception {
		QueryDataList queryDataList = AppConfig.getInstance().getQueryDataListConfig().getQueryDataList(queryDataListName);
		Vector<QueryCondition> conditionList = queryDataList.getListConditions();
		String[] items = new String[conditionList.size()];
		for (int i = 0; i < conditionList.size(); ++i) {
			String expressionName = conditionList.get(i).getExpression();
			expressionName = expressionName.substring(expressionName.indexOf("$") + 1, 
					expressionName.lastIndexOf("$"));
			items[i] = expressionName;
		}	
		clearDatas(items);
	}
	
	
	
	public String getBrandSelect() throws Exception {
		Hashtable<String, String> key = new Hashtable<String, String>();
		key.put("validFlag", "1");
		Vector<Hashtable<String, String>> datas = DBProxy.query(getConnection(), "brand", key);
		
		String brandString = makeSelectElementString("brandID", datas, "brandID", "name", "");
		return brandString;
	}
	
	public String getSupplierSelect() throws Exception {
		Hashtable<String, String> key = new Hashtable<String, String>();
		key.put("validFlag", "1");
		Vector<Hashtable<String, String>> datas = DBProxy.query(getConnection(), "supplier", key);
		
		String brandString = makeSelectElementString("supplierID", datas, "supplierID", "name", "");
		return brandString;
	}
	
	public String getQueryBrandSelect() throws Exception {
		Hashtable<String, String> key = new Hashtable<String, String>();
		key.put("validFlag", "1");
		Vector<Hashtable<String, String>> brandDatas = DBProxy.query(getConnection(), "brand", key);
		
		String brandString = makeSelectElementString("q_brandID", brandDatas, "brandID", "name", "");
		return brandString;
	}
	
	public String getQueryBrandSelect2() throws Exception {
		Hashtable<String, String> key = new Hashtable<String, String>();
		key.put("validFlag", "1");

		Vector<Hashtable<String, String>> brandDatas = DBProxy.query(getConnection(), "brand", key);
		
		String brandString = makeSelectElementString("q_brandID2", brandDatas, "brandID", "name", "");
		return brandString;
	}
	
	public String getEmailInfo(String templateFile) throws Exception {
		String path = AppConfig.getInstance().getApplicationRoot()
				+ "templates" + File.separator + templateFile;
		SimpleFileReader reader = new SimpleFileReader(path);
		reader.setEncoding("utf-8");
		return reader.getContent();
	}	
	
	public void writeExcel(String filePath, boolean isLandscapePageSetup, String headTitle, String[] titles,
			String[] fieldNames, int[] columnWidths, WritableCellFormat[] cellFormats,
			Vector<Hashtable<String, String>> datas, String mergeID,
			int[] mergeColumns) throws Exception {
		OutputStream os = null;
		try {
			if (mergeID != null) {
				for (int i = 0; i < datas.size(); i++) {
					Hashtable<String, String> data = datas.get(i);
					for (int j = i + 1; j < datas.size(); j++) {
						Hashtable<String, String> data2 = datas.get(j);
						if (data2.get(mergeID).equals(data.get(mergeID))) {
							data2.put(mergeID, "");
							for (int m = 0; m < mergeColumns.length; m++) {
								data2.put(fieldNames[mergeColumns[m]], "");
							}
						} else {
							i = j - 1;
							break;
						}
						if (j == datas.size() - 1) {
							i = datas.size() - 1;
						}
					}
				}
			}

			os = new FileOutputStream(filePath);
			WritableWorkbook wwb = Workbook.createWorkbook(os);

			WritableSheet ws = wwb.createSheet(headTitle, 0);
//			if (isLandscapePageSetup) {
//				ws.setPageSetup(PageOrientation.LANDSCAPE);
//			}
			// 设置页边距 (注意默认单位是英寸 1d = 2.54cm)  
			ws.getSettings().setTopMargin(0.7 / 2.54d);
			ws.getSettings().setBottomMargin(1.3 / 2.54d);
			ws.getSettings().setLeftMargin(0.7 / 2.54d);
			ws.getSettings().setRightMargin(0.7 / 2.54d);
			// 页眉边距  
			ws.getSettings().setHeaderMargin(0.7 / 2.54d);
//			// 页脚边距  
			ws.getSettings().setFooterMargin(0.7 / 2.54d);
//			ws.getSettings().setFooter(
//					new HeaderFooter(headTitle + " 第 &P 页，共 &N 页"));

			// 标题
			WritableFont wf = new WritableFont(WritableFont.TIMES, 20,
					WritableFont.BOLD, false);
			WritableCellFormat headFormat = new WritableCellFormat(wf);
			headFormat.setAlignment(jxl.format.Alignment.CENTRE);
			headFormat.setVerticalAlignment(VerticalAlignment.CENTRE);

			// 表头
			WritableCellFormat titleFormat = new WritableCellFormat();
			titleFormat.setBorder(Border.ALL, jxl.format.BorderLineStyle.THIN); // 设置 border 格式
			titleFormat.setAlignment(jxl.format.Alignment.CENTRE);
			titleFormat.setBackground(Colour.GRAY_25);
			titleFormat.setVerticalAlignment(VerticalAlignment.CENTRE);

			Label label = new Label(0, 0, headTitle, headFormat);
			ws.addCell(label);
			ws.mergeCells(0, 0, fieldNames.length - 1, 0);
			ws.setRowView(0, 800);

			for (int i = 0; i < titles.length; i++) {
				Label labelCF = new Label(i, 1, titles[i], titleFormat);
				ws.addCell(labelCF);
				ws.setColumnView(i, columnWidths[i]);
			}

			for (int i = 0; i < datas.size(); i++) {
				Hashtable<String, String> rowData = datas.get(i);
				rowData.put("null", "");
				for (int j = 0; j < fieldNames.length; j++) {
					Label labelCF = new Label(j, i + 2, rowData
							.get(fieldNames[j]), cellFormats[j]);
					ws.addCell(labelCF);
				}
			}

			if (mergeID != null) {
				for (int i = 0; i < datas.size(); i++) {
					if (!datas.get(i).get(mergeID).equals("")) {
						int startIndex = i;
						int endIndex = datas.size();
						for (int j = i + 1; j < datas.size(); j++) {
							if (!datas.get(j).get(mergeID).equals("")) {
								endIndex = j;
								break;
							}
						}
						for (int m = 0; m < mergeColumns.length; m++) {
							if (startIndex + 2 != endIndex + 2 - 1) {
								ws.mergeCells(mergeColumns[m], startIndex + 2,
										mergeColumns[m], endIndex + 2 - 1);
							}
						}
					}
				}
			}

			wwb.write();
			wwb.close();
		} catch (Exception e) {
			throw e;
		} finally {
			try {
				if (os != null) {
					os.close();
				}
			} catch (Exception e) {
			}
		}
	}
	
	public Vector<Hashtable<String, String>> getXiaoShouDaiBiaos(String validFlag) throws Exception {
		Vector<String> values = new Vector<String>();
		String sql = "select * from systemUser_V where priority like ?";
		if (validFlag.equals("1")) {
			sql += " and validFlag = '1'";
		} else if (validFlag.equals("0")) {
			sql += " and validFlag = '0'";
		}
		values.add("%xiaoShouDaiBiao%");
		
		return DBProxy.query(getConnection(), "systemUser_V", sql, values);
	}
	
	public boolean containUnit(Vector<Hashtable<String, String>> reportDatas, String unit) {
		for (int i = 0; i < reportDatas.size(); ++i) {
			if (reportDatas.get(i).get("unit").equals(unit)) {
				return true;
			}
		}
		return false;
	}
	
	public int getDataListCountByExtendSql(String queryDataListName, 
			Hashtable<String, String> condition, String extendSql, Vector<String> extendValues) throws Exception {
		QueryDataList querydatalist = AppConfig.getInstance().getQueryDataListConfig().getQueryDataList(queryDataListName);
		
		Vector<String> keyValueSelect = new Vector<String>();
		String sqlSelect = querydatalist.getPreparedCountSql(condition, keyValueSelect);
		
		if (!extendSql.equals("")) {
			sqlSelect += ((sqlSelect.indexOf("where") == -1 ? " where " : " and ") + extendSql);
			keyValueSelect.addAll(extendValues);
		}
		
		int count = Integer.parseInt(DBProxy.query(getConnection(), 
				"count_V", sqlSelect, keyValueSelect).get(0).get("COUNT"));
		
		return count;
	}		
	
	public Vector<Hashtable<String, String>> getDataListByExtendSql(String queryDataListName, 
			Hashtable<String, String> condition, String extendSql, Vector<String> extendValues, String sortSql) throws Exception {
		initPageIndex();
		int pageIndex = Integer.parseInt(getFormData("pageIndex"));
		QueryDataList querydatalist = AppConfig.getInstance().getQueryDataListConfig().getQueryDataList(queryDataListName);
		
		Vector<String> keyValueSelect = new Vector<String>();
		String sqlSelect = querydatalist.getPreparedSql(condition, keyValueSelect);
		
		if (!extendSql.equals("")) {
			sqlSelect += ((sqlSelect.indexOf("where") == -1 ? " where " : " and ") + extendSql);
			keyValueSelect.addAll(extendValues);
		}
		
		if (!sortSql.equals("")) {
			sqlSelect += (" " + sortSql);
		}
		
		Vector<Hashtable<String, String>> datas = DBProxy.query(getConnection(), 
				queryDataListName, sqlSelect, keyValueSelect, (pageIndex - 1), querydatalist.getPageNumber());
		
		return datas;
	}
	
	public boolean checkPayFlag(Hashtable<String, String> shopOrder) throws Exception {
		if (Double.parseDouble(shopOrder.get("needPayMoney")) <= 0) {
			return true;
		}
		
		String orderStatus = shopOrder.get("status");
		String payTypeID = shopOrder.get("payTypeID");
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

	public String getProductDefaultCode(String productID, 
			String specificationID) throws Exception {
		String code = productID + specificationID;
		return code;
	}
	
	public void initPageByQueryDataList(String queryDataListName, Hashtable<String, String> condition, 
			String jspDataName, String extendSql, Vector<String> extendValues, String sortSql)  throws Exception {
		int pageIndex = 1;
		try {
			pageIndex = Integer.parseInt(getFormData("pageIndex"));
			if (pageIndex < 1) {
				pageIndex = 1;
			}
		} catch (Exception e) {
			pageIndex = 1;
		}
		
		int count = getDataListCountByExtendSql(queryDataListName, condition, extendSql, extendValues);
		int pageNumber = getPageNumber(queryDataListName);
		int pageCount = count / pageNumber + (count % pageNumber > 0 ? 1 : 0);
		
		if (pageIndex > pageCount && pageCount > 0) {
			pageIndex = pageCount;
		}
		setFormData("pageIndex", String.valueOf(pageIndex));
		
		Vector<Hashtable<String, String>> datas = getDataListByExtendSql(queryDataListName, condition, extendSql, extendValues, sortSql);
		if (count > 0 && datas.size() == 0 && pageIndex > 1) {
			pageIndex = pageIndex - 1;
			setFormData("pageIndex", String.valueOf(pageIndex));
			datas = getDataListDatas(queryDataListName, condition);
		}
		
		setJSPData(jspDataName, datas);
		setJumpPageInfo(count, pageNumber);
	}
	
	public String getCitySelect() throws Exception {
		Hashtable<String, String> key = new Hashtable<String, String>();
		String province = makeSelectElementString("provinceID", DBProxy.query(getConnection(), "province"), "provinceID", "name", "doAction('selectCity')");
		key.put("provinceID", getFormData("provinceID"));
		String city = makeSelectElementString("cityID", DBProxy.query(getConnection(), "city", key), "cityID", "name", "doAction('selectCity')");
		key.clear();
		key.put("cityID", getFormData("cityID"));
		String town = makeSelectElementString("townID", DBProxy.query(getConnection(), "town", key), "townID", "name", "doAction('selectCity')");
		return  province + " " + city + " " + town;
	}
	
	public String getSmptHostSelect() throws Exception {
		String smtpHostListStr = makeSelectElementString("mailServer.smtpHost", LocalDataCache.getInstance().getTableDatas("c_smtpHost"), "c_smtpHostID", "c_smtpHostName", "");
		return smtpHostListStr;
	}
	
	public String getQueryCitySelect() throws Exception {
		Hashtable<String, String> key = new Hashtable<String, String>();
		String province = makeSelectElementString("q_provinceID", DBProxy.query(getConnection(), "province"), "provinceID", "name", "doAction('selectQueryCity')");
		key.put("provinceID", getFormData("q_provinceID"));
		String city = makeSelectElementString("q_cityID", DBProxy.query(getConnection(), "city", key), "cityID", "name", "doAction('selectQueryCity')");
		key.clear();
		key.put("cityID", getFormData("q_cityID"));
		String town = makeSelectElementString("q_townID", DBProxy.query(getConnection(), "town", key), "townID", "name", "");
		return "省：" + province + " 市：" + city + " 区：" + town;
	}
	
	
	public void searchAction() throws Exception {
		setFormData("pageIndex", "1");
		listAction();
	}
	
	public boolean isIcoFile(File f) {
		String fileName = f.getName().toLowerCase();
		if (!fileName.endsWith("ico")) {
			f.delete();
			return false;
		}
		return true;
	}
	
	public String makeSelectElementString(String selectID, Vector<Hashtable<String, String>> sourceDatas, 
			String optionValue, String optionText, String onchangeEvent, String cssName, boolean allowEmptyOption,
			String fillEmptyText, String validFlag) throws Exception {
		StringBuffer stringbuffer = new StringBuffer();
		stringbuffer.append((new StringBuilder("<select id='")).append(selectID).
				append("' name='").append(selectID).append("'").append(" class='").append(cssName).append("'")
				.append(onchangeEvent.equals("") ? "" : (new StringBuilder(" onchange=javascript:"))
						.append(onchangeEvent).toString()).append(">").toString());
		
		if (allowEmptyOption) {
			stringbuffer.append("<option value=''>");
			stringbuffer.append(fillEmptyText);
			stringbuffer.append("</option>");
		}
		for (int i = 0; i < sourceDatas.size(); i++) {
			Hashtable<String,String> hashtable = sourceDatas.get(i);
			if (validFlag.equals("1")) {
				if (hashtable.get("validFlag") == null || hashtable.get("validFlag").equals("1")) {
					stringbuffer.append((new StringBuilder("<option value='")).append(hashtable.get(optionValue))
							.append("'").append((hashtable.get(optionValue)).equals(getFormData(selectID)) ? " selected" : "")
							.append(">").append(hashtable.get(optionText)).append("</option>").toString());
				}
			} else if (validFlag.equals("0")) {
				if (hashtable.get("validFlag") == null || hashtable.get("validFlag").equals("0")) {
					stringbuffer.append((new StringBuilder("<option value='")).append(hashtable.get(optionValue))
							.append("'").append((hashtable.get(optionValue)).equals(getFormData(selectID)) ? " selected" : "")
							.append(">").append(hashtable.get(optionText)).append("</option>").toString());
				}
			} else {
				stringbuffer.append((new StringBuilder("<option value='")).append(hashtable.get(optionValue))
						.append("'").append((hashtable.get(optionValue)).equals(getFormData(selectID)) ? " selected" : "")
						.append(">").append(hashtable.get(optionText)).append("</option>").toString());
			}
		}
	
		stringbuffer.append("</select>");
		return stringbuffer.toString();
	}
	
	// 按条件分页显示数据信息并将数据设置到jsp
		public void initPageByQueryDataList2(String queryDataListName, Hashtable<String, String> condition, 
				String jspDataName, String extendSql, Vector<String> extendValues, String sortSql)  throws Exception {
			String pageIndex2 = getFormData("pageIndex");
			int pageIndex = 1;
			try {
				pageIndex = Integer.parseInt(getFormData("pageIndex2"));
				if (pageIndex < 1) {
					pageIndex = 1;
				}
			} catch (Exception e) {
				pageIndex = 1;
			}
			
			int count = getDataListCountByExtendSql(queryDataListName, condition, extendSql, extendValues);
			int pageNumber = getPageNumber(queryDataListName);
			int pageCount = count / pageNumber + (count % pageNumber > 0 ? 1 : 0);
			
			if (pageIndex > pageCount && pageCount > 0) {
				pageIndex = pageCount;
			}
			setFormData("pageIndex", String.valueOf(pageIndex));
			Vector<Hashtable<String, String>> datas = getDataListByExtendSql(queryDataListName, condition, extendSql, extendValues, sortSql);
			
			setFormData("pageIndex", pageIndex2);
			setFormData("pageIndex2", pageIndex + "");
			
			setJSPData(jspDataName, datas);
			setJumpPageInfo2(count, pageNumber);
		}
	
	// 设置第二级分页信息
	public void setJumpPageInfo2(int paramInt1, int paramInt2) {
	    int i = paramInt1 / paramInt2 + ((paramInt1 % paramInt2 > 0) ? 1 : 0);
	    int j = Integer.parseInt(getFormData("pageIndex2"));
	    int k = 1;
	    int l = 5;
	    if (i > 5)
	    {
	      if (i - j <= 2)
	        k = i - 4;
	      else if (j <= 2)
	        k = 1;
	      else
	        k = j - 2;
	      l = k + 4;
	    }
	    else
	    {
	      l = i;
	    }
	    setFormData("count2", paramInt1 + "");
	    setFormData("pageCount2", i + "");
	    setFormData("pageNumber2", paramInt2 +"");
	    setFormData("pageFrom2", k + "");
	    setFormData("pageTo2", l + "");
	 }
	
	public void uploadImageWindowAction() throws Exception {
	}
		
	public void uploadImageAction() throws Exception {
		if (getUploadFiles().size() == 0 
				|| !isImageFile(getUploadFiles().get(0))) {
			setAjaxJavascript("clearFiles();alert('图片上传失败');");
    		return;
		}
	
		String fileName = getUploadFiles().get(0).getName();
		String uploadDir = getFormData("uploadDir");
		String uploadItemType = getFormData("uploadItemType");
		String dir = AppKeys.UPLOAD_FILE_PATH + File.separator +  uploadDir
			+ File.separator;
		if (!new File(dir).exists()) {
			new File(dir).mkdirs();
		}
		FileUtil.moveFile(getUploadFiles().get(0), dir);
		
		if (uploadDir.equals("product") && !uploadItemType.equals("sku")) {
			resizeProductPicture(dir, new File(dir + fileName));
		} else if (uploadDir.equals("product") && uploadItemType.equals("sku")) {
		}
		
		fileName = uploadDir + "/" + fileName;
		String src = AppUtil.getImageURL(dir, fileName, 0);
		setAjaxJavascript("$('#confirmBut').css('display', '');"
				+ "$('#hasNotSend_img').css('display', 'none');" +
				"$('#previewImg_window').attr('src', '" + src + "');" +
				"clearFiles();$('#tmpImage_window').val('" + fileName + "');");
	}
	

	public void updateSortIndex() throws Exception {
		String table = getFormData("table");
		String id = getFormData(table + "ID");
		CheckList list = getChecklist();
		list.addCheckItem(new IntegerCheckItem("sortIndex_" + id, "排序值", false));
		if (!list.check()) {
			setErrorMessageAndFocusItem();
			return;
		}
		
		updateTableDataSortIndex();
		setAjaxJavascript("alert('更新成功')");
	}
	
	public void updateSortIndexAll() throws Exception {
		String table = getFormData("table");
		String sortIndexColumnName = "sortIndex";
		if (!getFormData("sortIndexColumnName").equals("")) {
			sortIndexColumnName = getFormData("sortIndexColumnName");
		}
		
		Hashtable<String, String> formDatas = getFormDatas();
		Iterator<String> iter = formDatas.keySet().iterator();
		while (iter.hasNext()) {
			String key = iter.next();
			if (key.startsWith("sortIndex_")) {
				String id = StringUtil.split(key, "_")[1];
				String sortIndex = getFormData("sortIndex_" + id);
				boolean isIndex = isNumeric(sortIndex);
				if (isIndex) {
					setAjaxJavascript("alert('请输入00000-99999之间的数字哦!')");
				} else {						
				if (IntegerCheckItem.isInteger(sortIndex)) {
					Hashtable<String, String> k = new Hashtable<String, String>();
					k.put(table + "ID", id);
					Hashtable<String, String> v = new Hashtable<String, String>();
					v.put(sortIndexColumnName, sortIndex);
					DBProxy.update(getConnection(), table, k, v);
				}
				}
			}
		}
		
		setAjaxJavascript("alert('更新成功')");
	}
	
	private void updateTableDataSortIndex() throws Exception {
		String table = getFormData("table");
		String id = getFormData(table + "ID");
	    String sortIndex = getFormData("sortIndex_" + id);
		
		Hashtable<String, String> k = new Hashtable<String, String>();
		k.put(table + "ID", id);
		Hashtable<String, String> v = new Hashtable<String, String>();
		v.put("sortIndex", sortIndex);
		DBProxy.update(getConnection(), table, k, v);
	}
	
	public void selectQueryProductType2() throws Exception {
		setAjaxJavascript("document.getElementById('queryProductTypeSelect2').innerHTML= \""
				+ getQueryProductTypeSelect2() + "\"");
	}
	
	public void selectQueryProductType2Action() throws Exception {
		setAjaxJavascript("document.getElementById('queryProductTypeSelect2').innerHTML= \""
				+ getQueryProductTypeSelect2() + "\"");
	}
	
	public void selectQueryProductType3Action() throws Exception {
		setAjaxJavascript("document.getElementById('queryProductTypeSelect3').innerHTML= \""
				+ getQueryProductTypeSelect3Action() + "\"");
	}
	
	public void selectProductType2() throws Exception {
		setAjaxJavascript("document.getElementById('productTypeSelect').innerHTML= \""
				+ getProductTypeSelect2() + "\"");
	}
	
	public void selectCity() throws Exception {
		Hashtable<String, String> key = new Hashtable<String, String>();
		String province = makeSelectElementString("provinceID", DBProxy.query(getConnection(), "province"), "provinceID", "name", "doAction('selectCity')");
		key.put("provinceID", getFormData("provinceID"));
		String city = makeSelectElementString("cityID", DBProxy.query(getConnection(), "city", key), "cityID", "name", "doAction('selectCity')");
		key.clear();
		key.put("cityID", getFormData("cityID"));
		String town = makeSelectElementString("townID", DBProxy.query(getConnection(), "town", key), "townID", "name", "doAction('selectCity')");
		String selectStr = province + " " + city + " " + town;
		setAjaxJavascript("$('#townSelectTd').html(\"" + selectStr + "\");");
	}
	
	public void updateSortIndexAction() throws Exception {
		String table = getFormData("table");
		String id = getFormData(table + "ID");
		CheckList list = getChecklist();
		list.addCheckItem(new IntegerCheckItem("sortIndex_" + id, "排序值", true));
		if (!list.check()) {
			setErrorMessageAndFocusItem();
			return;
		}
		
		updateTableDataSortIndex();
		setAjaxJavascript("alert('更新成功')");
	}
	
	public void updateSortIndexAllAction() throws Exception {
		String table = getFormData("table");
		String sortIndexColumnName = "sortIndex";
		if (!getFormData("sortIndexColumnName").equals("")) {
			sortIndexColumnName = getFormData("sortIndexColumnName");
		}
		
		Hashtable<String, String> formDatas = getFormDatas();
		Iterator<String> iter = formDatas.keySet().iterator();
		while (iter.hasNext()) {
			String key = iter.next();
			if (key.startsWith("sortIndex_")) {
				String id = StringUtil.split(key, "_")[1];
				String sortIndex = getFormData("sortIndex_" + id);
				boolean isIndex = isNumeric(sortIndex);
				if (!isIndex) {
					setAjaxJavascript("alert('请输入00000-99999之间的数字哦!')");
					return ;
				} else {				
				if (IntegerCheckItem.isInteger(sortIndex)) {
					Hashtable<String, String> k = new Hashtable<String, String>();
					k.put(table + "ID", id);
					Hashtable<String, String> v = new Hashtable<String, String>();
					v.put(sortIndexColumnName, sortIndex);
					DBProxy.update(getConnection(), table, k, v);
				}
				}
			}
		}
		
		setAjaxJavascript("alert('更新成功')");
	}
	
	//校验获取的字符串是否是数字
	public boolean isNumeric(String str){ 
			Pattern pattern = Pattern.compile("[0-9]*");
			Matcher isNum = pattern.matcher(str);
		   if( !isNum.matches() ){
		       return false; 
		   } 
		   return true; 
		}
	
	public void selectProductType() throws Exception {
		setAjaxJavascript("document.getElementById('productTypeSelect').innerHTML= \""
				+ getProductTypeSelect() + "\"");
	}
	
	public void selectProductTypeAction() throws Exception {
		setAjaxJavascript("document.getElementById('productTypeSelect').innerHTML= \""
				+ getProductTypeSelect() + "\"");
	}
	
	public void selectQueryProductType() throws Exception {
		setAjaxJavascript("document.getElementById('queryProductTypeSelect').innerHTML= \""
				+ getQueryProductTypeSelect() + "\"");
	}
	
	public void selectQueryProductTypeAction() throws Exception {
		setAjaxJavascript("document.getElementById('queryProductTypeSelect').innerHTML= \""
				+ getQueryProductTypeSelect() + "\"");
	}
	
	
	protected void setAjaxInfoMessage(String message) {
		setFormData(AppKeys.AJAX_RESULT, "alert('" + message + "');");
	}

	protected void setAjaxDispatch(String link) {
		setFormData(AppKeys.AJAX_RESULT, "dispatch('" + link + "')");
	}

	protected void setErrorMessageAndFocusItem() {
		setErrorMessageAndFocusItem(getControlDatas().get(
				FrameKeys.ERROR_MESSAGE), getControlDatas().get(
				FrameKeys.FOCUS_ITEM));
	}

	protected void setErrorMessageAndFocusItem(String message, String focusItem) {
		setFormData(AppKeys.AJAX_RESULT, "alert('" + message
				+ "');document.getElementById('" + focusItem + "').focus();");
	}

	protected void setErrorMessage() {
		setFormData(AppKeys.AJAX_RESULT, "alert('" + getControlDatas().get(
				FrameKeys.ERROR_MESSAGE)
				+ "');");		
	}		
	
	protected void setAjaxJavascript(String script) {
		setFormData(AppKeys.AJAX_RESULT, script);
	}
	
	protected void setAjaxJavascriptInWindow(String script) {
		setFormData(AppKeys.AJAX_RESULT, script);
		setFormData("ajaxAction", "javascript");
	}
	
	public boolean isExistsEmail(String oldEmail, String newEmail) throws Exception {
		if (oldEmail.equals(newEmail)) {
			return false;
		}
		String sql = "select * from user where email = ? and deletedFlag = 0";
		Vector<String> values = new Vector<String>();
		values.add(newEmail);
		
		Vector<Hashtable<String, String>> datas = 
			DBProxy.query(getConnection(), "user", sql, values);
		
		if (datas.size() > 0) {
			return true;
		}
		
		return false;
	}
	
	public boolean isExistsMobile(String oldMobile, String newMobile) throws Exception {
		if (oldMobile.equals(newMobile)) {
			return false;
		}
		String sql = "select * from user where mobile = ? and deletedFlag = 0";
		Vector<String> values = new Vector<String>();
		values.add(newMobile);
		
		Vector<Hashtable<String, String>> datas = 
			DBProxy.query(getConnection(), "user", sql, values);
		
		if (datas.size() > 0) {
			return true;
		}
		
		return false;
	}
	
	protected void setReDispath() {
		setFormData("reDispatch", "1");
	}
	
	public String insertDefaultSku(String productID, String productCode, String stock, String price, 
			String settlementPrice) throws Exception {
		Hashtable<String, String> k = new Hashtable<String, String>();
		k.put("productID", productID);
		k.put("defaultFlag", "1");
		Vector<Hashtable<String, String>> skus = DBProxy.query(getConnection(), "sku", k);
		
		if (skus.size() == 0) {
			Hashtable<String, String> data = new Hashtable<String, String>();
			String newSkuID = IndexGenerater.getTableIndex("sku", getConnection());
			data.put("skuID", newSkuID);
			data.put("productID", productID);
			data.put("props", "");
			data.put("stock", stock.equals("") ? "0" : stock);
			data.put("barCode", productCode);
			data.put("price", price);
			data.put("settlementPrice", settlementPrice.equals("") ? price : settlementPrice);
			data.put("validFlag", "1");
			data.put("defaultFlag", "1");
			DBProxy.insert(getConnection(), "sku", data);
			
			return newSkuID;
		} else {
			Hashtable<String, String> skuV = new Hashtable<String, String>();
			skuV.put("price", price);
			skuV.put("settlementPrice", settlementPrice);
			skuV.put("barCode", productCode);
			DBProxy.update(getConnection(), "sku", k, skuV);
			
			return skus.get(0).get("skuID");
		}
	}
	
	public static void updateProductMainImage(Connection con, String productID) throws Exception {
		Hashtable<String, String> key = new Hashtable<String, String>();
		key.put("productID", productID);
		key.put("mainFlag", "1");
		
		Vector<Hashtable<String, String>> datas = DBProxy.query(con, "productImage", key);
		key.remove("mainFlag");
		Hashtable<String, String> value = new Hashtable<String, String>();
		if (datas.size() == 0) {
			value.put("mainImage", "");
		} else {
			value.put("mainImage", datas.get(0).get("image"));
		}
		
		DBProxy.update(con, "product", key, value);
	}
	
	public static void resizeProductPicture(String imageDir, File imgFile) throws Exception {
		String srcImage = imageDir + imgFile.getName();
		
		String destImage1 = imageDir + AppKeys.IMAGE_SIZE_LARGE + "_" + imgFile.getName();
		String destImage2 = imageDir + AppKeys.IMAGE_SIZE_MIDDEN + "_" + imgFile.getName();
		String destImage3 = imageDir + AppKeys.IMAGE_SIZE_SMALL + "_" + imgFile.getName();
		String listImage = imageDir + AppKeys.IMAGE_SIZE_LIST + "_" + imgFile.getName();
		
		if (!(new File((destImage1)).exists())) {
			PictureUtil.resizePicture(srcImage, destImage1, AppKeys.IMAGE_SIZE_LARGE);
			PictureUtil.makeImageToSquare(destImage1);
		}
		if (!(new File((destImage2)).exists())) {
			PictureUtil.resizePicture(destImage1, destImage2, AppKeys.IMAGE_SIZE_MIDDEN);
		}
		if (!(new File((destImage3)).exists())) {
			PictureUtil.resizePicture(destImage2, destImage3, AppKeys.IMAGE_SIZE_SMALL);
		}
		if (!(new File((listImage)).exists())) {
			PictureUtil.resizeMaxSizePicture(srcImage, listImage, AppKeys.IMAGE_SIZE_LIST);
		}
	}
	
	public static int getCountValue(Connection con, String tableOrViewName, String countColumn, 
			Hashtable<String, String> condition) throws Exception {
		String prepareSql = "select count(" + countColumn + ") as COUNT from " + tableOrViewName;
		
		Iterator<String> iter = condition.keySet().iterator();
		String key;
		String value;
		Vector<String> values = new Vector<String>();
		while (iter.hasNext()) {
			key = iter.next();
			value = condition.get(key);
			prepareSql += (" and " + key + " = ?");
			values.add(value);
		}
		
		prepareSql = prepareSql.replaceFirst("and", "where");
		
		String count = DBProxy.query(con, "count_V", 
				prepareSql, values).get(0).get("COUNT");
		
		return count.equals("") ? 0 : Integer.parseInt(count);
	}
	
	public void selectProductWindowAction() throws Exception {
		setFormData("count", getFormData("windowCount"));
		setFormData("pageCount", getFormData("windowPageCount"));
		setFormData("pageNumber", getFormData("windowPageNumber"));
		setFormData("pageFrom", getFormData("windowPageFrom"));
		setFormData("pageTo", getFormData("windowPageTo"));
		setFormData("pageIndex", getFormData("windowPageIndex"));
		
		Hashtable<String, String> key = new Hashtable<String, String>();
		key.put("q_validFlag", "1");
		key.put("q_deletedFlag", "0");
		setFormData(key);
		
		initPageByQueryDataList("product_V", getFormDatas(), "productDatas");
		
		setFormData("windowCount", getFormData("count"));
		setFormData("windowPageCount", getFormData("pageCount"));
		setFormData("windowPageNumber", getFormData("pageNumber"));
		setFormData("windowPageFrom", getFormData("pageFrom"));
		setFormData("windowPageTo", getFormData("pageTo"));
		setFormData("windowPageIndex", getFormData("pageIndex"));
		
		setFormData("queryProductTypeSelect", getQueryProductTypeSelect());
		//setFormData("queryBrandSelect2", getBrandSelect());
	}
	
	public void selectProduct2WindowAction() throws Exception {
		setFormData("count", getFormData("windowCount"));
		setFormData("pageCount", getFormData("windowPageCount"));
		setFormData("pageNumber", getFormData("windowPageNumber"));
		setFormData("pageFrom", getFormData("windowPageFrom"));
		setFormData("pageTo", getFormData("windowPageTo"));
		setFormData("pageIndex", getFormData("windowPageIndex"));
		
		Hashtable<String, String> key = new Hashtable<String, String>();
		key.put("q_validFlag", "1");
		key.put("q_deletedFlag", "0");
		setFormData(key);
		
		initPageByQueryDataList("product_V", getFormDatas(), "productDatas");
		
		Vector<Hashtable<String, String>> productDatas = (Vector<Hashtable<String, String>>) getJSPData("productDatas");
		Vector<Hashtable<String, String>> jsonData = new Vector<Hashtable<String, String>>();
		for(int i = 0; i < productDatas.size(); i++) {
			Hashtable<String, String> product = productDatas.get(i);
			Hashtable<String, String> newProduct = new Hashtable<String, String>();
			newProduct.put("pID", product.get("productID"));
			newProduct.put("name", product.get("name"));
			jsonData.add(newProduct);
		}
		String json = JSON.toJSONString(jsonData);
		
		setFormData("json", json);
		
		setFormData("windowCount", getFormData("count"));
		setFormData("windowPageCount", getFormData("pageCount"));
		setFormData("windowPageNumber", getFormData("pageNumber"));
		setFormData("windowPageFrom", getFormData("pageFrom"));
		setFormData("windowPageTo", getFormData("pageTo"));
		setFormData("windowPageIndex", getFormData("pageIndex"));
		
		setFormData("queryProductTypeSelect", getQueryProductTypeSelect());
		//setFormData("queryBrandSelect2", getBrandSelect());
	}
	
	public Vector<Hashtable<String, String>> getDatas(String tableOrView) throws Exception {
		Hashtable<String, String> key = new Hashtable<String, String>();
		return DBProxy.query(getConnection(), tableOrView, key);
	}
	
	public void resetProductPrice(String productID) throws Exception {
		String sql = "select min(price) as COUNT from sku where productID = ? and price > 0";
		Vector<String> p = new Vector<String>();
		p.add(productID);
		Vector<Hashtable<String, String>> datas = DBProxy.query(getConnection(), "count_V", sql, p);
		if (datas.size() > 0) {
			String minPrice = datas.get(0).get("COUNT");
			if (minPrice.equals("")) {
				return;
			}
			Hashtable<String, String> productK = new Hashtable<String, String>();
			productK.put("productID", productID);
			Hashtable<String, String> productV = new Hashtable<String, String>();
			productV.put("price", minPrice);
			DBProxy.update(getConnection(), "product", productK, productV);
		}
	}
	
	public void resizeSkuPicture(String imageDir, File imgFile) throws Exception {
		String srcImage = imageDir + imgFile.getName();
		
		String destImage1 = imageDir + AppKeys.SKU_IMAGE_SIZE_SMALL + "_" + imgFile.getName();
		
		if (!(new File((destImage1)).exists())) {
			PictureUtil.resizePicture(srcImage, destImage1, AppKeys.SKU_IMAGE_SIZE_SMALL);
		}
	}
	
	public String getQueryPayTypeSelect() throws Exception {
		String str = makeSelectElementString("q_payTypeID", LocalDataCache.getInstance().getTableDatas("payType"), "payTypeID", "name", "");
		return str;
	}
	
	public String getQueryTransactionStatusSelect() throws Exception {
		String str = makeSelectElementString("q_status", LocalDataCache.getInstance().getTableDatas("c_transactionStatus"), "c_transactionStatusID", "c_transactionStatusName", "");
		return str;
	}
	
	public String getQueryTransactionTypeSelect() throws Exception {
		String str = makeSelectElementString("q_transactionTypeID", LocalDataCache.getInstance().getTableDatas("c_transactionType"), "c_transactionTypeID", "c_transactionTypeName", "");
		return str;
	}
	
//	全局方法
	public static String insertCard(Connection con, String cardTypeID, String title, String money, 
			String minBuyPrice, String deadDate, 
			String userID, String source, String relateID) throws Exception {
		Hashtable<String, String> kv = new Hashtable<String, String>();
		kv.put("cardID", IndexGenerater.getTableIndex("card", con));
		kv.put("title", title);
		String code = getCardCode(kv.get("cardID"));
		kv.put("code", code);
		kv.put("money", money);
		kv.put("minBuyPrice", minBuyPrice);
		kv.put("addTime", DateTimeUtil.getCurrentDateTime());
		kv.put("deadDate", deadDate);
		kv.put("userID", userID);
		kv.put("usedFlag", "0");
		kv.put("source", source);
		kv.put("relateID", relateID);
		kv.put("cardTypeID", cardTypeID);
		DBProxy.insert(con, "card", kv);
		
		updateUserShoppingInfo(con, userID, 0, 0, 0, "", 1, 0, kv.get("addTime"));
		
		return code;
	}
	
//	全局方法
	public static void updateUserShoppingInfo(Connection con, String userID, 
			int orderCount, int payOrderCount, double consumeAmount, String lastShoppingTime,
			int moneyCardCount, int consumeCardCount, String lastGetCardTime) throws Exception {
		String sql = "update user ";
		
		String setSql = "";
		Vector<String> p = new Vector<String>();
		if (orderCount > 0) {
			setSql += ", orderCount = orderCount + ?";
			p.add(orderCount + "");
		}
		if (payOrderCount > 0) {
			setSql += ", payOrderCount = payOrderCount + ?";
			p.add(payOrderCount + "");
		}
		if (consumeAmount > 0) {
			setSql += ", consumeAmount = consumeAmount + ?";
			p.add(consumeAmount + "");
		}
		if (lastShoppingTime != null && !lastShoppingTime.equals("")) {
			setSql += ", lastShoppingTime = ?";
			p.add(lastShoppingTime);
		}
		if (moneyCardCount > 0) {
			setSql += ", moneyCardCount = moneyCardCount + ?";
			p.add(moneyCardCount + "");
		}
		if (consumeCardCount > 0) {
			setSql += ", consumeCardCount = consumeCardCount + ?";
			p.add(consumeCardCount + "");
		}
		if (lastGetCardTime != null && !lastGetCardTime.equals("")) {
			setSql += ", lastGetCardTime = ?";
			p.add(lastGetCardTime);
		}
		if (setSql.equals("")) {
			return;
		}
		sql = sql + setSql.replaceFirst(",", "set") + " where  userID = ? ";
		p.add(userID);
		DBProxy.update(con, "user", sql, p);
	}
	
	public static String getCardCode(String cardID) {
		return cardID + RandomCodeGenerator.generateCodeString(6);
	}
	
	public String getQueryInfoTypeSelect() throws Exception {
		return makeSelectElementString("q_infoTypeID", LocalDataCache.getInstance().getTableDatas("infoType"), 
				"infoTypeID", "name", "", "form-control", true, "", "1");
	}
	
	public String getQueryInfoAuditTypeSelect() throws Exception {
		return makeSelectElementString("q_auditStatus", LocalDataCache.getInstance().getTableDatas("c_infoAuditType"), 
				"c_infoAuditTypeID", "c_infoAuditTypeName", "", "form-control", true, "", "1");
	}
	
	public String getInfoTypeSelect() throws Exception {
		return makeSelectElementString("infoTypeID", LocalDataCache.getInstance().getTableDatas("infoType"), 
				"infoTypeID", "name", "", "form-control", true, "", "1");
	}
	
	public String getQueryFloorTypeSelect() throws Exception {
		return makeSelectElementString("q_floorTypeID", LocalDataCache.getInstance().getTableDatas("c_floorType"), 
				"c_floorTypeID", "name", "", "", true, "", "1");
	}
	public String getFloorTypeSelect() throws Exception {
		return makeSelectElementString("floorTypeID", LocalDataCache.getInstance().getTableDatas("c_floorType"), 
				"c_floorTypeID", "name", "", "", true, "", "1");
	}
	
	public void selectStockBillProductWindowAction() throws Exception {
	 	setFormData("count", getFormData("windowCount"));
		setFormData("pageCount", getFormData("windowPageCount"));
		setFormData("pageNumber", getFormData("windowPageNumber"));
		setFormData("pageFrom", getFormData("windowPageFrom"));
		setFormData("pageTo", getFormData("windowPageTo"));
		setFormData("pageIndex", getFormData("windowPageIndex"));
		
		Hashtable<String, String> key = new Hashtable<String, String>();
		key.put("q_productID", getFormData("q_productID2"));
		key.put("q_name", getFormData("q_name2"));
		key.put("q_bigTypeID", getFormData("q_bigTypeID2"));
		key.put("q_smallTypeID", getFormData("q_smallTypeID2"));
		key.put("q_tinyTypeID", getFormData("q_tinyTypeID2"));
		key.put("q_brandID", getFormData("q_brandID2"));
		//key.put("q_path", getFormData("q_path2"));
	//			key.put("q_validFlag", "1");
		key.put("q_deletedFlag", "0");
		setFormData(key);
		
		String extendSql = "";
		if (getFormData("stockInBillFlag").equals("0")) {
			extendSql = " stock > 0 ";
		}
		
		initPageByQueryDataList("sku_V", getFormDatas(), "datas", extendSql, new Vector<String>(), "");
		
		setFormData("windowCount", getFormData("count"));
		setFormData("windowPageCount", getFormData("pageCount"));
		setFormData("windowPageNumber", getFormData("pageNumber"));
		setFormData("windowPageFrom", getFormData("pageFrom"));
		setFormData("windowPageTo", getFormData("pageTo"));
		setFormData("windowPageIndex", getFormData("pageIndex"));
		
		setFormData("queryProductTypeSelect3", getQueryProductTypeSelect3Action());
		}
	 
		public void addStockBillProductAction() throws Exception {
			String selectedValues = getFormData("selectedValues");
		String hasSelectedValues = getFormData("hasSelectedValues");
		if (selectedValues.equals("")) {
			setAjaxJavascript("alert('请选择商品！');");
			return;
		}
		
		String unSelectedValues = getUnSelectValues(selectedValues, hasSelectedValues);
		//String unSelectedValues = selectedValues;
		Vector<Hashtable<String, String>> skus = new Vector<Hashtable<String,String>>();
		if (!unSelectedValues.equals("")) {
			String sql = "select * from sku_V where skuID in (" + unSelectedValues + ")";
			Vector<String> p = new Vector<String>();
			skus = DBProxy.query(getConnection(), "sku_V", sql, p);
		}
		setJSPData("datas", skus);
		dispatch("stockBill/stockBill.jsp");
	}

	private String getUnSelectValues(String selectdValues, String hasSelectedValues) {
		String[] hasSelectedValuesArray = StringUtil.split(hasSelectedValues, ",");
		Hashtable<String, String> hasSelectedValueHash = new Hashtable<String, String>();
		for (int i = 0; i < hasSelectedValuesArray.length; ++i) {
			hasSelectedValueHash.put(hasSelectedValuesArray[i], hasSelectedValuesArray[i]);
		}
		
		String[] selectedValuesArray = StringUtil.split(selectdValues, ",");
		String unSelectedValues = "";
		for (int i = 0; i < selectedValuesArray.length; ++i) {
			String tmp = selectedValuesArray[i];
			if (hasSelectedValueHash.get(tmp) == null) {
				unSelectedValues += ("," + tmp);
			}
		}
		
		return unSelectedValues.replaceFirst(",", "");
	}
 
	// 增加商品评分
	public void plusProductCommentCount(String productID, String score) throws Exception {
		Vector<String> pValues = new Vector<String>();
		String addBetterScore = "0";
		String addMediumScore = "0";
		String addWorseScore = "0";
		if (score.equals("1")) {
			addWorseScore = "1";
		} else if (score.equals("5")) {
			addBetterScore = "1";
		} else {
			addMediumScore = "1";
		}
		
		pValues.add(addBetterScore);
		pValues.add(addMediumScore);
		pValues.add(addWorseScore);
		pValues.add(score);
		pValues.add(productID);
		
		DBProxy.update(getConnection(), "product", "update product set betterScore = betterScore + ?, mediumScore = mediumScore + ?, " +
				"worseScore = worseScore + ?, commentPoint = commentPoint + ?, commentTimes = commentTimes + 1 where productID = ?", pValues);
	}
	
	public boolean isExcelFile(File f) {
		String fileName = f.getName().toLowerCase();
		if (!fileName.endsWith(".xlsx") && !fileName.endsWith(".xls")) {
			f.delete();
			return false;
		}
		return true;
	}
	
	/**
	 * 插入优惠券信息
	 * @param shopOrder
	 */
	public static void insertPromotion(Connection con, Hashtable<String, String> shopOrder, String time) throws Exception {
		String promotionActiveID = shopOrder.get("promotionActiveID");
		Hashtable<String, String> k = new Hashtable<String, String>();
		k.put("promotionActiveID", promotionActiveID);
		Vector<Hashtable<String, String>> datas = DBProxy.query(con, "promotionActive", k);
		if(datas.size() == 0) {
			return;
		}
		Hashtable<String, String> data = datas.get(0);
		String minBuyPrice = data.get("value3"); // 启用金额 
		String value4 = data.get("value4"); // 有效期，天数
		
		String promotionLogID = IndexGenerater.getTableIndex("promotionLog", con);
		
		String cardCode = BaseProcessor.insertCard(con, "1", shopOrder.get("cutMoney") + "元优惠券",
				shopOrder.get("cutMoney"), minBuyPrice, 
				AppUtil.getDateBefore(time, "yyyy-MM-dd", Calendar.DATE, Integer.valueOf(value4)).substring(0, 10), 
				shopOrder.get("userID"), AppKeys.CARD_SOURCE_WHOLE_PROMOTION, promotionLogID);
		
		Hashtable<String, String> valuesLog = new Hashtable<String, String>();
		valuesLog.put("promotionLogID", promotionLogID);
		valuesLog.put("type", "1"); // 优惠券日志
		valuesLog.put("content", "参与全站促销活动赠送优惠券[code: " + cardCode + "] 赠送优惠券满足条件，购满" 
				+ shopOrder.get("needMoney") + "赠" + shopOrder.get("cutMoney") + "【" + shopOrder + "】" ); 
		valuesLog.put("addTime", time); 
		DBProxy.insert(con, "promotionLog", valuesLog);
	}
	
	/**
	 * 发送微信模板消息
	 * @param toOpenID 接收消息者的openID
	 * @param wxTempMsgID 微信消息模板ID
	 */
	public void sendWXTempMsg(String toOpenID, String wxTempMsgID, String url, LinkedHashMap<String, TemplateMessageItem> data) {
		try {
			String access_token = WeiXinAccessTokenTool.getAccess_token(LocalDataCache.getInstance().getSysConfig("weixinAppID"), LocalDataCache.getInstance().getSysConfig("weixinAppSecret"));
			TemplateMessage msg = new TemplateMessage();
			msg.setTemplate_id(wxTempMsgID);
			msg.setTouser(toOpenID);
			if (url != null && !url.equals("")) {
				msg.setUrl(url);
			}
			msg.setData(data);
			MessageAPI.messageTemplateSend(access_token, msg);
		} catch (Exception e) {
			AppLogger.getInstance().errorLog("发送微信模板消息出错", e);
		}
	}
	
	public boolean finishSetWeixinConfig() throws Exception {
		return !LocalDataCache.getInstance().getSysConfig("weixinAppID").equals("")
				&& !LocalDataCache.getInstance().getSysConfig("weixinAppSecret").equals("");
	}
	
	protected String resetShopOrderStatus(String shopOrderID) throws Exception {
		Hashtable<String, String> k = new Hashtable<String, String>();
		k.put("shopOrderID", shopOrderID);
		Vector<Hashtable<String, String>> datas = DBProxy.query(getConnection(), "orderProduct", k);
		int totalCount = datas.size();
		int hasReturnCount = 0;
		for (int i = 0; i < datas.size(); ++i) {
			String orderProductStatus = datas.get(i).get("status");
			if (orderProductStatus.equals("4")) {
				hasReturnCount++;
			}
		}
		String status = "";
		if (totalCount == hasReturnCount) {
			Hashtable<String, String> v = new Hashtable<String, String>();
			status = AppKeys.ORDER_STATUS_CLOSE;
			v.put("status", status);
			v.put("rebateFinishFlag", "9");
			v.put("rebateFinishTime", DateTimeUtil.getCurrentDateTime());
			DBProxy.update(getConnection(), "shopOrder", k, v);
		}
		return status;
	}
	
	public void deleteSiteDatas(String table) throws Exception {
		Hashtable<String, String> key = new Hashtable<String, String>();
		key.put(table + "ID", getFormData(table + "ID"));
		DBProxy.delete(getConnection(), table, key);
	}
	
	public void insertAuditLog(String auditLogTypeID, String auditResult, String auditNote, String dataID) {
		try {
			Hashtable<String, String> kv = new Hashtable<String, String>();
			kv.put("auditLogID", IndexGenerater.getTableIndex("auditLog", getConnection()));
			kv.put("auditLogTypeID", auditLogTypeID);
			kv.put("auditResult", auditResult);
			kv.put("auditNote", auditNote);
			kv.put("auditTime", DateTimeUtil.getCurrentDateTime());
			kv.put("dataID", dataID);
			kv.put("systemUserID", getLoginedUserInfo().get("systemUserID"));
			kv.put("systemUserName", getLoginedUserInfo().get("userName"));
			DBProxy.insert(getConnection(), "auditLog", kv);
		} catch (Exception E) {
			AppLogger.getInstance().errorLog("insertAuditLog error: auditLogTypeID = " + auditLogTypeID + ", auditResult = " + auditResult
					+ ", auditNote = " + auditNote + ", dataID = " + dataID);
		}
	}
	public void selectCityAction() throws Exception {
		setAjaxElementHtml("citySelect", getCitySelect());
	}
	
	protected void setAjaxElementHtml(String pageElementID, String html) {
		setAjaxJavascript("$('#" + pageElementID + "').html('" + html.replace("\'", "\\\'") + "')");
	}
}
