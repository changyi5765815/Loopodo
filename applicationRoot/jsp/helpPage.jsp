<%@ page contentType="text/html;charset=UTF-8"%>
<jsp:directive.page import="java.util.Vector"/>
<jsp:directive.page import="java.util.Hashtable"/>
<%@page import="java.util.Iterator"%>
<%@page import="admin.customer.guanwangbao.AppUtil"%>
<%@page import="admin.customer.guanwangbao.LocalDataCache"%>

<jsp:useBean id="JSPDataBean" scope='request' class="simpleWebFrame.web.JSPDataBean" />

<%@include file="common/commonHeader.jsp" %>
<div class="headDiv">

<div class="btn_t left"><a href="javascript:postModuleAndAction('helpPage','defaultView')"><span><strong>帮助页管理</strong></span></a></div>

	<% if (JSPDataBean.getFormData("action").equals("list")) { %>
		<div class="tip gray9" style="float: right;"><a href="javascript:postModuleAndAction('helpPage', 'addView')" class="btn_y"><span><strong class="icon_add">添加</strong></span></a> </div>
	<% } %>
</div>

<div class="main clear">
	<div class="clear"></div>
	<% if (JSPDataBean.getFormData("action").equals("list")) { %>
	<div>
		<table class="list" border="0" cellpadding="0" cellspacing="1" width="100%" id="tab1">
			<tr>
				<th id="s_helpPageID">帮助页ID</th>
				<th>标题</th>
				<th>帮助页分组</th>
				<th>链接</th>
				<th>排序&nbsp;<input value="更新" onclick="$('#table').val('helpPage');doAction('updateSortIndexAll')" type="button"></th>
				<th>状态</th>
				<th>操作</th>
			</tr>
			<%
				Vector datas = (Vector) JSPDataBean.getJSPData("datas");
				String[] columns = {"title", "helpPageTypeName"};
				AppUtil.convertToHtml(columns, datas);
				for (int i = 0; i < datas.size(); i++) {
					Hashtable data = (Hashtable) datas.get(i);
					String trClass = "tr_line" + (i % 2);
			%>
			<tr class="<%=trClass %>">
				<td><%= data.get("helpPageID") %></td>
					<td><%= data.get("title") %></td>
					<td><%= LocalDataCache.getInstance().getTableDataColumnValue("helpPageType", data.get("helpPageTypeID").toString(), "helpPageTypeName") %></td>
					<td>/help/<%= data.get("helpPageID") %>.html</td>
					<td>
						<input id="sortIndex_<%= data.get("helpPageID") %>" name="sortIndex_<%= data.get("helpPageID") %>" value="<%= data.get("sortIndex") %>" size="5" maxlength="11" type="text">
					</td>
					<td>
						<% if (data.get("validFlag").equals("1")) { %>
						<a href="javascript:document.getElementById('helpPageID').value='<%=data.get("helpPageID")%>';postModuleAndAction('helpPage','disable')">
						<% } else { %>
						<a href="javascript:document.getElementById('helpPageID').value='<%=data.get("helpPageID")%>';postModuleAndAction('helpPage','enable')">
						<% } %>
						<img src="/images/<%= data.get("validFlag").equals("1") ? "yes" : "no"%>.gif" width="15px" border="none"/>
						</a>
					</td>
					<td>
						<a href="javascript:document.getElementById('helpPageID').value='<%=data.get("helpPageID")%>';postModuleAndAction('helpPage', 'editView')">编辑</a>
						<a href="javascript:if (confirm('帮助页一旦删除将不能恢复，是否确认删除？')) {document.getElementById('helpPageID').value='<%= data.get("helpPageID")%>';postModuleAndAction('helpPage','delete');}">删除</a>
					</td>
			</tr>
			<% } %>		
		</table>
	</div>
	<% } else if(JSPDataBean.getFormData("action").equals("addView")
			 || JSPDataBean.getFormData("action").equals("editView")
			 || JSPDataBean.getFormData("action").equals("confirm")) { 
		String[] columns = {"title"};
		AppUtil.convertToHtml(columns, JSPDataBean.getFormDatas());
			 %>
	<div class="record">
		<%@include file="common/commonEditTitle.jsp" %>
		<table border="0" cellspacing="0" cellpadding="0" width="100%">
			<tr>
				<th width="25%"><span class="red">* </span>标题：</th>
				<td>
					<input type="text" name="title" id="title" value="<%=JSPDataBean.getFormData("title")%>" size="30" maxlength="50" />
				</td>
			</tr>
			<tr>
				<th><span class="red">* </span>类型：</th>
				<td>
					<%= JSPDataBean.getFormData("helpPageTypeSelect") %>
				</td>
			</tr>
			<tr>
				<th></th>
				<td>
					<input type="checkbox" name="showOnProductPageFlag" id="showOnProductPageFlag" value="1" <%= JSPDataBean.getFormData("showOnProductPageFlag").equals("1") ? "checked=\"checked\"" : "" %> />&nbsp;产品详细页展示
				</td>
			</tr>
			<tr>
				<th><span class="red">* </span>内容：</th>
				<td>
				</td>
			</tr>
			<tr>
				<th></th>
					<script id="ueditor" name="content" type="text/plain"
						style="width:700px;height:300px;"><%= JSPDataBean.getFormData("content") %></script>
					<script type="text/javascript">
						$(function(){
					    	UE.getEditor('ueditor');
						});
					</script>
				</td>
			</tr>	
		</table>
		<div align="center">
			<div class="button">
				<a class="btn_bb1" id="btnSave" onclick="javascript:postModuleAndAction('helpPage', 'confirm')"><span>保 存</span></a>
				<a class="btn_bb1" onclick="javascript:postModuleAndAction('helpPage', 'defaultView')" ><span>返 回</span></a>
			</div>
		</div> 
	</div>	
	 <% } %>
</div>

<input type="hidden" name="helpPageID" id="helpPageID" value="<%= JSPDataBean.getFormData("helpPageID") %>">

<%@include file="common/commonFooter.jsp" %>
