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

<style>
.order_detail_box table.order_detail {
	background: #ccc;
	margin: 0 0 10px 0;
	border-spacing: 1px;
	border-collapse: separate;
}

.order_detail_box table.order_detail td {
	padding: 4px 8px;
	text-align: left;
	height:25px;
	line-height: 25px;
	background: #FFFFFF;
}

.childrenuser_box table.order_detail td {
	padding: 4px 8px;
	text-align: center;
	height:25px;
	line-height: 25px;
	background: #FFFFFF;
}

.order_detail_box table.order_detail tr.order_detail_title td {
	color: #5A5A5A;
	text-align: left;
	padding: 4px 15px;
	background: #F8F8F8;
}

.order_detail_box table.order_detail td.leftbg {
	color: #666;
	background: #F0F0F0;
}

.order_detail_box .order_detail_info {
	margin-top: 5px;
	color: #666666;
	text-align: center;
	line-height: 20px;
}

.order_detail_box .gift_list {
	padding: 5px 0px;
	line-height: 18px;
}

.order_detail_box .goods_txt {
	text-align: left;
}

.order_detail_box .goods_name {
	color: #666666;
}

.order_detail_box .goods_name a:link {
	color: #666666;
}

.order_detail_box .goods_name a:visited {
	color: #666666;
}

.order_detail_box .goods_name a:hover {
	color: #666666;
}

.order_detail_box .good_xiuhua {
	padding: 5px 8px;
	line-height: 25px;
}

.table {
	width: 100%;
	margin-bottom: 20px;
	text-align: center;
	border: 1px solid #ddd;
	color: #666666;
}
.mod-all-btn{
	float: right; 
	margin-left: 5px; 
	margin-right: 5px; 
	position: relative;
}
.mod-all-btn .arrow{
	font-style: normal;
	width: 0px;
	height: 0px;
	border-width: 5px;
	border-style: solid;
	border-color: transparent transparent #fff transparent;
	position: absolute;
	top: 24px;
	left: 30px;
	display: block;
}
.mod-all-drop{ 
	 border: 1px solid #ccc; 
	 box-sizing: border-box; 
	 border-radius: 5px;
	 position: absolute; 
	 top: 27px; 
	 left: 0px; 
	 background: #fff;
	 width: 100%;
	 display: none;
}
.mod-all-drop li{
	list-style: none;
	line-height: 26px;
	border-bottom: 1px solid #ddd;
	cursor: pointer;
	padding: 0px 10px;
}
.mod-all-drop li:hover{
	background: #f3f3f3;
}
.mod-all-drop li a{
	text-decoration: none;
	color: #333;
}
.mod-all-drop li:last-child{
	border-bottom: 0;
}
</style>

<div class="headDiv">
	<div class="btn_t left"><a href="javascript:postModuleAndAction('refund','defaultView')"><span><strong>退款管理</strong></span></a></div>
</div>

<div class="main clear">
	<div class="clear"></div>
	
	<% if (JSPDataBean.getFormData("action").equals("list")) { %>
	<div class="search">
	  	<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td>
				
					退款申请ID：<input type="text" name="q_refundID" id="q_refundID" value="<%= JSPDataBean.getFormData("q_refundID") %>" size="25" maxlength="20" onkeydown="javascript:if(event.keyCode==13) postModuleAndAction('refund', 'search')"/>&nbsp;
					店铺：<input type="text" id="q_supplierName" name="q_supplierName" value="<%= JSPDataBean.getFormData("q_supplierName") %>" onclick="openInfoWindow('common', 'selectSupplierWindow')" style="cursor: pointer;" readonly onkeydown="javascript:if(event.keyCode==13)postModuleAndAction('refund', 'search')" />&nbsp;
	                   	<input type="hidden" id="q_supplierID" name="q_supplierID" value="<%= JSPDataBean.getFormData("q_supplierID") %>" />
	                   	<a href="javascript:;" onclick="$('#q_supplierID').val('');$('#q_supplierName').val('');">清除</a>&nbsp;&nbsp;
					申请人手机号：<input type="text" name="q_mobile" id="q_mobile" value="<%= JSPDataBean.getFormData("q_mobile") %>" size="25" maxlength="20" onkeydown="javascript:if(event.keyCode==13) postModuleAndAction('refund', 'search')"/>&nbsp;
					申请人邮箱：<input type="text" name="q_email" id="q_email" value="<%= JSPDataBean.getFormData("q_email") %>" size="25" maxlength="20" onkeydown="javascript:if(event.keyCode==13) postModuleAndAction('refund', 'search')"/>&nbsp;
					订单编号：<input type="text" name="q_shopOrderID" id="q_shopOrderID" value="<%= JSPDataBean.getFormData("q_shopOrderID") %>" size="25" maxlength="20" onkeydown="javascript:if(event.keyCode==13) postModuleAndAction('refund', 'search')"/>&nbsp;
			         处理状态：<%= JSPDataBean.getFormData("queryRefundStatusSelect") %>&nbsp;
			         退款理由：<%= JSPDataBean.getFormData("queryRefundTypeSelect") %>&nbsp;
				</td>
				<td class="righttd">
					<div><dl>
	               		<dt style="width: 100%;">
	                   		<a class="btn_y" onclick="javascript:postModuleAndAction('refund', 'search')"><span>搜&nbsp;&nbsp;&nbsp;&nbsp;索</span></a>
	                   	</dt>
	              	</dl></div>
				</td>
			</tr>
		</table>
	</div>
	<div>
		<table class="list" border="0" cellpadding="0" cellspacing="1" width="100%" id="tab1">
			<tr>
				<th>退款申请ID</th>
				<th>店铺</th>
				<th>退款理由</th>
				<th>手机号<br>邮箱</th>
				<th>订单编号</th>
				<th>支付方式</th>
				<th>交易单号</th>
				<th>退款金额</th>
				<th>申请时间</th>
				<th>处理时间</th>
				<th>处理状态</th>
				<th>操作</th>
			</tr>
			<%
				Vector datas = (Vector) JSPDataBean.getJSPData("datas");
				for (int i = 0; i < datas.size(); i++) {
					Hashtable data = (Hashtable) datas.get(i);
			%>
						<tr>
				<td><%= data.get("refundID") %></td>
				<td><%= data.get("supplierName") %></td>
				<td><%= LocalDataCache.getInstance().getTableDataColumnValue("c_refundType", data.get("refundTypeID").toString() , "c_refundTypeName") %></td>
				<td><%= data.get("mobile") %><br><%= data.get("email") %></td>
				<td><%= data.get("shopOrderID") %></td>
				<td>
					<%= LocalDataCache.getInstance().getTableDataColumnValue("payType", data.get("payTypeID").toString(), "name") %>
					<% if (data.get("useSysParaFlag").equals("1")) { %>
					<font style="color: red">系统账号收款，如需退款请联系客服进行退款操作</font>
					<% } %>
				</td>
				<td><%= data.get("transactionNum") %></td>
				<td>
					<%= data.get("refundAmount") %>
				</td>
				<td><%= data.get("addTime") %></td>
				<td><%= data.get("dealTime") %></td>
				<td>
					<%= LocalDataCache.getInstance().getTableDataColumnValue("c_refundStatus", data.get("status").toString(), "c_refundStatusName") %>
				</td>
				<td align="center">
					<a href="javascript:document.getElementById('refundID').value='<%= data.get("refundID") %>';postModuleAndAction('refund','detailView')">查看详细</a>
					<% if (data.get("status").equals("1")) { %>
					<a href="javascript:document.getElementById('refundID').value='<%= data.get("refundID") %>';openInfoWindow('agreeRefundWindow')">同意退款</a>
					<a href="javascript:document.getElementById('refundID').value='<%= data.get("refundID") %>';openInfoWindow('refuseRefundWindow')">拒绝退款</a>
					<% } %>
				</td>                                                               																				
			</tr>
			<%	} %>
		</table>
			<div class="page blue">
		    <p class="floatl"><%@include file="common/commonJumpPage.jsp" %></p>
		    <div class="clear"></div>
		</div>
	</div>
	
	<% } else if (JSPDataBean.getFormData("action").equals("detailView")) { %>	
		<div class="order_detail_box" >
			<table class="order_detail" cellpadding="0" cellspacing="1" width="100%">
			    <tr>
				  <td class="leftbg" width="15%">退款申请ID</td>
				  <td height="28" width="85%">
			  		<%= JSPDataBean.getFormData("refundID") %>
				  </td>
				</tr>
			    <tr>
				  <td class="leftbg" width="15%">申请类型</td>
				  <td height="28">
			  		 <%= LocalDataCache.getInstance().getTableDataColumnValue("c_refundType", JSPDataBean.getFormData("refundTypeID").toString() , "c_refundTypeName") %> 
				  </td>
				</tr>
				<tr>
				  <td class="leftbg" width="15%">申请人手机</d>
				  <td height="28">
			  		<%= JSPDataBean.getFormData("mobile") %>
				  </td>
				</tr>
				<tr>
				  <td class="leftbg" width="15%">申请人邮箱</d>
				  <td height="28">
			  		<%= JSPDataBean.getFormData("email") %>
				  </td>
				</tr>
				<tr>
				  <td class="leftbg" width="15%">订单编号</td>
				  <td height="28">
			  		<%= JSPDataBean.getFormData("shopOrderID") %>
				  </td>
				</tr>
				<tr>
				  <td class="leftbg" width="15%">申请退款金额</td>
				  <td height="28">
			  		<%= JSPDataBean.getFormData("refundAmount") %>
			  		（退还到银行卡：<%= JSPDataBean.getFormData("refundToBankAmount") %> + 退还到账户余额：<%= JSPDataBean.getFormData("refundToAccountAmount") %>）
				  </td>
				</tr>
				<tr>
				  <td class="leftbg" width="15%">申请时间</td>
				  <td height="28">
				  	<%= JSPDataBean.getFormData("addTime") %>
				  </td>
				</tr>
				<tr>
				  <td class="leftbg" width="15%">申请备注</td>
				  <td height="28">
				  	<%= StringUtil.convertXmlChars(JSPDataBean.getFormData("note")) %>
				  </td>
				</tr>
				<tr>
				  <td class="leftbg" width="15%">处理时间</td>
				  <td height="28">
				  	<%= JSPDataBean.getFormData("dealTime") %>
				  </td>
				</tr>
				<tr>
				  <td class="leftbg" width="15%">处理备注</td>
				  <td height="28">
				  	<%= StringUtil.convertXmlChars(JSPDataBean.getFormData("dealNote")) %>
				  </td>
				</tr>
				<tr>
				  <td class="leftbg" width="15%">处理状态</td>
				  <td height="28">
				  	<%= LocalDataCache.getInstance().getTableDataColumnValue("c_refundStatus", JSPDataBean.getFormData("status"), "c_refundStatusName") %>
				  </td>
				</tr>
			</table>
			<div align="center" style="margin:10px;">
				<div class="button">
				<% if (JSPDataBean.getFormData("status").equals("0")) { %>
					<a class="btn_bb1" href="javascript:openInfoWindow('agreeRefundWindow')"><span>同意退款</span></a>
					<a class="btn_bb1" href="javascript:openInfoWindow('refuseRefundWindow')"><span>拒绝退款</span></a>
				<% } %>
					<a onclick="javascript:postModuleAndAction('refund', 'list')" class="btn_bb1"><span>返 回</span></a>
				</div>
			</div>
		</div>
	<% } %>
	<%= JSPDataBean.getFormData("queryConditionHtml") %>
	<input type="hidden" id="refundID" name="refundID" value="<%=JSPDataBean.getFormData("refundID")%>" />
</div>

<%@include file="common/commonFooter.jsp" %>

<script type="text/javascript">

</script>








