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
	<div class="btn_t left"><a href="javascript:postModuleAndAction('groupCompany','defaultView')"><span><strong>集团客户管理</strong></span></a></div>
	<% if (JSPDataBean.getFormData("action").equals("list")) { %>
		<div class="tip gray9" style="float: right;"><a href="javascript:openInfoWindow('groupCompany', 'selectCompanyUserWindow')" class="btn_y"><span><strong class="icon_add">添加</strong></span></a> </div>
	<% } %>
</div>

<div class="main clear">
	<div class="clear"></div>
	
	<% if (JSPDataBean.getFormData("action").equals("list")) { %>
    <div class="search">
	  	<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td>
					会员ID：<input type="text" name="q_userID" id="q_userID" value="<%= JSPDataBean.getFormData("q_userID") %>" size="15" maxlength="20" onkeydown="javascript:if(event.keyCode==13) postModuleAndAction('groupCompany', 'search')"/>&nbsp;
					公司名称：<input type="text" name="q_companyName" id="q_companyName" value="<%= JSPDataBean.getFormData("q_companyName") %>" size="15" maxlength="20" onkeydown="javascript:if(event.keyCode==13) postModuleAndAction('groupCompany', 'search')"/>&nbsp;
				</td>
				<td class="righttd">
					<div><dl>
	               		<dt style="width: 100%;">
	                   		<a class="btn_y" onclick="javascript:postModuleAndAction('groupCompany', 'search')"><span>搜&nbsp;&nbsp;&nbsp;&nbsp;索</span></a>
	                   	</dt>
	              	</dl></div>
				</td>
			</tr>
		</table>
	</div>
	<div>
		<table class="list" border="0" cellpadding="0" cellspacing="1" width="100%" id="tab1">
			<tr>
				<th width="4%">会员ID</th>
				<th width="3%">企业名称</th>
				<th width="5%">联系人姓名</th>
				<th width="4%">联系人手机</th>
				<th width="6%">企业人数</th>
				<th width="7%">公司行业</th>
				<th width="7%">公司性质</th>
				<th width="8%">排序&nbsp;<input class="btn btn-xs btn-warning" value="更新" onclick="$('#table').val('user');$('#sortIndexColumnName').val('groupSortIndex');doAction('updateSortIndexAll')" type="button"></th>
				<th width="15%">操作</th>
			</tr>
			<%
				Vector datas = (Vector) JSPDataBean.getJSPData("datas");
				String[] columns = {"companyName", "companyContactName"};
				AppUtil.convertToHtml(columns, datas);
				for (int i = 0; i < datas.size(); i++) {
					Hashtable data = (Hashtable) datas.get(i);
			%>
			<tr>
				<td><%= data.get("userID") %></td>
				<td><%= data.get("companyName") %></td>
				<td><%= data.get("companyContactName") %></td>
				<td><%= data.get("companyContactMobile") %></td>
				<td><%= LocalDataCache.getInstance().getTableDataColumnValue("c_companyScale", data.get("companyScaleID").toString(), "c_companyScaleName")  %></td>
				<td><%= LocalDataCache.getInstance().getTableDataColumnValue("c_companyIndustry", data.get("companyIndustryID").toString(), "c_companyIndustryName")  %></td>
				<td><%= LocalDataCache.getInstance().getTableDataColumnValue("c_companyNature", data.get("companyNatureID").toString(), "c_companyNatureName")  %></td>
				<td>
					<input id="sortIndex_<%= data.get("userID") %>" name="sortIndex_<%= data.get("userID") %>" value="<%= data.get("groupSortIndex") %>" size="5" maxlength="11" type="text">
				</td>
				<td>
					<a href="javascript:document.getElementById('userID').value='<%= data.get("userID") %>';postModuleAndAction('groupCompany', 'delete')">删除</a>
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
					<td class="leftbg" width="15%"></th>
					<td></td>
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
					<td class="leftbg" width="15%">&nbsp;</th>
					<td>&nbsp;</td>
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
					<td class="leftbg" width="15%">手机号</td>
					<td width="35%"><%= JSPDataBean.getFormData("companyContactMobile") %></td>
					<td class="leftbg" width="15%">邮箱</th>
					<td><%= JSPDataBean.getFormData("companyContactEmail") %></td>
				</tr>
				<% } %>
			</table>
			
			<div align="center">
				<div class="button">
					<a onclick="javascript:postModuleAndAction('groupCompany','defaultView')" class="btn_bb1"><span>返 回</span></a>
				</div>
			</div>
			
		</div>
	<% } %>
	<%= JSPDataBean.getFormData("queryConditionHtml") %>	

	<input type="hidden" id="userID" name="userID" value="<%= JSPDataBean.getFormData("userID") %>" />
	<input type="hidden" id="selectedValues" name="selectedValues" value="<%= JSPDataBean.getFormData("selectedValues") %>" />
</div>

<%@include file="common/commonFooter.jsp" %>








