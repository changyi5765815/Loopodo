<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="admin.customer.guanwangbao.AppKeys"%>
<jsp:useBean id="JSPDataBean" scope='request' class="simpleWebFrame.web.JSPDataBean" />

<span style="display:none;" id="hiddenSpanInWindowInside">
<%= JSPDataBean.getFormData(AppKeys.AJAX_RESULT) %>
</span>
