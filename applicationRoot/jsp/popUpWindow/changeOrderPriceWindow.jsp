<%@ page contentType="text/html;charset=UTF-8"%>
<jsp:directive.page import="java.util.Vector"/>
<jsp:directive.page import="java.util.Hashtable"/>
<%@page import="simpleWebFrame.util.PriceUtil"%>

<jsp:useBean id="JSPDataBean" scope='request' class="simpleWebFrame.web.JSPDataBean" />

<div id="popwindow">
<h2><span>修改订单价格</span><a style="" class="close-button" href="javascript:closeInfoWindow('infoWindow');">关闭</a></h2>

<div style="width:420px; padding:10px">
	<div style="margin-top:10px;">
	<table cellpadding="0" cellspacing="0">
	<tr>
		<td width="200px" align="right" style="height:30px;font-weight:bold;">原订单总金额：</td>
		<td width="220px"><%= PriceUtil.formatPrice(JSPDataBean.getFormData("oldTotalPrice")) %> 元</td>
	</tr>
	<tr>
		<td align="right" style="height:30px;font-weight:bold;"><span class="red">* </span>修改后订单总金额：</td>
		<td><input type="text" name="inputTotalPrice" id="inputTotalPrice" maxlength="11"> 元</td>
	</tr>
	<tr>
		<td colspan="2" align="center"><span style="color:red;">注：订单修改价格后，不允许退货</span></td>
	</tr>
	</table>
	</div>
</div>

<div style="text-align: center;" class="buttonsDIV">
	<a class="btn_y" onclick="javascript:doAction('order', 'changeOrderPrice');"><span>确认</span></a>&nbsp;
	<a class="btn_y" onclick="javascript:closeInfoWindow('infoWindow');"><span>取消</span></a>
</div>
</div>
