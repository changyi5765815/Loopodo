<%@ page contentType="text/html;charset=UTF-8"%>
<jsp:directive.page import="java.util.Vector"/>
<jsp:directive.page import="java.util.Hashtable"/>
<%@page import="simpleWebFrame.util.StringUtil"%>
<%@page import="admin.customer.guanwangbao.AppUtil"%>
<%@page import="admin.customer.guanwangbao.LocalDataCache"%>

<jsp:useBean id="JSPDataBean" scope='request' class="simpleWebFrame.web.JSPDataBean" />

<div id="popwindow">
<h2><span>设置菜单</span><a style="" class="close-button" href="javascript:closeInfoWindow('infoWindow');">关闭</a></h2>
<div style="width:450px; padding:10px">
	<div style="margin-top:10px;height:auto;">
		<table cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td width="100px" align="right" style="height:30px;font-weight:bold;">菜单名：</td>
				<td width="270px">
					<input type="text" name="dataAlias" id="dataAlias" size="30" value="<%= StringUtil.convertFromXmlChars(JSPDataBean.getFormData("dataAlias")) %>" maxlength="10" />
				</td>
			</tr>
			<tr>
				<td width="100px" align="right" style="height:30px;font-weight:bold;">链接：</td>
				<td width="270px">
					<input type="text" name="dataLink" id="dataLink" value="<%= StringUtil.convertFromXmlChars(JSPDataBean.getFormData("dataLink")) %>" maxlength="100" onchange="setDataLink($(this).val(), 'http://<%=LocalDataCache.getInstance().getSysConfig("domain") %>')"/>&nbsp;
				<a id="show_link_a" style="display: <%= !JSPDataBean.getFormData("dataLink").equals("") ? "" : "none" %>" class="infoLink" href="<%= JSPDataBean.getFormData("dataLink").startsWith("http://") ? "" : ("http://" + LocalDataCache.getInstance().getSysConfig("domain")) %><%= JSPDataBean.getFormData("dataLink") %>" target="_blank">访问该链接</a>
				</td>
			</tr>
			<tr>
				<td width="100px" align="right" style="height:30px;font-weight:bold;">新窗口打开：</td>
				<td width="270px">
					<%= JSPDataBean.getFormData("isTargetRadio") %>
				</td>
			</tr>
		</table>
	</div>
</div>

		<%
			if(!JSPDataBean.getFormData("replyFlag").equals("1")) {
		%>
		<div>
			<div style="text-align: center;" class="buttonsDIV">
			<a class="btn_y" onclick="setPageLinkItem()"><span>确认</span></a>&nbsp;
			<a class="btn_y" onclick="javascript:closeInfoWindow('infoWindow');"><span>取消</span></a>
			</div>
		</div>
		<% } %>
</div>
