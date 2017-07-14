<%@ page contentType="text/html;charset=UTF-8"%>
<jsp:directive.page import="java.util.Vector"/>
<jsp:directive.page import="java.util.Hashtable"/>
<%@page import="java.util.Iterator"%>
<%@page import="admin.customer.guanwangbao.AppUtil"%>
<%@page import="admin.customer.guanwangbao.LocalDataCache"%>
<%@page import="simpleWebFrame.util.PriceUtil"%>
<%@page import="admin.customer.guanwangbao.AppKeys"%>
<jsp:useBean id="JSPDataBean" scope='request' class="simpleWebFrame.web.JSPDataBean" />

<%@include file="common/commonHeader.jsp" %>

<div class="headDiv">
	<div class="btn_t left"><a href="javascript:postModuleAndAction('supplierCash','defaultView')"><span><strong>店铺提现</strong></span></a></div>
</div>

<div class="main clear">
	<div class="clear"></div>
	
	<% if (JSPDataBean.getFormData("action").equals("list")) { %>
	<div class="search">
	  <table border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr>
			<td>
				提现ID：<input type="text" name="q_supplierCashID" id="q_supplierCashID" value="<%= JSPDataBean.getFormData("q_supplierCashID") %>" size="15" maxlength="6" onkeydown="javascript:if(event.keyCode==13) postModuleAndAction('supplierCash', 'search')"/>&nbsp;
				店铺：<input type="text" name="q_supplierName" id="q_supplierName" value="<%= JSPDataBean.getFormData("q_supplierName") %>" size="15" maxlength="50" onkeydown="javascript:if(event.keyCode==13) postModuleAndAction('supplierCash', 'search')"/>&nbsp;
				状态：<select id="q_status" name="q_status">
                		<option></option>
                		<option value="1" <%= JSPDataBean.getFormData("q_status").equals("1") ? "selected=\"selected\"" : "" %> >提现中</option>
                		<option value="2" <%= JSPDataBean.getFormData("q_status").equals("2") ? "selected=\"selected\"" : "" %> >已完成</option>
                	</select>
			</td>
			<td class="righttd">
				<div><dl>
	               	<dt style="width: 100%;">
	                   	<a class="btn_y" onclick="javascript:postModuleAndAction('supplierCash', 'search')"><span>搜&nbsp;&nbsp;&nbsp;&nbsp;索</span></a>
	                  	</dt>
	              </dl></div>
			</td>
		</tr>
		</table>
	</div>
	<div>
		<table class="list" border="0" cellpadding="0" cellspacing="1" width="100%" id="tab1">
			<tr>
				<th>提现ID</th>
				<th>店铺</th>
				<th>联系人</th>
				<th>联系电话</th>
				<th>联系邮箱</th>
				<th>提现金额</th>
				<th>状态</th>
				<th>开户行</th>
				<th>开户行支行</th>
				<th>开户名</th>
				<th>银行卡号</th>
				<th>申请时间</th>
				<th>打款时间</th>
				<th>备注</th>
				<th>操作</th>
			</tr>
			<%
				Vector datas = (Vector) JSPDataBean.getJSPData("datas");
				String[] columns = {"bankName", "bankBatchName", "bankUserName", "bankNum", "note", "supplierName", "supplierLinkMan"};
				AppUtil.convertToHtml(columns, datas);
				for (int i = 0; i < datas.size(); i++) {
					Hashtable data = (Hashtable) datas.get(i);
			%>
			<tr>
				<td><%= data.get("supplierCashID") %></td>
			  	<td><%= data.get("supplierName") %></td>
			  	<td><%= data.get("supplierLinkMan") %></td>
			  	<td><%= data.get("supplierLinkPhone") %></td>
			  	<td><%= data.get("supplierLinkEmail") %></td>
				<td><%= PriceUtil.formatPrice(data.get("amount").toString()) %></td>
			  	<td><%= data.get("status").equals("1") ? "提现中" : (data.get("status").equals("2") ? "已完成" : "失败") %></td> 
			  	<td><%= data.get("bankName") %></td>
				<td><%= data.get("bankBatchName") %></td>
				<td><%= data.get("bankUserName") %></td>
				<td><%= data.get("bankNum") %></td>
				<td><%= data.get("addTime") %></td>
				<td><%= data.get("finishTime") %></td>
				<td><%= data.get("note") %></td>
			  	<td>
			  		<%	if (data.get("status").equals("1")) { %>
			  		<a href="javascript:document.getElementById('supplierCashID').value='<%= data.get("supplierCashID") %>';openInfoWindow('finishSupplierDaKuanWindow')">打款完成</a>
			  		<%	} %>
			  	</td>
			</tr>
			<%	} %>
		</table>
	</div>
	<% } %>	
	<input type="hidden" id="supplierCashID" name="supplierCashID" value="<%=JSPDataBean.getFormData("supplierCashID")%>" />
</div>

<%@include file="common/commonFooter.jsp" %>
