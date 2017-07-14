<%@page import="admin.customer.guanwangbao.AppKeys"%>
<%@ page contentType="text/html;charset=UTF-8"%>
<jsp:useBean id="JSPDataBean" scope='request' class="simpleWebFrame.web.JSPDataBean" />

<% if (!JSPDataBean.getControlData("ERROR_MESSAGE").equals("")) { %>
	alert("<%= JSPDataBean.getControlData("ERROR_MESSAGE") %>")
<% } %>
<% if (!JSPDataBean.getControlData("INFO_MESSAGE").equals("")) { %>
	alert("<%= JSPDataBean.getControlData("INFO_MESSAGE") %>")
<% } %>
<% if (!JSPDataBean.getControlData("FOCUS_ITEM").equals("")) { %>
	var element = document.getElementById("<%= JSPDataBean.getControlData("FOCUS_ITEM") %>");
	if (element) {
		element.focus()
	}
<% } %>
<% if (!JSPDataBean.getControlData("DOWNLOAD_FILE").equals("")) { %>
	window.location="/download?fileName=" + "<%= JSPDataBean.getControlData("DOWNLOAD_FILE")%>"
<% } %>
<% if (!JSPDataBean.getControlData("INIT_FUNCTION").equals("")) { %>
	<%= JSPDataBean.getControlData("INIT_FUNCTION")%>
<% } %>
<% if (!JSPDataBean.getFormData(AppKeys.AJAX_RESULT).equals("")) { %>
	<%= JSPDataBean.getFormData(AppKeys.AJAX_RESULT) %>
<% } %>

<% if (JSPDataBean.getFormData("reDispatch").equals("1")) { %>
reDispatchFlag
<% } %>