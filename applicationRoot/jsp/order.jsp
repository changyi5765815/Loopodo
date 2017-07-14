<%@ page contentType="text/html;charset=UTF-8"%>
<jsp:directive.page import="java.util.Vector"/>
<jsp:directive.page import="java.util.Hashtable"/>
<%@page import="java.util.Iterator"%>
<%@page import="admin.customer.guanwangbao.AppUtil"%>
<%@page import="admin.customer.guanwangbao.LocalDataCache"%>
<%@page import="simpleWebFrame.util.PriceUtil"%>
<%@page import="admin.customer.guanwangbao.AppKeys"%>
<%@page import="org.w3c.dom.Document"%>
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
	<div class="<% if (JSPDataBean.getFormData("action").equals("list") || JSPDataBean.getFormData("action").equals("detailView")) { %>btn_t left<% } else { %>btn_t0 left<% } %>"><a href="javascript:postModuleAndAction('order','defaultView')"><span><strong>订单管理</strong></span></a></div>
	<% if (JSPDataBean.getFormData("module").equals("order")) { %>
		<div class="tip gray9" style="float: right;"><a href="javascript:openInfoWindow('exportOrderWindow')" class="btn_y"><span><strong class="icon_add">导出</strong></span></a> </div>
	<% } %>
</div>

<% String operationName = JSPDataBean.getFormData("operationName"); %>

<div class="main clear">
	<div class="clear"></div>
	
	<% if (JSPDataBean.getFormData("action").equals("list")) { %>
    <div class="search">
	  	<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td>
					订单ID：<input type="text" name="q_shopOrderID" id="q_shopOrderID" value="<%= JSPDataBean.getFormData("q_shopOrderID") %>" size="25" maxlength="20" onkeydown="javascript:if(event.keyCode==13) postModuleAndAction('order', 'search')"/>&nbsp;
					收货人：<input type="text" name="q_shouHuoRen" id="q_shouHuoRen" value="<%= JSPDataBean.getFormData("q_shouHuoRen") %>" size="25" maxlength="20" onkeydown="javascript:if(event.keyCode==13) postModuleAndAction('order', 'search')"/>&nbsp;
					手机号：<input type="text" name="q_mobile" id="q_mobile" value="<%= JSPDataBean.getFormData("q_mobile") %>" size="25" maxlength="20" onkeydown="javascript:if(event.keyCode==13) postModuleAndAction('order', 'search')"/>&nbsp;
					下单时间：<input type="text" size="12" maxlength="20" id="q_fromOrderTime" name="q_fromOrderTime" value="<%= JSPDataBean.getFormData("q_fromOrderTime").equals("") ? "" : JSPDataBean.getFormData("q_fromOrderTime").substring(0, 10) %>" onclick="calendar(this, false);" class="itime" style="cursor: pointer;" readonly onkeydown="javascript:if(event.keyCode==13)postModuleAndAction('order', 'search')" />&nbsp;-
			               <input type="text" size="12" maxlength="20" id="q_toOrderTime" name="q_toOrderTime" value="<%= JSPDataBean.getFormData("q_toOrderTime").equals("") ? "" : JSPDataBean.getFormData("q_toOrderTime").substring(0, 10) %>" onclick="calendar(this, false);" class="itime" style="cursor: pointer;" readonly onkeydown="javascript:if(event.keyCode==13)postModuleAndAction('order', 'search')" />&nbsp;
			<% if(JSPDataBean.getFormData("operationName").equals("quanBuDingDan")) { %>
			<%-- <% if(JSPDataBean.getFormData("operationName").equals("")) { %> --%>
				</td>
			<% } %>
			</tr>
			<tr>
				<td>
					订单状态：<%= JSPDataBean.getFormData("queryOrderGroupSelect") %>&nbsp;&nbsp;&nbsp;&nbsp;
					店	铺：<input type="text" name="q_supplierName" id="q_supplierName" value="<%= JSPDataBean.getFormData("q_supplierName") %>" size="25" maxlength="50" onkeydown="javascript:if(event.keyCode==13) postModuleAndAction('order', 'search')"/>&nbsp;
				</td>
				<td class="righttd">
					<div><dl>
	               		<dt style="width: 100%;">
	                   		<a class="btn_y" onclick="javascript:postModuleAndAction('order', 'search')"><span>搜&nbsp;&nbsp;&nbsp;&nbsp;索</span></a>
	                   	</dt>
	              	</dl></div>
				</td>
			</tr>	
				
		</table>
		<input type="hidden" name="operationName" id="operationName" value="<%= JSPDataBean.getFormData("operationName") %>" />
	</div>
	<div>
		<table class="list" border="0" cellpadding="0" cellspacing="1" width="100%" id="tab1">
			<tr>
				<th width="7%">订单ID</th>
				<th width="6%">来源</th>
				<th width="6%">店铺</th>
				<th width="9%">下单时间</th>
				<th width="6%">订单总额</th>
				<th width="8%">收货人</th>
				<th width="9%">手机号</th>
				<%-- <th width="5%">是否自提</th> --%>
				<%-- if ("daiZiTi".equals(operationName)){ %>
					<th width="7%">自提码</th>
				<% } --%>
				<% if ("quanBuDingDan".equals(operationName)){ %>
					<th width="6%">退款状态</th>
					<th width="6%">退货状态</th>
					<th width="6%">异常订单</th>
				<% } %>
				<% if ("yiChangDingDan".equals(operationName)) { %>
					<th width="5%">问题类型</th>
					<th width="8%">问题描述</th>
				<% } %>
			<%--	<th>是否返利</th>  --%>
				<th width="7%">订单状态</th>
				<th width="*">操作</th>
			</tr>
			<%
				Vector datas = (Vector) JSPDataBean.getJSPData("datas");
				String[] columns = {"shouHuoRen"};
				AppUtil.convertToHtml(columns, datas);
				for (int i = 0; i < datas.size(); i++) {
					Hashtable data = (Hashtable) datas.get(i);
					Hashtable area = AppUtil.getArea(data.get("townID").toString());
					String address = area.get("provinceName") + "-" + area.get("cityName") + "-" + area.get("townName") + "-" + data.get("address");
			%>
			<tr>
				<td><%= data.get("shopOrderID")%></td>
				<td><%= LocalDataCache.getInstance().getTableDataColumnsValue("c_shopOrderSourceType", data.get("sourceTypeID").toString(), "c_shopOrderSourceTypeName") %></td>
				<td><%= data.get("supplierName") %></td>
				<td><%= data.get("orderTime") %></td>
				<td><%= data.get("totalPrice") %>元</td>
				<td><%= data.get("shouHuoRen") %></td>
				<td><%= data.get("mobile") %></td>
				<%--<td><%= data.get("ztFlag").equals("1") ? "是" : "否" %></td>--%>
				<%-- if ("daiZiTi".equals(operationName)){ %>
					<td><%= data.get("ztCode") %></td>
				<% } --%>
				<% if ("quanBuDingDan".equals(operationName)){ %>
					<td>
						<%= "1".equals(data.get("refundStatus")) ? "<span class='red'>退款中</span>" : "2".equals(data.get("refundStatus")) ? "<span class='red'>已退款</span>" : "无退款" %>
					</td>
					<td>
						<%= "1".equals(data.get("returnGoodsStatus")) ? "<span class='red'>退货中</span>" : "2".equals(data.get("returnGoodsStatus")) ? "<span class='red'>已退货</span>" : "无退货" %>
					</td>
					<td>
						<%= "1".equals(data.get("exceptionFlag")) ? "<span class='red'>是</span>" : "否" %>
					</td>
				<% } %>
				<% if ("yiChangDingDan".equals(operationName)) { %>
					<td>
					    <%= LocalDataCache.getInstance().getTableDataColumnValue("c_exceptionType", data.get("exceptionTypeID").toString(), "c_exceptionTypeName") %>
					</td>
					<td><%= AppUtil.splitString(data.get("exceptionNote").toString(), 66) %></td>
				<% } %>
		<%--		<td align="center">
						<%= "1".equals(data.get("rebateFlag")) ? "<span class='red'>是</span>" : "否" %>
					</td> --%>
				<td><%= LocalDataCache.getInstance().getTableDataColumnValue("c_orderStatus", data.get("status").toString(), "c_orderStatusName") %></td>
				
				<td align="center">
					<a href="javascript:document.getElementById('shopOrderID').value='<%=data.get("shopOrderID")%>';postModuleAndAction('order','detailView')">订单信息</a>
					<a href="/admin?module=printOrder&action=printView&shopOrderID=<%=data.get("shopOrderID") %>" target="_blank">打印订单</a>
					<br>
					<% if (data.get("status").equals(AppKeys.ORDER_STATUS_UNPAY)) { %>
						<a href="javascript:if (confirm('请确认已收到汇款')) {document.getElementById('shopOrderID').value='<%=data.get("shopOrderID")%>';openInfoWindow('payShopOrderWindow')}">置已付款</a>
					<% } %>
					<%-- if (data.get("status").equals(AppKeys.ORDER_STATUS_WAITAUDIT)) { %>
						<a href="javascript:document.getElementById('shopOrderID').value='<%=data.get("shopOrderID")%>';openInfoWindow('orderAuditWindow');">审核</a>
					<% } --%>
					<%-- if (data.get("status").equals(AppKeys.ORDER_STATUS_DAIPEIHUO)) { %>
						<a href="javascript:document.getElementById('shopOrderID').value='<%=data.get("shopOrderID")%>';postModuleAndAction('order', 'finishPeiHuo')">配货完成</a>
					<% } --%>
					<%-- if (data.get("status").equals(AppKeys.ORDER_STATUS_WAITZT)) { %>
						<a href="javascript:document.getElementById('shopOrderID').value='<%=data.get("shopOrderID")%>';postModuleAndAction('order', 'finishZT')">已提货</a>
					<% } --%>
					<%-- if (data.get("status").equals(AppKeys.ORDER_STATUS_DAIFAHUO)) { %>
						<a href="javascript:document.getElementById('shopOrderID').value='<%=data.get("shopOrderID")%>';openInfoWindow('orderDeliveryWindow');">发货</a>
					<% } --%>
					<%-- if (data.get("status").equals(AppKeys.ORDER_STATUS_DAISHOUHUO) && !"1".equals(data.get("returnGoodsStatus"))) { %>
						<a href="javascript:document.getElementById('shopOrderID').value='<%=data.get("shopOrderID")%>';postModuleAndAction('order','acceptOrder')" onclick="javascript:if(!confirm('是否确认收货？')){return false};">已收货</a>
					<% } --%>
					<%-- if (data.get("exceptionFlag").equals("1")) { %>
						<a href="javascript:document.getElementById('shopOrderID').value='<%=data.get("shopOrderID")%>';postModuleAndAction('order','solveException')" onclick="javascript:if(!confirm('是否确定已处理？')){return false};">异常已处理</a>
					<% } else { %>
						<a href="javascript:document.getElementById('shopOrderID').value='<%=data.get("shopOrderID")%>';openInfoWindow('setExceptionWindow')">置为异常订单</a>
					<% } --%>
					<%-- <% if (!data.get("deliveryTypeID").equals("") && !data.get("deliveryTypeID").equals("99")) { %>
						<a href="javascript:document.getElementById('shopOrderID').value='<%=data.get("shopOrderID")%>';openInfoWindow('printDelivery','orderDeliveryPrintWindow')">打印物流单</a>
					<% } %> --%>
				</td>
			</tr>
			<%	} %>
		</table>
		<div class="page blue">
		    <p class="floatl"><%@include file="common/commonJumpPage.jsp" %></p>
		    <div class="clear"></div>
		</div>
	</div>
	
	<% } else if (JSPDataBean.getFormData("action").equals("detailView")) { 
		Hashtable area = AppUtil.getArea(JSPDataBean.getFormData("townID"));
		String[] columns = {"shouHuoRen", "exceptionNote", "note", "auditNote", "address", "invoiceTitle", "invoiceContent"};
		AppUtil.convertToHtml(columns, JSPDataBean.getFormDatas());
	%>
		<div class="order_detail_box" style="margin: 10px;">
			<table class="order_detail" cellpadding="0" cellspacing="1" width="100%" style="">
				<tr class="order_detail_title">
					<td colspan="4">订单详情</td>
				</tr>
				<tr>
					<td class="leftbg" width="15%">订单编号</td>
					<td width="35%"><%= JSPDataBean.getFormData("shopOrderID") %></td>
					<td class="leftbg" width="15%">订单来源</th>
					<td>
					<%= LocalDataCache.getInstance().getTableDataColumnValue("c_shopOrderSourceType", JSPDataBean.getFormData("sourceTypeID"), "c_shopOrderSourceTypeName") %>
					</td>
				</tr>
				<tr>
					<td class="leftbg" width="15%">下单时间</td>
					<td width="35%"><%= JSPDataBean.getFormData("orderTime") %></td>
					<td class="leftbg" width="15%">订单状态</th>
					<td><%= LocalDataCache.getInstance().getTableDataColumnValue("c_orderStatus", JSPDataBean.getFormData("status"), "c_orderStatusName") %></td>
				</tr>
				<% if ("yiChangDingDan".equals(operationName)) { %>
					<tr>
						<td class="leftbg">问题类型</td>
						<td>
							<%= LocalDataCache.getInstance().getTableDataColumnValue("c_exceptionType", JSPDataBean.getFormData("exceptionTypeID").toString(), "c_exceptionTypeName") %>&nbsp;&nbsp;&nbsp;&nbsp;
						</td>
						<td class="leftbg">问题描述</td>
						<td style="color: red"><%= JSPDataBean.getFormData("exceptionNote") %></td>
					</tr>
				<% } %>
				<tr>
					<td class="leftbg" width="15%">用户备注</td>
					<td width="35%"><%= JSPDataBean.getFormData("note") %></td>
					<td class="leftbg" width="15%">店铺名称</th>
					<td><%= JSPDataBean.getFormData("supplierName") %></td>
				</tr>
			</table>
			
			<table class="order_detail" cellpadding="0" cellspacing="1" width="100%">
				  <tr class="order_detail_title">
					<td colspan="4">收货人信息</td>
				  </tr>
				  <tr>
					<td class="leftbg" width="15%">收货人</td>
					<td width="35%"><%= JSPDataBean.getFormData("shouHuoRen") %></td>
					<td class="leftbg"  width="15%">用户ID</td>
					<td width="35%"><%= JSPDataBean.getFormData("userID") %></td>
				  </tr>
				  <tr>
				  	<td class="leftbg" width="15%">手机</td>
					<td width="35%"><%= JSPDataBean.getFormData("mobile") %></td>
				  	<td class="leftbg">电话</td>
					<td><%= JSPDataBean.getFormData("phone") %></td>
				  </tr>
				  <tr>
				  	<td class="leftbg">收货人地址</td>
					<td><%= area.get("provinceName") %>-<%= area.get("cityName") %>-<%= area.get("townName") %>-<%= JSPDataBean.getFormData("address") %></td>
					<td class="leftbg">收货人邮编</td>
					<td><%= JSPDataBean.getFormData("postalCode") %>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				  </tr>
			</table>
			
			<table class="order_detail" cellpadding="0" cellspacing="1" width="100%">
				  <tr class="order_detail_title">
					<td colspan="4">支付及配送</td>
				  </tr>
				  <tr>
				    <td class="leftbg" width="15%">支付方式</td>
					<td width="35%">
						<%= JSPDataBean.getFormData("payWayID").equals("1") ? "在线支付" : JSPDataBean.getFormData("payWayID").equals("99") ? "货到付款" : "" %>
						<% if (!JSPDataBean.getFormData("payWayID").equals("99")) { %>
						&nbsp;<%= LocalDataCache.getInstance().getTableDataColumnValue("payType", JSPDataBean.getFormData("payTypeID"), "name") %>
						<% } %>
					</td>
					<td class="leftbg" width="15%">支付时间</td>
					<td><%= JSPDataBean.getFormData("payTime") %></td>
				  </tr>
				  <tr>
				    <td class="leftbg" width="15%">送货方式</td>
					<td>
						<%= LocalDataCache.getInstance().getTableDataColumnValue("deliveryType", JSPDataBean.getFormData("deliveryTypeID"), "name") %>
					</td>
					
					<td class="leftbg" width="15%">物流单号</td>
					<td>
					<%= JSPDataBean.getFormData("deliveryCode") %>&nbsp;
						<%	if (!JSPDataBean.getFormData("deliveryCode").equals("")) { %>
						<a class="infoLink" href="javascript:document.getElementById('shopOrderID').value='<%= JSPDataBean.getFormData("shopOrderID") %>';openInfoWindow('order', 'deliveryInfoWindow');">查看物流</a>
						<%	} %>
					</td>
				  </tr>
				</table>
				
				<table class="order_detail" cellpadding="0" cellspacing="1" width="100%">
				  <tr class="order_detail_title">
					<td colspan="4">发票信息</td>
				  </tr>
				   <tr>
					<td class="leftbg" width="15%">是否开发票</td>
					<td width="35%"><%= JSPDataBean.getFormData("invoiceFlag").equals("1") ? "开发票" : "不开发票" %>&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td class="leftbg" width="15%">发票抬头</td>
					<td><%= JSPDataBean.getFormData("invoiceTitle") %>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				  </tr>
				  <%--
				  <tr>
					<td class="leftbg" id="rrr" width="15%">是否开发票</td>
					<td id="CustomerName_td" width="35%"><%= JSPDataBean.getFormData("invoiceFlag").equals("1") ? "开发票" : "不开发票" %>&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td class="leftbg" width="15%">发票类型</td>
					<td width="35%"><%= JSPDataBean.getFormData("invoiceTypeID").equals("1") ? "个人" : JSPDataBean.getFormData("invoiceTypeID").equals("2") ? "公司" : "" %></td>					
				  </tr>
				  <tr>
				  	<td class="leftbg" width="15%">发票抬头</td>
					<td id="Mobile_td"><%= JSPDataBean.getFormData("invoiceTitle") %>&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td class="leftbg" width="15%">发票内容</td>
					<td id="Mobile_td"><%= JSPDataBean.getFormData("invoiceContent") %>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				  </tr>
				   --%>
				</table>
				
				<table class="order_detail" border="0" cellpadding="0" cellspacing="1" width="100%">
					  <tr class="order_detail_title">
						<td colspan="4">订单金额</td>
					  </tr>
		
					  <tr>
						<td class="leftbg" width="15%">商品总金额</td>
						<td width="35%">￥<%= PriceUtil.formatPrice(JSPDataBean.getFormData("productMoney")) %>元</td>
						<td class="leftbg" width="15%">运费</td>
						<td>￥<%= PriceUtil.formatPrice(JSPDataBean.getFormData("deliveryMoney"))  %>元</td>
					  </tr>
					  
					  <tr>
					    <td class="leftbg">满减金额</td>
						<td>￥<%= JSPDataBean.getFormData("wholeSitePromotionFlag").equals("1") && !JSPDataBean.getFormData("promotionActiveTypeID").equals("2") ? PriceUtil.formatPrice(JSPDataBean.getFormData("cutMoney")) : "0.00" %>元</td>
					    <td class="leftbg">满赠金额</td>
					 	<td>￥<%= JSPDataBean.getFormData("wholeSitePromotionFlag").equals("1") && JSPDataBean.getFormData("promotionActiveTypeID").equals("2") ? PriceUtil.formatPrice(JSPDataBean.getFormData("cutMoney")) : "0.00" %>元</td>
					  </tr>
					  
					  <tr>
					    <td class="leftbg">账户余额支付</td>
						<td>￥<%= PriceUtil.formatPrice(JSPDataBean.getFormData("accountMoney")) %>元</td>
					    <td class="leftbg">优惠券支付金额</td>
					 	<td>￥<%= PriceUtil.formatPrice(JSPDataBean.getFormData("cardAmount")) %>元</td>
					  </tr>
					  
					  <tr>
					    <td class="leftbg">订单总金额</td>
						<td>￥<%= PriceUtil.formatPrice(JSPDataBean.getFormData("totalPrice")) %>元
							<%	if (JSPDataBean.getFormData("changePriceFlag").equals("1")) { %>
							（原订单总金额：<%= PriceUtil.formatPrice(JSPDataBean.getFormData("oldTotalPrice")) %>元）
							<%	} %>
						</td>
					    <td class="leftbg"></td>
						<td></td>
					  </tr>
		
					  <tr>
						<% if (AppKeys.ORDER_STATUS_UNPAY.equals(JSPDataBean.getFormData("status")) || AppKeys.ORDER_STATUS_WAITAUDIT.equals(JSPDataBean.getFormData("status"))) { %>
						<td class="leftbg">需支付金额</td>
						<td>￥<%= PriceUtil.formatPrice(JSPDataBean.getFormData("needPayMoney")) %>元
							<%	if (JSPDataBean.getFormData("changePriceFlag").equals("1")) { %>
							（原订单需支付金额：<%= PriceUtil.formatPrice(JSPDataBean.getFormData("oldNeedPayMoney")) %>元）
							<%	} %>
						</td>
						<% } else { %>
						<td class="leftbg"></td>
						<td></td>
						<% } %>
						<td class="leftbg"></td>
						<td></td>
					  </tr>
				</table>
				<table class="order_detail" cellpadding="0" cellspacing="1" width="100%">
					  <tr>
						<td class="leftbg" width="15%" style="text-align: center;">商品编号</td>
						<td class="leftbg" width="35%" style="text-align: center;">商品名称</td>
						<td class="leftbg" width="15%" style="text-align: center;">单价</td>
						<td class="leftbg" width="10%" style="text-align: center;">数量</td>
						<td class="leftbg" width="15%" style="text-align: center;">小计</td>
						<td class="leftbg" width="10%" style="text-align: center;">状态</td>
					  </tr>
						<%
							Vector itemDatas = (Vector) JSPDataBean.getJSPData("itemDatas");
							Hashtable<String, Hashtable<String, String>> footTypeData = (Hashtable<String, Hashtable<String, String>>) JSPDataBean.getJSPData("footTypeData");
							String[] columns2 = {"name", "propName"};
							AppUtil.convertToHtml(columns2, itemDatas);
							for (int i = 0; i < itemDatas.size(); i++) {
								Hashtable data = (Hashtable) itemDatas.get(i);
						%>
					  <tr>
						<td><%= data.get("productID") %></td>
						<td class="goods_txt">
							<span class="goods_name">
								<a href="http://<%=AppKeys.DOMAIN_WWW %>/product/<%= data.get("productID")%>.html" target="_blank" style="text-decoration: none;">
									<%= data.get("name") %>&nbsp;
								</a>
							</span>
						</td>
						<td>￥<%= PriceUtil.formatPrice(data.get("price").toString()) %>元</td>
						<td><%= data.get("number") %></td>
						<td>￥<%= PriceUtil.multiPrice(data.get("price").toString(), Integer.parseInt(data.get("number").toString())) %>元</td>
						<td><%= "3".equals(data.get("status")) ? "已退货" : "" %></td>
					  </tr>
					 <%	} %>
				</table>
			
			<div align="center">
				<div class="button">
					<a onclick="javascript:postModuleAndAction('order','defaultView')" class="btn_bb1"><span>返 回</span></a>
				</div>
			</div>
			
			<input type="hidden" id="orderProductID" name="orderProductID"  />
			
		</div>
	<% } %>
	
	
	<%= JSPDataBean.getFormData("queryConditionHtml") %>	
	<input type="hidden" id="shopOrderID" name="shopOrderID" value="<%= JSPDataBean.getFormData("shopOrderID") %>" />
	<input type="hidden" id="operationName" name="operationName" value="<%= JSPDataBean.getFormData("operationName") %>" />
</div>

<%@include file="common/commonFooter.jsp" %>

<script type="text/javascript">

</script>








