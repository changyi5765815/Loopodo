package admin.customer.guanwangbao.processor;

import java.io.File;
import java.sql.Connection;
import java.util.Hashtable;
import java.util.Vector;

import simpleWebFrame.config.Module;
import simpleWebFrame.database.DBProxy;
import simpleWebFrame.database.IndexGenerater;
import simpleWebFrame.util.DateTimeUtil;
import simpleWebFrame.util.ExcelUtil;
import simpleWebFrame.util.FileUtil;
import simpleWebFrame.util.PriceUtil;
import simpleWebFrame.web.CheckList;
import simpleWebFrame.web.DataHandle;
import simpleWebFrame.web.validate.DateCheckItem;
import simpleWebFrame.web.validate.IntegerCheckItem;
import simpleWebFrame.web.validate.StringCheckItem;
import admin.customer.guanwangbao.AppKeys;
import admin.customer.guanwangbao.LocalDataCache;

public class CommentProcessor extends BaseProcessor {
	public CommentProcessor(Module module, DataHandle dataHandle) {
		super(module, dataHandle);
	}

	public void makeView() throws Exception {
		if(getFormData("action").equals("list")) {
			initPageByQueryDataList("comment_V", getFormDatas(), "datas", "", 
					new Vector<String>(), "order by replyFlag, commentID desc");
		}
		
	}
	
	public void defaultViewAction() throws Exception {
		listAction();
	}
	public void replyWindowAction() throws Exception {
		String commentID = getFormData("commentID");
		Hashtable<String, String> k = new Hashtable<String, String>();
		k.put("commentID", commentID);
		Vector<Hashtable<String, String>> datas = DBProxy.query(getConnection(), "comment_V", k);
		if(datas.size() == 0) {
			setAjaxJavascript("alert('找不到评论信息！');");
			setReDispath();
			return;
		}
		setFormData(datas.get(0));
	}

	public void auditCommentAction() throws Exception {
		CheckList list = getChecklist();
		list.addCheckItem(new IntegerCheckItem("auditStatus", "审核状态", true));
		if(!list.check()) {
			setErrorMessageAndFocusItem();
			return;
		}
		String auditType = getFormData("auditStatus");
		if(!auditType.equals("1") && !auditType.equals("2")) {
			setAjaxInfoMessage("不支持的审核状态");
			return;
		}
		Hashtable<String, String> keys = new Hashtable<String, String>(); 
		keys.put("commentID", getFormData("commentID"));
		keys.put("auditFlag", "0");
		Hashtable<String, String> values = new Hashtable<String, String>();  
		values.put("auditFlag", auditType);
		String commentDeadDay2 = LocalDataCache.getInstance().getSysConfig("commentDeadDay2");
		// 只有审核通过之后才能设置追评
		if(auditType.equals("1") && IntegerCheckItem.isInteger(commentDeadDay2) && Integer.valueOf(commentDeadDay2) > 0) {
			long toTimeMills = System.currentTimeMillis() + (Integer.valueOf(commentDeadDay2) * 24 * 60 * 60 * 1000L);
			values.put("autoComment2TimeMills", toTimeMills + "");
			values.put("autoComment2Flag", "0"); // 设置追评
		}
		int update = DBProxy.update(getConnection(), "comment", keys, values);
		if(auditType.equals("1") && update > 0) {
			keys.put("auditFlag", "1");
			Vector<Hashtable<String, String>> datas = DBProxy.query(getConnection(), "comment_V", keys);
			if(datas.size() > 0) {
				Hashtable<String, String> comment = datas.get(0);
				plusProductCommentCount(comment.get("productID"), "5", getConnection());
				updateSupplierCommentInfo(comment.get("supplierID"), "5", "5", "5",  getConnection());
			}
		}
		listAction();
	}
	
	public void auditCommentWindowAction() throws Exception {
		
	}
	
	private void plusProductCommentCount(String productID, String score, Connection con) throws Exception {
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
		
		DBProxy.update(con, "product", "update product set betterScore = betterScore + ?, mediumScore = mediumScore + ?, " +
				"worseScore = worseScore + ?, commentPoint = commentPoint + ?, commentTimes = commentTimes + 1 where productID = ?", pValues);
	}
	
	private void updateSupplierCommentInfo(String supplierID, String commentScore, String serviceScore, String deliveryScore, Connection con) throws Exception {
		int commentScorePercent = Integer.parseInt(LocalDataCache.getInstance().getTableDataColumnValue("commentDimension", "commentScore", "percent"));
		int serviceScorePercent = Integer.parseInt(LocalDataCache.getInstance().getTableDataColumnValue("commentDimension", "serviceScore", "percent"));
		int deliveryScorePercent = Integer.parseInt(LocalDataCache.getInstance().getTableDataColumnValue("commentDimension", "deliveryScore", "percent"));
		
		double totalScore = (Double.parseDouble(commentScore) * commentScorePercent / 100.00D) 
				+ (Double.parseDouble(serviceScore) * serviceScorePercent / 100.00D)
				+ (Double.parseDouble(deliveryScore) * deliveryScorePercent / 100.00D);
		
		
		String sql = "update supplier set totalScore = totalScore + ?, commentScore = commentScore + ?, serviceScore = serviceScore + ?, deliveryScore = deliveryScore + ?,"
				+ "commentTimes = commentTimes + 1 where supplierID = ?";
		Vector<String> p = new Vector<String>();
		p.add(PriceUtil.formatPrice(totalScore + ""));
		p.add(commentScore);
		p.add(serviceScore);
		p.add(deliveryScore);
		p.add(supplierID);
		DBProxy.update(con, "supplier", sql, p);
		
		Hashtable<String, String> supplierK = new Hashtable<String, String>();
		supplierK.put("supplierID", supplierID);
		Hashtable<String, String> supplier = DBProxy.query(con, "supplier", supplierK).get(0);
		
		double totalScoreD = Double.parseDouble(supplier.get("totalScore"));
		double commentScoreD = Double.parseDouble(supplier.get("commentScore"));
		double serviceScoreD = Double.parseDouble(supplier.get("serviceScore"));
		double deliveryScoreD = Double.parseDouble(supplier.get("deliveryScore"));
		int commentTimes = Integer.parseInt(supplier.get("commentTimes"));
		
		double totalScoreAvgD = totalScoreD / commentTimes;
		double commentScoreAvgD = commentScoreD / commentTimes;
		double serviceScoreAvgD = serviceScoreD / commentTimes;
		double deliveryScoreAvgD = deliveryScoreD / commentTimes;
		
		Hashtable<String, String> supplierV = new Hashtable<String, String>();
		supplierV.put("totalScoreAvg", PriceUtil.formatPrice(totalScoreAvgD + ""));
		supplierV.put("commentScoreAvg", PriceUtil.formatPrice(commentScoreAvgD + ""));
		supplierV.put("serviceScoreAvg", PriceUtil.formatPrice(serviceScoreAvgD + ""));
		supplierV.put("deliveryScoreAvg", PriceUtil.formatPrice(deliveryScoreAvgD + ""));
		DBProxy.update(con, "supplier", supplierK, supplierV);
		
	}
	
	public void saveReplyAction() throws Exception {
		CheckList checklist = getChecklist();
		checklist.addCheckItem(new StringCheckItem("replyContent", "回复内容", true));
		if(!checklist.check()) {
			return;
		}
		Hashtable<String, String> values = new Hashtable<String, String>();
		values.put("replyContent", getFormData("replyContent"));
		values.put("replyFlag", "1");
		values.put("replyTime", DateTimeUtil.getCurrentDateTime());
		values.put("siteManagerUserID", getLoginedUserInfo().get("systemUserID"));//TODO
		Hashtable<String, String> keys = new Hashtable<String, String>();
		keys.put("commentID", getFormData("commentID"));
		int update = DBProxy.update(getConnection(), "comment", keys , values);
		if(update == 1) {
			setAjaxJavascript("closeInfoWindow();alert('回复成功');postModuleAndAction('comment', 'defaultView');");
		} else {
			setAjaxJavascript("closeInfoWindow();alert('回复失败，请稍后再试');");
		}
	}
	
	public void addViewAction() throws Exception {
		String[] items = {"commentID"};
		clearDatas(items);
		
		setFormData("number", "1");
		setFormData("orderTime", DateTimeUtil.getCurrentDate());
	}
	
	public void confirmAction() throws Exception {
		CheckList list = getChecklist();
		list.addCheckItem(new IntegerCheckItem("productID", "商品", true));
		list.addCheckItem(new IntegerCheckItem("commentScore", "评论分数", true));
		list.addCheckItem(new DateCheckItem("orderTime", "购买时间", true));
		list.addCheckItem(new IntegerCheckItem("number", "购买数量", true));
		list.addCheckItem(new StringCheckItem("showUserName", "评论人", true));
		list.addCheckItem(new StringCheckItem("commentContent", "评论内容", true));
		list.addCheckItem(new DateCheckItem("postTime", "评论时间", true));
		
		if (!list.check()) {
			return;
		}
		
		setFormData("validFlag", "1");
		setFormData("orderProductID", "0");
		setFormData("userID", "0");
		if (!getFormData("replyContent").equals("")) {
			setFormData("replyFlag", "1");
			setFormData("replyTime", DateTimeUtil.getCurrentDateTime());
		} else {
			setFormData("replyFlag", "0");
		}
		
		confirmValue("comment");
		
		plusProductCommentCount(getFormData("productID"), getFormData("commentScore"));
		
		setAjaxInfoMessage("添加评论成功");
		listAction();
	}
	
	public void selectSkuWindowAction() throws Exception {
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
		setFormData(key);
		setFormData("queryProductTypeSelect3", getQueryProductTypeSelect3Action());
		
		initPageByQueryDataList("sku_V", getFormDatas(), "datas");
		
		setFormData("windowCount", getFormData("count"));
		setFormData("windowPageCount", getFormData("pageCount"));
		setFormData("windowPageNumber", getFormData("pageNumber"));
		setFormData("windowPageFrom", getFormData("pageFrom"));
		setFormData("windowPageTo", getFormData("pageTo"));
		setFormData("windowPageIndex", getFormData("pageIndex"));
	}
	
	public void commentBatchImportWindowAction() throws Exception {
	}
	
	public void uploadCommentFileAction() throws Exception {
		if (getUploadFiles().size() == 0 
				|| !isExcelFile(getUploadFiles().get(0))) {
			setAjaxJavascript("$('#hasNotSend_img').hide();$('#confirmBut').show();clearFiles();alert('上传的文件不合法');");
    		return;
		}
		String fileName = getUploadFiles().get(0).getName();
		String uploadDir = "uploadFileTemp";
		String dir = AppKeys.UPLOAD_FILE_PATH + File.separator +  uploadDir
			+ File.separator;
		if (!new File(dir).exists()) {
			new File(dir).mkdirs();
		}
		FileUtil.moveFile(getUploadFiles().get(0), dir);
		String sourcePicPath = dir + fileName;
		Hashtable<String, Vector<Vector<String>>> sheetHash = new Hashtable<String, Vector<Vector<String>>>();
		try {
			sheetHash = ExcelUtil.readExcel(sourcePicPath);
		} catch (Exception e) {
			setAjaxJavascript("$('#hasNotSend_img').hide();$('#confirmBut').show();clearFiles();alert('请导入后缀为.xls的文件');");
			FileUtil.deleteFile(sourcePicPath);
			return;
		}
		Vector<Vector<String>> rowDatas = sheetHash.get("Sheet1");
		
		Vector<String> checkResult = checkImportDatas(rowDatas);
		if (checkResult.size() > 0) {
			setAjaxJavascript("$('#hasNotSend_img').hide();$('#confirmBut').show();clearFiles();alert('" + checkResult.get(0) + "');");
			FileUtil.deleteFile(sourcePicPath);
			return;
		}
		
		dealImportDatas(rowDatas);
		
		FileUtil.deleteFile(sourcePicPath);
	}
	
	private Vector<String> checkImportDatas(Vector<Vector<String>> datas) throws Exception {
		Vector<String> result = new Vector<String>();
		if(datas == null || datas.size() <= 1) {
			result.add("没有可导入的商品数据");
		} else if (getHeaderInfo(datas.get(0)).isEmpty()) {
			result.add("表头的格式不正确");
		} else if (datas.size() > 1001) {
			result.add("一次最多可导入的评论数据不能超过1000条");
		}
		
		return result;
	}
	
	private Hashtable<String, Integer> getHeaderInfo(Vector<String> headerDatas) {
		int productIDIndex = -1;
		int propNameIndex = -1;
		int commentScoreIndex = -1;
		int orderTimeIndex = -1;
		int numberIndex = -1;
		int showUserNameIndex = -1;
		int commentContentIndex = -1;
		int postTimeIndex = -1;
		int replyContentIndex = -1;
		for (int i = 0; i < headerDatas.size(); ++i) {
			String titleName = headerDatas.get(i);
			if (titleName.equals("商品ID（必填）")) {
				productIDIndex = i;
			} else if (titleName.equals("sku名称")) {
				propNameIndex = i;
			} else if (titleName.equals("评论分数（必填）")) {
				commentScoreIndex = i;
			} else if (titleName.equals("购买时间（必填）")) {
				orderTimeIndex = i;
			} else if (titleName.equals("购买数量（必填）")) {
				numberIndex = i;
			} else if (titleName.equals("评论人（必填）")) {
				showUserNameIndex = i;
			} else if (titleName.equals("评论内容（必填）")) {
				commentContentIndex = i;
			} else if (titleName.equals("评论时间（必填）")) {
				 postTimeIndex = i;
			} else if (titleName.equals("回复内容")) {
				replyContentIndex = i;
			}
		}
		
		if (productIDIndex == -1 || commentScoreIndex == -1 || orderTimeIndex == -1 || numberIndex == -1 || showUserNameIndex == -1 || commentContentIndex == -1 || postTimeIndex == -1) {
			return new Hashtable<String, Integer>();
		}
		
		Hashtable<String, Integer> columnIndex = new Hashtable<String, Integer>();
		columnIndex.put("productIDIndex", productIDIndex);
		columnIndex.put("propNameIndex", propNameIndex);
		columnIndex.put("commentScoreIndex", commentScoreIndex);
		columnIndex.put("orderTimeIndex", orderTimeIndex);
		columnIndex.put("numberIndex", numberIndex);
		columnIndex.put("showUserNameIndex", showUserNameIndex);
		columnIndex.put("postTimeIndex", postTimeIndex);
		columnIndex.put("replyContentIndex", replyContentIndex);
		columnIndex.put("commentContentIndex", commentContentIndex);
		
		return columnIndex;
	}
	
	private void dealImportDatas(Vector<Vector<String>> datas) throws Exception {
		Vector<String> result = new Vector<String>();
		
		Hashtable<String, Integer> columnIndex = getHeaderInfo(datas.get(0));
		int productIDIndex = columnIndex.get("productIDIndex");
		int propNameIndex = columnIndex.get("propNameIndex");
		int commentScoreIndex = columnIndex.get("commentScoreIndex");
		int orderTimeIndex = columnIndex.get("orderTimeIndex");
		int numberIndex = columnIndex.get("numberIndex");
		int showUserNameIndex = columnIndex.get("showUserNameIndex");
		int commentContentIndex = columnIndex.get("commentContentIndex");
		int postTimeIndex = columnIndex.get("postTimeIndex");
		int replyContentIndex = columnIndex.get("replyContentIndex");
		
		Hashtable<String, String> key = new Hashtable<String, String>();
		key.put("validFlag", "1");
		key.put("deletedFlag", "0");
		Vector<Hashtable<String, String>> productDatas = DBProxy.query(getConnection(), "product", key);
		Hashtable<String, Hashtable<String, String>> productDatasToHash = parseDataToHash("productID", productDatas);
		int count = 0;
		for (int i = 1; i < datas.size(); ++i) {
			Vector<String> cellDatas = datas.get(i);
			
			String productID = cellDatas.get(productIDIndex);
			String price = "0";
			if (productDatasToHash.get(productID) == null) {
				result.add("第" + (i + 1) + "行商品ID为空或者找不到该商品");
				continue;
			} else {
				price = productDatasToHash.get(productID).get("price");
			}
			
			String propName = cellDatas.get(propNameIndex);
			if (!propName.equals("") && propName.length() > 1000) {
				result.add("第" + (i + 1) + "行sku名称长度大于1000个字符");
				continue;
			}
			
			String commentScore = cellDatas.get(commentScoreIndex);
			if (!IntegerCheckItem.isInteger(commentScore)) {
				result.add("第" + (i + 1) + "行评论分数输入有误");
				continue;
			} else if (Integer.parseInt(commentScore) < 1 || Integer.parseInt(commentScore) > 5) {
				result.add("第" + (i + 1) + "行评论分数输入有误");
				continue;
			}
			
			String orderTime = cellDatas.get(orderTimeIndex);
			if (orderTime.equals("")) {
				result.add("第" + (i + 1) + "行购买时间为空");
				continue;
			} else if (!isCorrectTime(orderTime)) {
				result.add("第" + (i + 1) + "行购买时间输入有误");
				continue;
			}
			
			String number = cellDatas.get(numberIndex);
			if (!IntegerCheckItem.isInteger(number)) {
				result.add("第" + (i + 1) + "行购买数量输入有误");
				continue;
			} else if (Integer.parseInt(number) <= 0) {
				result.add("第" + (i + 1) + "行购买数量输入有误");
				continue;
			}
			
			String showUserName = cellDatas.get(showUserNameIndex);
			if (showUserName.equals("") || showUserName.length() > 100) {
				result.add("第" + (i + 1) + "行评论人为空或者长度大于100个字符");
				continue;
			}
			
			String commentContent = cellDatas.get(commentContentIndex);
			if (commentContent.equals("") || commentContent.length() > 500) {
				result.add("第" + (i + 1) + "行评论内容为空或者长度大于500个字符");
				continue;
			}
			
			String postTime = cellDatas.get(postTimeIndex);
			if (postTime.equals("")) {
				result.add("第" + (i + 1) + "行评论时间为空");
				continue;
			} else if (!isCorrectTime(postTime)) {
				result.add("第" + (i + 1) + "行评论时间输入有误");
				continue;
			}
			
			String replyContent = cellDatas.get(replyContentIndex);
			if (!replyContent.equals("") && replyContent.length() > 500) {
				result.add("第" + (i + 1) + "行回复内容长度大于500个字符");
				continue;
			}
			
			String replyTime = replyContent.equals("") ? "" : DateTimeUtil.getCurrentDateTime();
			String replyFlag = replyContent.equals("") ? "0" : "1";
			
			Hashtable<String, String> kv = new Hashtable<String, String>();
			kv.put("productID", productID);
			kv.put("orderProductID", "0");
			kv.put("userID", "0");
			kv.put("showUserName", showUserName);
			kv.put("orderTime", orderTime);
			kv.put("productID", productID);
			kv.put("number", number);
			kv.put("price", price);
			kv.put("propName", propName);
			kv.put("commentScore", commentScore);
			kv.put("postTime", postTime);
			kv.put("commentContent", commentContent);
			kv.put("replyContent", replyContent);
			kv.put("replyTime", replyTime);
			kv.put("replyFlag", replyFlag);
			kv.put("validFlag", "1");
			
			String commentID = IndexGenerater.getTableIndex("comment", getConnection());
			kv.put("commentID", commentID);
			
			DBProxy.insert(getConnection(), "comment", kv);
			
			plusProductCommentCount(productID, commentScore);
			
			count++;
		}
		
		setAjaxJavascript("$('#hasNotSend_img').hide();$('#confirmBut').show();$('#importResult').html(\"" + showImportResult(result, count) + "\")");
	}
	
	private Hashtable<String, Hashtable<String, String>> parseDataToHash(String key, Vector<Hashtable<String, String>>datas) {
		Hashtable<String, Hashtable<String, String>> tempData = new Hashtable<String, Hashtable<String,String>>();
		for(int i = 0; i < datas.size(); i++) {
			Hashtable<String, String> data = datas.get(i);
			tempData.put(data.get(key), data);
		}
		return tempData;
	}
	
	/**
	 * 校验购买时间格式
	 * @param orderTime
	 * @return
	 */
	private boolean isCorrectTime(String orderTime) {
		boolean flag = false;
		String dateReg1 = "[0-9]{4}-[0-9]{1,2}-[0-9]{1,2}";
		String dateReg2 = "[0-9]{4}/[0-9]{1,2}/[0-9]{1,2}";
		boolean dateFlag1 = orderTime.matches(dateReg1);
		boolean dateFlag2 = orderTime.matches(dateReg2);
		
		if (dateFlag1 || dateFlag2) {
			flag = true;
		}
		return flag;
	}
	
	private String showImportResult(Vector<String> results, int count) {
		StringBuffer sbf = new StringBuffer("<p>本次成功导入商品评论：").append(count).append("个</p>");
		for (int i = 0; i < results.size(); ++i) {
			sbf.append("<p>").append(results.get(i)).append("</p>");
		}
		
		return sbf.toString();
	}
}
