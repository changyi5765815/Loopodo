<%@ page contentType="text/html;charset=UTF-8"%>
<jsp:directive.page import="java.util.Vector"/>
<jsp:directive.page import="java.util.Hashtable"/>
<%@page import="java.util.Iterator"%>
<%@page import="admin.customer.guanwangbao.AppUtil"%>
<%@page import="admin.customer.guanwangbao.LocalDataCache"%>
<%@page import="simpleWebFrame.util.PriceUtil"%>
<%@page import="admin.customer.guanwangbao.AppKeys"%>
<%@page import="simpleWebFrame.util.StringUtil"%>
<jsp:useBean id="JSPDataBean" scope='request' class="simpleWebFrame.web.JSPDataBean" />

<%@include file="common/commonHeader.jsp" %>

<div class="headDiv">	
	<% if (JSPDataBean.getFormData("action").equals("list") || JSPDataBean.getFormData("action").equals("addView")) { %>
		<div class="btn_t left"><a href="javascript:postModuleAndAction('infoComment','defaultView')"><span><strong>文章评论</strong></span></a></div>
	<% } %>
</div>

<div class="main clear">
	<div class="clear"></div>
	
	<% if (JSPDataBean.getFormData("action").equals("list")) { %>
    <div class="search">
	  	<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td>
					评论ID：<input type="text" name="q_infoCommentID" id="q_infoCommentID" value="<%= JSPDataBean.getFormData("q_infoCommentID") %>" size="25" maxlength="6" onkeydown="javascript:if(event.keyCode==13) postModuleAndAction('infoComment', 'search')"/>&nbsp;
					评论人：<input type="text" name="q_nick" id="q_nick" value="<%= JSPDataBean.getFormData("q_nick") %>" size="25" maxlength="50" onkeydown="javascript:if(event.keyCode==13) postModuleAndAction('infoComment', 'search')"/>&nbsp;
					文章名称：<input type="text" name="q_title" id="q_title" value="<%= JSPDataBean.getFormData("q_title") %>" size="25" maxlength="50" onkeydown="javascript:if(event.keyCode==13) postModuleAndAction('infoComment', 'search')"/>&nbsp;
				</td>
				<td class="righttd">
					<div><dl>
	               		<dt style="width: 100%;">
	                   		<a class="btn_y" onclick="javascript:postModuleAndAction('infoComment', 'search')"><span>搜&nbsp;&nbsp;&nbsp;&nbsp;索</span></a>
	                   	</dt>
	              	</dl></div>
				</td>
			</tr>
		</table>
	</div>
	<div>
		<table class="list" border="0" cellpadding="0" cellspacing="1" width="100%" id="tab1">
			<tr>
				<th width="5%">评论ID</th>
				<th width="10%">评论人</th>
				<th width="30%">文章信息</th>
				<th width="*">评论内容</th>
				<th width="15%">评论时间</th>
				<th width="5%">状态</th>
				<th width="5%">操作</th>
			</tr>
			<%
				Vector datas = (Vector) JSPDataBean.getJSPData("datas");
				String[] columns = {"showUserName", "title", "content"};
				AppUtil.convertToHtml(columns, datas);
				for (int i = 0; i < datas.size(); i++) {
					Hashtable data = (Hashtable) datas.get(i);
			%>
			<tr>
				<td><%= data.get("infoCommentID") %></td>
				<td><%= data.get("nick") %></td>
				<td><a href="http://<%= LocalDataCache.getInstance().getSysConfig("wwwDomain") %>/community/<%= data.get("infoID") %>.html"  target="_blank"><%= data.get("title") %></a></td>
				<td title="<%= StringUtil.convertFromXmlChars(data.get("content").toString()) %>"><%= AppUtil.splitString(data.get("content").toString(), 100) %></td>
				<td><%= data.get("addTime") %></td>
				<td>
					<a href="javascript:document.getElementById('infoCommentID').value='<%= data.get("infoCommentID") %>';postModuleAndAction('infoComment','<%= data.get("validFlag").equals("1") ? "disable" : "enable" %>')">
					<img src="/images/<%= data.get("validFlag").equals("1") ? "yes" : "no"%>.gif" width="15px" border="none"/>
					</a>
				</td>
				<td>
					<a href="javascript:if(confirm('确定删除？')) {document.getElementById('infoCommentID').value='<%= data.get("infoCommentID") %>';postModuleAndAction('infoComment', 'delInfoComment');}">删除</a>
				</td>
			</tr>
			<% } %>
		</table>
		<div class="page blue">
		    <p class="floatl"><%@include file="common/commonJumpPage.jsp" %></p>
		    <div class="clear"></div>
		</div>
	</div>
	<% } %>
	<%= JSPDataBean.getFormData("queryConditionHtml") %>	
	<input type="hidden" id="infoCommentID" name="infoCommentID" value="<%=JSPDataBean.getFormData("infoCommentID")%>" />
</div>
<%@include file="common/commonFooter.jsp" %>