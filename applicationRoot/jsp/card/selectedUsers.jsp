<%@page import="java.util.Vector"%>
<%@page import="java.util.Hashtable"%>
<%@page import="simpleWebFrame.web.JSPDataBean"%>
<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="admin.customer.guanwangbao.AppUtil"%>

<% JSPDataBean JSPDataBean1 = (JSPDataBean) request.getAttribute("JSPDataBean"); %>


<div id="qqServiceNum_holder_tagsinput" class="tagsinput" style="width: auto; min-height: 100px; height: 100%;">
<%
	Vector users = (Vector) JSPDataBean1.getJSPData("users");
	String[] columns1 = {"nick"};
	AppUtil.convertToHtml(columns1, users);
	for (int i = 0; i < users.size(); ++i) {
		Hashtable user = (Hashtable) users.get(i);
%>
<span class="tag" id="user_<%= user.get("userID") %>">
	<span><%= user.get("nick") %>&nbsp;&nbsp;</span>
	<a href="javascript:;" onclick="removeUser('<%= user.get("userID") %>')" title="删除">x</a>
</span>
<% } %>
</div>
<br>
<a class="infoLink" href="javascript:;" onclick="openInfoWindow('common', 'selectUserWindow')">选择会员</a>（一次最多可选择<font style="color: red">100</font>个会员，已选择<font id="selectedUserCount_font" style="color: red"><%= users.size() %></font>个会员）

