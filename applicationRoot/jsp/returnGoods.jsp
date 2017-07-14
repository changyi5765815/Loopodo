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
	<div class="btn_t left"><a href="javascript:postModuleAndAction('returnGoods','defaultView')"><span><strong>退货管理</strong></span></a></div>
</div>

<div class="main clear">
	<div class="clear"></div>
	
	<% if (JSPDataBean.getFormData("action").equals("list")) { %>
	<div class="search">
	  	<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td>
					退货申请ID：<input type="text" name="q_returnGoodsID" id="q_returnGoodsID" value="<%= JSPDataBean.getFormData("q_returnGoodsID") %>" size="25" maxlength="20" onkeydown="javascript:if(event.keyCode==13) postModuleAndAction('returnGoods', 'search')"/>&nbsp;
					店铺：<input type="text" id="q_supplierName" name="q_supplierName" value="<%= JSPDataBean.getFormData("q_supplierName") %>" onclick="openInfoWindow('common', 'selectSupplierWindow')" style="cursor: pointer;" readonly onkeydown="javascript:if(event.keyCode==13)postModuleAndAction('returnGoods', 'search')" />&nbsp;
	                   	<input type="hidden" id="q_supplierID" name="q_supplierID" value="<%= JSPDataBean.getFormData("q_supplierID") %>" />
	                   	<a href="javascript:;" onclick="$('#q_supplierID').val('');$('#q_supplierName').val('');">清除</a>&nbsp;&nbsp;
					申请人手机号：<input type="text" name="q_mobile" id="q_mobile" value="<%= JSPDataBean.getFormData("q_mobile") %>" size="25" maxlength="20" onkeydown="javascript:if(event.keyCode==13) postModuleAndAction('returnGoods', 'search')"/>&nbsp;
					申请人邮箱：<input type="text" name="q_email" id="q_email" value="<%= JSPDataBean.getFormData("q_email") %>" size="25" maxlength="20" onkeydown="javascript:if(event.keyCode==13) postModuleAndAction('returnGoods', 'search')"/>&nbsp;
					订单编号：<input type="text" name="q_shopOrderID" id="q_shopOrderID" value="<%= JSPDataBean.getFormData("q_shopOrderID") %>" size="25" maxlength="20" onkeydown="javascript:if(event.keyCode==13) postModuleAndAction('returnGoods', 'search')"/>&nbsp;
			         处理状态：<%= JSPDataBean.getFormData("queryReturnGoodsStatusSelect") %>&nbsp;
				</td>
				<td class="righttd">
					<div><dl>
	               		<dt style="width: 100%;">
	                   		<a class="btn_y" onclick="javascript:postModuleAndAction('returnGoods', 'search')"><span>搜&nbsp;&nbsp;&nbsp;&nbsp;索</span></a>
	                   	</dt>
	              	</dl></div>
				</td>
			</tr>
		</table>
	</div>
	<div>
		<table class="list" border="0" cellpadding="0" cellspacing="1" width="100%" id="tab1">
			<tr>
				<th>退货申请ID</th>
				<th>店铺</th>
				<th>订单编号</th>
				<th>手机号<br>邮箱</th>
				<th>申请时间</th>
				<th>商品</th>
				<th>商品名</th>
				<th>退货数量</th>
				<th>退款金额</th>
				<th>支付方式</th>
				<th>交易单号</th>
				<th>退货理由</th>
				<th>处理状态</th>
				<th>操作</th>
			</tr>
			<%
				Vector datas = (Vector) JSPDataBean.getJSPData("datas");
				for (int i = 0; i < datas.size(); i++) {
					String[] columns = {"productName"};
					AppUtil.convertToHtml(columns, datas);
					Hashtable data = (Hashtable) datas.get(i);
			%>
				<tr>
				<td><%= data.get("returnGoodsID") %></td>
				<td><%= data.get("supplierName") %></td>
				<td><%= data.get("shopOrderID") %></td>
				<td><%= data.get("mobile") %><br><%= data.get("email") %></td>
				<td><%= data.get("addTime") %></td>
				<td>
					<a href="http://<%=AppKeys.DOMAIN_WWW %>/product/<%= data.get("productID")%>.html" class="thumbnail" target="_blank">
			          <img src="<%= AppUtil.getProductImage(data, AppKeys.IMAGE_SIZE_SMALL) %>"  style="height: 60px; width: 60px;">
			        </a>
				</td>
				 <td><a class="infoLink" href="http://<%=AppKeys.DOMAIN_WWW %>/product/<%= data.get("productID")%>.html" target="_blank" title="<%= data.get("productName") %>"><%= AppUtil.splitString(data.get("productName").toString(), 40) %></a></td>
				<td><%= data.get("returnNumber") %></td>
				<td>
					<%= PriceUtil.formatPrice(data.get("refundAmount").toString()) %>
				</td>
				<td>
					<%= LocalDataCache.getInstance().getTableDataColumnValue("payType", data.get("payTypeID").toString(), "name") %>
					<% if (data.get("useSysParaFlag").equals("1")) { %>
					<font style="color: red">系统账号收款，如需退款请联系客服进行退款操作</font>
					<% } %>
				</td>
				<td><%= data.get("transactionNum") %></td>
				<td><%= LocalDataCache.getInstance().getTableDataColumnValue("c_returnGoodsType", data.get("returnGoodsTypeID").toString(), "c_returnGoodsTypeName") %></td>
				<td>
					<%= LocalDataCache.getInstance().getTableDataColumnValue("c_returnGoodsStatus", data.get("status").toString(), "c_returnGoodsStatusName") %>
				</td>
				<td align="center">
					<a href="javascript:document.getElementById('returnGoodsID').value='<%= data.get("returnGoodsID") %>';postModuleAndAction('returnGoods','detailView')">查看详细</a>
					<%-- if (data.get("status").equals("1")) { %>
					<a href="javascript:document.getElementById('returnGoodsID').value='<%= data.get("returnGoodsID") %>';openInfoWindow('auditReturnGoodsWindow')">审核</a>
					<% } --%>
					<%-- if (data.get("status").equals("3")) { %>
					<a href="javascript:document.getElementById('returnGoodsID').value='<%= data.get("returnGoodsID") %>';openInfoWindow('confirmReturnGoodsWindow')">确认收货</a>
					<% } --%>
					<% if (data.get("status").equals("5")) { %>
					<a href="javascript:document.getElementById('returnGoodsID').value='<%=data.get("returnGoodsID")%>';openInfoWindow('returnGoodsRefundWindow')">确认退款</a>
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
				  <td class="leftbg" width="15%">退货申请ID：</td>
				  <td height="28">
			  		<%= JSPDataBean.getFormData("returnGoodsID") %>
				  </td>
				  <td class="leftbg" width="15%">订单编号：</td>
				  <td height="28">
			  		<%= JSPDataBean.getFormData("shopOrderID") %>
				  </td>
				</tr>
				<tr>
				  <td class="leftbg" width="15%">申请人手机/邮箱：</td>
				  <td height="28">
			  		<%= JSPDataBean.getFormData("mobile") %>&nbsp;<%= JSPDataBean.getFormData("email") %>
				  </td>
				  <td class="leftbg" width="15%">申请时间：</td>
				  <td height="28">
				  	<%= StringUtil.convertXmlChars(JSPDataBean.getFormData("addTime")) %>
				  </td>
				</tr>
				<tr>
				  <td class="leftbg" width="15%">商品：</td>
				  <td height="28">
					<a href="" target="_blank">
			          <img src="<%= AppUtil.getProductImage(JSPDataBean.getFormDatas(), AppKeys.IMAGE_SIZE_SMALL) %>"  style="height: 60px; width: 60px; display: block;">
			        </a>
				  </td>
				  <td class="leftbg" width="15%">商品名称：</td>
				  <td height="28">
				  	<a class="infoLink" href="" target="_blank"><%= StringUtil.convertXmlChars(JSPDataBean.getFormData("productName")) %></a>
				  </td>
				</tr>
				<tr>
				  <td class="leftbg" width="15%">申请退货数量：</td>
				  <td height="28">
			  		<%= JSPDataBean.getFormData("returnNumber") %>
				  </td>
				  <td class="leftbg" id="rrr" width="15%">可退款金额：</td>
				  <td height="28">
			  		<%= PriceUtil.formatPrice(JSPDataBean.getFormData("refundAmount")) %>
			  		（退还到银行卡：<%= JSPDataBean.getFormData("refundToBankAmount") %> + 退还到账户余额：<%= JSPDataBean.getFormData("refundToAccountAmount") %>）
				  </td>
				</tr>
				<tr>
				  <td class="leftbg" width="15%">退货理由：</td>
				  <td height="28" colspan="3">
			  		<%= LocalDataCache.getInstance().getTableDataColumnValue("c_returnGoodsType", JSPDataBean.getFormData("returnGoodsTypeID") , "c_returnGoodsTypeName") %>
				  </td>
				</tr>
				<tr>
				  <td class="leftbg" width="15%">申请备注：</td>
				  <td height="28" colspan="3">
				  	<%= StringUtil.convertXmlChars(JSPDataBean.getFormData("note")) %>
				  </td>
				</tr>
				<tr>
				  <td class="leftbg" width="15%">处理状态：</td>
				  <td height="28">
				  	<%= LocalDataCache.getInstance().getTableDataColumnValue("c_returnGoodsStatus", JSPDataBean.getFormData("status").toString(), "c_returnGoodsStatusName") %>
				  </td>
				  <td class="leftbg" width="15%">审核结果：</td>
				  <td height="28">
				  	<%= JSPDataBean.getFormData("auditResult").equals("1") ? "通过" : (JSPDataBean.getFormData("auditResult").equals("0") ? "不通过" : "") %>
				  </td>
				</tr>
				<tr>
				  <td class="leftbg" width="15%">审核备注：</td>
				  <td height="28">
				  	<%= StringUtil.convertXmlChars(JSPDataBean.getFormData("auditNote")) %>
				  </td>
				  <td class="leftbg" width="15%">审核时间：</td>
				  <td height="28">
				  	<%= StringUtil.convertXmlChars(JSPDataBean.getFormData("auditTime")) %>
				  </td>
				</tr>
				<tr>
				  <td class="leftbg" width="15%">买家发货物流公司：</td>
				  <td height="28">
				  	<%= JSPDataBean.getFormData("logisticsCompanyID").equals("99") ? JSPDataBean.getFormData("logisticsCompanyName") : LocalDataCache.getInstance().getTableDataColumnValue("c_logisticsCompany", JSPDataBean.getFormData("logisticsCompanyID").toString(), "c_logisticsCompanyName")  %>
				  </td>
				  <td class="leftbg" width="15%">买家发货物流单号：</td>
				  <td height="28">
				  	<%= JSPDataBean.getFormData("deliveryCode") %>
				  </td>
				</tr>
				<tr>
				  <td class="leftbg" width="15%">买家发货时间：</td>
				  <td height="28" colspan="3">
				  	<%= JSPDataBean.getFormData("deliveryTime") %>
				  </td>
				</tr>
				<tr>
				  <td class="leftbg" width="15%">商家确认收货结果：</td>
				  <td height="28">
				  	<% if (!JSPDataBean.getFormData("confirmResult").equals("")) { %>
				  		<%= JSPDataBean.getFormData("confirmResult").equals("1") ? "确认收货" : "拒绝收货" %>
				  	<% } %>
				  </td>
				  <td class="leftbg" width="15%">商家确认备注：</td>
				  <td height="28">
				  	<%= StringUtil.convertXmlChars(JSPDataBean.getFormData("confirmNote")) %>
				  </td>
				</tr>
				<tr>
				  <td class="leftbg" width="15%">商家确认收货时间：</td>
				  <td height="28" colspan="3">
				  	<%= StringUtil.convertXmlChars(JSPDataBean.getFormData("confirmTime")) %>
				  </td>
				</tr>
			</table>
			<div align="center" style="margin:10px;">
				<div class="button">
					<a onclick="javascript:postModuleAndAction('returnGoods', 'list')" class="btn_bb1"><span>返 回</span></a>
				</div>
			</div>
		</div>
	<% } %>
	<%= JSPDataBean.getFormData("queryConditionHtml") %>
	<input type="hidden" id="returnGoodsID" name="returnGoodsID" value="<%=JSPDataBean.getFormData("returnGoodsID")%>" />
</div>

<%@include file="common/commonFooter.jsp" %>

<script type="text/javascript">

</script>








