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
	<div class="btn_t left"><a href="javascript:postModuleAndAction('supplier','defaultView')"><span><strong>供应商管理</strong></span></a></div>
	<% if (JSPDataBean.getFormData("action").equals("list")) { %>
		<div class="tip gray9" style="float: right;"><a href="javascript:postModuleAndAction('supplier', 'addView')" class="btn_y"><span><strong class="icon_add">添加</strong></span></a> </div>
	<% } %>
</div>

<div class="main clear">
	<div class="clear"></div>
	
	<% if (JSPDataBean.getFormData("action").equals("list")) { %>
	<div>
		<table class="list" border="0" cellpadding="0" cellspacing="1" width="100%" id="tab1">
			<tr>
				<th>供应商ID</th>
				<th>名称</th>
				<th>联系人</th>
				<th>联系电话</th>
				<th>地址</th>
				<th>邮编</th>
				<th>状态</th>
				<th>操作</th>
			</tr>
			<%
				Vector datas = (Vector) JSPDataBean.getJSPData("datas");
				String[] columns = {"name", "linkMan", "linkPhone", "address", "postalCode"};
				AppUtil.convertToHtml(columns, datas);
				for (int i = 0; i < datas.size(); i++) {
					Hashtable data = (Hashtable) datas.get(i);
			%>
			<tr>
				<td><%= data.get("supplierID") %></td>
				<td><%= data.get("name") %></td>
				<td><%= data.get("linkMan") %></td>
				<td><%= data.get("linkPhone") %></td>
				<td><%= data.get("address") %></td>
				<td><%= data.get("postalCode") %></td>
				<td>
				<% if (data.get("validFlag").equals("1")) { %>
					<a href="javascript:document.getElementById('supplierID').value='<%= data.get("supplierID") %>';postModuleAndAction('supplier','disable')">
				<% } else { %>
					<a href="javascript:document.getElementById('supplierID').value='<%= data.get("supplierID") %>';postModuleAndAction('supplier','enable')">
				<% } %>
					<img src="/images/<%= data.get("validFlag").equals("1") ? "yes" : "no"%>.gif" width="15px" border="none"/>
					</a>
				</td>
				<td>
					<a href="javascript:document.getElementById('supplierID').value='<%= data.get("supplierID") %>';postModuleAndAction('supplier', 'editView')">编辑</a>
				</td>
			</tr>
			<%	} %>
		</table>
	</div>
	
	<% } else if (JSPDataBean.getFormData("action").equals("addView") || JSPDataBean.getFormData("action").equals("editView")) { %>
		<div class="record">
		<%@include file="common/commonEditTitle.jsp" %>
		<table border="0" cellspacing="0" cellpadding="0" width="100%">
			<tr>
			  <th><span class="red">* </span>名称：</th>
			  <td><input type="text" name="name" id="name" size="60" maxlength="50" value="<%= JSPDataBean.getFormData("name") %>" /></td>
			</tr>
			<tr>
			  <th>联系人：</th>
			  <td><input type="text" name="linkMan" id="linkMan" size="60" maxlength="50" value="<%= JSPDataBean.getFormData("linkMan") %>" /></td>
			</tr>
			<tr>
			  <th>联系电话：</th>
			  <td><input type="text" name="linkPhone" id="linkPhone" size="60" maxlength="50" value="<%= JSPDataBean.getFormData("linkPhone") %>" /></td>
			</tr>
			<tr>
			  <th>地址：</th>
			  <td><input type="text" name="address" id="address" size="60" maxlength="100" value="<%= JSPDataBean.getFormData("address") %>" /></td>
			</tr>
			<tr>
			  <th>邮编：</th>
			  <td><input type="text" name="postalCode" id="postalCode" size="60" maxlength="10" value="<%= JSPDataBean.getFormData("postalCode") %>" /></td>
			</tr>
		</table>
		
		<div align="center">
			<div class="button">
				<a class="btn_bb1" id="btnSave" onclick="javascript:postModuleAndAction('supplier', 'confirm')"><span>保 存</span></a>
				<a onclick="javascript:postModuleAndAction('supplier', 'defaultView')" class="btn_bb1"><span>返 回</span></a>
			</div>
		</div> 
	</div>

	<% } %>	
	<input type="hidden" id="supplierID" name="supplierID" value="<%=JSPDataBean.getFormData("supplierID")%>" />
</div>

<%@include file="common/commonFooter.jsp" %>

<script type="text/javascript">

</script>








