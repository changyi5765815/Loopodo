<%@ page contentType="text/html;charset=UTF-8"%>
<jsp:directive.page import="java.util.Vector"/>
<jsp:directive.page import="java.util.Hashtable"/>
<%@page import="java.util.Iterator"%>
<%@page import="admin.customer.guanwangbao.AppUtil"%>
<%@page import="admin.customer.guanwangbao.LocalDataCache"%>

<jsp:useBean id="JSPDataBean" scope='request' class="simpleWebFrame.web.JSPDataBean" />

<%@include file="common/commonHeader.jsp" %>
<div class="headDiv">

<div class="btn_t left"><a href="javascript:postModuleAndAction('helpPageType','defaultView')"><span><strong>帮助页分组</strong></span></a></div>

	<% if (JSPDataBean.getFormData("action").equals("list")) { %>
		<div class="tip gray9" style="float: right;"><a href="javascript:postModuleAndAction('helpPageType', 'addView')" class="btn_y"><span><strong class="icon_add">添加</strong></span></a> </div>
	<% } %>
</div>

<div class="main clear">
	<div class="clear"></div>
	<% if (JSPDataBean.getFormData("action").equals("list")) { %>
	<div>
		<table class="list" border="0" cellpadding="0" cellspacing="1" width="100%" id="tab1">
			<tr>
				<th id="s_helpPageID">分组ID</th>
				<th>分组名称</th>
				<th>排序&nbsp;<input value="更新" onclick="$('#table').val('helpPageType');doAction('updateSortIndexAll')" type="button"></th>
				<th>操作</th>
			</tr>
			<%
				Vector datas = (Vector) JSPDataBean.getJSPData("datas");
				String[] columns = {"helpPageTypeName"};
				AppUtil.convertToHtml(columns, datas);
				for (int i = 0; i < datas.size(); i++) {
					Hashtable data = (Hashtable) datas.get(i);
					String trClass = "tr_line" + (i % 2);
			%>
			<tr class="<%=trClass %>">
				<td><%= data.get("helpPageTypeID") %></td>
					<td><%= data.get("helpPageTypeName") %></td>
					<td>
						<input id="sortIndex_<%= data.get("helpPageTypeID") %>" name="sortIndex_<%= data.get("helpPageTypeID") %>" value="<%= data.get("sortIndex") %>" size="5" maxlength="11" type="text">
					</td>
					<td>
				 		<a href="javascript:document.getElementById('helpPageTypeID').value='<%= data.get("helpPageTypeID")%>';postModuleAndAction('helpPageType','editView')">编辑</a>
				 		<a href="javascript:if (confirm('是否确认删除？')) {document.getElementById('helpPageTypeID').value='<%= data.get("helpPageTypeID")%>';postModuleAndAction('helpPageType','delete');}">删除</a>
				 	</td>
			</tr>
			<% } %>		
		</table>
	</div>
	<% } else if(JSPDataBean.getFormData("action").equals("addView")
			 || JSPDataBean.getFormData("action").equals("editView")
			 || JSPDataBean.getFormData("action").equals("confirm")) { 
		String[] columns = {"helpPageTypeName"};
		AppUtil.convertToHtml(columns, JSPDataBean.getFormDatas());
			 %>
	<div class="record">
		<%@include file="common/commonEditTitle.jsp" %>
		<table border="0" cellspacing="0" cellpadding="0" width="100%">
			<tr>
				<th width="25%"><span class="red">* </span>分组名称：</th>
				<td>
					<input type="text" name="helpPageTypeName" id="helpPageTypeName" value="<%=JSPDataBean.getFormData("helpPageTypeName")%>" size="30" maxlength="20" />
				</td>
			</tr>
		</table>
		<div align="center">
			<div class="button">
				<a class="btn_bb1" id="btnSave" onclick="javascript:postModuleAndAction('helpPageType', 'confirm')"><span>保 存</span></a>
				<a class="btn_bb1" onclick="javascript:postModuleAndAction('helpPageType', 'defaultView')" ><span>返 回</span></a>
			</div>
		</div> 
	</div>	
	 <% } %>
</div>

<input type="hidden" name="helpPageTypeID" id="helpPageTypeID" value="<%= JSPDataBean.getFormData("helpPageTypeID") %>">

<%@include file="common/commonFooter.jsp" %>
