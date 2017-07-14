<%@ page contentType="text/html;charset=UTF-8"%>
<jsp:directive.page import="java.util.Vector"/>
<jsp:directive.page import="java.util.Hashtable"/>

<jsp:useBean id="JSPDataBean" scope='request' class="simpleWebFrame.web.JSPDataBean" />

<div id="popwindow">
<h2><span>更新会员等级</span><a style="" class="close-button" href="javascript:closeInfoWindow('infoWindow');">关闭</a></h2>

<div style="width:400px; padding:10px">
	<div style="margin-top:10px;">
		<table cellpadding="0" cellspacing="0">
			<tr>
				<td width="60%" align="right" style="height:30px;font-weight:bold;"><span class="red">* </span>等级：</td>
				<td width="40%"><%= JSPDataBean.getFormData("levelSelect") %></td>
			</tr>
		</table>
	</div>
</div>

<div style="text-align: center;" class="buttonsDIV">
	<a class="btn_y" onclick="javascript:doAction('batchUpdateUserLevel');"><span>确认</span></a>&nbsp;
	<a class="btn_y" onclick="javascript:closeInfoWindow('infoWindow');"><span>取消</span></a>
</div>
</div>
