<%@page import="simpleWebFrame.util.StringUtil"%>
<%@page import="simpleWebFrame.util.PriceUtil"%>
<%@ page contentType="text/html;charset=UTF-8"%>
<jsp:directive.page import="java.util.Vector"/>
<jsp:directive.page import="java.util.Hashtable"/>

<jsp:useBean id="JSPDataBean" scope='request' class="simpleWebFrame.web.JSPDataBean" />
<style>
.titleCheck {
	margin-right: 3px;
}
</style>

<div id="popwindow">
<h2><span>订单导出-选择导出项</span><a style="" class="close-button" href="javascript:closeInfoWindow('infoWindow');">关闭</a></h2>
<div style="width:700px; padding:10px">
	<div style="margin-top:10px;height:auto;">
		<table cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td width="80px" align="right" style="height:30px;font-weight:bold;">订单详情：</td>
				<td width="auto;">
				<% boolean allSelect1 = JSPDataBean.getFormData("shopOrderColumns-1").indexOf(",shopOrderID,") != -1 && JSPDataBean.getFormData("shopOrderColumns-1").indexOf(",sourceType,") != -1
						&& JSPDataBean.getFormData("shopOrderColumns-1").indexOf(",orderTime,") != -1 && JSPDataBean.getFormData("shopOrderColumns-1").indexOf(",status,") != -1 
						&& JSPDataBean.getFormData("shopOrderColumns-1").indexOf(",note,") != -1 && JSPDataBean.getFormData("shopOrderColumns-1").indexOf(",auditNote,") != -1; %>
					<input class="titleCheck" type="checkbox" name="all1" id="all1" <%= allSelect1 ? "checked=\"checked\"" : "" %>  onclick="selectAllCheckBox('all1',  'shopOrderColumn-1', 'shopOrderColumns-1')"/>全选
					<input class="titleCheck" type="checkbox" name="shopOrderColumn-1" id="shopOrderColumn-1" <%= JSPDataBean.getFormData("shopOrderColumns-1").indexOf(",shopOrderID,") != -1 ? "checked=\"checked\"" : "" %> value="shopOrderID" onclick="setSelectedValues('shopOrderColumn-1', 'shopOrderColumns-1')"/>订单ID
					<input class="titleCheck" type="checkbox" name="shopOrderColumn-1" id="shopOrderColumn-1" <%= JSPDataBean.getFormData("shopOrderColumns-1").indexOf(",sourceType,") != -1 ? "checked=\"checked\"" : "" %> value="sourceType" onclick="setSelectedValues('shopOrderColumn-1', 'shopOrderColumns-1')"/>订单来源
					<input class="titleCheck" type="checkbox" name="shopOrderColumn-1" id="shopOrderColumn-1" <%= JSPDataBean.getFormData("shopOrderColumns-1").indexOf(",orderTime,") != -1 ? "checked=\"checked\"" : "" %> value="orderTime" onclick="setSelectedValues('shopOrderColumn-1', 'shopOrderColumns-1')"/>下单时间
					<input class="titleCheck" type="checkbox" name="shopOrderColumn-1" id="shopOrderColumn-1" <%= JSPDataBean.getFormData("shopOrderColumns-1").indexOf(",status,") != -1 ? "checked=\"checked\"" : "" %> value="status" onclick="setSelectedValues('shopOrderColumn-1', 'shopOrderColumns-1')"/>订单状态
					<input class="titleCheck" type="checkbox" name="shopOrderColumn-1" id="shopOrderColumn-1" <%= JSPDataBean.getFormData("shopOrderColumns-1").indexOf(",note,") != -1 ? "checked=\"checked\"" : "" %> value="note" onclick="setSelectedValues('shopOrderColumn-1', 'shopOrderColumns-1')"/>用户备注
					<input class="titleCheck" type="checkbox" name="shopOrderColumn-1" id="shopOrderColumn-1" <%= JSPDataBean.getFormData("shopOrderColumns-1").indexOf(",auditNote,") != -1 ? "checked=\"checked\"" : "" %> value="auditNote" onclick="setSelectedValues('shopOrderColumn-1', 'shopOrderColumns-1')"/>审核备注
				</td>
			</tr>
			<tr>
				<td width="80px" align="right" style="height:30px;font-weight:bold;">收货人信息：</td>
				<td width="auto;">
				<% boolean allSelect2 = JSPDataBean.getFormData("shopOrderColumns-2").indexOf(",shouHuoRen,") != -1 && JSPDataBean.getFormData("shopOrderColumns-2").indexOf(",mobile,") != -1
						&& JSPDataBean.getFormData("shopOrderColumns-2").indexOf(",phone,") != -1 && JSPDataBean.getFormData("shopOrderColumns-2").indexOf(",address,") != -1 
						&& JSPDataBean.getFormData("shopOrderColumns-2").indexOf(",postalCode,") != -1; %>
					<input class="titleCheck" type="checkbox" name="all2" id="all2" <%= allSelect2 ? "checked=\"checked\"" : "" %> onclick="selectAllCheckBox('all2',  'shopOrderColumn-2', 'shopOrderColumns-2')"/>全选
					<input class="titleCheck" type="checkbox" name="shopOrderColumn-2" id="shopOrderColumn-2" <%= JSPDataBean.getFormData("shopOrderColumns-2").indexOf(",shouHuoRen,") != -1 ? "checked=\"checked\"" : "" %> value="shouHuoRen" onclick="setSelectedValues('shopOrderColumn-2', 'shopOrderColumns-2')"/>收货人
					<input class="titleCheck" type="checkbox" name="shopOrderColumn-2" id="shopOrderColumn-2" <%= JSPDataBean.getFormData("shopOrderColumns-2").indexOf(",mobile,") != -1 ? "checked=\"checked\"" : "" %> value="mobile" onclick="setSelectedValues('shopOrderColumn-2', 'shopOrderColumns-2')"/>收货人手机
					<input class="titleCheck" type="checkbox" name="shopOrderColumn-2" id="shopOrderColumn-2" <%= JSPDataBean.getFormData("shopOrderColumns-2").indexOf(",phone,") != -1 ? "checked=\"checked\"" : "" %> value="phone" onclick="setSelectedValues('shopOrderColumn-2', 'shopOrderColumns-2')"/>收货人电话
					<input class="titleCheck" type="checkbox" name="shopOrderColumn-2" id="shopOrderColumn-2" <%= JSPDataBean.getFormData("shopOrderColumns-2").indexOf(",address,") != -1 ? "checked=\"checked\"" : "" %> value="address" onclick="setSelectedValues('shopOrderColumn-2', 'shopOrderColumns-2')"/>收货人地址
					<input class="titleCheck" type="checkbox" name="shopOrderColumn-2" id="shopOrderColumn-2" <%= JSPDataBean.getFormData("shopOrderColumns-2").indexOf(",postalCode,") != -1 ? "checked=\"checked\"" : "" %> value="postalCode" onclick="setSelectedValues('shopOrderColumn-2', 'shopOrderColumns-2')"/>收货人邮编
				
				</td>
			</tr>
			<tr>
				<td width="80px" align="right" style="height:30px;font-weight:bold;">商品信息：</td>
				<td width="auto;">
				<% boolean allSelect6 = JSPDataBean.getFormData("shopOrderColumns-6").indexOf(",productID,") != -1 &&  JSPDataBean.getFormData("shopOrderColumns-6").indexOf(",productName,") != -1 && JSPDataBean.getFormData("shopOrderColumns-6").indexOf(",propName,") != -1
						&& JSPDataBean.getFormData("shopOrderColumns-6").indexOf(",price,") != -1 && JSPDataBean.getFormData("shopOrderColumns-6").indexOf(",settlementPrice,") != -1 
						&& JSPDataBean.getFormData("shopOrderColumns-6").indexOf(",number,") != -1 && JSPDataBean.getFormData("shopOrderColumns-6").indexOf(",numberAndPrice,") != -1; %>
					<input class="titleCheck" type="checkbox" name="all6" id="all6" <%= allSelect6 ? "checked=\"checked\"" : "" %> onclick="selectAllCheckBox('all6',  'shopOrderColumn-6', 'shopOrderColumns-6')"/>全选
					<input class="titleCheck" type="checkbox" name="shopOrderColumn-6" id="shopOrderColumn-6" <%= JSPDataBean.getFormData("shopOrderColumns-6").indexOf(",productID,") != -1 ? "checked=\"checked\"" : "" %> value="productID" onclick="setSelectedValues('shopOrderColumn-6', 'shopOrderColumns-6')"/>编码
					<input class="titleCheck" type="checkbox" name="shopOrderColumn-6" id="shopOrderColumn-6" <%= JSPDataBean.getFormData("shopOrderColumns-6").indexOf(",productName,") != -1 ? "checked=\"checked\"" : "" %> value="productName" onclick="setSelectedValues('shopOrderColumn-6', 'shopOrderColumns-6')"/>名称
					<input class="titleCheck" type="checkbox" name="shopOrderColumn-6" id="shopOrderColumn-6" <%= JSPDataBean.getFormData("shopOrderColumns-6").indexOf(",propName,") != -1 ? "checked=\"checked\"" : "" %> value="propName" onclick="setSelectedValues('shopOrderColumn-6', 'shopOrderColumns-6')"/>销售属性
					<input class="titleCheck" type="checkbox" name="shopOrderColumn-6" id="shopOrderColumn-6" <%= JSPDataBean.getFormData("shopOrderColumns-6").indexOf(",price,") != -1 ? "checked=\"checked\"" : "" %> value="price" onclick="setSelectedValues('shopOrderColumn-6', 'shopOrderColumns-6')"/>价格
					<input class="titleCheck" type="checkbox" name="shopOrderColumn-6" id="shopOrderColumn-6" <%= JSPDataBean.getFormData("shopOrderColumns-6").indexOf(",settlementPrice,") != -1 ? "checked=\"checked\"" : "" %> value="settlementPrice" onclick="setSelectedValues('shopOrderColumn-6', 'shopOrderColumns-6')"/>结算价
					<input class="titleCheck" type="checkbox" name="shopOrderColumn-6" id="shopOrderColumn-6" <%= JSPDataBean.getFormData("shopOrderColumns-6").indexOf(",number,") != -1 ? "checked=\"checked\"" : "" %> value="number" onclick="setSelectedValues('shopOrderColumn-6', 'shopOrderColumns-6')"/>数量
					<input class="titleCheck" type="checkbox" name="shopOrderColumn-6" id="shopOrderColumn-6" <%= JSPDataBean.getFormData("shopOrderColumns-6").indexOf(",numberAndPrice,") != -1 ? "checked=\"checked\"" : "" %> value="numberAndPrice" onclick="setSelectedValues('shopOrderColumn-6', 'shopOrderColumns-6')"/>总价
				</td>
			</tr>
			<tr>
				<td width="80px" align="right" style="height:30px;font-weight:bold;">支付及配送：</td>
				<td>
				<% boolean allSelect3 = JSPDataBean.getFormData("shopOrderColumns-3").indexOf(",payType,") != -1 && JSPDataBean.getFormData("shopOrderColumns-3").indexOf(",payTime,") != -1
						&& JSPDataBean.getFormData("shopOrderColumns-3").indexOf(",deliveryType,") != -1; %>	
					<input class="titleCheck" type="checkbox" name="all3" id="all3" <%= allSelect3 ? "checked=\"checked\"" : "" %> onclick="selectAllCheckBox('all3',  'shopOrderColumn-3', 'shopOrderColumns-3')"/>全选
					<input class="titleCheck" type="checkbox" name="shopOrderColumn-3" id="shopOrderColumn-3" <%= JSPDataBean.getFormData("shopOrderColumns-3").indexOf(",payType,") != -1 ? "checked=\"checked\"" : "" %> value="payType" onclick="setSelectedValues('shopOrderColumn-3', 'shopOrderColumns-3')"/>支付方式
					<input class="titleCheck" type="checkbox" name="shopOrderColumn-3" id="shopOrderColumn-3" <%= JSPDataBean.getFormData("shopOrderColumns-3").indexOf(",payTime,") != -1 ? "checked=\"checked\"" : "" %> value="payTime" onclick="setSelectedValues('shopOrderColumn-3', 'shopOrderColumns-3')"/>支付时间
					<input class="titleCheck" type="checkbox" name="shopOrderColumn-3" id="shopOrderColumn-3" <%= JSPDataBean.getFormData("shopOrderColumns-3").indexOf(",deliveryType,") != -1 ? "checked=\"checked\"" : "" %> value="deliveryType" onclick="setSelectedValues('shopOrderColumn-3', 'shopOrderColumns-3')"/>送货方式
				</td>
			</tr>
			<tr>
				<td width="80px" align="right" style="height:30px;font-weight:bold;">发票信息：</td>
				<td>
				<%-- boolean allSelect4 = JSPDataBean.getFormData("shopOrderColumns-4").indexOf(",invoiceType,") != -1 && JSPDataBean.getFormData("shopOrderColumns-4").indexOf(",invoiceTitle,") != -1
						&& JSPDataBean.getFormData("shopOrderColumns-4").indexOf(",invoiceContent,") != -1; --%>
				<% boolean allSelect4 = JSPDataBean.getFormData("shopOrderColumns-4").indexOf(",invoiceTitle,") != -1; %>		
					 <input class="titleCheck" type="checkbox" name="all4" id="all4" <%= allSelect4 ? "checked=\"checked\"" : "" %>  onclick="selectAllCheckBox('all4',  'shopOrderColumn-4', 'shopOrderColumns-4')"/>全选
					<%--<input type="checkbox" name="shopOrderColumn-4" id="shopOrderColumn-4" <%= JSPDataBean.getFormData("shopOrderColumns-4").indexOf(",invoiceType,") != -1 ? "checked=\"checked\"" : "" %> value="invoiceType" onclick="setSelectedValues('shopOrderColumn-4', 'shopOrderColumns-4')"/>发票类型--%>
					<input class="titleCheck" type="checkbox" name="shopOrderColumn-4" id="shopOrderColumn-4" <%= JSPDataBean.getFormData("shopOrderColumns-4").indexOf(",invoiceTitle,") != -1 ? "checked=\"checked\"" : "" %> value="invoiceTitle" onclick="setSelectedValues('shopOrderColumn-4', 'shopOrderColumns-4')"/>发票抬头
					<%--<input type="checkbox" name="shopOrderColumn-4" id="shopOrderColumn-4" <%= JSPDataBean.getFormData("shopOrderColumns-4").indexOf(",invoiceContent,") != -1 ? "checked=\"checked\"" : "" %> value="invoiceContent" onclick="setSelectedValues('shopOrderColumn-4', 'shopOrderColumns-4')"/>发票内容--%>
				</td>
			</tr>
			<tr>
				<td width="80px" align="right" style="height:30px;font-weight:bold;">订单金额：</td>
				<td>
				<% boolean allSelect5 = JSPDataBean.getFormData("shopOrderColumns-5").indexOf(",productMoney,") != -1 && JSPDataBean.getFormData("shopOrderColumns-5").indexOf(",deliveryMoney,") != -1
						&& JSPDataBean.getFormData("shopOrderColumns-5").indexOf(",cutMoney1,") != -1 && JSPDataBean.getFormData("shopOrderColumns-5").indexOf(",cutMoney2,") != -1
						&& JSPDataBean.getFormData("shopOrderColumns-5").indexOf(",accountMoney,") != -1 && JSPDataBean.getFormData("shopOrderColumns-5").indexOf(",cardAmount,") != -1
						&& JSPDataBean.getFormData("shopOrderColumns-5").indexOf(",totalPrice,") != -1 && JSPDataBean.getFormData("shopOrderColumns-5").indexOf(",payAmount,") != -1; %>	
					<input class="titleCheck" type="checkbox" name="all5" id="all5" <%= allSelect5 ? "checked=\"checked\"" : "" %> onclick="selectAllCheckBox('all5',  'shopOrderColumn-5', 'shopOrderColumns-5')"/>全选
					<input class="titleCheck" type="checkbox" name="shopOrderColumn-5" id="shopOrderColumn-5" <%= JSPDataBean.getFormData("shopOrderColumns-5").indexOf(",productMoney,") != -1 ? "checked=\"checked\"" : "" %> value="productMoney" onclick="setSelectedValues('shopOrderColumn-5', 'shopOrderColumns-5')"/>商品总金额
					<input class="titleCheck" type="checkbox" name="shopOrderColumn-5" id="shopOrderColumn-5" <%= JSPDataBean.getFormData("shopOrderColumns-5").indexOf(",deliveryMoney,") != -1 ? "checked=\"checked\"" : "" %> value="deliveryMoney" onclick="setSelectedValues('shopOrderColumn-5', 'shopOrderColumns-5')"/>运费
					<input class="titleCheck" type="checkbox" name="shopOrderColumn-5" id="shopOrderColumn-5" <%= JSPDataBean.getFormData("shopOrderColumns-5").indexOf(",cutMoney1,") != -1 ? "checked=\"checked\"" : "" %> value="cutMoney1" onclick="setSelectedValues('shopOrderColumn-5', 'shopOrderColumns-5')"/>满减金额
					<input class="titleCheck" type="checkbox" name="shopOrderColumn-5" id="shopOrderColumn-5" <%= JSPDataBean.getFormData("shopOrderColumns-5").indexOf(",cutMoney2,") != -1 ? "checked=\"checked\"" : "" %> value="cutMoney2" onclick="setSelectedValues('shopOrderColumn-5', 'shopOrderColumns-5')"/>满赠金额
					<input class="titleCheck" type="checkbox" name="shopOrderColumn-5" id="shopOrderColumn-5" <%= JSPDataBean.getFormData("shopOrderColumns-5").indexOf(",accountMoney,") != -1 ? "checked=\"checked\"" : "" %> value="accountMoney" onclick="setSelectedValues('shopOrderColumn-5', 'shopOrderColumns-5')"/>余额支付
					<input class="titleCheck" type="checkbox" name="shopOrderColumn-5" id="shopOrderColumn-5" <%= JSPDataBean.getFormData("shopOrderColumns-5").indexOf(",cardAmount,") != -1 ? "checked=\"checked\"" : "" %> value="cardAmount" onclick="setSelectedValues('shopOrderColumn-5', 'shopOrderColumns-5')"/>优惠券支付
					<input class="titleCheck" type="checkbox" name="shopOrderColumn-5" id="shopOrderColumn-5" <%= JSPDataBean.getFormData("shopOrderColumns-5").indexOf(",totalPrice,") != -1 ? "checked=\"checked\"" : "" %> value="totalPrice" onclick="setSelectedValues('shopOrderColumn-5', 'shopOrderColumns-5')"/>订单总金额
					<input class="titleCheck" type="checkbox" name="shopOrderColumn-5" id="shopOrderColumn-5" <%= JSPDataBean.getFormData("shopOrderColumns-5").indexOf(",payAmount,") != -1 ? "checked=\"checked\"" : "" %> value="payAmount" onclick="setSelectedValues('shopOrderColumn-5', 'shopOrderColumns-5')"/>实收金额
				</td>
			</tr>
		</table>
	</div>
</div>

	<div>
		<div style="text-align: center;" class="buttonsDIV">
			<div id="confirmBut">
				<a class="btn_y" onclick="javascript:$('#confirmBut').css('display', 'none');$('#hasNotSend_img').css('display', '');doAction('order', 'export');"><span>确认</span></a>&nbsp;
				<a class="btn_y" onclick="javascript:closeInfoWindow('infoWindow');"><span>取消</span></a>
			</div>
		</div>
		<div class="textCenter" id="hasNotSend_img" style="display: none;">
			<img src="/images/waitSendEmail.gif" />
		</div>
	</div>
	
	<input type="hidden" name="shopOrderColumns-1" id="shopOrderColumns-1" value="<%= JSPDataBean.getFormData("shopOrderColumns-1") %>"/>
	<input type="hidden" name="shopOrderColumns-2" id="shopOrderColumns-2" value="<%= JSPDataBean.getFormData("shopOrderColumns-2") %>"/>
	<input type="hidden" name="shopOrderColumns-3" id="shopOrderColumns-3" value="<%= JSPDataBean.getFormData("shopOrderColumns-3") %>"/>
	<input type="hidden" name="shopOrderColumns-4" id="shopOrderColumns-4" value="<%= JSPDataBean.getFormData("shopOrderColumns-4") %>"/>
	<input type="hidden" name="shopOrderColumns-5" id="shopOrderColumns-5" value="<%= JSPDataBean.getFormData("shopOrderColumns-5") %>"/>
	<input type="hidden" name="shopOrderColumns-6" id="shopOrderColumns-6" value="<%= JSPDataBean.getFormData("shopOrderColumns-6") %>"/>

</div>
