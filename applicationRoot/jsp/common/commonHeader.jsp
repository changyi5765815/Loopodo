<%@ page contentType="text/html;charset=UTF-8"%>
<jsp:directive.page import="simpleWebFrame.web.JSPDataBean"/>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1.0, user-scalable=no" />
<title>蜜品网平台管理系统</title>
<% if (JSPDataBean.getFormData("module").equals("left")) { %>
<link href="/css/left.css"  rel="stylesheet" type="text/css" />
<% } else { %>
<link href="/css/admin.css"  rel="stylesheet" type="text/css" />
<link href="/css/nprogress.css"  rel="stylesheet" type="text/css" />
<% } %>
<link rel="shortcut icon" href="/images/favicon.ico" />

<script src="/javascript/jquery-1.10.2.min.js"></script>
<script type="text/javascript" src="/javascript/jquery-form.js"></script>
<script type="text/javascript" src="/javascript/frame.js"></script>
<script type="text/javascript" src="/javascript/admin.js"></script>
<script type="text/javascript" src="/javascript/ajax.js"></script>
<script type="text/javascript" src="/javascript/nprogress.js"></script>
<script type="text/javascript" src="/javascript/WdatePicker.js"></script>
<script type="text/javascript" charset="utf-8" src="/ueditor/ueditor.config.js"></script>
<script type="text/javascript" charset="utf-8" src="/ueditor/ueditor.all.min.js"> </script>
<script type="text/javascript" charset="utf-8" src="/ueditor/lang/zh-cn/zh-cn.js"></script>
<% if(!JSPDataBean.getFormData("module").equals("left")) { %>
<style>
.spinner{width:32px;height:32px;position:fixed;left:50%;top:50%;margin-left:-16px;margin-top:-32px;}
.cube1,.cube2{background-color: #0056bb;width:30px;height:30px;position:absolute;top:0px;left:0px;-webkit-animation: cubemove 1.8s infinite ease-in-out;animation: cubemove 1.8s infinite ease-in-out;}
.cube2 {-webkit-animation-delay: -0.9s;animation-delay: -0.9s;}

@-webkit-keyframes cubemove {
  25% { transform: translateX(42px) rotate(-90deg) scale(0.5);-webkit-transform: translateX(42px) rotate(-90deg) scale(0.5);} 
  50% {transform: translateX(42px) translateY(42px) rotate(-179deg);-webkit-transform: translateX(42px) translateY(42px) rotate(-179deg);} 
  50.1% {transform: translateX(42px) translateY(42px) rotate(-180deg);-webkit-transform: translateX(42px) translateY(42px) rotate(-180deg);} 
  75% {transform: translateX(0px) translateY(42px) rotate(-270deg) scale(0.5);-webkit-transform: translateX(0px) translateY(42px) rotate(-270deg) scale(0.5);} 
  100% {transform: rotate(-360deg);-webkit-transform: rotate(-360deg);}
}
@keyframes cubemove {
  25% { transform: translateX(42px) rotate(-90deg) scale(0.5);-webkit-transform: translateX(42px) rotate(-90deg) scale(0.5);} 
  50% {transform: translateX(42px) translateY(42px) rotate(-179deg);-webkit-transform: translateX(42px) translateY(42px) rotate(-179deg);} 
  50.1% {transform: translateX(42px) translateY(42px) rotate(-180deg);-webkit-transform: translateX(42px) translateY(42px) rotate(-180deg);} 
  75% {transform: translateX(0px) translateY(42px) rotate(-270deg) scale(0.5);-webkit-transform: translateX(0px) translateY(42px) rotate(-270deg) scale(0.5);} 
  100% {transform: rotate(-360deg);-webkit-transform: rotate(-360deg);}
}
</style>
    
<script>
  $(document).ready(function () {
    //common
    try {
        //loading
        var loadHtml = '<div class="spinner">';
        loadHtml += '<div class="cube1"></div>';
        loadHtml += '<div class="cube2"></div>';
        loadHtml += '</div>';
        $("#lodingBody").append(loadHtml);
        $("form").css({ "opacity": "0" });
        try {
            $(".spinner").stop(true, true).animate({ "opacity": "0" }, 500, function () {
                $(".spinner").remove();
                $("form").stop(true, true).animate({ "opacity": "1" }, 500);
            });
        } catch (e) { }
    }
    catch (e) { }
    
});

</script>
<% } %>
<%-- 
<% if (!JSPDataBean.getFormData("module").equals("left")) { %>
<script type="text/javascript" src="/javascript/jquery.min.js"></script>
<script type="text/javascript" charset="utf-8" src="/javascript/amazeui.js"> </script>
<% } %>
--%>

</head>
<body id="lodingBody">

<form action="/admin" method="post" name="mainForm" id="mainForm" enctype="multipart/form-data" target="_self" onSubmit="return false;">

