<%@ page contentType="text/html;charset=UTF-8"%>
<jsp:directive.page import="java.util.Vector"/>
<jsp:directive.page import="java.util.Hashtable"/>
<jsp:directive.page import="simpleWebFrame.config.AppConfig"/>
<jsp:directive.page import="simpleWebFrame.web.FrameKeys"/>

<jsp:useBean id="JSPDataBean" scope='request' class="simpleWebFrame.web.JSPDataBean" />

<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title></title>
<link rel="stylesheet" type="text/css" href="/css/middle.css" media="all" />
<script type="text/javascript">
  function ctnFrame(){
	  fs = top.document.getElementById("frame");
	  if (fs.cols == "0,9,*") {
	  	fs.cols = "190,9,*"
	  	document.getElementById("btnSwitch").src="/images/mid_close.png";
	  } else {
	  	fs.cols = "0,9,*";
	  	document.getElementById("btnSwitch").src="/images/mid_open.png";
	  }
  }
</script>

</head>
<body>
    <img id="btnSwitch" src="/images/mid_close.png" onclick="javascript:ctnFrame()" style="border: 1px;"/>
</body>
</html>
