<%@ page contentType="text/html;charset=UTF-8"%>
<jsp:directive.page import="java.util.Vector"/>
<jsp:directive.page import="java.util.Hashtable"/>
<%@page import="java.util.Iterator"%>
<%@page import="admin.customer.guanwangbao.AppUtil"%>
<%@page import="admin.customer.guanwangbao.LocalDataCache"%>
<%@page import="simpleWebFrame.util.PriceUtil"%>
<%@page import="admin.customer.guanwangbao.AppKeys"%>
<jsp:useBean id="JSPDataBean" scope='request' class="simpleWebFrame.web.JSPDataBean" />

<%@include file="common/commonHeader.jsp" %>

<div class="headDiv">
	<div class="btn_t left"><a href="javascript:postModuleAndAction('weixinConfig','defaultView')"><span><strong>微信公众号集成账号</strong></span></a></div>
</div>

<div class="main clear">
	<div class="clear"></div>
		<div class="record">
		<%@include file="common/commonEditTitle.jsp" %>
		<table border="0" cellspacing="0" cellpadding="0" width="100%">
			<tr>
			  <th><span class="red">* </span>AppID：</th>
			  <td><input type="text" name="weixinAppID" id="weixinAppID" size="60" maxlength="30" value="<%= JSPDataBean.getFormData("weixinAppID") %>" /></td>
			</tr>
			<tr>
			  <th><span class="red">* </span>AppSecret：</th>
			  <td><input type="text" name="weixinAppSecret" id="weixinAppSecret" size="60" maxlength="50" value="<%= JSPDataBean.getFormData("weixinAppSecret") %>" /></td>
			</tr>
			<tr>
			  <th></th>
			  <td><a class="infoLink" href="http://kf.qq.com/faq/120322fu63YV130422AJbaI3.html" target="_blank">如何开通公众号?</a></td>
			</tr>

		</table>
		
		<div align="center">
			<div class="button">
				<a class="btn_bb1" id="btnSave" onclick="javascript:postModuleAndAction('weixinConfig', 'confirm')"><span>保 存</span></a>
				<a onclick="javascript:if(confirm('是否清除？'))postModuleAndAction('weixinConfig', 'clear')" class="btn_bb1"><span>清除微信绑定</span></a>
			</div>
		</div> 
	</div>
</div>

<%@include file="common/commonFooter.jsp" %>

<script type="text/javascript">

</script>








