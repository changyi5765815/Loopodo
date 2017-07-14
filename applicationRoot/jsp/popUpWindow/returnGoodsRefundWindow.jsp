<%@page import="simpleWebFrame.util.PriceUtil"%>
<%@ page contentType="text/html;charset=UTF-8"%>
<jsp:directive.page import="java.util.Vector"/>
<jsp:directive.page import="java.util.Hashtable"/>
<%@page import="admin.customer.guanwangbao.LocalDataCache"%>

<jsp:useBean id="JSPDataBean" scope='request' class="simpleWebFrame.web.JSPDataBean" />

<div id="popwindow">
<h2><span>确认退款</span><a style="" class="close-button" href="javascript:closeInfoWindow('infoWindow');">关闭</a></h2>
<div style="width:420px; padding:10px">
	<div style="margin-top:10px;height:auto;">
		<table cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td width="120px" align="right" style="height:30px;font-weight:bold;">退款总金额：</td>
				<td width="220px"><%= PriceUtil.formatPrice(JSPDataBean.getFormData("refundAmount")) %></td>
			</tr>
			<tr>
				<td width="120px" align="right" style="height:30px;font-weight:bold;">退还到银行卡：</td>
				<td width="220px"><%= PriceUtil.formatPrice(JSPDataBean.getFormData("refundToBankAmount")) %></td>
			</tr>
			<tr>
				<td width="120px" align="right" style="height:30px;font-weight:bold;">退还到账户余额：</td>
				<td width="220px"><%= PriceUtil.formatPrice(JSPDataBean.getFormData("refundToAccountAmount")) %></td>
			</tr>
			<% if (Float.parseFloat(JSPDataBean.getFormData("refundToBankAmount")) > 0.00f) { %>
				<tr>
					<td width="120px" align="right" style="height:30px;font-weight:bold;">支付方式：</td>
					<td width="220px">
						<%= LocalDataCache.getInstance().getTableDataColumnValue("payType", JSPDataBean.getFormData("payTypeID"), "name") %>
						<% if (JSPDataBean.getFormData("useSysParaFlag").equals("1")) { %>
							<span style="color: red">系统账号收款，请联系客服进行退款操作</span>
						<% } %>
					</td>
				</tr>
				<tr>
					<td width="120px" align="right" style="height:30px;font-weight:bold;">第三方平台交易单号：</td>
					<td width="220px"><%= JSPDataBean.getFormData("transactionNum") %></td>
				</tr>
				<tr>
					<td width="120px" align="right" style="height:30px;font-weight:bold;">注意：</td>
					<td width="220px">
					<%
						String link = LocalDataCache.getInstance().getTableDataColumnValue("payType", JSPDataBean.getFormData("payTypeID"), "siteUrl");
					%>
						请到<a href="<%= link.equals("") ? "javascript:;" : link %>" <% if (!link.equals("")) { %>target="_blank"<% } %>><%= LocalDataCache.getInstance().getTableDataColumnValue("payType", JSPDataBean.getFormData("payTypeID"), "name") %></a>
						平台中将交易单号为<%= JSPDataBean.getFormData("transactionNum") %>的交易进行退款操作，操作完成后方可点击确认按钮
					</td>
				</tr>
			<% } %>
		</table>
	</div>
</div>

		<div>
			<div style="text-align: center;" class="buttonsDIV">
			<a class="btn_y" onclick="javascript:if(confirm('是否已完成退款')){doAction('returnGoods', 'returnGoodsRefund')}"><span>确认</span></a>&nbsp;
			<a class="btn_y" onclick="javascript:closeInfoWindow('infoWindow');"><span>取消</span></a>
			</div>
		</div>
</div>