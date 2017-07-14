<%@page import="simpleWebFrame.util.PriceUtil"%>
<%@ page contentType="text/html;charset=UTF-8"%>
<jsp:directive.page import="java.util.Vector"/>
<jsp:directive.page import="java.util.Hashtable"/>
<%@page import="admin.customer.guanwangbao.LocalDataCache"%>

<jsp:useBean id="JSPDataBean" scope='request' class="simpleWebFrame.web.JSPDataBean" />

<div id="popwindow">
<h2><span>拒绝退款</span><a style="" class="close-button" href="javascript:closeInfoWindow('infoWindow');">关闭</a></h2>
<div style="width:420px; padding:10px">
	<div style="margin-top:10px;height:auto;">
		<table cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td width="120px" align="right" style="height:30px;font-weight:bold;">退款金额：</td>
				<td width="220px"><%= PriceUtil.formatPrice(JSPDataBean.getFormData("refundAmount")) %></td>
			</tr>
			<tr>
				<td width="120px" align="right" style="height:30px;font-weight:bold;">支付方式：</td>
				<td width="220px"><%= LocalDataCache.getInstance().getTableDataColumnValue("payType", JSPDataBean.getFormData("payTypeID"), "name") %></td>
			</tr>
			<tr>
				<td width="120px" align="right" style="height:30px;font-weight:bold;">第三方平台交易单号：</td>
				<td width="220px"><%= JSPDataBean.getFormData("transactionNum") %></td>
			</tr>
			<tr>
				<td width="120px" align="right" style="height:30px;font-weight:bold;"><span style="color: red">*</span>拒绝原因：</td>
				<td width="220px">
				<textarea style="width:200px;" id="dealNote" name="dealNote" 
					onkeyup="if(this.value.length > 100)this.value=this.value.substring(0,100)"></textarea>
				</td>
			</tr>
		</table>
	</div>
</div>

		<div>
			<div style="text-align: center;" class="buttonsDIV">
			<a class="btn_y" onclick="doAction('refund', 'refuseRefund')"><span>确认</span></a>&nbsp;
			<a class="btn_y" onclick="javascript:closeInfoWindow('infoWindow');"><span>取消</span></a>
			</div>
		</div>
</div>
