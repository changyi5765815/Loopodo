<%@ page contentType="text/html;charset=UTF-8"%>
<jsp:directive.page import="java.util.Vector"/>
<jsp:directive.page import="java.util.Hashtable"/>
<%@page import="java.util.Iterator"%>
<%@page import="admin.customer.guanwangbao.AppUtil"%>
<jsp:useBean id="JSPDataBean" scope='request' class="simpleWebFrame.web.JSPDataBean" />

<%@include file="common/commonHeader.jsp" %>

<div class="headDiv">
<% if (JSPDataBean.getFormData("action").startsWith("tinyType")) { %>
	<div class="btn_t0 left"><a href="javascript:postModuleAndAction('type','defaultView')"><span><strong>大分类设置</strong></span></a></div>
	<div class="btn_t0 left"><a href="javascript:postModuleAndAction('type', 'smallTypeDefaultView')"><span><strong>小分类设置</strong></span></a></div>
	<div class="btn_t left"><a href="javascript:postModuleAndAction('type', 'tinyTypeDefaultView')"><span><strong>细分类设置</strong></span></a></div>
<% } else if (JSPDataBean.getFormData("action").startsWith("smallType")) { %>
	<div class="btn_t0 left"><a href="javascript:postModuleAndAction('type','defaultView')"><span><strong>大分类设置</strong></span></a></div>
	<div class="btn_t left"><a href="javascript:postModuleAndAction('type', 'smallTypeDefaultView')"><span><strong>小分类设置</strong></span></a></div>
<% } else { %>
	<div class="btn_t left"><a href="javascript:postModuleAndAction('type','defaultView')"><span><strong>大分类设置</strong></span></a></div>
<% } %>

<% if (JSPDataBean.getFormData("action").equals("list")) { %>
	<div class="tip gray9" style="float: right;"><a href="javascript:postModuleAndAction('type', 'addView')" class="btn_y"><span><strong class="icon_add">添加大分类</strong></span></a> </div>
<% } else if (JSPDataBean.getFormData("action").equals("smallTypeDefaultView")) { %>
	<div class="tip gray9" style="float: right;"><a href="javascript:postModuleAndAction('type','smallTypeAddView')" class="btn_y"><span><strong class="icon_add">添加小分类</strong></span></a> </div>
<% } else if (JSPDataBean.getFormData("action").equals("tinyTypeDefaultView")) { %>
	<div class="tip gray9" style="float: right;"><a href="javascript:postModuleAndAction('type','tinyTypeAddView')" class="btn_y"><span><strong class="icon_add">添加细分类</strong></span></a> </div>
<% } %>
</div>

<div class="main clear">
	<div class="clear"></div>
	
<% if (JSPDataBean.getFormData("action").equals("list")) { %>
	<div>
		<table class="list" border="0" cellpadding="0" cellspacing="1" width="100%" id="tab1">
		<tr>
			<th>大分类ID</th>
			<th>名称</th>
			<th>排序&nbsp;<input value="更新" onclick="$('#table').val('bigType');doAction('updateSortIndexAll')" type="button"></th>
			<th>状态</th>
			<th>操作</th>
		</tr>
		<%
			Vector datas = (Vector) JSPDataBean.getJSPData("datas");
			String[] columns = {"name"};
			AppUtil.convertToHtml(columns, datas);
			for (int i = 0; i < datas.size(); i++) {
				Hashtable data = (Hashtable) datas.get(i);
				String trClass = "tr_line" + (i % 2);
		%>
		<tr class="<%= trClass %>">
			<td><%= data.get("bigTypeID") %></td>
			<td><%= data.get("name") %></td>
			<td>
				<input id="sortIndex_<%= data.get("bigTypeID") %>" name="sortIndex_<%= data.get("bigTypeID") %>" value="<%= data.get("sortIndex") %>" size="5" maxlength="11" type="text">
			</td>
			<td>
				<% if (data.get("validFlag").equals("1")) { %>
				<a href="javascript:document.getElementById('bigTypeID').value='<%=data.get("bigTypeID")%>';postModuleAndAction('type','disable')">
				<% } else { %>
				<a href="javascript:document.getElementById('bigTypeID').value='<%=data.get("bigTypeID")%>';postModuleAndAction('type','enable')">
				<% } %>
				<img src="/images/<%= data.get("validFlag").equals("1") ? "yes" : "no"%>.gif" width="15px" border="none"/>
				</a>
			</td>
			<td>
				<a href="javascript:document.getElementById('bigTypeID').value='<%= data.get("bigTypeID") %>';postModuleAndAction('type','editView')">编辑</a>
				<a href="javascript:document.getElementById('bigTypeID').value='<%= data.get("bigTypeID") %>';postModuleAndAction('type','smallTypeDefaultView')">小分类</a>
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
		  <td><input type="text" name="name" id="name" size="30" maxlength="50" value="<%= JSPDataBean.getFormData("name") %>" /></td>
		</tr>
		</table>
		<div align="center">
			<div class="button">
				<a class="btn_bb1" id="btnSave" onclick="javascript:postModuleAndAction('type', 'confirm')"><span>保 存</span></a>
				<a onclick="javascript:postModuleAndAction('type', 'defaultView')" class="btn_bb1"><span>返 回</span></a>
			</div>
		</div> 
	</div>
<% } else if (JSPDataBean.getFormData("action").equals("smallTypeDefaultView")) {%>
	<div>
		<table class="list" border="0" cellpadding="0" cellspacing="1" width="100%" id="tab1">
		<tr>
			<th>小分类ID</th>
			<th>名称</th>
			<th>排序&nbsp;<input value="更新" onclick="$('#table').val('smallType');doAction('updateSortIndexAll')" type="button"></th>
			<th>状态</th>
			<th>操作</th>
		</tr>
		<%
			Vector datas = (Vector) JSPDataBean.getJSPData("datas");
			String[] columns = {"name"};
			AppUtil.convertToHtml(columns, datas);		
			for (int i = 0; i < datas.size(); i++) {
				Hashtable data = (Hashtable) datas.get(i);
				String trClass = "tr_line" + (i % 2);
		%>
		<tr class="<%= trClass %>">
			<td height="28"><%= data.get("smallTypeID") %></td>
			<td><%= data.get("name") %></td>
			<td>
				<input id="sortIndex_<%= data.get("smallTypeID") %>" name="sortIndex_<%= data.get("smallTypeID") %>" value="<%= data.get("sortIndex") %>" size="5" maxlength="11" type="text">
			</td>
			<td>
				<% if (data.get("validFlag").equals("1")) { %>
				<a href="javascript:document.getElementById('smallTypeID').value='<%=data.get("smallTypeID")%>';postModuleAndAction('type','smallTypeDisable')">
				<% } else { %>
				<a href="javascript:document.getElementById('smallTypeID').value='<%=data.get("smallTypeID")%>';postModuleAndAction('type','smallTypeEnable')">
				<% } %>
				<img src="/images/<%= data.get("validFlag").equals("1") ? "yes" : "no"%>.gif" width="15px" border="none"/>
				</a>
			</td>
			<td>
				<a href="javascript:document.getElementById('smallTypeID').value='<%= data.get("smallTypeID") %>';postModuleAndAction('type','smallTypeEditView')">编辑</a>
				<a href="javascript:document.getElementById('smallTypeID').value='<%= data.get("smallTypeID") %>';postModuleAndAction('type','tinyTypeDefaultView')">细分类</a>
			</td>
		</tr>
		<%	} %>
		</table>
	</div>
	
<% } else if (JSPDataBean.getFormData("action").equals("smallTypeAddView") 
		|| JSPDataBean.getFormData("action").equals("smallTypeEditView") 
		|| JSPDataBean.getFormData("action").equals("smallTypeConfirm")) { 
		String[] columns = {"name"};
		AppUtil.convertToHtml(columns, JSPDataBean.getFormDatas());				
%>
	<div class="record">
		<%@include file="common/commonEditTitle.jsp" %>
		<table border="0" cellspacing="0" cellpadding="0" width="100%">
			<tr>
			  <th><span class="red">* </span>名称：</th>
			  <td height="28"><input type="text" name="name" id="name" size="30" maxlength="50" value="<%= JSPDataBean.getFormData("name") %>" /></td>
			</tr>
		</table>
		<div align="center">
			<div class="button">
				<a class="btn_bb1" id="btnSave" onclick="javascript:postModuleAndAction('type', 'smallTypeConfirm')"><span>保 存</span></a>
				<a onclick="javascript:postModuleAndAction('type', 'smallTypeDefaultView')" class="btn_bb1"><span>返 回</span></a>
			</div>
		</div>
	</div>
	
<% } else if (JSPDataBean.getFormData("action").equals("tinyTypeDefaultView")) {%>
	<div>
		<table class="list" border="0" cellpadding="0" cellspacing="1" width="100%" id="tab1">
		<tr>
			<th>细分类ID</th>
			<th>名称</th>
			<th>排序&nbsp;<input value="更新" onclick="$('#table').val('tinyType');doAction('updateSortIndexAll')" type="button"></th>
			<th>状态</th>
			<th>操作</th>
		</tr>
		<%
			Vector datas = (Vector) JSPDataBean.getJSPData("datas");
			String[] columns = {"name"};
			AppUtil.convertToHtml(columns, datas);		
			for (int i = 0; i < datas.size(); i++) {
				Hashtable data = (Hashtable) datas.get(i);
				String trClass = "tr_line" + (i % 2);
		%>
		<tr class="<%= trClass %>">
			<td height="28"><%= data.get("tinyTypeID") %></td>
			<td><%= data.get("name") %></td>
			<td>
				<input id="sortIndex_<%= data.get("tinyTypeID") %>" name="sortIndex_<%= data.get("tinyTypeID") %>" value="<%= data.get("sortIndex") %>" size="5" maxlength="11" type="text">
			</td>
			<td>
				<% if (data.get("validFlag").equals("1")) { %>
				<a href="javascript:document.getElementById('tinyTypeID').value='<%=data.get("tinyTypeID")%>';postModuleAndAction('type','tinyTypeDisable')">
				<% } else { %>
				<a href="javascript:document.getElementById('tinyTypeID').value='<%=data.get("tinyTypeID")%>';postModuleAndAction('type','tinyTypeEnable')">
				<% } %>
				<img src="/images/<%= data.get("validFlag").equals("1") ? "yes" : "no"%>.gif" width="15px" border="none"/>
				</a>
			</td>
			<td>
				<a href="javascript:document.getElementById('tinyTypeID').value='<%= data.get("tinyTypeID") %>';postModuleAndAction('type','tinyTypeEditView')">编辑</a>
			</td>
		</tr>
		<%	} %>
		</table>
	</div>
	
<% } else if (JSPDataBean.getFormData("action").equals("tinyTypeAddView") 
		|| JSPDataBean.getFormData("action").equals("tinyTypeEditView") 
		|| JSPDataBean.getFormData("action").equals("tinyTypeConfirm")) { 
		String[] columns = {"name"};
		AppUtil.convertToHtml(columns, JSPDataBean.getFormDatas());				
%>
	<div class="record">
		<%@include file="common/commonEditTitle.jsp" %>
		<table border="0" cellspacing="0" cellpadding="0" width="100%">
			<tr>
			  <th><span class="red">* </span>名称：</th>
			  <td height="28"><input type="text" name="name" id="name" size="30" maxlength="50" value="<%= JSPDataBean.getFormData("name") %>" /></td>
			</tr>
		</table>
		<div align="center">
			<div class="button">
				<a class="btn_bb1" id="btnSave" onclick="javascript:postModuleAndAction('type', 'tinyTypeConfirm')"><span>保 存</span></a>
				<a onclick="javascript:postModuleAndAction('type', 'tinyTypeDefaultView')" class="btn_bb1"><span>返 回</span></a>
			</div>
		</div>
	</div>
	
<% } %>

<input type="hidden" id="bigTypeID" name="bigTypeID" value="<%= JSPDataBean.getFormData("bigTypeID") %>" />
<input type="hidden" id="smallTypeID" name="smallTypeID" value="<%= JSPDataBean.getFormData("smallTypeID") %>" />
<input type="hidden" id="tinyTypeID" name="tinyTypeID" value="<%= JSPDataBean.getFormData("tinyTypeID") %>" />

</div>

<%@include file="common/commonFooter.jsp" %>
