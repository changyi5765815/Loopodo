<%@page import="admin.customer.guanwangbao.LocalDataCache"%>
<%@ page contentType="text/html;charset=UTF-8"%>
<jsp:directive.page import="java.util.Vector"/>
<jsp:directive.page import="java.util.Hashtable"/>

<jsp:useBean id="JSPDataBean" scope='request' class="simpleWebFrame.web.JSPDataBean" />

<div id="popwindow">
<h2><span>店铺信誉值修改</span><a style="" class="close-button" href="javascript:closeInfoWindow('infoWindow');">关闭</a></h2>
<div style="width:420px; padding:10px">
	<div style="margin-top:10px;height:auto;">
		<table cellpadding="0" cellspacing="0" width="100%" align="center">
			<tr>
				<td width="25%" align="right" style="height:30px;font-weight:bold;"><span class="red">* </span>信誉值：</td>
				<td width="75%"><input type="text" maxlength="8" name="value" id="value" value="<%= JSPDataBean.getFormData("reputationValue") %>" /></td>
			</tr>
		</table>
	</div>
</div>
	<div>
		<div style="text-align: center;" class="buttonsDIV">
		<a class="btn_y" onclick="doAction('userStore', 'confirmShopReputation')"><span>确认</span></a>&nbsp;
		<a class="btn_y" onclick="javascript:closeInfoWindow('infoWindow');"><span>取消</span></a>
		</div>
	</div>
</div>

<input type="hidden" name="supplierTagIDs" id="supplierTagIDs" value="<%= JSPDataBean.getFormData("supplierTagIDs") %>" />