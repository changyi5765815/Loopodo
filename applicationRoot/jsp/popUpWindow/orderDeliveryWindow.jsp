<%@ page contentType="text/html;charset=UTF-8"%>
<jsp:directive.page import="java.util.Vector"/>
<jsp:directive.page import="java.util.Hashtable"/>
<%@page import="simpleWebFrame.util.StringUtil"%>
<%@page import="admin.customer.guanwangbao.AppUtil"%>

<jsp:useBean id="JSPDataBean" scope='request' class="simpleWebFrame.web.JSPDataBean" />

<div id="popwindow">
<h2><span>订单发货</span><a style="" class="close-button" href="javascript:closeInfoWindow('infoWindow');">关闭</a></h2>

<div style="width:400px; padding:10px">
	<div style="margin-top:10px;height:auto;">
		<table cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td width="100px" align="right" style="height:30px;font-weight:bold;"><span style="color: red">* </span>物流公司：</td>
				<td width="220px"><%= JSPDataBean.getFormData("devlieryTypeSelect") %></td>
			</tr>
			<tr>
				<td width="100px" align="right" style="height:30px;font-weight:bold;"><span style="color: red">* </span>物流单号：</td>
				<td width="220px">
					<input type="text" name="deliveryCode" id="deliveryCode" value="<%= JSPDataBean.getFormData("deliveryCode") %>"  maxlength="20">
				</td>
			</tr>
		</table>
	</div>
</div>

		<div>
			<div style="text-align: center;" class="buttonsDIV">
			<a class="btn_y" onclick="javascript:doAction('order', 'faHuo');"><span>确认</span></a>&nbsp;
			<a class="btn_y" onclick="javascript:closeInfoWindow('infoWindow');"><span>取消</span></a>
			</div>
		</div>
</div>
