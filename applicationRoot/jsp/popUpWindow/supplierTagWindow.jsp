<%@page import="admin.customer.guanwangbao.LocalDataCache"%>
<%@ page contentType="text/html;charset=UTF-8"%>
<jsp:directive.page import="java.util.Vector"/>
<jsp:directive.page import="java.util.Hashtable"/>

<jsp:useBean id="JSPDataBean" scope='request' class="simpleWebFrame.web.JSPDataBean" />

<div id="popwindow">
<h2><span>店铺信誉标签</span><a style="" class="close-button" href="javascript:closeInfoWindow('infoWindow');">关闭</a></h2>
<div style="width:420px; padding:10px">
	<div style="margin-top:10px;height:auto;">
		<table cellpadding="0" cellspacing="0" width="100%" align="center">
			<tr>
				<td width="80px" align="right" style="height:30px;font-weight:bold;">店铺标签：</td>
				<td width="*">
				<%
					Vector supplierTags = LocalDataCache.getInstance().getTableDatas("c_supplierTag");
					for (int i = 0; i < supplierTags.size(); ++i) {
						Hashtable data = (Hashtable) supplierTags.get(i);
				%>
				<input type="checkbox" name="supplierTag_choice" id="supplierTag_<%= data.get("c_supplierTagID") %>" value="<%= data.get("c_supplierTagID") %>" <%= JSPDataBean.getFormData("supplierTagIDs").indexOf(data.get("c_supplierTagID").toString()) != -1 ? "checked=\"checked\"" : "" %> onclick="setSelectedValues('supplierTag_choice', 'supplierTagIDs')" />
				<label for="supplierTag_<%= data.get("c_supplierTagID") %>"><%= data.get("c_supplierTagName") %></label>
				<% } %>
				</td>
			</tr>
		</table>
	</div>
</div>
		<div>
			<div style="text-align: center;" class="buttonsDIV">
			<a class="btn_y" onclick="doAction('userStore', 'confirmSupplierTag')"><span>确认</span></a>&nbsp;
			<a class="btn_y" onclick="javascript:closeInfoWindow('infoWindow');"><span>取消</span></a>
			</div>
		</div>
</div>

<input type="hidden" name="supplierTagIDs" id="supplierTagIDs" value="<%= JSPDataBean.getFormData("supplierTagIDs") %>" />