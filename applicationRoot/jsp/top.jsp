<%@ page contentType="text/html;charset=UTF-8"%>
<jsp:directive.page import="java.util.Vector"/>
<jsp:directive.page import="java.util.Hashtable"/>

<jsp:useBean id="JSPDataBean" scope='request' class="simpleWebFrame.web.JSPDataBean" />

<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title></title>
	<link href="/css/top.css"  rel="stylesheet" type="text/css" media="all"/>
	<script type="text/javascript" src="javascript/frame.js"></script>
	<script type="text/javascript" src="javascript/ajax.js"></script>
	<style>
	#head h1 {
	height: 52px;
	width: 305px;
	font: bold 24px/ 52px "����";
	color: rgb(255, 255, 255);
	float: left;
	padding-left: 5px;
	line-height:52px;
}

#head h1 a {
	color: rgb(255, 255, 255);
}

#head .tel {
	height: 25px;
	color: rgb(255, 255, 255);
	font: 12px/ 25px "arial";
	text-align: right;
	padding-right: 10px;
	overflow: hidden;
}

#head .tel .icon {
	padding-left: 23px;
	background: url('/images/icon_head.gif') no-repeat scroll 0pt -389px transparent
		;
}

#head .toptip {
	height: 27px;
	line-height: 29px;
	overflow: hidden;
	padding-left: 6px;
	background: url('/images/corner_left.gif') no-repeat scroll 0% 0% transparent;
	float: right;
}

#head p {
	background: url('/images/bk_body.gif') repeat-x scroll 0pt -80px transparent;
	padding-left: 5px;
}

.icon_hello,.icon_time,.icon_help,.icon_exit,.icon_home,.icon_advise {
	background: url('/images/icon_head2.gif') no-repeat scroll 0pt 5px transparent;
	padding: 0pt 10px 0pt 20px;
	display: inline-block;
}

.icon_time {
	background-position: 0pt -25px;
}

.icon_help {
	background-position: 0pt -55px;
}

.icon_exit {
	background-position: 0pt -85px;
}

.icon_home {
	background-position: 0pt -416px;
	color: rgb(255, 255, 255);
	padding-right: 12px;
}

.icon_advise {
	background-position: 0pt -446px;
	color: rgb(255, 255, 255);
}
	</style>
	
</head>


<body style="background: url('images/bk_body.gif') repeat-x scroll 0% 0% transparent;">
<form action="admin" method="post" name="mainForm" id="mainForm" enctype="multipart/form-data">
    <div id="head">
        <h1>巨鹏陶瓷平台管理系统</h1>
        <div class="tel">
        <span class="icon" style="background-image: none;"></span>
        </div>
        <div class="toptip">
            <p>
                <span class="icon_hello">欢迎您，<%= JSPDataBean.getFormData("userName") %>！ |  <%= JSPDataBean.getFormData("date") %> <%= JSPDataBean.getFormData("dayOfWeekStr") %>  |  <a href="javascript:postModuleAndActionToTarget('adminLogin','logoff','_parent');" class="icon_exit">退出</a></p>
        </div>
    </div>
    <%= JSPDataBean.getFrameHiddenHtml() %>
</form>
</body>
</html>
