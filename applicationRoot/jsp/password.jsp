<%@ page contentType="text/html;charset=UTF-8"%>
<jsp:directive.page import="java.util.Vector"/>
<jsp:directive.page import="java.util.Hashtable"/>
<%@page import="java.util.Iterator"%>

<jsp:useBean id="JSPDataBean" scope='request' class="simpleWebFrame.web.JSPDataBean" />

<%@include file="common/commonHeader.jsp" %>

<div class="headDiv">
<div class="btn_t left"><a href="javascript:postModuleAndAction('password','defaultView')"><span><strong>密码修改</strong></span></a></div>
</div>

<div class="main clear">
	<div class="clear"></div>
	<div class="record">
		<%@include file="common/commonEditTitle.jsp" %>
		<table border="0" cellspacing="0" cellpadding="0" width="100%">
			<tr>
				<th><span class="red">*</span> 原密码：</th>
				<td><input type="password" maxlength="20" name="password1" id="password1" value="" /></td>
			</tr>
			<tr>
				<th><span class="red">*</span> 初始密码：</th>
				<td><input type="password" maxlength="20" name="password2" id="password2" value="" /> (6-20个英文字符,例：_、a~z、A~Z、0~9等)</td>
			</tr>
			<tr>
				<th><span class="red">*</span> 确认密码：</th>
				<td><input type="password" maxlength="20" name="password3" id="password3" value="" /></td>
			</tr>    
		</table>
		<div align="center">
			<div class="button">
				<a class="btn_bb1" id="btnSave" onclick="javascript:postModuleAndAction('password', 'confirm')"><span>保 存</span></a>
			</div>
		</div>
	</div>

<input type="hidden" id="systemUserID" name="systemUserID" value="<%= JSPDataBean.getFormData("systemUserID") %>" />
</div>

<%@include file="common/commonFooter.jsp" %>
