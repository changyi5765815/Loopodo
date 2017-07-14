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
	<div class="btn_t left"><a href="javascript:postModuleAndAction('transaction','defaultView')"><span><strong>付款记录</strong></span></a></div>
</div>

<div class="main clear">
	<div class="clear"></div>
	
	<% if (JSPDataBean.getFormData("action").equals("list")) { %>
	<div class="search">
	  	<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td>
					流水号：<input type="text" name="q_transactionID" id="q_transactionID" value="<%= JSPDataBean.getFormData("q_transactionID") %>" size="25" maxlength="50" onkeydown="javascript:if(event.keyCode==13) postModuleAndAction('transaction', 'search')"/>&nbsp;
					交易类型：<%= JSPDataBean.getFormData("queryTransactionTypeSelect") %>&nbsp;
					订单ID：<input type="text" name="q_relateIDs" id="q_relateIDs" value="<%= JSPDataBean.getFormData("q_relateIDs") %>" size="25" maxlength="50" onkeydown="javascript:if(event.keyCode==13) postModuleAndAction('transaction', 'search')"/>&nbsp;
					支付时间：<input type="text" size="12" maxlength="20" id="q_fromPayTime" name="q_fromPayTime" value="<%= JSPDataBean.getFormData("q_fromPayTime").equals("") ? "" : JSPDataBean.getFormData("q_fromPayTime").substring(0, 10) %>" onclick="calendar(this, false);" class="itime" style="cursor: pointer;" readonly onkeydown="javascript:if(event.keyCode==13)postModuleAndAction('transaction', 'search')" />&nbsp;-
			               <input type="text" size="12" maxlength="20" id="q_toPayTime" name="q_toPayTime" value="<%= JSPDataBean.getFormData("q_toPayTime").equals("") ? "" : JSPDataBean.getFormData("q_toPayTime").substring(0, 10) %>" onclick="calendar(this, false);" class="itime" style="cursor: pointer;" readonly onkeydown="javascript:if(event.keyCode==13)postModuleAndAction('transaction', 'search')" />&nbsp;
				</td>
				<td class="righttd">
					<div><dl>
	               		<dt style="width: 100%;">
	                   		<a class="btn_y" onclick="javascript:postModuleAndAction('transaction', 'search')"><span>搜&nbsp;&nbsp;&nbsp;&nbsp;索</span></a>
	                   	</dt>
	              	</dl></div>
				</td>
			</tr>
		</table>
	</div>
	<div>
		<table class="list" border="0" cellpadding="0" cellspacing="1" width="100%" id="tab1">
			<tr>
				<th>流水号</th>
				<th>交易类型</th>
				<th>订单ID</th>
				<th>创建时间</th>
				<th>需付金额</th>
				<th>已支付金额</th>
				<th>支付平台</th>
				<th>平台交易号</th>
				<th>支付时间</th>
				<th>状态</th>
			</tr>
			<%
				Vector datas = (Vector) JSPDataBean.getJSPData("datas");
				for (int i = 0; i < datas.size(); i++) {
					Hashtable data = (Hashtable) datas.get(i);
			%>
			<tr>
				<td><%= data.get("transactionID") %></td>
				<td><%= LocalDataCache.getInstance().getTableDataColumnValue("c_transactionType", data.get("transactionTypeID").toString(), "c_transactionTypeName")  %></td>
				<td><%= data.get("relateIDs") %></td>
				<td><%= data.get("addTime") %></td>
				<td><%= data.get("amount") %></td>
				<td style="color: red"><%= data.get("actualAmount") %></td>
				<td><%= LocalDataCache.getInstance().getTableDataColumnValue("payType", data.get("payTypeID").toString(), "name") %></td>
				<td><%= data.get("transactionNum") %></td>
				<td><%= data.get("payTime") %></td>
				<td><%= LocalDataCache.getInstance().getTableDataColumnValue("c_transactionStatus", data.get("status").toString(), "c_transactionStatusName") %></td>
			</tr>
			<%	} %>
		</table>
			<div class="page blue">
		    <p class="floatl"><%@include file="common/commonJumpPage.jsp" %></p>
		    <div class="clear"></div>
		</div>
	</div>
	
	<% } %>	
	<%= JSPDataBean.getFormData("queryConditionHtml") %>
	<input type="hidden" id="supplierID" name="supplierID" value="<%=JSPDataBean.getFormData("supplierID")%>" />
</div>

<%@include file="common/commonFooter.jsp" %>

<script type="text/javascript">

</script>








