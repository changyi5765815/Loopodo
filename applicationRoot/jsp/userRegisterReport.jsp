<%@ page contentType="text/html;charset=UTF-8"%>
<jsp:directive.page import="java.util.Vector"/>
<jsp:directive.page import="java.util.Hashtable"/>
<%@page import="java.util.Iterator"%>
<%@page import="simpleWebFrame.util.StringUtil"%>
<jsp:useBean id="JSPDataBean" scope='request' class="simpleWebFrame.web.JSPDataBean" />

<%@include file="common/commonHeader.jsp" %>

<div class="headDiv">
<% if (JSPDataBean.getFormData("action").startsWith("list")) { %>
	<div class="btn_t left"><a href="javascript:postModuleAndAction('userRegisterReport','defaultView')"><span><strong>用户日注册统计</strong></span></a></div>
<% } %>
</div>

<div class="main clear">
	<div class="clear"></div>
<% if (JSPDataBean.getFormData("action").equals("list")) { %>
	<div class="search">
	  	<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td>
	                <div><dl>
	                   <dd style="width: auto;">注册日期：
	                   		<input type="text" size="12" id="q_fromTime" name="q_fromTime" value="<%= JSPDataBean.getFormData("q_fromTime") %>" onclick="calendar(this, false);" class="itime" style="cursor: pointer;" readonly onkeydown="javascript:if(event.keyCode==13)postModuleAndAction('userRegisterReport', 'search')" />&nbsp;-&nbsp;
	                   		<input type="text" size="12" id="q_toTime" name="q_toTime" value="<%= JSPDataBean.getFormData("q_toTime") %>" onclick="calendar(this, false);" class="itime" style="cursor: pointer;" readonly onkeydown="javascript:if(event.keyCode==13)postModuleAndAction('userRegisterReport', 'search')" />&nbsp;
	                   	</dd>
	              	</dl></div>
				</td>
				<td class="righttd">
					<div><dl>
	               		<dt style="width: 100px">
	                   		<a class="btn_y" onclick="javascript:postModuleAndAction('userRegisterReport', 'search')"><span>搜&nbsp;&nbsp;&nbsp;&nbsp;索</span></a>
	                   	</dt>
	              	</dl></div>
				</td>
			</tr>
		</table>
	</div>
	<div>
		<table class="list" border="0" cellpadding="0" cellspacing="1" width="100%" id="tab1">
		<tr>
			<th width="40%">注册日期</th>
			<th width="*">注册量</th>
		</tr>
		<%
			Vector datas = (Vector) JSPDataBean.getJSPData("datas");
			Hashtable orderDayCountHash = (Hashtable) JSPDataBean.getJSPData("orderDayCountHash");
			for (int i = 0; i < datas.size(); i++) {
				Hashtable data = (Hashtable) datas.get(i);
				Hashtable orderCountHash = (Hashtable) orderDayCountHash.get(data.get("registerTime").toString());
		%>
		<tr>
			<td><%= data.get("registerTime") %></td>
			<td><%= data.get("userRegisterCount") %></td>
		</tr>
		<%	} %>
		</table>
		<div class="page blue">
		    <p class="floatl"><%@include file="common/commonJumpPage.jsp" %></p>
		    <div class="clear"></div>
		</div>
	</div>
<% } %>
</div>

<%@include file="common/commonFooter.jsp" %>
