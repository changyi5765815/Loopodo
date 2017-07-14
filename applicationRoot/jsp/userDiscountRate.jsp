<%@ page contentType="text/html;charset=UTF-8"%>
<jsp:directive.page import="java.util.Vector"/>
<jsp:directive.page import="java.util.Hashtable"/>
<%@page import="java.util.Iterator"%>
<%@page import="admin.customer.guanwangbao.AppUtil"%>
<%@page import="simpleWebFrame.util.PriceUtil"%>
<jsp:useBean id="JSPDataBean" scope='request' class="simpleWebFrame.web.JSPDataBean" />

<%@include file="common/commonHeader.jsp" %>

<div class="headDiv">
	<div class="btn_t left"><a href="javascript:postModuleAndAction('userDiscountRate','defaultView')"><span><strong>会员折扣率设置</strong></span></a></div>
</div>

<div class="main clear">
	<div class="clear"></div>
	
	<% if (JSPDataBean.getFormData("action").equals("list")) { %>
	<table class="list" border="0" cellpadding="0" cellspacing="1" width="100%" id="tab1">
		<tr>
			<th width="35%">会员等级</th>
			<th width="65%">折扣率&nbsp;<input type="button" value="更新" onclick="doAction('confirm');"/></th>
		</tr>
		<%
			Vector datas = (Vector) JSPDataBean.getJSPData("datas");
			for (int i = 0; i < datas.size(); i++) {
				Hashtable data = (Hashtable) datas.get(i);
		%>
		<tr>
		  	<td><%= data.get("c_userLevelName") %>折扣率</td>
		  	<td>
		  		<input id="level<%= data.get("c_userLevelID") %>DiscountRate" name="level<%= data.get("c_userLevelID") %>DiscountRate" value="<%= data.get("levelDiscountRate") %>" maxlength="20" size="50" placeholder="如5折扣请填写0.5，不填写则表示不打折"/>
	  		</td>
		</tr>
		<%	} %>
	</table>
	<% } %>
</div>

<%@include file="common/commonFooter.jsp" %>
