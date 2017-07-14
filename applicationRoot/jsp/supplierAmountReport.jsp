<%@ page contentType="text/html;charset=UTF-8"%>
<jsp:directive.page import="java.util.Vector"/>
<jsp:directive.page import="java.util.Hashtable"/>
<%@page import="java.util.Iterator"%>
<%@page import="simpleWebFrame.util.StringUtil"%>
<%@page import="simpleWebFrame.util.PriceUtil"%>
<jsp:useBean id="JSPDataBean" scope='request' class="simpleWebFrame.web.JSPDataBean" />

<%@include file="common/commonHeader.jsp" %>

<div class="headDiv">
<% if (JSPDataBean.getFormData("action").startsWith("list")) { %>
	<div class="btn_t left"><a href="javascript:postModuleAndAction('supplierAmountReport','defaultView')"><span><strong>商户交易统计</strong></span></a></div>
	<div class="tip gray9" style="float: right;"><a href="javascript:doAction('supplierAmountReport', 'export')" class="btn_y"><span><strong class="icon_add">导出</strong></span></a> </div>
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
	                   <dd style="width: auto;">日期：
	                   		<input type="text" size="12" id="q_fromOrderTime" name="q_fromOrderTime" value="<%= JSPDataBean.getFormData("q_fromOrderTime") %>" onclick="calendar(this, false);" class="itime" style="cursor: pointer;" readonly onkeydown="javascript:if(event.keyCode==13)postModuleAndAction('supplierAmountReport', 'search')" />&nbsp;-&nbsp;
	                   		<input type="text" size="12" id="q_toOrderTime" name="q_toOrderTime" value="<%= JSPDataBean.getFormData("q_toOrderTime") %>" onclick="calendar(this, false);" class="itime" style="cursor: pointer;" readonly onkeydown="javascript:if(event.keyCode==13)postModuleAndAction('supplierAmountReport', 'search')" />&nbsp;
	                   	</dd>
	                   <dd style="width: auto;">店铺：
	                   		<input type="text" id="q_supplierName" name="q_supplierName" value="<%= JSPDataBean.getFormData("q_supplierName") %>" onclick="openInfoWindow('common', 'selectSupplierWindow')" style="cursor: pointer;" readonly onkeydown="javascript:if(event.keyCode==13)postModuleAndAction('supplierAmountReport', 'search')" />
	                   		<input type="hidden" id="q_supplierID" name="q_supplierID" value="<%= JSPDataBean.getFormData("q_supplierID") %>" /><a href="javascript:;" onclick="$('#q_supplierID').val('');$('#q_supplierName').val('');">清除</a>&nbsp;&nbsp;
	                   	</dd>
	                   <dd style="width: auto;">统计类型：
	                   		<input type="radio" name="q_dateFlag" <%= JSPDataBean.getFormData("q_dateFlag").equals("1") || JSPDataBean.getFormData("q_dateFlag").equals("") ? "checked='checked'" : "" %> value="1" onkeydown="javascript:if(event.keyCode==13)postModuleAndAction('supplierAmountReport', 'search')" />按天
	                   		<input type="radio" name="q_dateFlag" <%= JSPDataBean.getFormData("q_dateFlag").equals("0") ? "checked='checked'" : "" %> value="0" onkeydown="javascript:if(event.keyCode==13)postModuleAndAction('supplierAmountReport', 'search')" />按月&nbsp;&nbsp;
	                   	</dd>
	              	</dl></div>
				</td>
				<td class="righttd">
					<div><dl>
	               		<dt style="width: 100px">
	                   		<a class="btn_y" onclick="javascript:postModuleAndAction('supplierAmountReport', 'search')"><span>搜&nbsp;&nbsp;&nbsp;&nbsp;索</span></a>
	                   	</dt>
	              	</dl></div>
				</td>
			</tr>
		</table>
	</div>
	<div>
		<table class="list" border="0" cellpadding="0" cellspacing="1" width="100%" id="tab1">
		<tr>
			<th>日期</th>
			<th>店铺</th>
			<th>收入</th>
			<th>支出</th>		
		</tr>
		<%
			Vector datas = (Vector) JSPDataBean.getJSPData("datas");
			for (int i = 0; i < datas.size(); i++) {
				Hashtable data = (Hashtable) datas.get(i);
		%>
		<tr>
			<td><%= data.get("addTime") %></td>
			<td><%= data.get("name") %></td>
			<td><%= data.get("amountIn") %></td>
			<td><%= data.get("amountOut") %></td>
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
