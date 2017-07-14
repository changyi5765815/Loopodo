package admin.customer.guanwangbao.processor;

import java.util.Hashtable;
import java.util.Vector;

import simpleWebFrame.config.AppConfig;
import simpleWebFrame.config.Module;
import simpleWebFrame.config.QueryDataList;
import simpleWebFrame.database.DBProxy;
import simpleWebFrame.database.IndexGenerater;
import simpleWebFrame.util.DateTimeUtil;
import simpleWebFrame.util.MD5Util;
import simpleWebFrame.web.CheckList;
import simpleWebFrame.web.DataHandle;
import simpleWebFrame.web.validate.IntegerCheckItem;
import simpleWebFrame.web.validate.MailAddressCheckItem;
import simpleWebFrame.web.validate.MobileCheckItem;
import simpleWebFrame.web.validate.PasswordCheckItem;
import simpleWebFrame.web.validate.StringCheckItem;
import admin.customer.guanwangbao.LocalDataCache;
import admin.customer.guanwangbao.RandomCodeGenerator;
import admin.customer.guanwangbao.tool.ExcelUtils;

public class UserProcessor extends BaseProcessor {

	public UserProcessor(Module module, DataHandle dataHandle) {
		super(module, dataHandle);
	}

	@Override
	public void makeView() throws Exception {
		String action = getFormData("action");
		if ("list".equals(action)) {
			setFormData("q_deletedFlag", "0");
			initPageByQueryDataList("user", getFormDatas(), "datas", "", new Vector<String>(), "order by userID desc");
			
			setFormData("queryUserTypeSelect", makeSelectElementString("q_userTypeID", 
					LocalDataCache.getInstance().getTableDatas("c_userType"), "c_userTypeID",
					"c_userTypeName", "", "form-control", true, "", ""));
		} else if(getFormData("action").equals("userMoneyHistoryList")) {
			Hashtable<String, String> key = new Hashtable<String, String>();
			key.put("userID", getFormData("userID"));
			setJSPData("datas", DBProxy.query(getConnection(), "userMoneyHistory", key, "order by userMoneyHistoryID desc"));
		}
		
		if (!"list".equals(action)) {
			setFormData("queryConditionHtml", makeQueryConditionHtml("user"));
		}
	}
	
	public void defaultViewAction() throws Exception  {
		listAction();
	}

	public void editViewAction() throws Exception {
		getData("user", DATA_TYPE_TABLE);
		setJSPData("users", getChildUsers(getFormData("userID")));
	}
	
	/**
	 * 查询下级用户
	 * @param userID
	 * @return
	 * @throws Exception
	 */
	private Vector<Hashtable<String, String>> getChildUsers(String userID) throws Exception {
		/* 下一级用户 */
		Hashtable<String, String> key = new Hashtable<String, String>();
		key.put("parentUserID", userID);
		Vector<Hashtable<String, String>> childrenUsers = DBProxy.query(getConnection(), "user", key);
		
		/* 下两级用户 */
		StringBuffer sbf = new StringBuffer();
		Vector<String> value = new Vector<String>();
		for (int i = 0; i < childrenUsers.size(); ++i) {
			sbf.append(i == 0 ? "" : ",").append("?");
			value.add(childrenUsers.get(i).get("userID"));
		}
		
		if (!sbf.toString().equals("")) {
			String extendSql = "select * from user where parentUserID in (" + sbf.toString() + ")";
			childrenUsers.addAll(DBProxy.query(getConnection(), "user", extendSql, value));
		}
		
		return childrenUsers;
	}
	
	public void resetUserPasswordWindowAction() throws Exception {
	}
	
	public void resetUserPasswordAction() throws Exception {
		CheckList list = getChecklist();
		list.addCheckItem(new PasswordCheckItem("password", getFormData("password2"), "新密码"));
		if (!list.check()) {
			return;
		}
		Hashtable<String, String> key = new Hashtable<String, String>();
		key.put("userID", getFormData("userID"));
		Hashtable<String, String> value = new Hashtable<String, String>();
		value.put("password", MD5Util.MD5(getFormData("password")));
		DBProxy.update(getConnection(), "user", key, value);
		
		setAjaxJavascript("alert('重置密码成功');closeInfoWindow()");
	}
	
	public void userMoneyHistoryListAction() throws Exception {
	}
	
	public void batchUpdateUserLevelWindowAction() throws Exception {
		String selectedValues = getFormData("selectedValues");
		if (selectedValues.equals("")) {
			setErrorMessage("请选择要更新等级的会员");
			setReDispath();
			return;
		}
		
		setFormData("levelSelect", makeSelectElementString("levelID", LocalDataCache.getInstance().getTableDatas("c_userLevel"), "c_userLevelID", "c_userLevelName", ""));
	}
	
	public void batchUpdateUserLevelAction() throws Exception {
		String selectedValues = getFormData("selectedValues");
		if (selectedValues.equals("")) {
			setErrorMessage("请选择要更新等级的会员");	
			return;
		}
		
		Vector<String> value = new Vector<String>();
		if (!"".equals(getFormData("levelID"))) {
			value.add(getFormData("levelID"));
		}
		
		StringBuffer sbf = new StringBuffer();
		String[] userIDs = selectedValues.split(",");
		for (int i = 0; i < userIDs.length; i++) {
			sbf.append(i == 0 ? "?" : ",?");
			value.add(userIDs[i]);
		}
		
		String sql = "";
		if (!"".equals(getFormData("levelID"))) {
			sql = "update user set levelID = ? where userID in (" + sbf + ")";
		} else {
			sql = "update user set levelID = null where userID in (" + sbf + ")";
		}
		
		
		DBProxy.update(getConnection(), "user", sql, value);
		setAjaxJavascript("alert('操作成功');closeInfoWindow();$('#selectedValues').val('');postModuleAndAction('user', 'defaultView')");
	}
	
	public void registerViewAction() throws Exception {
		String[] items = {"userID"};
		clearDatas(items);
		setCompanyInfo();
	}
	public void setCompanyInfo() throws Exception {
		setFormData("companyDepartmentSelect", makeSelectElementString("companyDepartmentID", 
				LocalDataCache.getInstance().getTableDatas("c_companyDepartment"), 
				"c_companyDepartmentID", "c_companyDepartmentName", "", "user-select", true, "", ""));
		
		setFormData("companyScaleSelect", makeSelectElementString("companyScaleID", 
				LocalDataCache.getInstance().getTableDatas("c_companyScale"), 
				"c_companyScaleID", "c_companyScaleName", "", "user-select", true, "", ""));
		
		setFormData("companyIndustrySelect", makeSelectElementString("companyIndustryID", 
				LocalDataCache.getInstance().getTableDatas("c_companyIndustry"), 
				"c_companyIndustryID", "c_companyIndustryName", "", "user-select", true, "", ""));
		
		setFormData("companyNatureSelect", makeSelectElementString("companyNatureID", 
				LocalDataCache.getInstance().getTableDatas("c_companyNature"), 
				"c_companyNatureID", "c_companyNatureName", "", "user-select", true, "", ""));
	}
	public void registerAction() throws Exception {
		CheckList list = getChecklist();
		String account = getFormData("account");
		if (!MailAddressCheckItem.isMailAddress(account) && !MobileCheckItem.isMobile(account)) {
			setErrorMessageAndFocusItem("邮箱/手机号的输入不正确", "account");
			return;
		}
		
		list.addCheckItem(new PasswordCheckItem("password", getFormData("password2"), "密码"));
		
		if (list.check()) {
			if (MailAddressCheckItem.isMailAddress(account)) {
				boolean isExistsEmail = isExistsEmail("", account);
				if (isExistsEmail) {
					setErrorMessageAndFocusItem("邮箱已被注册", "account");
					return;
				}
			} else {
				boolean isExistsMobile = isExistsMobile("", account);
				if (isExistsMobile) {
					setErrorMessageAndFocusItem("手机号已被注册", "account");
					return;
				}
			}
		}
		
		if (!list.check()) {
			return;
		}
		
		String userID = IndexGenerater.getTableIndex("user", getConnection());
		String email = "";
		String mobile = "";
		String userName = "";
		String nick = "";
		String name = "";
		String curTime = DateTimeUtil.getCurrentDateTime();
		boolean mobileCheck = false;
		boolean emailCheck = false;
		if (MailAddressCheckItem.isMailAddress(account)) {
			email = account;
			name = getFormData("name");
			nick = email.substring(0, email.indexOf("@"));
			userName = userID + "_" + RandomCodeGenerator.generateCodeString(4).toLowerCase();
			emailCheck = true;
		} else {
			mobile = account;
			name = getFormData("name");
			userName = account;
			nick = userID + "_" + RandomCodeGenerator.generateCodeString(4).toLowerCase();
			mobileCheck = true;
		}
		
		Hashtable<String, String> kv = new Hashtable<String, String>();
		kv.put("userID", userID);
		kv.put("userTypeID", "1");
		kv.put("email", email);
		kv.put("mobile", mobile);
		kv.put("userName", userName);
		kv.put("nick", getFormData("nick").equals("") ? nick : getFormData("nick"));
		kv.put("name", name);
		kv.put("password", MD5Util.MD5(getFormData("password")));
		kv.put("registerTime", curTime);
		kv.put("registerIP", getRequestIPInfo());
		kv.put("loginIP", getRequestIPInfo());
		kv.put("loginTime", curTime);
		kv.put("validFlag", "1");
		kv.put("emailCheckFlag", emailCheck ? "1" : "0");
		kv.put("mobileCheckFlag", mobileCheck ? "1" : "0");
		kv.put("userMoney", "0.00");
		kv.put("point", "0");
		kv.put("historyPoint", "0");
		kv.put("orderCount", "0");
		kv.put("payOrderCount", "0");
		kv.put("consumeAmount", "0.00");
		kv.put("moneyCardCount", "0");
		kv.put("consumeCardCount", "0");
		kv.put("sourceTypeID", "1");
		kv.put("mapID", userID);
		kv.put("mapLevel", "0");
		DBProxy.insert(getConnection(), "user", kv);
		setAjaxJavascript("alert('添加用户成功');postModuleAndAction('user', 'defaultView')");
	}
	
	public void companyRegisterAction() throws Exception {
		CheckList list = getChecklist();
		list.addCheckItem(new StringCheckItem("account", "用户名", true));
		list.addCheckItem(new PasswordCheckItem("password", getFormData("password2"), "密码"));
		list.addCheckItem(new StringCheckItem("companyContactName", "联系人姓名", true));
		list.addCheckItem(new IntegerCheckItem("companyDepartmentID", "所在部门", true));
		list.addCheckItem(new MobileCheckItem("mobile", "手机", true));
		list.addCheckItem(new MailAddressCheckItem("companyContactEmail", "联系人邮箱", false));
		list.addCheckItem(new StringCheckItem("companyName", "公司名称", true));
		list.addCheckItem(new StringCheckItem("companyAddress", "公司地址", true));
		list.addCheckItem(new IntegerCheckItem("companyScaleID", "企业人数", true));
		list.addCheckItem(new IntegerCheckItem("companyIndustryID", "公司行业", true));
		list.addCheckItem(new IntegerCheckItem("companyNatureID", "公司性质", true));
		
		if (!list.check()) {
			return;
		}
		
		if (isExistsUserName("", getFormData("account"))) {
			setAjaxJavascript("alert('用户名已被注册')");
			return;
		}
		
		String userID = IndexGenerater.getTableIndex("user", getConnection());
		String userName = getFormData("account");
		String name = getFormData("name");
		String mobile = getFormData("mobile");
		boolean isExistsMobile = isExistsMobile("", mobile);
		if (isExistsMobile) {
			setErrorMessageAndFocusItem("手机号已被注册", "mobile");
			return;
		}
		String nick = getFormData("nick");
		String curTime = DateTimeUtil.getCurrentDateTime();
		boolean mobileCheck = false;
		boolean emailCheck = false;
		
		Hashtable<String, String> kv = new Hashtable<String, String>();
		kv.put("userID", userID);
		kv.put("userTypeID", "2");
		kv.put("userName", userName);
		kv.put("nick", nick);
		kv.put("name", name);
		kv.put("mobile", mobile);
		kv.put("password", MD5Util.MD5(getFormData("password")));
		kv.put("registerTime", curTime);
		kv.put("registerIP", getClusterRequestIPInfo());
		kv.put("loginIP", getClusterRequestIPInfo());
		kv.put("loginTime", curTime);
		kv.put("validFlag", "1");
		kv.put("emailCheckFlag", emailCheck ? "1" : "0");
		kv.put("mobileCheckFlag", mobileCheck ? "1" : "0");
		kv.put("userMoney", "0.00");
		kv.put("point", "0");
		kv.put("historyPoint", "0");
		kv.put("orderCount", "0");
		kv.put("payOrderCount", "0");
		kv.put("consumeAmount", "0.00");
		kv.put("moneyCardCount", "0");
		kv.put("consumeCardCount", "0");
		kv.put("sourceTypeID", "1");
		

		kv.put("companyContactName", getFormData("companyContactName"));
		kv.put("companyDepartmentID", getFormData("companyDepartmentID"));
		kv.put("companyContactMobile", getFormData("companyContactMobile"));
		kv.put("companyContactEmail", getFormData("companyContactEmail"));
		kv.put("companyName", getFormData("companyName"));
		kv.put("companyAddress", getFormData("companyAddress"));
		kv.put("companyScaleID", getFormData("companyScaleID"));
		kv.put("companyIndustryID", getFormData("companyIndustryID"));
		kv.put("companyNatureID", getFormData("companyNatureID"));
		DBProxy.insert(getConnection(), "user", kv);
		setAjaxJavascript("alert('添加用户成功');postModuleAndAction('user', 'defaultView')");
	}

	/**
	 * 用户注册时候需要判断注册的手机号是否已被注册
	 * (如果是来自独站宝官网的注册用户,则还需要判断该手机号是否被后台管理员siteManagagerUser注册)
	 * @param newMobile
	 * @return
	 * @throws Exception
	 */
	public boolean isExistsUserName(String oldUserName, String newUserName) throws Exception {
		if (oldUserName.equals(newUserName)) {
			return false;
		}
		String sql = "select * from user where userName = ? and deletedFlag = 0";
		Vector<String> values = new Vector<String>();
		values.add(newUserName);
		
		Vector<Hashtable<String, String>> datas = 
			DBProxy.query(getConnection(), "user", sql, values);
		
		if (datas.size() > 0) {
			return true;
		}
		
		return false;
	}
	/**
	 * 导出客户信息
	 * @throws Exception
	 */
	public void exportUserAction() throws Exception {
		setFormData("q_deletedFlag", "0");
		// 根据查询条件查询用户
		QueryDataList querydatalist = AppConfig.getInstance().getQueryDataListConfig().getQueryDataList("user");
		Vector<String> keyValueSelect = new Vector<String>();
		String sqlSelect = querydatalist.getPreparedSql(getFormDatas(), keyValueSelect);
		
		String sortSql = "order by userID desc";
		
		if (!sortSql.equals("")) {
			sqlSelect += (" " + sortSql);
		}
		
		Vector<Hashtable<String, String>> datas = DBProxy.query(getConnection(), "user", sqlSelect, keyValueSelect);
		// 处理导出数据
		for(int i = 0;i < datas.size(); i++) {
			Hashtable<String, String> data = datas.get(i);
			data.put("sourceTypeID", LocalDataCache.getInstance().getTableDataColumnsValue("c_userSourceType", data.get("sourceTypeID").toString(), "c_userSourceTypeName"));
			data.put("userTypeID", LocalDataCache.getInstance().getTableDataColumnsValue("c_userType", data.get("userTypeID").toString(), "c_userTypeName"));
			data.put("levelID", LocalDataCache.getInstance().getTableDataColumnsValue("c_userLevel", data.get("levelID").toString(), "c_userLevelName"));
			data.put("levelID", LocalDataCache.getInstance().getTableDataColumnsValue("c_userLevel", data.get("levelID").toString(), "c_userLevelName"));
		}
		String[] tableName = {
				"会员ID-userID",
				"来源-sourceTypeID",
				"类型-userTypeID",
				"姓名-name",
				"等级-levelID",
				"昵称-nick",
				"手机号-mobile",
				"Email-email",
				"用户名-userName",
				"注册时间-registerTime",
				"总订单-orderCount",
				"付款订单-payOrderCount",
				"消费金额-consumeAmount",
				"账户余额-userMoney",
				};
		String fileName = ExcelUtils.export(tableName, datas);
		String fileDirName = "default/tmp";
		String downLoadDir = "location.href='/download?dir=" + fileDirName + "&fileName=" + fileName + "'";
		setAjaxJavascript(downLoadDir);
	}
}
