<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="admin.customer.guanwangbao.LocalDataCache"%>

<jsp:useBean id="JSPDataBean" scope='request' class="simpleWebFrame.web.JSPDataBean" />

<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%= LocalDataCache.getInstance().getSysConfig("websiteName") %>平台管理系统</title>    
<link rel="stylesheet" type="text/css" href="/css/adminLogin.css" media="all">

<link rel="shortcut icon" href="/images/favicon.ico" />
	
<script type="text/javascript" src="javascript/frame.js"></script>
<script type="text/javascript" src="javascript/admin.js"></script>
<script type="text/javascript" src="javascript/ajax.js"></script>
</head>

<body> 
<form action="admin" method="post" name="mainForm" id="mainForm" enctype="multipart/form-data">
<div id="container">

<div id="login">
<div class="logo">
	<h1></h1>
</div>
    
<div class="main">
	<dl>
	<dt style="margin:20px;">
		<span style="font-weight:bold; font-size:30px;"><%= LocalDataCache.getInstance().getSysConfig("websiteName") %>平台管理系统<span>
	</dt>
	<dt>用户名：
		<input name="adminUserName" id="adminUserName" class="box" tabindex="1" value="<%= JSPDataBean.getFormData("adminUserName") %>" type="text" onkeydown="javascript:if(event.keyCode==13) postModuleAndAction('adminLogin', 'login');" />
	</dt>
	<dt>密　码：
		<input name="adminPassword" id="adminPassword" class="box" tabindex="1" value="" type="password" onkeydown="javascript:if(event.keyCode==13) postModuleAndAction('adminLogin', 'login');" />
	</dt>
	<% if(LocalDataCache.getInstance().getSysConfig("useVerifyFlag").equals("1")) { %>
	<dt>验证码：
	<span>
		<input name="randomString" id="randomString" class="box" tabindex="1" value="" type="text" size="10" maxlength="4" style="width: 85px;" onkeydown="javascript:if(event.keyCode==13) postModuleAndAction('adminLogin', 'login');" /></span>
		<img id="randomNumberImage" src="randomNumberImage" height="24" width="80" align="absmiddle"/> <span class="grayq font12"><a href="javascript:changeRandomImage()">看不清？</a></span>
	</dt>
	<% } %>
	<dd>
 	<input name="btnSubmit" id="btnSubmit" tabindex="1" style="font-size: 12px;" class="btn_out" value=" " onclick="postModuleAndAction('adminLogin', 'login');" type="button"  />
	</dd>
	</dl>      
</div>    

<%@include file="common/commonFooter.jsp" %>
