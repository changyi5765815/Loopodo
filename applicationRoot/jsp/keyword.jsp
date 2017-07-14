<%@ page contentType="text/html;charset=UTF-8"%>
<jsp:directive.page import="java.util.Vector"/>
<jsp:directive.page import="java.util.Hashtable"/>
<%@page import="java.util.Iterator"%>
<%@page import="admin.customer.guanwangbao.AppUtil"%>

<jsp:useBean id="JSPDataBean" scope='request' class="simpleWebFrame.web.JSPDataBean" />

<%@include file="common/commonHeader.jsp" %>
<div class="headDiv">
	<div class="btn_t left"><a href="javascript:postModuleAndAction('keyword','defaultView')"><span><strong>关键字设置</strong></span></a></div>
	
	<% if(JSPDataBean.getFormData("action").equals("list")) {%>
	<div class="tip gray9" style="float: right;"><a href="javascript:postModuleAndAction('keyword', 'keywordAddView')" class="btn_y"><span><strong class="icon_add">添加关键字</strong></span></a> </div>
	</div>
	<% } %>
<div class="main clear">
	<div class="clear"></div>
	<% if (JSPDataBean.getFormData("action").equals("list")) {%>
	<div>
		<table class="list" border="0" cellpadding="0" cellspacing="1" width="100%" id="tab1">
			<tr>
				<th>关键字ID</th>
				<th>名称</th>
				<th>排序值&nbsp;<input value="更新" onclick="$('#table').val('keyword');$('#sortIndexColumnName').val('sortIndex');doAction('updateSortIndexAll')" type="button"></th>
				<th>状态</th>
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
				<td><%= data.get("keywordID") %></td>
				<td><%= data.get("name") %></td>
				<td>
					<input id="sortIndex_<%= data.get("keywordID") %>" name="sortIndex_<%= data.get("keywordID") %>" value="<%= data.get("sortIndex") %>" size="5" maxlength="11" type="text">
				</td>
				<td>
					<% if (data.get("validFlag").equals("1")) {%>
					<a href="javascript:document.getElementById('keywordID').value= '<%= data.get("keywordID")%>'; postModuleAndAction('keyword','keywordDisable')"/>
					<% }else{ %>
					<a href="javascript:document.getElementById('keywordID').value= '<%= data.get("keywordID")%>'; postModuleAndAction('keyword','keywordEnable')"/>
					<% } %>
					<img src="/images/<%= data.get("validFlag").equals("1") ? "yes" : "no"%>.gif" width="15px" border="none"/>
				</td>
				<td>
					<a href="javascript:document.getElementById('keywordID').value='<%=data.get("keywordID")%>';postModuleAndAction('keyword','keywordEditView')">编辑</a>
					<a href="javascript:if (confirm('是否删除')) {document.getElementById('keywordID').value='<%=data.get("keywordID")%>';postModuleAndAction('keyword','delete')}">删除</a>
				</td>
			</tr>
			<% } %>		
		</table>
	</div>
	<% } else if (JSPDataBean.getFormData("action").equals("keywordAddView")
	    || JSPDataBean.getFormData("action").equals("keywordEditView")
		|| JSPDataBean.getFormData("action").equals("keywordConfirm")) {
	%>
	<div class="record">
		<%@include file="common/commonEditTitle.jsp" %>
		<table border="0" cellspacing="0" cellpadding="0" width="100%">
			<tr>
				<th><span class="red">* </span>关键字名称：</th>
				<td>
					<input type="text" name="name" id="name" value="<%=JSPDataBean.getFormData("name")%>" size="30" maxlength="20" />
				</td>
			</tr>
		</table>
		<div align="center">
			<div class="button">
				<a class="btn_bb1" id="btnSave" onclick="javascript:postModuleAndAction('keyword', 'keywordConfirm')"><span>保 存</span></a>
				<a class="btn_bb1" onclick="javascript:postModuleAndAction('keyword', 'defaultView')" ><span>返 回</span></a>
			</div>
		</div> 
	</div>	
	<% } %>
	
</div>

<input type="hidden" id="keywordID" name="keywordID" value="<%=JSPDataBean.getFormData("keywordID")%>" />

<%@include file="common/commonFooter.jsp" %>
