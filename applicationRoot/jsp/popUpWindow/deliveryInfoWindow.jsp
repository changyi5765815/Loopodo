<%@ page contentType="text/html;charset=UTF-8"%>
<jsp:directive.page import="java.util.Vector"/>
<jsp:directive.page import="java.util.Hashtable"/>
<%@page import="simpleWebFrame.util.StringUtil"%>
<%@page import="admin.customer.guanwangbao.AppUtil"%>
<%@page import="com.alibaba.fastjson.JSON"%>

<jsp:useBean id="JSPDataBean" scope='request' class="simpleWebFrame.web.JSPDataBean" />

<%
	String[] columns = {"showUserName", "commentContent", "replyContent"};
	AppUtil.convertToHtml(columns, JSPDataBean.getFormDatas());
%>

<div id="popwindow">
<h2><span>物流信息</span><a style="" class="close-button" href="javascript:closeInfoWindow('infoWindow');">关闭</a></h2>
<div style="width:400px; padding:10px">
	<div style="margin-top:10px;height:auto;">
		<table cellpadding="0" cellspacing="0" width="100%">
		
		
		<%
			Vector routers = (Vector) JSPDataBean.getJSPData("routers");
			if (routers != null) {
				for (int i = 0; i < routers.size(); ++i) {
					Hashtable data = JSON.parseObject(routers.get(i).toString(), Hashtable.class);;
		%>
			<tr>
				<td>
					<span style="<%= (i == routers.size() -1 ) ? "color:red;" : "" %>"><%= data.get("AcceptTime") %>：<%= data.get("AcceptStation") %></span>
				</td>
			</tr>
		<% } %>
		<% } else  { %>
			<tr>
				<td><span">暂无物信息</span></td>
			</tr>
		<% } %>
		
		</table>
	</div>
</div>

		<div>
			<div style="text-align: center;" class="buttonsDIV">
			<a class="btn_y" onclick="javascript:closeInfoWindow();"><span>确认</span></a>
			</div>
		</div>
</div>
