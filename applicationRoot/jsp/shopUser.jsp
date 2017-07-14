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
	<div class="<% if (JSPDataBean.getFormData("action").equals("list") || JSPDataBean.getFormData("action").equals("addView") || JSPDataBean.getFormData("action").equals("editView")) { %>btn_t left<% } else { %>btn_t0 left<% } %>"><a href="javascript:postModuleAndAction('shopUser','defaultView')"><span><strong>会员管理</strong></span></a></div>
</div>

<div class="main clear">
	<div class="clear"></div>
	
	<% if (JSPDataBean.getFormData("action").equals("list")) { %>
    <div class="search">
	  	<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td>
					会员ID：<input type="text" name="q_userID" id="q_userID" value="<%= JSPDataBean.getFormData("q_userID") %>" size="15" maxlength="20" onkeydown="javascript:if(event.keyCode==13) postModuleAndAction('shopUser', 'search')"/>&nbsp;
					<%-- 
					姓名：<input type="text" name="q_name" id="q_name" value="<%= JSPDataBean.getFormData("q_name") %>" size="15" maxlength="50" onkeydown="javascript:if(event.keyCode==13) postModuleAndAction('shopUser', 'search')"/>&nbsp;
					--%>
					手机号：<input type="text" name="q_mobile" id="q_mobile" value="<%= JSPDataBean.getFormData("q_mobile") %>" size="15" maxlength="20" onkeydown="javascript:if(event.keyCode==13) postModuleAndAction('shopUser', 'search')"/>&nbsp;
					Email：<input type="text" name="q_email" id="q_email" value="<%= JSPDataBean.getFormData("q_email") %>" size="15" maxlength="50" onkeydown="javascript:if(event.keyCode==13) postModuleAndAction('shopUser', 'search')"/>&nbsp;
					用户名：<input type="text" name="q_userName" id="q_userName" value="<%= JSPDataBean.getFormData("q_userName") %>" size="15" maxlength="20" onkeydown="javascript:if(event.keyCode==13) postModuleAndAction('shopUser', 'search')"/>&nbsp;
				</td>
				<td class="righttd">
					<div><dl>
	               		<dt style="width: 100%;">
	                   		<a class="btn_y" onclick="javascript:postModuleAndAction('shopUser', 'search')"><span>搜&nbsp;&nbsp;&nbsp;&nbsp;索</span></a>
	                   	</dt>
	              	</dl></div>
				</td>
			</tr>
		</table>
	</div>
	<div>
		<table class="list" border="0" cellpadding="0" cellspacing="1" width="100%" id="tab1">
			<tr>
				<tr>
					<th>会员ID</th>
					<th>店铺名称</th>
					<%-- 
					<th>姓名</th>
					--%>
					<th>昵称</th>
					<th>等级</th>
					<th>会员来源</th>
					<th>手机号</th>
					<th>Email</th>
					<th>注册时间</th>
					<th>订单总数</th>
					<th>已付款订单</th>
					<th>消费金额</th>
					<th>上次购物时间</th>
					<th>操作</th>
				</tr>
			</tr>
			<%
				Vector datas = (Vector) JSPDataBean.getJSPData("datas");
				String[] columns = {"name", "nick"};
				AppUtil.convertToHtml(columns, datas);
				for (int i = 0; i < datas.size(); i++) {
					Hashtable data = (Hashtable) datas.get(i);
			%>
				<tr>
					<td>
						<a href="javascript:document.getElementById('supplierID').value='<%= data.get("shopID") %>';document.getElementById('userID').value='<%= data.get("shopUserID") %>';postModuleAndAction('shopUser', 'editView')">
						<%= data.get("shopUserID") %>
						</a>
					</td>
				  	<td><%= data.get("supplierName") %></td>
				  	<%-- 
				  	<td><%= data.get("name") %></td>
				  	--%>
				  	<td><%= data.get("nick") %></td>
				  	<td><%= data.get("shopUserLevelName") %></td>
				  	<td><%= LocalDataCache.getInstance().getTableDataColumnsValue("c_userSourceType", (String)data.get("sourceTypeID"), "c_userSourceTypeName") %></td>
				  	<td><%= data.get("mobile") %></td>
				  	<td><div><%= data.get("email") %></div></td>
					<td><%= data.get("registerTime") %></td>
				  	<td><%= data.get("shopOrderCount") %></td>
					<td><%= data.get("shopPayOrderCount") %></td>
					<td><%= data.get("shopConsumeAmount") %></td>
					<td><%= data.get("shopLastShoppingTime") %></td>
				  	<td>
				  		<a href="javascript:document.getElementById('supplierID').value='<%= data.get("shopID") %>';document.getElementById('userID').value='<%= data.get("shopUserID") %>';postModuleAndAction('shopUser', 'editView')">查看</a>
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
			<table class="order_detail" cellpadding="0" cellspacing="1" width="100%">
				<tr class="order_detail_title">
					<td colspan="4">用户信息</td>
				</tr>
				<tr>
					<td class="leftbg" id="rrr" width="15%">会员ID</td>
					<td width="35%"><%= JSPDataBean.getFormData("userID") %></td>
					<td class="leftbg" id="rrr" width="15%">会员等级</th>
					<td><%= JSPDataBean.getFormData("shopUserLevelName") %></td>
				</tr>
				<tr>
					<td class="leftbg" id="rrr" width="15%">姓名</td>
					<td width="35%"><%= JSPDataBean.getFormData("name") %></td>
					<td class="leftbg" id="rrr" width="15%">昵称</th>
					<td><%= JSPDataBean.getFormData("nick") %></td>
				</tr>
				<tr>
					<td class="leftbg" id="rrr" width="15%">手机</td>
					<td width="35%"><%= !JSPDataBean.getFormData("mobile").equals("") ? JSPDataBean.getFormData("mobile") : (JSPDataBean.getFormData("platType").equals("5") ? JSPDataBean.getFormData("unionid") : "") %></td>
					<td class="leftbg" id="rrr" width="15%">邮箱</th>
					<td><%= JSPDataBean.getFormData("email") %></td>
				</tr>
				<tr>
					<td class="leftbg" id="rrr" width="15%">性别</td>
					<td width="35%"><%= JSPDataBean.getFormData("sex").equals("1") ? "男" : JSPDataBean.getFormData("sex").equals("2") ? "女" : "保密" %></td>
					<td class="leftbg" id="rrr" width="15%">生日</th>
					<td><%= JSPDataBean.getFormData("birthday") %></td>
				</tr>
				<tr>
					<td class="leftbg" id="rrr" width="15%">注册时间</td>
					<td width="35%"><%= JSPDataBean.getFormData("registerTime") %></td>
					<td class="leftbg" id="rrr" width="15%">注册IP</th>
					<td><%= JSPDataBean.getFormData("registerIP") %></td>
				</tr>
				<tr>
					<td class="leftbg" id="rrr" width="15%">登录时间</td>
					<td width="35%"><%= JSPDataBean.getFormData("loginTime") %></td>
					<td class="leftbg" id="rrr" width="15%">登录IP</th>
					<td><%= JSPDataBean.getFormData("loginIP") %></td>
				</tr>
				<tr>
					<td class="leftbg" id="rrr" width="15%">订单总数</td>
					<td width="35%"><%= JSPDataBean.getFormData("shopOrderCount") %></td>
					<td class="leftbg" id="rrr" width="15%">已付款订单</th>
					<td><%= JSPDataBean.getFormData("shopPayOrderCount") %></td>
				</tr>
				<tr>
					<td class="leftbg" id="rrr" width="15%">消费总金额</td>
					<td width="35%"><%= JSPDataBean.getFormData("shopConsumeAmount") %></td>
					<td class="leftbg" id="rrr" width="15%">最后一次购物时间</th>
					<td><%= JSPDataBean.getFormData("shopLastShoppingTime") %></td>
				</tr>
				<tr>
					<td class="leftbg" id="rrr" width="15%">优惠券总数</td>
					<td width="35%"><%= JSPDataBean.getFormData("shopMoneyCardCount") %></td>
					<td class="leftbg" id="rrr" width="15%">已使用优惠券</th>
					<td><%= JSPDataBean.getFormData("shopConsumeCardCount") %></td>
				</tr>
			</table>
			<div align="center">
				<div class="button">
					<a onclick="javascript:postModuleAndAction('shopUser','defaultView')" class="btn_bb1"><span>返 回</span></a>
				</div>
			</div>
			
		</div>
	<% } %>
	<%= JSPDataBean.getFormData("queryConditionHtml") %>	

	<input type="hidden" id="userID" name="userID" value="<%= JSPDataBean.getFormData("userID") %>" />
	<input type="hidden" id="supplierID" name="supplierID" value="<%= JSPDataBean.getFormData("supplierID") %>" />
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








