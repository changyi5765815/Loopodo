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
	<div class="btn_t<%= JSPDataBean.getFormData("action").equals("list") ? "" : "0" %> left"><a href="javascript:postModuleAndAction('orderReport','defaultView')"><span><strong>订单统计</strong></span></a></div>
	<div class="btn_t<%= JSPDataBean.getFormData("action").equals("list2") ? "" : "0" %>  left"><a href="javascript:postModuleAndAction('orderReport','list2')"><span><strong>店铺销售统计</strong></span></a></div>
	<div class="btn_t<%= JSPDataBean.getFormData("action").equals("list3") ? "" : "0" %>  left"><a href="javascript:postModuleAndAction('orderReport','list3')"><span><strong>店铺营销情况统计</strong></span></a></div>
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
	                   		<input type="text" size="12" id="q_fromOrderTime" name="q_fromOrderTime" value="<%= JSPDataBean.getFormData("q_fromOrderTime") %>" onclick="calendar(this, false);" class="itime" style="cursor: pointer;" readonly onkeydown="javascript:if(event.keyCode==13)postModuleAndAction('orderReport', 'search')" />&nbsp;-&nbsp;
	                   		<input type="text" size="12" id="q_toOrderTime" name="q_toOrderTime" value="<%= JSPDataBean.getFormData("q_toOrderTime") %>" onclick="calendar(this, false);" class="itime" style="cursor: pointer;" readonly onkeydown="javascript:if(event.keyCode==13)postModuleAndAction('orderReport', 'search')" />&nbsp;
	                   	</dd>
	                   <dd style="width: auto;">店铺：
	                   		<input type="text" id="q_supplierName" name="q_supplierName" value="<%= JSPDataBean.getFormData("q_supplierName") %>" onclick="openInfoWindow('common', 'selectSupplierWindow')" style="cursor: pointer;" readonly onkeydown="javascript:if(event.keyCode==13)postModuleAndAction('orderReport', 'search')" />
	                   		<input type="hidden" id="q_supplierID" name="q_supplierID" value="<%= JSPDataBean.getFormData("q_supplierID") %>" /><a href="javascript:;" onclick="$('#q_supplierID').val('');$('#q_supplierName').val('');">清除</a>&nbsp;&nbsp;
	                   	</dd>
	                   <dd style="width: auto;">订单总数范围：
	                   		<input type="text" id="q_orderNumFrom" name="q_orderNumFrom" value="<%= JSPDataBean.getFormData("q_orderNumFrom") %>" size="8" onkeydown="javascript:if(event.keyCode==13)postModuleAndAction('orderReport', 'search')" />-
	                   		<input type="text" id="q_orderNumTo" name="q_orderNumTo" value="<%= JSPDataBean.getFormData("q_orderNumTo") %>" size="8" onkeydown="javascript:if(event.keyCode==13)postModuleAndAction('orderReport', 'search')" />
	                   	</dd>
	                   <dd style="width: auto;">订单总金额范围：
	                   		<input type="text" id="q_orderMoneyFrom" name="q_orderMoneyFrom" value="<%= JSPDataBean.getFormData("q_orderMoneyFrom") %>" size="15" onkeydown="javascript:if(event.keyCode==13)postModuleAndAction('orderReport', 'search')" />-
	                   		<input type="text" id="q_orderMoneyTo" name="q_orderMoneyTo" value="<%= JSPDataBean.getFormData("q_orderMoneyTo") %>" size="15" onkeydown="javascript:if(event.keyCode==13)postModuleAndAction('orderReport', 'search')" />
	                   	</dd>
	              	</dl></div>
				</td>
				<td class="righttd">
					<div><dl>
	               		<dt style="width: 100px">
	                   		<a class="btn_y" onclick="javascript:postModuleAndAction('orderReport', 'search')"><span>搜&nbsp;&nbsp;&nbsp;&nbsp;索</span></a>
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
			<th>总订单</th>
			<th>总订单金额</th>
			<th>未付款订单</th>
			<th>待审核订单</th>
			<th>待配货订单</th>
			<th>待发货订单</th>
			<th>已发货订单</th>
			<th>已签收订单</th>
			<th>交易成功订单</th>
			<th>交易关闭订单</th>		
		</tr>
		<%
			Vector datas = (Vector) JSPDataBean.getJSPData("datas");
			for (int i = 0; i < datas.size(); i++) {
				Hashtable data = (Hashtable) datas.get(i);
		%>
		<tr>
			<td><%= data.get("orderTime") %></td>
			<td><%= data.get("totalOrderNum") %></td>
			<td><%= PriceUtil.formatPrice((String)data.get("sumPrice")) %></td>
			<td><%= data.get("status1Num") %></td>
			<td><%= data.get("status7Num") %></td>
			<td><%= data.get("status2Num") %></td>
			<td><%= data.get("status8Num") %></td>
			<td><%= data.get("status3Num") %></td>
			<td><%= data.get("status4Num") %></td>
			<td><%= data.get("status5Num") %></td>
			<td><%= data.get("status6Num") %></td>
		</tr>
		<%	} %>
		</table>
		<div class="page blue">
		    <p class="floatl"><%@include file="common/commonJumpPage.jsp" %></p>
		    <div class="clear"></div>
		</div>
	</div>
<% } else  if (JSPDataBean.getFormData("action").equals("list2")) { %>
	<div class="search">
	  	<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td>
	                <div><dl>
	                   <dd style="width: auto;">日期：
	                   		<input type="text" size="12" id="q_fromOrderTime" name="q_fromOrderTime" value="<%= JSPDataBean.getFormData("q_fromOrderTime") %>" onclick="calendar(this, false);" class="itime" style="cursor: pointer;" readonly onkeydown="javascript:if(event.keyCode==13)postModuleAndAction('orderReport', 'list2')" />&nbsp;-&nbsp;
	                   		<input type="text" size="12" id="q_toOrderTime" name="q_toOrderTime" value="<%= JSPDataBean.getFormData("q_toOrderTime") %>" onclick="calendar(this, false);" class="itime" style="cursor: pointer;" readonly onkeydown="javascript:if(event.keyCode==13)postModuleAndAction('orderReport', 'list2')" />&nbsp;
	                   	</dd>
	                   <dd style="width: auto;">店铺：
	                   		<input type="text" id="q_supplierName" name="q_supplierName" value="<%= JSPDataBean.getFormData("q_supplierName") %>" onclick="openInfoWindow('common', 'selectSupplierWindow')" style="cursor: pointer;" readonly onkeydown="javascript:if(event.keyCode==13)postModuleAndAction('orderReport', 'list2')" />
	                   		<input type="hidden" id="q_supplierID" name="q_supplierID" value="<%= JSPDataBean.getFormData("q_supplierID") %>" /><a href="javascript:;" onclick="$('#q_supplierID').val('');$('#q_supplierName').val('');">清除</a>&nbsp;&nbsp;
	                   	</dd>
	              	</dl></div>
				</td>
				<td class="righttd">
					<div><dl>
	               		<dt style="width: 100px">
	                   		<a class="btn_y" onclick="javascript:postModuleAndAction('orderReport', 'list2')"><span>搜&nbsp;&nbsp;&nbsp;&nbsp;索</span></a>
	                   	</dt>
	              	</dl></div>
				</td>
			</tr>
		</table>
	</div>
	<div>
		<table class="list" border="0" cellpadding="0" cellspacing="1" width="100%" id="tab1">
		<tr>
			<th>店铺</th>
			<th>商品ID</th>
			<th>商品名称</th>
			<th>销售总量</th>
			<th>销售总额</th>
		</tr>
		<%
			Vector datas = (Vector) JSPDataBean.getJSPData("datas");
			for (int i = 0; i < datas.size(); i++) {
				Hashtable data = (Hashtable) datas.get(i);
		%>
		<tr>
			<td><%= data.get("supplierName") %></td>
			<td><%= data.get("productID") %></td>
			<td><%= data.get("name") %></td>
			<td><%= data.get("totalNum") %></td>
			<td><%= PriceUtil.formatPrice((String)data.get("sumPrice")) %></td>
		</tr>
		<% } %>
		</table>
		<div class="page blue">
		    <p class="floatl"><%@include file="common/commonJumpPage.jsp" %></p>
		    <div class="clear"></div>
		</div>
	</div>
<% } else  if (JSPDataBean.getFormData("action").equals("list3")) { %>
	<div class="search">
	  	<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td>
	                <div><dl>
	                   <dd style="width: auto;">日期：
	                   		<input type="text" size="12" id="q_fromOrderTime" name="q_fromOrderTime" value="<%= JSPDataBean.getFormData("q_fromOrderTime") %>" onclick="calendar(this, false);" class="itime" style="cursor: pointer;" readonly onkeydown="javascript:if(event.keyCode==13)postModuleAndAction('orderReport', 'list3')" />&nbsp;-&nbsp;
	                   		<input type="text" size="12" id="q_toOrderTime" name="q_toOrderTime" value="<%= JSPDataBean.getFormData("q_toOrderTime") %>" onclick="calendar(this, false);" class="itime" style="cursor: pointer;" readonly onkeydown="javascript:if(event.keyCode==13)postModuleAndAction('orderReport', 'list3')" />&nbsp;
	                   	</dd>
	                   <dd style="width: auto;">店铺：
	                   		<input type="text" id="q_supplierName" name="q_supplierName" value="<%= JSPDataBean.getFormData("q_supplierName") %>" onclick="openInfoWindow('common', 'selectSupplierWindow')" style="cursor: pointer;" readonly onkeydown="javascript:if(event.keyCode==13)postModuleAndAction('orderReport', 'list3')" />
	                   		<input type="hidden" id="q_supplierID" name="q_supplierID" value="<%= JSPDataBean.getFormData("q_supplierID") %>" /><a href="javascript:;" onclick="$('#q_supplierID').val('');$('#q_supplierName').val('');">清除</a>&nbsp;&nbsp;
	                   	</dd>
	              	</dl></div>
				</td>
				<td class="righttd">
					<div><dl>
	               		<dt style="width: 100px">
	                   		<a class="btn_y" onclick="javascript:postModuleAndAction('orderReport', 'list3')"><span>搜&nbsp;&nbsp;&nbsp;&nbsp;索</span></a>
	                   	</dt>
	              	</dl></div>
				</td>
			</tr>
		</table>
	</div>
	<div>
		<table class="list" border="0" cellpadding="0" cellspacing="1" width="100%" id="tab1">
		<tr>
			<th>店铺</th>
			<th>成交订单总数</th>
			<th>退货单总数</th>
			<th>退款单总数</th>
		</tr>
		<%
			Vector datas = (Vector) JSPDataBean.getJSPData("datas");
			for (int i = 0; i < datas.size(); i++) {
				Hashtable data = (Hashtable) datas.get(i);
		%>
		<tr>
			<td><%= data.get("supplierName") %></td>
			<td><%= data.get("countShopOrder") %></td>
			<td><%= data.get("countRefund") %></td>
			<td><%= data.get("countRet") %></td>
		</tr>
		<% } %>
		</table>
		<div class="page blue">
		    <p class="floatl"><%@include file="common/commonJumpPage.jsp" %></p>
		    <div class="clear"></div>
		</div>
	</div>
<% } %>
</div>

<%@include file="common/commonFooter.jsp" %>
