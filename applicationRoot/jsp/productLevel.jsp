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
	<div class="btn_t left"><a href="javascript:postModuleAndAction('productLevel','defaultView')"><span><strong>质量星级管理</strong></span></a></div>
	<% if (JSPDataBean.getFormData("action").equals("list")) { %>
		<div class="tip gray9" style="float: right;"><a href="javascript:postModuleAndAction('productLevel', 'addView')" class="btn_y"><span><strong class="icon_add">添加</strong></span></a> </div>
	<% } %>
</div>

<div class="main clear">
	<div class="clear"></div>
	
	<% if (JSPDataBean.getFormData("action").equals("list")) { %>
	<div>
		<table class="list" border="0" cellpadding="0" cellspacing="1" width="100%" id="tab1">
			<tr>
				<th>ID</th>
				<th>名称</th>
				<th>操作</th>
			</tr>
			<%
				Vector datas = (Vector) JSPDataBean.getJSPData("datas");
				String[] columns = {"name"};
				AppUtil.convertToHtml(columns, datas);
				for (int i = 0; i < datas.size(); i++) {
					Hashtable data = (Hashtable) datas.get(i);
			%>
			<tr>
				<td><%= data.get("productLevelID") %></td>
				<td><%= data.get("name") %></td>
				<td>
					<a href="javascript:document.getElementById('productLevelID').value='<%= data.get("productLevelID") %>';postModuleAndAction('productLevel', 'editView')">编辑</a>
					<a href="javascript:if (confirm('是否删除')) {document.getElementById('productLevelID').value='<%=data.get("productLevelID")%>';postModuleAndAction('productLevel','delete')}">删除</a>
				</td>
			</tr>
			<%	} %>
		</table>
	</div>
	
	<% } else if (JSPDataBean.getFormData("action").equals("addView") 
			   || JSPDataBean.getFormData("action").equals("editView")
			   || JSPDataBean.getFormData("action").equals("confirm")) { 
			String[] columns = {"name"};
			AppUtil.convertToHtml(columns, JSPDataBean.getFormDatas());
	%>
		<div class="record">
		<%@include file="common/commonEditTitle.jsp" %>
		<table border="0" cellspacing="0" cellpadding="0" width="100%">
			<tr>
			  <th><span class="red">* </span>名称：</th>
			  <td><input type="text" name="name" id="name" size="60" maxlength="10" value="<%= JSPDataBean.getFormData("name") %>" /></td>
			</tr>
		</table>
		
		<div align="center">
			<div class="button">
				<a class="btn_bb1" id="btnSave" onclick="javascript:postModuleAndAction('productLevel', 'confirm')"><span>保 存</span></a>
				<a onclick="javascript:postModuleAndAction('productLevel', 'list')" class="btn_bb1"><span>返 回</span></a>
			</div>
		</div> 
	</div>

	<% } %>	
	<input type="hidden" id="productLevelID" name="productLevelID" value="<%=JSPDataBean.getFormData("productLevelID")%>" />
</div>

<%@include file="common/commonFooter.jsp" %>

<script type="text/javascript">

</script>








