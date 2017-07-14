<%@ page contentType="text/html;charset=UTF-8"%>
<jsp:directive.page import="java.util.Vector"/>
<jsp:directive.page import="java.util.Hashtable"/>
<%@page import="java.util.Iterator"%>
<%@page import="admin.customer.guanwangbao.AppUtil"%>
<jsp:useBean id="JSPDataBean" scope='request' class="simpleWebFrame.web.JSPDataBean" />

<%@include file="common/commonHeader.jsp" %>

<div class="headDiv">
	<div class="btn_t left"><a href="javascript:postModuleAndAction('systemUser','defaultView')"><span><strong>系统用户列表</strong></span></a></div>
	<% if (JSPDataBean.getFormData("action").equals("list")) { %>
		<div class="tip gray9" style="float: right;"><a href="javascript:postModuleAndAction('systemUser','addView')" class="btn_y"><span><strong class="icon_add">添加用户</strong></span></a> </div>
	<% } %>
</div>

<div class="main clear">
	<div class="clear"></div>
	
	<% if (JSPDataBean.getFormData("action").equals("list")) { %>
	<div>
		<table class="list" border="0" cellpadding="0" cellspacing="1" width="100%" id="tab1">
			<tr>
				<th>用户帐号</th>
				<th>姓名</th>
				<th>状态</th>
				<th>系统角色</th>
				<th>操作</th>
			</tr>
			<%
				Vector datas = (Vector) JSPDataBean.getJSPData("datas");
				String[] columns = {"userName"};
				AppUtil.convertToHtml(columns, datas);
				for (int i = 0; i < datas.size(); i++) {
					Hashtable data = (Hashtable) datas.get(i);
					String trClass = "tr_line" + (i % 2);
			%>
			<tr class="<%= trClass %>">
				<td><%= data.get("userID") %></td>
				<td><%= data.get("userName") %></td>
				<td>
					<% if (data.get("validFlag").equals("1")) { %>
					<a href="javascript:document.getElementById('systemUserID').value='<%=data.get("systemUserID")%>';postModuleAndAction('systemUser','disable')">
					<% } else { %>
					<a href="javascript:document.getElementById('systemUserID').value='<%=data.get("systemUserID")%>';postModuleAndAction('systemUser','enable')">
					<% } %>
					<img src="/images/<%= data.get("validFlag").equals("1") ? "yes" : "no"%>.gif" width="15px" border="none"/>
					</a>
				</td>
				<td><%= data.get("name") %></td>
				<td>
					<a href="javascript:document.getElementById('systemUserID').value='<%= data.get("systemUserID") %>';postModuleAndAction('systemUser','editView')">编辑</a>
			  		<a href="javascript:document.getElementById('systemUserID').value='<%= data.get("systemUserID") %>';openInfoWindow('resetSystemUserPasswordWindow')">重置密码</a>
				</td>
			</tr>
			<%	} %>
		</table>
	</div>
	
	<% } else { 
			String[] columns = {"userName"};
			AppUtil.convertToHtml(columns, JSPDataBean.getFormDatas());
	%>
	<div class="record">
		<%@include file="common/commonEditTitle.jsp" %>
		<table border="0" cellspacing="0" cellpadding="0" width="100%">
			<% if (JSPDataBean.getFormData("systemUserID").equals("")) { %>
			<tr>
				<th><span class="red">* </span>用户帐号：</th>
				<td><input type="text" name="userID" id="userID" value="<%= JSPDataBean.getFormData("userID") %>" size="30" maxlength="20" />(6-20个英文字符以内 例:_、a~z、A~Z、0~9等)</td>
			</tr>
			<tr>
				<th><span class="red">* </span>初始密码：</th>
				<td><input type="password" maxlength="20" name="password" id="password" value="" /> (6-20个英文字符)</td>
			</tr>
			<tr>
				<th><span class="red">* </span>确认密码：</th>
				<td><input type="password" maxlength="20" name="password2" id="password2" value="" /></td>
			</tr>
			<% } %>
			<tr>
				<th><span class="red">* </span>姓名：</th>
				<td><input type="text" name="userName" id="userName" value="<%= JSPDataBean.getFormData("userName") %>" size="30" maxlength="50" /></td>
			</tr>
			<tr>
				<th><span class="red">* </span>系统角色：</th>
				<td><%= JSPDataBean.getFormData("systemRoleSelect") %></td>
			</tr>
		</table>
		<div align="center">
			<div class="button">
				<a class="btn_bb1" id="btnSave" onclick="javascript:postModuleAndAction('systemUser', 'confirm')"><span>保 存</span></a>
				<a onclick="javascript:postModuleAndAction('systemUser','defaultView')" class="btn_bb1"><span>返 回</span></a>
			</div>
		</div>
	</div>
	<% } %>

	<input type="hidden" id="systemUserID" name="systemUserID" value="<%= JSPDataBean.getFormData("systemUserID") %>" />
</div>

<%@include file="common/commonFooter.jsp" %>
