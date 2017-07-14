<%@ page contentType="text/html;charset=UTF-8"%>
<jsp:directive.page import="java.util.Vector"/>
<jsp:directive.page import="java.util.Hashtable"/>
<%@page import="simpleWebFrame.util.StringUtil"%>
<%@page import="admin.customer.guanwangbao.AppUtil"%>

<jsp:useBean id="JSPDataBean" scope='request' class="simpleWebFrame.web.JSPDataBean" />

<div id="popwindow">
	<h2><span>寄件人信息</span><a style="" class="close-button" href="javascript:closeInfoWindow('infoWindow');">关闭</a></h2>

	<div style="width:400px; padding:10px">
		<div style="margin-top:10px;height:auto;">
			<table cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td width="100px" align="right" style="height:30px;font-weight:bold;">寄件公司：</td>
					<td width="220px"><input type="text" name="deliveryFromCompany" id="deliveryFromCompany" value="<%= JSPDataBean.getFormData("deliveryFromCompany") %>"  maxlength="20"></td>
				</tr>
				<tr>
					<td width="100px" align="right" style="height:30px;font-weight:bold;">寄件人：</td>
					<td width="220px"><input type="text" name="deliveryFromPerson" id="deliveryFromPerson" value="<%= JSPDataBean.getFormData("deliveryFromPerson") %>"  maxlength="50"></td>
				</tr>
				<tr>
					<td width="100px" align="right" style="height:30px;font-weight:bold;">寄件地址：</td>
					<td width="220px">
						<input type="text" name="deliveryFromAddress" id="deliveryFromAddress" value="<%= JSPDataBean.getFormData("deliveryFromAddress") %>"  maxlength="50">
					</td>
				</tr>
				<tr>
					<td width="100px" align="right" style="height:30px;font-weight:bold;">寄件邮编：</td>
					<td width="220px">
						<input type="text" name="deliveryFromPostal" id="deliveryFromPostal" value="<%= JSPDataBean.getFormData("deliveryFromPostal") %>"  maxlength="50">
					</td>
				</tr>
				<tr>
					<td width="100px" align="right" style="height:30px;font-weight:bold;">寄件联系电话：</td>
					<td width="220px">
						<input type="text" name="deliveryFromPhone" id="deliveryFromPhone" value="<%= JSPDataBean.getFormData("deliveryFromPhone") %>"  maxlength="50">
					</td>
				</tr>
			</table>
		</div>
	</div>

	<div>
		<div style="text-align: center;" class="buttonsDIV">
		<a class="btn_y" href="" id="saveDeliveryInfo" target="_Blank" onclick="getHref();"><span>确认</span></a>&nbsp;
		<a class="btn_y" onclick="javascript:closeInfoWindow('infoWindow');"><span>取消</span></a>
		</div>
	</div>
	<script type="text/javascript">
		function getHref() {
			var href = "/admin?module=printDelivery&action=printView&shopOrderID=" + $("#shopOrderID").val();
			var otherParas1 = "&deliveryFromCompany=" + encodeURI(encodeURI($("#deliveryFromCompany").val()));
			var otherParas2 = "&deliveryFromPerson=" + encodeURI(encodeURI($("#deliveryFromPerson").val()));
			var otherParas3 = "&deliveryFromAddress=" + encodeURI(encodeURI($("#deliveryFromAddress").val()));
			var otherParas4 = "&deliveryFromPostal=" + encodeURI(encodeURI($("#deliveryFromPostal").val()));
			var otherParas5 = "&deliveryFromPhone=" + encodeURI(encodeURI($("#deliveryFromPhone").val()));
			$("#saveDeliveryInfo").attr('href', href + otherParas1 + otherParas2 + otherParas3 + otherParas4 + otherParas5);
		}
	</script>
</div>