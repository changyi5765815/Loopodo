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

<%
	String name = JSPDataBean.getFormData("q_consultationTypeID").equals("1") ? "咨询" : "投诉";
%>

<div class="headDiv">	
		<div class="btn_t left"><a href="javascript:postModuleAndAction('consultation','defaultView')"><span><strong>商品<%= name %></strong></span></a></div>
</div>

<div class="main clear">
	<div class="clear"></div>
	
	<% if (JSPDataBean.getFormData("action").equals("list")) { %>
    <div class="search">
	  	<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td>
					<%= name %>ID：<input type="text" name="q_consultationID" id="q_consultationID" value="<%= JSPDataBean.getFormData("q_consultationID") %>" size="25" maxlength="6" onkeydown="javascript:if(event.keyCode==13) postModuleAndAction('consultation', 'search')"/>&nbsp;
					商品名称：<input type="text" name="q_productName" id="q_productName" value="<%= JSPDataBean.getFormData("q_productName") %>" size="25" maxlength="50" onkeydown="javascript:if(event.keyCode==13) postModuleAndAction('consultation', 'search')"/>&nbsp;
					<% if(JSPDataBean.getFormData("q_consultationTypeID").equals("1")) { %>
						是否回复：<%= AppUtil.getSelectString("q_replyFlag", JSPDataBean.getFormData("q_replyFlag"), "1:已回复,0:未回复") %>&nbsp;
					<% } %>
				</td>
				<td class="righttd">
					<div><dl>
	               		<dt style="width: 100%;">
	                   		<a class="btn_y" onclick="javascript:postModuleAndAction('consultation', 'search')"><span>搜&nbsp;&nbsp;&nbsp;&nbsp;索</span></a>
	                   	</dt>
	              	</dl></div>
				</td>
			</tr>
		</table>
		<input type="hidden" name="q_consultationTypeID" id="q_consultationTypeID" value="<%= JSPDataBean.getFormData("q_consultationTypeID") %>">
	</div>
	<div>
		<table class="list" border="0" cellpadding="0" cellspacing="1" width="100%" id="tab1">
			<tr>
				<th><%= name %>ID</th>
				<th><%= name %>人</th>
				<th>商品名称</th>
				<th><%= name %>内容</th>
				<th><%= name %>时间</th>
				<% if(JSPDataBean.getFormData("q_consultationTypeID").equals("1")) { %>
				<th>回复内容</th>
				<th>回复时间</th>
				<th>状态</th>
				<th>操作</th>
				<% } else { %>
				<th>入驻商ID</th>
				<th>入驻商名称</th>
				<% } %>
			</tr>
			<%
				Vector datas = (Vector) JSPDataBean.getJSPData("datas");
				String[] columns = {"showUserName", "productName", "consultationContent", "replyContent"};
				AppUtil.convertToHtml(columns, datas);;
				for (int i = 0; i < datas.size(); i++) {
					Hashtable data = (Hashtable) datas.get(i);
			%>
			<tr>
				<td><%= data.get("consultationID") %></td>
				<td><%= data.get("showUserName") %></td>
				<td><a href="http://<%= AppKeys.DOMAIN_WWW %>/product/<%= data.get("productID") %>.html" target="_blank"><%= data.get("productName") %></a></td>
				<td title="<%= data.get("consultationContent") %>" align="right" style="width: 200px;">
					<div style="word-wrap: break-word;text-align: center;">
					<%= StringUtil.convertXmlChars(data.get("consultationContent").toString()) %>
					</div>
				</td>
				<td><%= data.get("postTime") %></td>
				<% if(JSPDataBean.getFormData("q_consultationTypeID").equals("1")) { %>
				<td title="<%= data.get("replyContent") %>"><%= StringUtil.convertXmlChars(data.get("replyContent").toString()) %></td>
				<td><%= data.get("replyTime") %></td>
				<td>
					<img src="/images/<%= data.get("validFlag").equals("1") ? "yes" : "no"%>.gif" width="15px" border="none"/>
				</td>
				<td align="center">
				<% if(data.get("replyFlag").equals("0")) { %>
				<%-- 
					<a href="javascript:document.getElementById('consultationID').value='<%= data.get("consultationID") %>';openInfoWindow('consultation', 'replyConsultationWindow');">回复</a>
				--%>
				<% } else { %>
					<a href="javascript:document.getElementById('consultationID').value='<%= data.get("consultationID") %>';openInfoWindow('consultation', 'replyConsultationWindow');">查看回复</a>
				<% } %>
				</td>
				<% } else { %>
					<td><%= data.get("supplierID") %></td>
					<td><%= data.get("supplierName") %></td>
				<% } %>
			</tr>
			<%	} %>
		</table>
		<div class="page blue">
		    <p class="floatl"><%@include file="common/commonJumpPage.jsp" %></p>
		    <div class="clear"></div>
		</div>
	</div>
	
	<% } %>

	<input type="hidden" id="consultationID" name="consultationID" value="<%=JSPDataBean.getFormData("consultationID")%>" />
	
</div>

<%@include file="common/commonFooter.jsp" %>









