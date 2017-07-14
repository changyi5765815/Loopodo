<%@ page contentType="text/html;charset=UTF-8"%>
<jsp:directive.page import="java.util.Vector"/>
<jsp:directive.page import="java.util.Hashtable"/>
<%@page import="admin.customer.guanwangbao.AppUtil"%>
<%@page import="admin.customer.guanwangbao.AppKeys"%>
<%@page import="admin.customer.guanwangbao.PropUtil"%>
<%@page import="simpleWebFrame.util.StringUtil"%>

<jsp:useBean id="JSPDataBean" scope='request' class="simpleWebFrame.web.JSPDataBean" />

<div id="popwindow">
<h2><span>选择商品</span><a style="" class="close-button" href="javascript:closeInfoWindow('infoWindow');">关闭</a></h2>

<div style="width:900px; padding:10px">
	<div style="width:100%;height:auto;">
		<table cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td style="padding-left: 20px;">
					<span>商品ID：</span><sapn><input type="text" name="q_productID2" id="q_productID2" value="<%= JSPDataBean.getFormData("q_productID2") %>" size="5" maxlength="20" /></span>&nbsp;
					<span>名称：</span><sapn><input type="text" name="q_name2" id="q_name2" value="<%= JSPDataBean.getFormData("q_name2") %>" size="10" maxlength="20" /></span>&nbsp;
					<span>分类：</span><sapn id="queryProductTypeSelect3"><%= JSPDataBean.getFormData("queryProductTypeSelect3") %></span>
				</td>
				<td align="right" style="padding-right: 20px;">
					<input style="width: 80px;" type="button" class="input-button" value="搜索" onclick="javascript:document.getElementById('pageIndex').value=1;openInfoWindow('selectSkuWindow')" />
				</td>
			</tr>
		</table>
	</div>
	
	<div style="height:350px;overflow-y:scroll;margin-top:10px">
		<table cellpadding="0" cellspacing="0" width="99%">
			<tr style="height:30px;">
				<td width="5%" style="border-bottom:1px solid #b8d4e8;border-top:1px solid #b8d4e8;">&nbsp;</td>
				<td align="center" width="10%" style="border-bottom:1px solid #b8d4e8;border-top:1px solid #b8d4e8;"><b>商品ID</b></td>
				<td align="center" width="*" style="border-bottom:1px solid #b8d4e8;border-top:1px solid #b8d4e8;"><b>名称</b></td>
				<td align="center" width="20%" style="border-bottom:1px solid #b8d4e8;border-top:1px solid #b8d4e8;"><b>sku名称</b></td>
				<th align="center" width="10%" style="border-bottom:1px solid #b8d4e8;border-top:1px solid #b8d4e8;">价格</th>
			</tr>
			<%
				Vector datas = (Vector) JSPDataBean.getJSPData("datas");
				for (int i = 0; i < datas.size(); i++) {
					Hashtable data = (Hashtable) datas.get(i);
					String skuPropName = PropUtil.getSkuPropName(data.get("props").toString(), data.get("skuPropValueAlias").toString());
					skuPropName = StringUtil.convertXmlChars(skuPropName);
			%>
			<tr>
				<td align="center"  style="border-bottom:1px solid #b8d4e8;">
					<input type="radio" id="selectChoice" name="selectChoice" onclick="$('#productID').val('<%= data.get("productID") %>');$('#productName').val('<%= StringUtil.convertXmlChars(data.get("name").toString()) %>');$('#propName').val('<%= skuPropName %>');$('#skuID').val('<%= data.get("skuID") %>');$('#price').val('<%= data.get("price") %>');" />
				</td>
				<td align="center" style="border-bottom:1px solid #b8d4e8;"><%= data.get("productID") %></td>
				<td align="center" style="border-bottom:1px solid #b8d4e8;" title="<%= data.get("name") %>">
					<%= AppUtil.splitString(StringUtil.convertXmlChars(data.get("name").toString()), 30) %>
				</td>
				<td align="center" style="border-bottom:1px solid #b8d4e8;"><%= skuPropName %></td>
				<td align="center" style="border-bottom:1px solid #b8d4e8;">
					￥<%= data.get("price") %>
				</td>
			</tr>
			<%	} %>
		</table>
	</div>
</div>
<div style="text-align: center;" class="buttonsDIV">
	<%@include file="commonWindowJumpPage.jsp" %>
</div>

<div style="text-align: center;" class="buttonsDIV">
	
	<input value="选定" class="button" style="width: 50px;height: 25px;" type="button" onclick="javascript:selectProducts()">

</div>
</div>
