<%@ page contentType="text/html;charset=UTF-8"%>
<jsp:directive.page import="java.util.Vector"/>
<jsp:directive.page import="java.util.Hashtable"/>
<%@page import="java.util.Iterator"%>
<%@page import="admin.customer.guanwangbao.AppUtil"%>
<%@page import="admin.customer.guanwangbao.LocalDataCache"%>
<%@page import="simpleWebFrame.util.PriceUtil"%>
<jsp:useBean id="JSPDataBean" scope='request' class="simpleWebFrame.web.JSPDataBean" />

<%@include file="common/commonHeader.jsp" %>

<style>
.order_detail_box table.order_detail {
	background: #ccc;
	margin: 0 0 10px 0;
	border-spacing: 1px;
	border-collapse: separate;
}

.order_detail_box table.order_detail td {
	padding: 4px 8px;
	text-align: left;
	height:25px;
	line-height: 25px;
	background: #FFFFFF;
}

.childrenuser_box table.order_detail td {
	padding: 4px 8px;
	text-align: center;
	height:25px;
	line-height: 25px;
	background: #FFFFFF;
}

.order_detail_box table.order_detail tr.order_detail_title td {
	color: #5A5A5A;
	text-align: left;
	padding: 4px 15px;
	background: #F8F8F8;
}

.order_detail_box table.order_detail td.leftbg {
	color: #666;
	background: #F0F0F0;
}

.order_detail_box .order_detail_info {
	margin-top: 5px;
	color: #666666;
	text-align: center;
	line-height: 20px;
}

.order_detail_box .gift_list {
	padding: 5px 0px;
	line-height: 18px;
}

.order_detail_box .goods_txt {
	text-align: left;
}

.order_detail_box .goods_name {
	color: #666666;
}

.order_detail_box .goods_name a:link {
	color: #666666;
}

.order_detail_box .goods_name a:visited {
	color: #666666;
}

.order_detail_box .goods_name a:hover {
	color: #666666;
}

.order_detail_box .good_xiuhua {
	padding: 5px 8px;
	line-height: 25px;
}

.table {
	width: 100%;
	margin-bottom: 20px;
	text-align: center;
	border: 1px solid #ddd;
	color: #666666;
}
.mod-all-btn{
	float: right; 
	margin-left: 5px; 
	margin-right: 5px; 
	position: relative;
}
.mod-all-btn .arrow{
	font-style: normal;
	width: 0px;
	height: 0px;
	border-width: 5px;
	border-style: solid;
	border-color: transparent transparent #fff transparent;
	position: absolute;
	top: 24px;
	left: 30px;
	display: block;
}
.mod-all-drop{ 
	 border: 1px solid #ccc; 
	 box-sizing: border-box; 
	 border-radius: 5px;
	 position: absolute; 
	 top: 27px; 
	 left: 0px; 
	 background: #fff;
	 width: 100%;
	 display: none;
}
.mod-all-drop li{
	list-style: none;
	line-height: 26px;
	border-bottom: 1px solid #ddd;
	cursor: pointer;
	padding: 0px 10px;
}
.mod-all-drop li:hover{
	background: #f3f3f3;
}
.mod-all-drop li a{
	text-decoration: none;
	color: #333;
}
.mod-all-drop li:last-child{
	border-bottom: 0;
}
</style>

<div class="headDiv">
	<div class="<% if (JSPDataBean.getFormData("action").equals("list") || JSPDataBean.getFormData("action").equals("addView") || JSPDataBean.getFormData("action").equals("editView")) { %>btn_t left<% } else { %>btn_t0 left<% } %>"><a href="javascript:postModuleAndAction('user','defaultView')"><span><strong>会员管理</strong></span></a></div>
	<% if (JSPDataBean.getFormData("action").equals("list")) { %>
			<%--
					<div class="gray9 mod-all-btn">
						<a href="javascript:;" class="btn_y"><span><strong class="icon_add">批量修改</strong></span></a> 
						<em class="arrow"></em>
						<ul class="mod-all-drop">
							<li><a href="javascript:openInfoWindow('batchUpdateUserLevelWindow');" title="">更新等级</a></li>
						</ul>
					</div>
	<div class="btn_t left"><a href="javascript:postModuleAndAction('user','exportUser')"><span><strong>导出客户</strong></span></a></div>	
			--%>
	<% } %>
	<% if (JSPDataBean.getFormData("action").equals("list")) { %>
		<div class="tip gray9" style="float: right;"><a href="javascript:postModuleAndAction('user', 'registerView')" class="btn_y"><span><strong class="icon_add">添加客户</strong></span></a> </div>
		<div class="tip gray9" style="float: right;"><a href="javascript:doAction('user','exportUser')" class="btn_y"><span><strong class="icon_add">导出客户</strong></span></a> </div>
	<% } %>
	<% if (JSPDataBean.getFormData("action").equals("userMoneyHistoryList")) { %>
		<div class="btn_t left"><a href="javascript:postModuleAndAction('user','userMoneyHistoryList')"><span><strong>资金记录</strong></span></a></div>	
	<% } %>
</div>

<div class="main clear">
	<div class="clear"></div>
	
	<% if (JSPDataBean.getFormData("action").equals("list")) { %>
    <div class="search">
	  	<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td>
					会员ID：<input type="text" name="q_userID" id="q_userID" value="<%= JSPDataBean.getFormData("q_userID") %>" size="15" maxlength="20" onkeydown="javascript:if(event.keyCode==13) postModuleAndAction('user', 'search')"/>&nbsp;
					<%-- 
					姓名：<input type="text" name="q_name" id="q_name" value="<%= JSPDataBean.getFormData("q_name") %>" size="15" maxlength="50" onkeydown="javascript:if(event.keyCode==13) postModuleAndAction('user', 'search')"/>&nbsp;
					--%>
					手机号：<input type="text" name="q_mobile" id="q_mobile" value="<%= JSPDataBean.getFormData("q_mobile") %>" size="15" maxlength="20" onkeydown="javascript:if(event.keyCode==13) postModuleAndAction('user', 'search')"/>&nbsp;
					Email：<input type="text" name="q_email" id="q_email" value="<%= JSPDataBean.getFormData("q_email") %>" size="15" maxlength="50" onkeydown="javascript:if(event.keyCode==13) postModuleAndAction('user', 'search')"/>&nbsp;
					用户名：<input type="text" name="q_userName" id="q_userName" value="<%= JSPDataBean.getFormData("q_userName") %>" size="15" maxlength="20" onkeydown="javascript:if(event.keyCode==13) postModuleAndAction('user', 'search')"/>&nbsp;
					类型：<%= JSPDataBean.getFormData("queryUserTypeSelect") %>&nbsp;
				</td>
				<td class="righttd">
					<div><dl>
	               		<dt style="width: 100%;">
	                   		<a class="btn_y" onclick="javascript:postModuleAndAction('user', 'search')"><span>搜&nbsp;&nbsp;&nbsp;&nbsp;索</span></a>
	                   	</dt>
	              	</dl></div>
				</td>
			</tr>
		</table>
	</div>
	<div>
		<table class="list" border="0" cellpadding="0" cellspacing="1" width="100%" id="tab1">
			<tr>
				<th width="2%"><input type="checkbox" id="selectAllID" name="selectAllID" onclick="selectAll('userCheckbox', 'selectedValues', 'selectAllID');"/></th>
				<th width="4%">会员ID</th>
				<th width="3%">来源</th>
				<th width="3%">类型</th>
				<th width="5%">姓名</th>
				<th width="4%">等级</th>
				<th width="6%">昵称</th>
				<th width="6%">手机号</th>
				<th width="7%">Email</th>
				<th width="7%">用户名</th>
				<th width="6%">注册时间</th>
				<th width="4%">总订单</th>
				<th width="5%">付款订单</th>
				<th width="5%">消费金额</th>
				<th width="5%">账户余额</th>
				<th width="3%">状态</th>
				<th width="15%">操作</th>
			</tr>
			<%
				Vector datas = (Vector) JSPDataBean.getJSPData("datas");
				String[] columns = {"name", "nick"};
				AppUtil.convertToHtml(columns, datas);
				for (int i = 0; i < datas.size(); i++) {
					Hashtable data = (Hashtable) datas.get(i);
			%>
			<tr>
				<td><input type="checkbox" name="userCheckbox" value="<%= data.get("userID") %>" onclick="setSelectedValuesAndSelectAll('userCheckbox', 'selectedValues', 'selectAllID', '<%= datas.size() %>')"/></td>
				<td><%= data.get("userID") %></td>
				<td><%= LocalDataCache.getInstance().getTableDataColumnsValue("c_userSourceType", data.get("sourceTypeID").toString(), "c_userSourceTypeName") %></td>
				<td><%= LocalDataCache.getInstance().getTableDataColumnsValue("c_userType", data.get("userTypeID").toString(), "c_userTypeName") %></td>
				<td><%= data.get("name") %></td>
				<td><%= LocalDataCache.getInstance().getTableDataColumnsValue("c_userLevel", data.get("levelID").toString(), "c_userLevelName") %></td>
				<td><%= data.get("nick") %></td>
				<td><%= data.get("mobile") %></td>
				<td><%= data.get("email") %></td>
				<td><%= data.get("userName") %></td>
				<td><%= data.get("registerTime") %></td>
				<td><%= data.get("orderCount")%></td>
				<td><%= data.get("payOrderCount")%></td>
				<td><%= data.get("consumeAmount")%></td>
				<td><%= data.get("userMoney")%></td>
				<td>
					<% if (data.get("validFlag").equals("1")) { %>
					<a href="javascript:document.getElementById('userID').value='<%= data.get("userID") %>';postModuleAndAction('user','disable')">
					<% } else { %>
					<a href="javascript:document.getElementById('userID').value='<%= data.get("userID") %>';postModuleAndAction('user','enable')">
					<% } %>
					<img src="/images/<%= data.get("validFlag").equals("1") ? "yes" : "no"%>.gif" width="15px" border="none"/>
					</a>
				</td>
				<td>
					<a href="javascript:document.getElementById('userID').value='<%= data.get("userID") %>';postModuleAndAction('user', 'editView')">查看</a>
					<a href="javascript:document.getElementById('selectedValues').value='<%= data.get("userID") %>';openInfoWindow('batchUpdateUserLevelWindow')">等级</a>
					<a href="javascript:document.getElementById('userID').value='<%= data.get("userID") %>';postModuleAndAction('user', 'userMoneyHistoryList')">资金</a>
					<a href="javascript:document.getElementById('q_userID').value='<%= data.get("userID") %>';postModuleAndAction('order', 'defaultView');">订单</a>	
					<a href="javascript:document.getElementById('userID').value='<%= data.get("userID") %>';openInfoWindow('resetUserPasswordWindow')">重置密码</a>
				</td>
			</tr>
			<%	} %>
		</table>
		<div class="page blue">
		    <p class="floatl"><%@include file="common/commonJumpPage.jsp" %></p>
		    <div class="clear"></div>
		</div>
	</div>
	
	<% } else if (JSPDataBean.getFormData("action").equals("editView")) { 
		String[] columns = {"name", "nick", "address"};
		AppUtil.convertToHtml(columns, JSPDataBean.getFormDatas());
	%>
		<div class="order_detail_box" style="margin: 10px;">
			<table class="order_detail" cellpadding="0" cellspacing="1" width="100%" style="">
				<tr class="order_detail_title">
					<td colspan="4">用户基础信息</td>
				</tr>
				<tr>
					<td class="leftbg" width="15%">会员ID</td>
					<td width="35%"><%= JSPDataBean.getFormData("userID") %></td>
					<td class="leftbg" width="15%">会员Email</th>
					<td><%= JSPDataBean.getFormData("email") %></td>
				</tr>
				<tr>
					<td class="leftbg" width="15%">昵称</td>
					<td width="35%"><%= JSPDataBean.getFormData("nick") %></td>
					<td class="leftbg" width="15%">姓名</th>
					<td width="35%"><%= JSPDataBean.getFormData("name") %></td>
				</tr>
				<tr>
					<td class="leftbg" width="15%">手机</td>
					<td width="35%"><%= JSPDataBean.getFormData("mobile") %></td>
					<td class="leftbg" width="15%">邮箱</th>
					<td><%= JSPDataBean.getFormData("email") %></td>
				</tr>
				<tr>
					<td class="leftbg" width="15%">注册时间</td>
					<td width="35%"><%= JSPDataBean.getFormData("registerTime") %></td>
					<td class="leftbg" width="15%">注册IP</th>
					<td><%= JSPDataBean.getFormData("registerIP") %></td>
				</tr>
				<tr>
					<td class="leftbg" width="15%">登录时间</td>
					<td width="35%"><%= JSPDataBean.getFormData("loginTime") %></td>
					<td class="leftbg" width="15%">登录IP</th>
					<td><%= JSPDataBean.getFormData("loginIP") %></td>
				</tr>
				<tr>
					<td class="leftbg" width="15%">订单总数</td>
					<td width="35%"><%= JSPDataBean.getFormData("orderCount") %></td>
					<td class="leftbg" width="15%">已付款订单</th>
					<td><%= JSPDataBean.getFormData("payOrderCount") %></td>
				</tr>
				<tr>
					<td class="leftbg" width="15%">消费总金额</td>
					<td width="35%"><%= JSPDataBean.getFormData("consumeAmount") %></td>
					<td class="leftbg" width="15%">最后一次购物时间</th>
					<td><%= JSPDataBean.getFormData("lastShoppingTime") %></td>
				</tr>
				<tr>
					<td class="leftbg" width="15%">优惠券总数</td>
					<td width="35%"><%= JSPDataBean.getFormData("moneyCardCount") %></td>
					<td class="leftbg" width="15%">已使用优惠券</th>
					<td><%= JSPDataBean.getFormData("consumeCardCount") %></td>
				</tr>
				<tr>
					<td class="leftbg" width="15%">账户余额</td>
					<td width="35%"><%= JSPDataBean.getFormData("userMoney") %></td>
					<td class="leftbg" width="15%">积分</td>
					<td width="35%"><%= JSPDataBean.getFormData("point") %></td>
				</tr>
				<tr>
					<td class="leftbg" width="15%">注册来源</td>
					<td width="35%"><%= LocalDataCache.getInstance().getTableDataColumnValue("c_userSourceType", JSPDataBean.getFormData("sourceTypeID"), "c_userSourceTypeName") %></td>
					<td class="leftbg" width="15%">推荐人ID</th>
					<td><%= JSPDataBean.getFormData("parentUserID") %></td>
				</tr>
				<tr>
					<td class="leftbg" width="15%">住址</td>
					<td colspan="3"><%= PriceUtil.formatPrice(JSPDataBean.getFormData("address")) %></td>
				</tr>
				
				
				<% if (JSPDataBean.getFormData("userTypeID").equals("2")) { %>
				<tr class="order_detail_title">
					<td colspan="4">企业信息</td>
				</tr>
				<tr>
					<td class="leftbg" width="15%">公司名称</td>
					<td width="35%"><%= JSPDataBean.getFormData("companyName") %></td>
					<td class="leftbg" width="15%">公司地址</th>
					<td><%= JSPDataBean.getFormData("companyAddress") %></td>
				</tr>
				<tr>
					<td class="leftbg" width="15%">企业人数</td>
					<td width="35%"><%= LocalDataCache.getInstance().getTableDataColumnValue("c_companyScale", JSPDataBean.getFormData("companyScaleID"), "c_companyScaleName") %></td>
					<td class="leftbg" width="15%">公司行业</th>
					<td><%= LocalDataCache.getInstance().getTableDataColumnValue("c_companyIndustry", JSPDataBean.getFormData("companyIndustryID"), "c_companyIndustryName") %></td>
				</tr>
				<tr>
					<td class="leftbg" width="15%">公司性质</td>
					<td width="35%"><%= LocalDataCache.getInstance().getTableDataColumnValue("c_companyNature", JSPDataBean.getFormData("companyNatureID"), "c_companyNatureName") %></td>
					<td class="leftbg" width="15%">营业执照</th>
					<td><img class="imgBorder" src="<%= AppUtil.getImageURL("supplier", JSPDataBean.getFormData("businessLicenseImage"), 0) %>" width="200" /></td>
				</tr>
				<tr>
					<td class="leftbg" width="15%">身份证正面照</td>
					<td width="35%"><img class="imgBorder" src="<%= AppUtil.getImageURL("supplier", JSPDataBean.getFormData("idCardImage1"), 0) %>" width="200" /></td>
					<td class="leftbg" width="15%">身份证反面照</th>
					<td><img class="imgBorder" src="<%= AppUtil.getImageURL("supplier", JSPDataBean.getFormData("idCardImage2"), 0) %>" width="200" /></td>
				</tr>
				
				<tr class="order_detail_title">
					<td colspan="4">企业联系人信息</td>
				</tr>
				<tr>
					<td class="leftbg" width="15%">联系人姓名</td>
					<td width="35%"><%= JSPDataBean.getFormData("companyContactName") %></td>
					<td class="leftbg" width="15%">所在部门</th>
					<td><%= LocalDataCache.getInstance().getTableDataColumnValue("c_companyDepartment", JSPDataBean.getFormData("companyDepartmentID"), "c_companyDepartmentName") %></td>
				</tr>
				<tr>
					<td class="leftbg" width="15%">邮箱</th>
					<td colspan="3"><%= JSPDataBean.getFormData("companyContactEmail") %></td>
				</tr>
				<% } %>
			</table>
			
			<div class="childrenuser_box" >
			<table class="order_detail" cellpadding="0" cellspacing="1" width="100%">
				<tr class="order_detail_title">
					<td>推荐用户</td>
				</tr>
				<tr>
					<td>
					<table class="table" id="dataTable">
					<thead>
						<tr id="sort_paras">
							<th id="s_userID">会员ID</th>
							<th id="s_userID">来源</th>
							<%-- 
							<th id="s_userID">姓名</th>
							--%>
							<th id="s_userID">昵称</th>
							<th id="s_nick">手机号</th>
							<th id="s_email">Email</th>
							<th id="s_email">操作</th>
						</tr>
						</thead>
						<%
							Vector datas = (Vector) JSPDataBean.getJSPData("users");
							String[] columns2 = {"name", "nick"};
							AppUtil.convertToHtml(columns2, datas);
							for (int i = 0; i < datas.size(); i++) {
								Hashtable data = (Hashtable) datas.get(i);
						%>
						<tr>
							<td><%= data.get("userID") %></td>
							<td><%= LocalDataCache.getInstance().getTableDataColumnValue("c_userSourceType", data.get("sourceTypeID").toString(), "c_userSourceTypeName") %></td>
							<%-- 
						  	<td><%= data.get("name") %></td>
							--%>
						  	<td><%= data.get("nick") %></td>
						  	<td><%= data.get("mobile") %></td>
						  	<td><%= data.get("email") %></td>
						  	<td>
						  		<a href="javascript:void(0)" onclick="document.getElementById('q_userID').value='<%= data.get("userID") %>';postModuleAndAction('order', 'search')">查看订单</a>
						  	</td>
						</tr>
						<%	} %>
					</table>
					</td>
				</tr>
			</table>
			</div>
			
			<div align="center">
				<div class="button">
					<a onclick="javascript:postModuleAndAction('user','defaultView')" class="btn_bb1"><span>返 回</span></a>
				</div>
			</div>
			
		</div>
	<% } else if (JSPDataBean.getFormData("action").equals("userMoneyHistoryList")) { %>
		<div>
			<table class="list" border="0" cellpadding="0" cellspacing="1" width="100%" id="tab1">
				<tr id="sort_paras">
					<th>交易号</th>
					<th>交易金额</th>
					<th>交易类型</th>
					<th>交易时间</th>
					<th>内容</th>
				</tr>
				<%
					Vector datas = (Vector) JSPDataBean.getJSPData("datas");
					String[] columns = {"info"};
					AppUtil.convertToHtml(columns, datas);
					for (int i = 0; i < datas.size(); i++) {
						Hashtable data = (Hashtable) datas.get(i);
				%>
					<tr class="<%= (i+1)%2 ==0 ? "oddTr":"" %>">
						<td><%= data.get("relatedID") %></td>
						<td><%= data.get("money") %></td>
						<td><%= LocalDataCache.getInstance().getTableDataColumnValue("c_userMoneyHistoryType", data.get("userMoneyHistoryTypeID").toString(), "c_userMoneyHistoryTypeName") %></td>
						  <td><%= data.get("addTime") %></td>
						  <td><%= data.get("info") %></td>
					</tr>
					<%	} %>
			</table>
			
			<div align="center" style="margin:10px;">
				<div class="button">
					<a onclick="javascript:postModuleAndAction('user','defaultView')" class="btn_bb1"><span>返 回</span></a>
				</div>
			</div>
			
		</div>

	<% } else if (JSPDataBean.getFormData("action").equals("registerView") || JSPDataBean.getFormData("action").equals("register")) {
		String[] columns = {"nick", "name"};
		AppUtil.convertToHtml(columns, JSPDataBean.getFormDatas());
		%>
		<div class="record">
		<%@include file="common/commonEditTitle.jsp" %>
			<table border="0" cellspacing="0" cellpadding="0" width="100%">
				<% if (JSPDataBean.getFormData("systemUserID").equals("")) { %>
				<tr>
					<th><span class="red">* </span>用户类型：</th>
					<td>
						<select name="userTypeID" id="userTypeID" onchange="changeUserType(this)">
							<option value="1">个人</option>
							<option value="2">企业用户</option>
						</select>
					</td>
				</tr>
				<tr pid="tr_1">
					<th><span class="red">* </span>邮箱/手机号：</th>
					<td><input type="text" name="account" id="account" value="<%= JSPDataBean.getFormData("account") %>" size="30" maxlength="50" /></td>
				</tr>
				
				<tr pid="tr_2" style="display:none;">
					<th><span class="red">* </span>联系人姓名：</th>
					<td><input type="text" name="companyContactName" id="companyContactName" value="<%= JSPDataBean.getFormData("companyContactName") %>" size="30" maxlength="50" /></td>
				</tr>
				<tr pid="tr_2" style="display:none;">
					<th><span class="red">* </span>所在部门：</th>
					<td>
						<%= JSPDataBean.getFormData("companyDepartmentSelect") %>
					</td>
				</tr>
				<tr pid="tr_2" style="display:none;">
					<th><span class="red">* </span>手机：</th>
					<td>
						<input type="text" class="nametxt" name="mobile" id="mobile" maxlength="11" autocomplete="off" placeholder="请输入您的手机号"/>
					</td>
				</tr>
				<tr pid="tr_2" style="display:none;">
					<th>联系人邮箱：</th>
					<td>
						<input type="text" class="nametxt" name="companyContactEmail" id="companyContactEmail" maxlength="50" autocomplete="off" placeholder="请输入您的邮箱"/>
					</td>
				</tr>
				<tr pid="tr_2" style="display:none;">
					<th><span class="red">* </span>公司名称：</th>
					<td>
						<input type="text" class="nametxt" name="companyName" id="companyName" maxlength="50" autocomplete="off" placeholder="请输入公司名称"/>
					</td>
				</tr>
				<tr pid="tr_2" style="display:none;">
					<th><span class="red">* </span>公司地址：</th>
					<td>
						<input type="text" class="nametxt" name="companyAddress" id="companyAddress" maxlength="100" autocomplete="off" placeholder="请输入公司地址"/>
					</td>
				</tr>
				<tr pid="tr_2" style="display:none;">
					<th><span class="red">* </span>企业人数：</th>
					<td>
						<%= JSPDataBean.getFormData("companyScaleSelect") %>
					</td>
				</tr>
				<tr pid="tr_2" style="display:none;">
					<th><span class="red">* </span>公司行业：</th>
					<td>
						<%= JSPDataBean.getFormData("companyIndustrySelect") %>
					</td>
				</tr>
				<tr pid="tr_2" style="display:none;">
					<th><span class="red">* </span>公司性质：</th>
					<td>
						<%= JSPDataBean.getFormData("companyNatureSelect") %>
					</td>
				</tr>
				<tr pid="tr_2" style="display:none;">
					<th><span class="red">* </span>营业执照：</th>
					<td>
						<img class="imgBorder" id="businessLicenseImagePreview" src="<%= AppUtil.getImageURL("supplier", JSPDataBean.getFormData("businessLicenseImage"), 0) %>" width="200" />
						<a href="javascript:void(0)" onclick="javascript:doUploadFile('supplier', 'businessLicenseImage', 'businessLicenseImagePreview', '')">上传</a>
						<a class="infoLink" href="javascript:void(0)" onclick="javascript:clearUploadFile('businessLicenseImage', 'businessLicenseImagePreview')">删除</a>
						<input type="hidden" value="<%= JSPDataBean.getFormData("businessLicenseImage") %>" id="businessLicenseImage" name="businessLicenseImage">
					</td>
				</tr>
				<tr pid="tr_2" style="display:none;">
					<th><span class="red">* </span>身份证正面照：</th>
					<td>
						<img class="imgBorder" id="idCardImage1Preview" src="<%= AppUtil.getImageURL("supplier", JSPDataBean.getFormData("image"), 0) %>" width="200" />
						<a href="javascript:void(0)" onclick="javascript:doUploadFile('supplier', 'idCardImage1', 'idCardImage1Preview', '')">上传</a>
						<a class="infoLink" href="javascript:void(0)" onclick="javascript:clearUploadFile('idCardImage1', 'idCardImage1Preview')">删除</a>
						<input type="hidden" value="<%= JSPDataBean.getFormData("idCardImage1") %>" id="idCardImage1" name="idCardImage1">
					</td>
				</tr>
				<tr pid="tr_2" style="display:none;">
					<th><span class="red">* </span>身份证反面面照：</th>
					<td>
						<img class="imgBorder" id="idCardImage2Preview" src="<%= AppUtil.getImageURL("supplier", JSPDataBean.getFormData("idCardImage2"), 0) %>" width="200" />
						<a href="javascript:void(0)" onclick="javascript:doUploadFile('supplier', 'idCardImage2', 'idCardImage2Preview', '')">上传</a>
						<a class="infoLink" href="javascript:void(0)" onclick="javascript:clearUploadFile('idCardImage2', 'idCardImage2Preview')">删除</a>
						<input type="hidden" value="<%= JSPDataBean.getFormData("idCardImage2") %>" id="idCardImage2" name="idCardImage2">
					</td>
				</tr>
				<tr>
					<th><span class="red">* </span>密码：</th>
					<td><input type="password" maxlength="20" name="password" id="password" value="" size="30"/> (6-20个英文字符,例：_、a~z、A~Z、0~9等)</td>
				</tr>
				<tr>
					<th><span class="red">* </span>确认密码：</th>
					<td><input type="password" maxlength="20" name="password2" id="password2" value="" size="30"/></td>
				</tr>
				<% } %>
				<tr>
					<th>姓名：</th>
					<td><input type="text" name="name" id="name" value="<%= JSPDataBean.getFormData("name") %>" size="30" maxlength="50" /></td>
				</tr>
				<tr>
					<th>昵称：</th>
					<td><input type="text" name="nick" id="nick" value="<%= JSPDataBean.getFormData("nick") %>" size="30" maxlength="50" /></td>
				</tr>
			</table>
		<div align="center">
			<div class="button">
				<a class="btn_bb1" id="btnSave" onclick="javascript:submitRegister();"><span>保 存</span></a>
				<a onclick="javascript:postModuleAndAction('user','defaultView')" class="btn_bb1"><span>返 回</span></a>
			</div>
		</div>
	</div>
	<script>
		function changeUserType(element) {
			var selected_val = element.options[element.selectedIndex].value;
			$("[pid^='tr_']").each(function(){
				if($(this).attr("pid").indexOf(selected_val) != -1) {
					$(this).show();
				} else {
					$(this).hide();
				}
				if($(this).attr("pid") == 'tr_1') {
					if(selected_val == '1') {
						$(this).find("th").html("<span class=\"red\">* </span>邮箱/手机号：");
					} else {
						$(this).find("th").html("<span class=\"red\">* </span>用户名：");
					}
					$(this).show();
				}
			})
		}
		function submitRegister() {
			var element = document.getElementById("userTypeID");
			var selected_val = element.options[element.selectedIndex].value;
			if(selected_val == "1") {
				doAction('register');			
			} else {
				doAction('companyRegister');
			}
		}
	</script>
	<% } %>
	<%= JSPDataBean.getFormData("queryConditionHtml") %>	

	<input type="hidden" id="userID" name="userID" value="<%= JSPDataBean.getFormData("userID") %>" />
	<input type="hidden" id="selectedValues" name="selectedValues" value="<%= JSPDataBean.getFormData("selectedValues") %>" />
</div>

<%@include file="common/commonFooter.jsp" %>

<script type="text/javascript">
$(function(){
	/*批量修改的下拉效果*/
	$(".mod-all-btn .btn_y").click(function(){
		$(this).siblings(".mod-all-drop").stop().toggle();
	});
});
</script>








