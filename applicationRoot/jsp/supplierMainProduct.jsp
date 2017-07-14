<%@ page contentType="text/html;charset=UTF-8"%>
<jsp:directive.page import="java.util.Vector"/>
<jsp:directive.page import="java.util.Hashtable"/>
<%@page import="java.util.Iterator"%>
<%@page import="admin.customer.guanwangbao.AppUtil"%>

<jsp:useBean id="JSPDataBean" scope='request' class="simpleWebFrame.web.JSPDataBean" />

<%@include file="common/commonHeader.jsp" %>
<div class="headDiv">
	<div class="btn_t left"><a href="javascript:postModuleAndAction('supplierMainProduct','defaultView')"><span><strong>店铺主营产品类别</strong></span></a></div>
	
	<% if(JSPDataBean.getFormData("action").equals("list")) {%>
	<div class="tip gray9" style="float: right;"><a href="javascript:postModuleAndAction('supplierMainProduct', 'supplierMainProductAddView')" class="btn_y"><span><strong class="icon_add">添加产品分类</strong></span></a> </div>
	</div>
	<% } %>
<div class="main clear">
	<div class="clear"></div>
	<% if (JSPDataBean.getFormData("action").equals("list")) {%>
	<div>
		<table class="list" border="0" cellpadding="0" cellspacing="1" width="100%" id="tab1">
			<tr>
				<th>主营产品ID</th>
				<th>主营产品名称</th>
				<th>操作</th>
			</tr>
			<%
				Vector datas = (Vector) JSPDataBean.getJSPData("datas");
				String[] convertColumns = {"name"}; 
				AppUtil.convertToHtml(convertColumns, datas); 
				for (int i = 0; i < datas.size(); i++) {
					Hashtable data = (Hashtable) datas.get(i);
					String trClass = "tr_line" + (i % 2);
			%>
			<tr class="<%=trClass %>">
				<td><%= data.get("supplierMainProductID") %></td>
				<td><%= data.get("name") %></td>
				<td>
					<a href="javascript:document.getElementById('supplierMainProductID').value='<%=data.get("supplierMainProductID")%>';postModuleAndAction('supplierMainProduct','supplierMainProductEditView')">编辑</a>
					<a href="javascript:if (confirm('是否删除')) {document.getElementById('supplierMainProductID').value='<%=data.get("supplierMainProductID")%>';postModuleAndAction('supplierMainProduct','delete')}">删除</a>
				</td>
			</tr>
			<% } %>		
		</table>
	</div>
	<% } else if (JSPDataBean.getFormData("action").equals("supplierMainProductAddView")
	    || JSPDataBean.getFormData("action").equals("supplierMainProductEditView")
		|| JSPDataBean.getFormData("action").equals("supplierMainProductConfirm")) {
	%>
	<div class="record">
		<%@include file="common/commonEditTitle.jsp" %>
		<table border="0" cellspacing="0" cellpadding="0" width="100%">
			<tr>
				<th><span class="red">* </span>主营产品名称：</th>
				<td>
					<input type="text" name="name" id="name" value="<%=JSPDataBean.getFormData("name")%>" size="30" maxlength="20" />
				</td>
			</tr>
		</table>
		<div align="center">
			<div class="button">
				<a class="btn_bb1" id="btnSave" onclick="javascript:postModuleAndAction('supplierMainProduct', 'supplierMainProductConfirm')"><span>保 存</span></a>
				<a class="btn_bb1" onclick="javascript:postModuleAndAction('supplierMainProduct', 'defaultView')" ><span>返 回</span></a>
			</div>
		</div> 
	</div>	
	<% } %>
	
</div>

<input type="hidden" id="supplierMainProductID" name="supplierMainProductID" value="<%=JSPDataBean.getFormData("supplierMainProductID")%>" />
<input type="hidden" id="table" name="table" value="<%=JSPDataBean.getFormData("table")%>" />
<%@include file="common/commonFooter.jsp" %>
