<%@ page contentType="text/html;charset=UTF-8"%>
<jsp:directive.page import="java.util.Vector"/>
<jsp:directive.page import="java.util.Hashtable"/>
<%@page import="java.util.Iterator"%>
<%@page import="admin.customer.guanwangbao.AppUtil"%>
<%@page import="admin.customer.guanwangbao.LocalDataCache"%>
<%@page import="simpleWebFrame.util.PriceUtil"%>
<jsp:useBean id="JSPDataBean" scope='request' class="simpleWebFrame.web.JSPDataBean" />

<%@include file="common/commonHeader.jsp" %>
<div class="headDiv">
	<div class="btn_t left"><a href="javascript:postModuleAndAction('singlePage','defaultView')"><span><strong>普通单页</strong></span></a></div>

	<% if (JSPDataBean.getFormData("action").equals("list")) { %>
		<div class="tip gray9" style="float: right;"><a href="javascript:postModuleAndAction('singlePage', 'addView')" class="btn_y"><span><strong class="icon_add">添加</strong></span></a> </div>
	<% } %>
</div>

<div class="main clear">
	<div class="clear"></div>
	
	<% if (JSPDataBean.getFormData("action").equals("list")) { %>

	<div>
		<table class="list" border="0" cellpadding="0" cellspacing="1" width="100%" id="tab1">
			<tr>
				<th>标题</th>
				<th>添加时间</th>
				<th>链接</th>
				<th>状态</th>
				<th>操作</th>
			</tr>
			<%
				Vector datas = (Vector) JSPDataBean.getJSPData("datas");
				String[] columns = {"title"};
				AppUtil.convertToHtml(columns, datas);
				for (int i = 0; i < datas.size(); i++) {
					Hashtable data = (Hashtable) datas.get(i);
			%>
			<tr>
				<td><a class="infoLink" href="" target="_blank"><%= data.get("title") %></a></td>
				<td><%= data.get("addTime") %></td>
				<td>/singlePage/<%= data.get("singlePageID") %>.html</td>
				<td>
					<a href="javascript:document.getElementById('singlePageID').value='<%=data.get("singlePageID")%>';postModuleAndAction('singlePage','<%= data.get("validFlag").equals("1") ? "disable" : "enable" %>')">
					<img src="/images/<%= data.get("validFlag").equals("1") ? "yes" : "no"%>.gif" width="15px" border="none"/>
					</a>
				</td>
				<td>
					<a href="javascript:document.getElementById('singlePageID').value='<%=data.get("singlePageID")%>';postModuleAndAction('singlePage','editView')">编辑</a>
				</td>
			</tr>
			<%	} %>
		</table>
	</div>
	
	<% } else if (JSPDataBean.getFormData("action").equals("addView") || JSPDataBean.getFormData("action").equals("confirm") || JSPDataBean.getFormData("action").equals("editView")) {
		String[] columns = {"title"};
		AppUtil.convertToHtml(columns, JSPDataBean.getFormDatas());
		%>
		<div class="record">
		<%@include file="common/commonEditTitle.jsp" %>
			<table border="0" cellspacing="0" cellpadding="0" width="100%">
				<tr>
					<th width="25%"><span class="red">* </span>标题：</th>
					<td><input type="text" name="title" id="title" value="<%= JSPDataBean.getFormData("title") %>" size="30" maxlength="20" /></td>
				</tr>
				<tr>
					<th>详细内容：</th>
					<td></td>
				</tr>
				<tr>
					<th></th>
					<td>
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
				<a class="btn_bb1" id="btnSave" onclick="javascript:postModuleAndAction('singlePage', 'confirm')"><span>保 存</span></a>
				<a onclick="javascript:postModuleAndAction('singlePage','defaultView')" class="btn_bb1"><span>返 回</span></a>
			</div>
		</div>
	</div>
	<% } %>
	<input type="hidden" name="singlePageID" id="singlePageID" value="<%= JSPDataBean.getFormData("singlePageID") %>" />
	<%= JSPDataBean.getFormData("queryConditionHtml") %>	
	
</div>

<%@include file="common/commonFooter.jsp" %>
