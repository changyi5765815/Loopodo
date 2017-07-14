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
	<div class="btn_t left"><a href="javascript:postModuleAndAction('brandType','defaultView')"><span><strong>品牌分类管理</strong></span></a></div>
	<% if (JSPDataBean.getFormData("action").equals("list")) { %>
		<div class="tip gray9" style="float: right;"><a href="javascript:postModuleAndAction('brandType', 'addView')" class="btn_y"><span><strong class="icon_add">添加</strong></span></a> </div>
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
				<th>排序&nbsp;<input type="button" value="更新" onclick="$('#table').val('brandType');doAction('updateSortIndexAll')"/></th>
				<th>状态</th>
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
				<td><%= data.get("brandTypeID") %></td>
				<td><%= data.get("name") %></td>
				<td>
					<input id="sortIndex_<%= data.get("brandTypeID") %>" name="sortIndex_<%= data.get("brandTypeID") %>" value="<%= data.get("sortIndex") %>" size="5" maxlength="8" type="text">
				</td>
				<td>
				<% if (data.get("validFlag").equals("1")) { %>
					<a href="javascript:document.getElementById('brandTypeID').value='<%= data.get("brandTypeID") %>';postModuleAndAction('brandType','disable')">
				<% } else { %>
					<a href="javascript:document.getElementById('brandTypeID').value='<%= data.get("brandTypeID") %>';postModuleAndAction('brandType','enable')">
				<% } %>
					<img src="/images/<%= data.get("validFlag").equals("1") ? "yes" : "no"%>.gif" width="15px" border="none"/>
					</a>
				</td>
				<td>
					<a href="javascript:document.getElementById('brandTypeID').value='<%= data.get("brandTypeID") %>';postModuleAndAction('brandType', 'editView')">编辑</a>
				</td>
			</tr>
			<%	} %>
		</table>
	</div>
	
	<% } else if (JSPDataBean.getFormData("action").equals("addView") 
				|| JSPDataBean.getFormData("action").equals("editView")
				|| JSPDataBean.getFormData("action").equals("confirm")) {  
	%>
		<div class="record">
		<%@include file="common/commonEditTitle.jsp" %>
		<table border="0" cellspacing="0" cellpadding="0" width="100%">
			<tr>
			  <th><span class="red">* </span>名称：</th>
			  <td><input type="text" name="name" id="name" size="60" maxlength="50" value="<%= JSPDataBean.getFormData("name") %>" /></td>
			</tr>
		</table>
		
		<div align="center">
			<div class="button">
				<a class="btn_bb1" id="btnSave" onclick="javascript:postModuleAndAction('brandType', 'confirm')"><span>保 存</span></a>
				<a onclick="javascript:postModuleAndAction('brandType', 'defaultView')" class="btn_bb1"><span>返 回</span></a>
			</div>
		</div> 
	</div>

	<% } %>	
	<input type="hidden" id="brandTypeID" name="brandTypeID" value="<%= JSPDataBean.getFormData("brandTypeID") %>" />
</div>

<%@include file="common/commonFooter.jsp" %>

<script type="text/javascript">

</script>








