<%@ page contentType="text/html;charset=UTF-8"%>
<jsp:directive.page import="java.util.Vector"/>
<jsp:directive.page import="java.util.Hashtable"/>
<%@page import="admin.customer.guanwangbao.AppUtil"%>
<%@page import="admin.customer.guanwangbao.AppKeys"%>

<jsp:useBean id="JSPDataBean" scope='request' class="simpleWebFrame.web.JSPDataBean" />

<div id="popwindow">
<h2><span>选择商品</span><a style="" class="close-button" href="javascript:closeInfoWindow('infoWindow');">关闭</a></h2>

<div style="width:900px; padding:10px">
	<div style="width:100%;height:auto;">
		<table cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td style="padding-left: 20px;">
					<span>商品ID：</span><sapn><input type="text" name="q_productID" id="q_productID" value="<%= JSPDataBean.getFormData("q_productID") %>" size="5" maxlength="20" /></span>&nbsp;
					<span>名称：</span><sapn><input type="text" name="q_name" id="q_name" value="<%= JSPDataBean.getFormData("q_name") %>" size="10" maxlength="20" /></span>&nbsp;
					<span>分类：</span><sapn id="queryProductTypeSelect"><%= JSPDataBean.getFormData("queryProductTypeSelect") %></span>
				</td>
				<td align="right" style="padding-right: 20px;">
					<input style="width: 80px;" type="button" class="input-button" value="搜索" onclick="javascript:document.getElementById('pageIndex').value=1;openInfoWindow('selectProduct2Window')" />
				</td>
			</tr>
		</table>
	</div>
	
	<div style="height:350px;overflow-y:scroll;margin-top:10px">
		<table cellpadding="0" cellspacing="0" width="99%">
			<tr style="height:30px;">
				<td width="5%" style="border-bottom:1px solid #b8d4e8;border-top:1px solid #b8d4e8;">&nbsp;</td>
				<td align="center" width="15%" style="border-bottom:1px solid #b8d4e8;border-top:1px solid #b8d4e8;"><b>商品ID</b></td>
				<td align="center" width="15%" style="border-bottom:1px solid #b8d4e8;border-top:1px solid #b8d4e8;"><b>图片</b></td>
				<td align="center" width="25%" style="border-bottom:1px solid #b8d4e8;border-top:1px solid #b8d4e8;"><b>名称</b></td>
				<td align="center" width="*" style="border-bottom:1px solid #b8d4e8;border-top:1px solid #b8d4e8;"><b>分类</b></td>
			</tr>
			<%
				Vector datas = (Vector) JSPDataBean.getJSPData("productDatas");
				for (int i = 0; i < datas.size(); i++) {
					Hashtable data = (Hashtable) datas.get(i);
					String[] columns = {"name"};
					AppUtil.convertToHtml(columns, data);
			%>
			<tr>
				<td align="center"  style="border-bottom:1px solid #b8d4e8;">
					<input type="checkbox" name="relateProductCheckbox" onchange="setSelectedValues('relateProductCheckbox', 'selectedValues')" value="<%= data.get("productID") %>" />
				</td>
				<td align="center" style="border-bottom:1px solid #b8d4e8;"><%= data.get("productID") %></td>
				<td align="center" style="border-bottom:1px solid #b8d4e8;">
					<img src="<%= AppUtil.getProductImage(data, AppKeys.IMAGE_SIZE_SMALL) %>"  style="height: 60px; width: 55px; display: block;">
				</td>
				<td align="center" style="border-bottom:1px solid #b8d4e8;"><%= data.get("name") %></td>
				<td align="center" style="border-bottom:1px solid #b8d4e8;">
					<%= data.get("bigTypeName") %> - <%= data.get("smallTypeName") %> - <%= data.get("tinyTypeName") %>
				</td>
			</tr>
			<%	} %>
		</table>
	</div>
</div>
<input type="hidden" id="json" value="<%= JSPDataBean.getFormData("json").replaceAll("\"", "'") %>" >
<div style="text-align: center;" class="buttonsDIV">
	<%@include file="commonWindowJumpPage.jsp" %>
</div>

<div style="text-align: center;" class="buttonsDIV">
	
	<input value="选定" class="button" style="width: 50px;height: 25px;" type="button" onclick="javascript:selectProducts2()">

</div>
</div>
