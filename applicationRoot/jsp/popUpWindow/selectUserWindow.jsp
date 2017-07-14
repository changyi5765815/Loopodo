<%@ page contentType="text/html;charset=UTF-8"%>
<jsp:directive.page import="java.util.Vector"/>
<jsp:directive.page import="java.util.Hashtable"/>
<%@page import="admin.customer.guanwangbao.AppKeys"%>
<%@page import="admin.customer.guanwangbao.AppUtil"%>

<jsp:useBean id="JSPDataBean" scope='request' class="simpleWebFrame.web.JSPDataBean" />

<div id="popwindow">
<h2><span>选择会员</span><a style="" class="close-button" href="javascript:closeInfoWindow('infoWindow');">关闭</a></h2>

<div style="width:900px; padding:10px">
	<div style="width:100%;height:auto;">
		<table cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td style="padding-left: 20px;">
					<span>会员ID：</span><sapn><input type="text" name="q_userID" id="q_userID" value="<%= JSPDataBean.getFormData("q_userID") %>" size="5" maxlength="20" /></span>&nbsp;
					<%-- 
					<span>姓名：</span><sapn><input type="text" name="q_name" id="q_name" value="<%= JSPDataBean.getFormData("q_name") %>" size="10" maxlength="20" /></span>&nbsp;
					--%>
					<span>手机号：</span><sapn><input type="text" name="q_mobile" id="q_mobile" value="<%= JSPDataBean.getFormData("q_mobile") %>" size="10" maxlength="20" /></span>
				</td>
				<td align="right" style="padding-right: 20px;">
					<input style="width: 80px;" type="button" class="input-button" value="搜索" onclick="javascript:document.getElementById('pageIndex').value=1;openInfoWindow('common', 'selectUserWindow')" />
				</td>
			</tr>
		</table>
	</div>
	
	<div style="height:350px;overflow-y:scroll;margin-top:10px">
		<table cellpadding="0" cellspacing="0" width="99%">
			<tr style="height:30px;">
				<td width="5%" style="border-bottom:1px solid #b8d4e8;border-top:1px solid #b8d4e8;">&nbsp;</td>
				<td align="center" width="10%" style="border-bottom:1px solid #b8d4e8;border-top:1px solid #b8d4e8;"><b>会员ID</b></td>
				<%-- 
				<td align="center" width="10%" style="border-bottom:1px solid #b8d4e8;border-top:1px solid #b8d4e8;"><b>姓名</b></td>
				--%>
				<td align="center" width="10%" style="border-bottom:1px solid #b8d4e8;border-top:1px solid #b8d4e8;"><b>昵称</b></td>
				<td align="center" width="15%" style="border-bottom:1px solid #b8d4e8;border-top:1px solid #b8d4e8;"><b>手机号</b></td>
				<td align="center" width="10%" style="border-bottom:1px solid #b8d4e8;border-top:1px solid #b8d4e8;"><b>订单总数</b></td>
				<td align="center" width="10%" style="border-bottom:1px solid #b8d4e8;border-top:1px solid #b8d4e8;"><b>已付款订单</b></td>
				<td align="center" width="10%" style="border-bottom:1px solid #b8d4e8;border-top:1px solid #b8d4e8;"><b>消费金额</b></td>
				<td align="center" width="10%" style="border-bottom:1px solid #b8d4e8;border-top:1px solid #b8d4e8;"><b>优惠券总数</b></td>
				<td align="center" width="10%" style="border-bottom:1px solid #b8d4e8;border-top:1px solid #b8d4e8;"><b>已使用优惠券</b></td>
			</tr>
			<%
			String selectedValues = "," + JSPDataBean.getFormData("selectedValues") + ",";
				Vector datas = (Vector) JSPDataBean.getJSPData("datas");
				String[] columns = {"name", "nick"};
				AppUtil.convertToHtml(columns, datas);
				for (int i = 0; i < datas.size(); i++) {
					Hashtable data = (Hashtable) datas.get(i);
					String userID = data.get("userID").toString();
			%>
			<tr>
				<td align="center"  style="border-bottom:1px solid #b8d4e8;">
					<input type="checkbox" <%= selectedValues.indexOf("," + userID + ",") != -1 ? "checked=\"checked\"" : "" %> id="selectChoice" name="selectChoice" onchange="selectValue(this, 'selectChoice', 'selectedValues')" value="<%= data.get("userID") %>" />
				</td>
				<td align="center" style="border-bottom:1px solid #b8d4e8;"><%= data.get("userID") %></td>
				<%-- 
				<td align="center" style="border-bottom:1px solid #b8d4e8;"><%= data.get("name") %></td>
				--%>
				<td align="center" style="border-bottom:1px solid #b8d4e8;"><%= data.get("nick") %></td>
				<td align="center" style="border-bottom:1px solid #b8d4e8;"><%= data.get("mobile") %></td>
				<td align="center" style="border-bottom:1px solid #b8d4e8;"><%= data.get("orderCount") %></td>
				<td align="center" style="border-bottom:1px solid #b8d4e8;"><%= data.get("payOrderCount") %></td>
				<td align="center" style="border-bottom:1px solid #b8d4e8;"><%= data.get("consumeAmount") %></td>
				<td align="center" style="border-bottom:1px solid #b8d4e8;"><%= data.get("moneyCardCount") %></td>
				<td align="center" style="border-bottom:1px solid #b8d4e8;"><%= data.get("consumeCardCount") %></td>
			</tr>
			<%	} %>
		</table>
	</div>
</div>
<div style="text-align: center;" class="buttonsDIV">
	<%@include file="commonWindowJumpPage.jsp" %>
</div>

<div style="text-align: center;" class="buttonsDIV">
	
	<input value="选定" class="button" style="width: 50px;height: 25px;" type="button" onclick="javascript:selectUsers()">

</div>
</div>
