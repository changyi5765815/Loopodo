<%@ page contentType="text/html;charset=UTF-8"%>
<jsp:directive.page import="java.util.Vector"/>
<jsp:directive.page import="java.util.Hashtable"/>
<%@page import="java.util.Iterator"%>
<%@page import="admin.customer.guanwangbao.AppUtil"%>
<jsp:useBean id="JSPDataBean" scope='request' class="simpleWebFrame.web.JSPDataBean" />

<%@include file="common/commonHeader.jsp" %>

<div class="headDiv">
	<div class="btn_t left"><a href="javascript:postModuleAndAction('systemUserLog','defaultView')"><span><strong>系统操作日志</strong></span></a></div>
</div>

<div class="main clear">
	<div class="clear"></div>
	
	<% if (JSPDataBean.getFormData("action").equals("list")) { %>
	<div>
		<table class="list" border="0" cellpadding="0" cellspacing="1" width="100%" id="tab1">
			<tr>
				<th>日志ID</th>
				<th>管理员ID</th>
				<th>管理员姓名</th>
				<th>sessionID</th>
				<th>module</th>
				<th>action</th>
				<th>操作系统</th>
				<th>浏览器</th>
				<th>浏览器版本</th>
				<th>IP</th>
				<th>时间</th>
			</tr>
			<%
				Vector datas = (Vector) JSPDataBean.getJSPData("datas");
				String[] columns = {"systemUserName"};
				AppUtil.convertToHtml(columns, datas);
				for (int i = 0; i < datas.size(); i++) {
					Hashtable data = (Hashtable) datas.get(i);
					String trClass = "tr_line" + (i % 2);
			%>
			<tr class="<%= trClass %>">
				<td><%= data.get("systemUserLogID") %></td>
				<td><%= data.get("systemUserID") %></td>
				<td><%= data.get("systemUserName") %></td>
				<td><%= data.get("sessionID") %></td>
				<td><%= data.get("module") %></td>
				<td><%= data.get("action") %></td>
				<td><%= data.get("os") %></td>
				<td><%= data.get("browser") %></td>
				<td><%= data.get("browserVersion") %></td>
				<td><%= data.get("ip") %></td>
				<td><%= data.get("logTime") %></td>
			</tr>
			<%	} %>
		</table>
		<div class="page blue">
		    <p class="floatl"><%@include file="common/commonJumpPage.jsp" %></p>
		    <div class="clear"></div>
		</div>
	</div>
	<%	} %>
	<input type="hidden" id="systemUserLogID" name="systemUserLogID" value="<%= JSPDataBean.getFormData("systemUserLogID") %>" />
</div>
<%@include file="common/commonFooter.jsp" %>
