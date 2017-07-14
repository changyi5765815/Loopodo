<%@ page contentType="text/html;charset=UTF-8"%>
<jsp:directive.page import="java.util.Vector"/>
<jsp:directive.page import="java.util.Hashtable"/>
<%@page import="java.util.Iterator"%>
<%@page import="admin.customer.guanwangbao.AppUtil"%>

<jsp:useBean id="JSPDataBean" scope='request' class="simpleWebFrame.web.JSPDataBean" />

<%@include file="common/commonHeader.jsp" %>
<div class="headDiv">
<div class="btn_t left"><a href="javascript:postModuleAndAction('friendshipLink','defaultView')"><span><strong>友情链接/合作客户管理</strong></span></a></div>
<% if(JSPDataBean.getFormData("action").equals("list")) {%>
	<div class="tip gray9" style="float: right;"><a href="javascript:postModuleAndAction('friendshipLink', 'addView')" class="btn_y"><span><strong class="icon_add">添加</strong></span></a> </div>
<% } %>
</div>

<div class="main clear">
	<div class="clear"></div>
	<% if (JSPDataBean.getFormData("action").equals("list")) {%>
	<div>
		<table class="list" border="0" cellpadding="0" cellspacing="1" width="100%" id="tab1">
			<tr>
				<th>ID</th>
				<th>分类</th>
				<th>名称</th>
				<th>排序&nbsp;<input value="更新" onclick="$('#table').val('friendshipLink');doAction('updateSortIndexAll')" type="button"></th>
				<th>链接</th>
				<th>状态</th>
				<th>操作</th>
			</tr>
			<%
				Vector datas = (Vector) JSPDataBean.getJSPData("datas");
				String[] columns = {"name", "link"};
				AppUtil.convertToHtml(columns, datas);
				for (int i = 0; i < datas.size(); i++) {
					Hashtable data = (Hashtable) datas.get(i);
					String trClass = "tr_line" + (i % 2);
			%>
			<tr class="<%=trClass %>">
				<td><%= data.get("friendshipLinkID") %></td>
				<td><%= data.get("friendshipLinkTypeID").equals("1") ? "友情链接" : (data.get("friendshipLinkTypeID").equals("2") ? "平台合作客户" : "") %></td>
				<td><%= data.get("name") %></td>
				<td>
					<input id="sortIndex_<%= data.get("friendshipLinkID") %>" name="sortIndex_<%= data.get("friendshipLinkID") %>" value="<%= data.get("sortIndex") %>" size="5" maxlength="11" type="text">
				</td>
				<td><%= data.get("link") %></td>
				<td>
					<% if (data.get("validFlag").equals("1")) { %>
					<a href="javascript:document.getElementById('friendshipLinkID').value= '<%= data.get("friendshipLinkID")%>'; postModuleAndAction('friendshipLink','disable')"/>
					<% }else{ %>
					<a href="javascript:document.getElementById('friendshipLinkID').value= '<%= data.get("friendshipLinkID")%>'; postModuleAndAction('friendshipLink','enable')"/>
					<% } %>
					<img src="/images/<%= data.get("validFlag").equals("1") ? "yes" : "no"%>.gif" width="15px" border="none"/>
				</td>
				<td>
					<a href="javascript:document.getElementById('friendshipLinkID').value='<%= data.get("friendshipLinkID")%>';postModuleAndAction('friendshipLink','editView')">编辑</a>
				</td>
			</tr>
			<% } %>		
		</table>
		<div class="page blue">
	    	<p class="floatl"><%@include file="common/commonJumpPage.jsp" %></p>
		    <div class="clear"></div>
		</div>
	</div>
	<% } else if (JSPDataBean.getFormData("action").equals("addView")
		   || JSPDataBean.getFormData("action").equals("editView")
		   || JSPDataBean.getFormData("action").equals("confirm")) {
		   	String[] columns = {"name", "link"};
			AppUtil.convertToHtml(columns, JSPDataBean.getFormDatas());
	%>
	<div class="record">
		<%@include file="common/commonEditTitle.jsp" %>
		<table border="0" cellspacing="0" cellpadding="0" width="100%">
			<tr>
				<th><span class="red">* </span>分类：</th>
				<td>
					<select name="friendshipLinkTypeID">
						<option value="1" <%= JSPDataBean.getFormData("friendshipLinkTypeID").equals("1") ? "selected='selected'" : "" %>>友情链接</option>
						<option value="2" <%= JSPDataBean.getFormData("friendshipLinkTypeID").equals("2") ? "selected='selected'" : "" %>>平台合作客户</option>
					</select>
				</td>
			</tr>
			<tr>
				<th><span class="red">* </span>名称：</th>
				<td>
					<input type="text" name="name" id="name" value="<%=JSPDataBean.getFormData("name")%>" size="30" maxlength="50" />
				</td>
			</tr>
			<tr>
				<th>友情链接：</th>
				<td>
					<input type="text" name="link" id="link" value="<%=JSPDataBean.getFormData("link")%>" size="30" maxlength="200" />
				</td>
			</tr>
		</table>
		
		<div align="center">
			<div class="button">
				<a class="btn_bb1" id="btnSave" onclick="javascript:postModuleAndAction('friendshipLink', 'friendshipLink')"><span>保 存</span></a> 
				<a onclick="javascript:postModuleAndAction('friendshipLink', 'defaultView')" class="btn_bb1"><span>返 回</span></a>
			</div>
		</div> 
	</div>	
	<% } %>
</div>

<input type="hidden" id="friendshipLinkID" name="friendshipLinkID" value="<%=JSPDataBean.getFormData("friendshipLinkID")%>" />

<%@include file="common/commonFooter.jsp" %>
