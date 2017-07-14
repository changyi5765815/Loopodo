<%@page import="java.util.Vector"%>
<%@page import="java.util.Hashtable"%>
<%@page import="simpleWebFrame.web.JSPDataBean"%>
<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="admin.customer.guanwangbao.AppUtil"%>
<%@page import="admin.customer.guanwangbao.PropUtil"%>

<% JSPDataBean JSPDataBean1 = (JSPDataBean) request.getAttribute("JSPDataBean"); %>

<%
	Vector datas = (Vector) JSPDataBean1.getJSPData("datas");
	String addSkuIDs = "";
	for (int i = 0; i < datas.size(); i++) {
		Hashtable data = (Hashtable) datas.get(i);
		addSkuIDs += ("," + data.get("skuID"));
%>
<tr id="sku_<%= data.get("skuID") %>_tr">
	<td><%= data.get("productID")%></td>
	<td><%= data.get("skuID")%></td>
	<td title="<%= data.get("name") %>"><%= AppUtil.splitString(data.get("name").toString(), 80) + (PropUtil.getSkuPropName(data.get("props").toString(), data.get("skuPropValueAlias").toString()))%> </td>
	<td><%= data.get("stock") %></td>
	<% if (JSPDataBean1.getFormData("action").equals("addStockBillProduct")) { %>
	<td><input id='<%= data.get("skuID") %>_number'  name='<%= data.get("skuID") %>_number' value='<%= data.get("stock") %>' type='text' size='10' maxlength='11'></td>
	<% } else { %>
	<td><input id='<%= data.get("skuID") %>_number'  name='<%= data.get("skuID") %>_number' value='1' type='text' size='10' maxlength='11'></td>
	<% } %>
	<td><input id='<%= data.get("skuID") %>_note' name='<%= data.get("skuID") %>_note' value='' type='text' size='30' maxlength='100'></td>
	<td><a href='javascript:void(0)' onclick="removeSku('<%= data.get("skuID") %>');">删除</a></td>
</tr>
<% } %>
<script>
	$('#hasSelectedValues').val($('#hasSelectedValues').val() + '<%= addSkuIDs %>');
	$('#action').val('selectStockBillProductWindow');
</script>