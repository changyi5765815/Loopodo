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
				<td width="80px" align="right" style="height:30px;font-weight:bold;">商品信息：</td>
				<td>
					<% boolean allSelect6 = JSPDataBean.getFormData("productColumns-6").indexOf(",productID,") != -1 &&  JSPDataBean.getFormData("productColumns-6").indexOf(",name,") != -1 && JSPDataBean.getFormData("productColumns-6").indexOf(",productTypeName,") != -1
						&& JSPDataBean.getFormData("productColumns-6").indexOf(",productCode,") != -1 && JSPDataBean.getFormData("productColumns-6").indexOf(",supplierName,") != -1 
						&& JSPDataBean.getFormData("productColumns-6").indexOf(",normalPrice,") != -1 && JSPDataBean.getFormData("productColumns-6").indexOf(",price,") != -1
						&& JSPDataBean.getFormData("productColumns-6").indexOf(",brandName,") != -1
						&& JSPDataBean.getFormData("productColumns-6").indexOf(",viewCount,") != -1 && JSPDataBean.getFormData("productColumns-6").indexOf(",stock,") != -1; %>
					<input type="checkbox" name="all6" id="all6" <%= allSelect6 ? "checked=\"checked\"" : "" %> onclick="selectAllCheckBox('all6',  'productColumn-6', 'productColumns-6')"/>全选
					<input type="checkbox" name="productColumn-6" id="productColumn-6" <%= JSPDataBean.getFormData("productColumns-6").indexOf(",productID,") != -1 ? "checked=\"checked\"" : "" %> value="productID" onclick="setSelectedValues('productColumn-6', 'productColumns-6')"/>商品ID
					<input type="checkbox" name="productColumn-6" id="productColumn-6" <%= JSPDataBean.getFormData("productColumns-6").indexOf(",name,") != -1 ? "checked=\"checked\"" : "" %> value="name" onclick="setSelectedValues('productColumn-6', 'productColumns-6')"/>名称
					<input type="checkbox" name="productColumn-6" id="productColumn-6" <%= JSPDataBean.getFormData("productColumns-6").indexOf(",supplierName,") != -1 ? "checked=\"checked\"" : "" %> value="supplierName" onclick="setSelectedValues('productColumn-6', 'productColumns-6')"/>供应商
					<input type="checkbox" name="productColumn-6" id="productColumn-6" <%= JSPDataBean.getFormData("productColumns-6").indexOf(",productTypeName,") != -1 ? "checked=\"checked\"" : "" %> value="productTypeName" onclick="setSelectedValues('productColumn-6', 'productColumns-6')"/>分类
					<input type="checkbox" name="productColumn-6" id="productColumn-6" <%= JSPDataBean.getFormData("productColumns-6").indexOf(",brandName,") != -1 ? "checked=\"checked\"" : "" %> value="brandName" onclick="setSelectedValues('productColumn-6', 'productColumns-6')"/>品牌
					<input type="checkbox" name="productColumn-6" id="productColumn-6" <%= JSPDataBean.getFormData("productColumns-6").indexOf(",productCode,") != -1 ? "checked=\"checked\"" : "" %> value="productCode" onclick="setSelectedValues('productColumn-6', 'productColumns-6')"/>商品条码
					<input type="checkbox" name="productColumn-6" id="productColumn-6" <%= JSPDataBean.getFormData("productColumns-6").indexOf(",normalPrice,") != -1 ? "checked=\"checked\"" : "" %> value="normalPrice" onclick="setSelectedValues('productColumn-6', 'productColumns-6')"/>市场价
					<input type="checkbox" name="productColumn-6" id="productColumn-6" <%= JSPDataBean.getFormData("productColumns-6").indexOf(",price,") != -1 ? "checked=\"checked\"" : "" %> value="price" onclick="setSelectedValues('productColumn-6', 'productColumns-6')"/>商城价
					<input type="checkbox" name="productColumn-6" id="productColumn-6" <%= JSPDataBean.getFormData("productColumns-6").indexOf(",viewCount,") != -1 ? "checked=\"checked\"" : "" %> value="viewCount" onclick="setSelectedValues('productColumn-6', 'productColumns-6')"/>浏览量
					<input type="checkbox" name="productColumn-6" id="productColumn-6" <%= JSPDataBean.getFormData("productColumns-6").indexOf(",stock,") != -1 ? "checked=\"checked\"" : "" %> value="stock" onclick="setSelectedValues('productColumn-6', 'productColumns-6')"/>库存
				</td>
			</tr>
		</table>
	</div>
</div>

	<div>
		<div style="text-align: center;" class="buttonsDIV">
			<div id="confirmBut">
				<a class="btn_y" onclick="javascript:$('#confirmBut').css('display', 'none');$('#hasNotSend_img').css('display', '');doAction('product', 'export');"><span>确认</span></a>&nbsp;
				<a class="btn_y" onclick="javascript:closeInfoWindow('infoWindow');"><span>取消</span></a>
			</div>
		</div>
		<div class="textCenter" id="hasNotSend_img" style="display: none;">
			<img src="/images/waitSendEmail.gif" />
		</div>
	</div>
	
	<input type="hidden" name="productColumns-6" id="productColumns-6" value="<%= JSPDataBean.getFormData("productColumns-6") %>"/>

</div>
