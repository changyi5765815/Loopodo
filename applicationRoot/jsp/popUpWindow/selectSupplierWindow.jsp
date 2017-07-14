<%@ page contentType="text/html;charset=UTF-8"%>
<jsp:directive.page import="java.util.Vector"/>
<jsp:directive.page import="java.util.Hashtable"/>
<%@page import="admin.customer.guanwangbao.AppKeys"%>
<%@page import="admin.customer.guanwangbao.AppUtil"%>
<%@page import="admin.customer.guanwangbao.LocalDataCache"%>

<jsp:useBean id="JSPDataBean" scope='request' class="simpleWebFrame.web.JSPDataBean" />

<div id="popwindow">
<h2><span>选择店铺</span><a style="" class="close-button" href="javascript:closeInfoWindow('infoWindow');">关闭</a></h2>

<div style="width:900px; padding:10px">
	<div style="width:100%;height:auto;">
		<table cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td style="padding-left: 20px;">
					<span>店铺ID：</span><sapn><input type="text" name="q_supplierID2" id="q_supplierID2" value="<%= JSPDataBean.getFormData("q_supplierID2") %>" size="5" maxlength="20" /></span>&nbsp;
					<span>店铺名称：</span><sapn><input type="text" name="q_name" id="q_name" value="<%= JSPDataBean.getFormData("q_name") %>" size="10" maxlength="20" /></span>&nbsp;
				</td>
				<td align="right" style="padding-right: 20px;">
					<input style="width: 80px;" type="button" class="input-button" value="搜索" onclick="javascript:document.getElementById('pageIndex').value=1;openInfoWindow('common', 'selectSupplierWindow')" />
				</td>
			</tr>
		</table>
	</div>
	
	<div style="height:350px;overflow-y:scroll;margin-top:10px">
		<table cellpadding="0" cellspacing="0" width="99%">
			<tr style="height:30px;">
				<td width="5%" style="border-bottom:1px solid #b8d4e8;border-top:1px solid #b8d4e8;">&nbsp;</td>
				<td align="center" width="10%" style="border-bottom:1px solid #b8d4e8;border-top:1px solid #b8d4e8;"><b>店铺ID</b></td>
				<td align="center" width="10%" style="border-bottom:1px solid #b8d4e8;border-top:1px solid #b8d4e8;"><b>旺铺名称</b></td>
				<td align="center" width="10%" style="border-bottom:1px solid #b8d4e8;border-top:1px solid #b8d4e8;"><b>旺铺信誉标签</b></td>
				<td align="center" width="15%" style="border-bottom:1px solid #b8d4e8;border-top:1px solid #b8d4e8;"><b>申请时间</b></td>
				<td align="center" width="10%" style="border-bottom:1px solid #b8d4e8;border-top:1px solid #b8d4e8;"><b>联系人</b></td>
				<td align="center" width="10%" style="border-bottom:1px solid #b8d4e8;border-top:1px solid #b8d4e8;"><b>联系电话</b></td>
				<td align="center" width="10%" style="border-bottom:1px solid #b8d4e8;border-top:1px solid #b8d4e8;"><b>是否优质供应商</b></td>
			</tr>
			<%
			String selectedValues = "," + JSPDataBean.getFormData("selectedValues") + ",";
				Vector datas = (Vector) JSPDataBean.getJSPData("datas");
				String[] columns = {"name", "nick"};
				AppUtil.convertToHtml(columns, datas);
				for (int i = 0; i < datas.size(); i++) {
					Hashtable data = (Hashtable) datas.get(i);
					String userID = data.get("userID").toString();
			%>
			<tr>
				<td align="center"  style="border-bottom:1px solid #b8d4e8;">
					<input type="radio" id="selectChoice" name="selectChoice" onclick="$('#q_supplierID').val('<%= data.get("supplierID") %>');$('#q_supplierName').val('<%= data.get("name") %>');closeInfoWindow('infoWindow');" value="<%= data.get("userID") %>" />
				</td>
				<td height="28" align="center" style="border-bottom:1px solid #b8d4e8;"><%= data.get("supplierID")%></td>
				<td align="center" style="border-bottom:1px solid #b8d4e8;"><%= data.get("name") %></td>
				<td align="center" style="border-bottom:1px solid #b8d4e8;">
					<%= LocalDataCache.getInstance().getTableDataColumnsValue("c_supplierTag", data.get("supplierTagIDs").toString(), "c_supplierTagName") %>
				</td>
				<td align="center" style="border-bottom:1px solid #b8d4e8;"><%= data.get("applyTime") %></td>
				<td align="center" style="border-bottom:1px solid #b8d4e8;"><%= data.get("linkMan") %></td>
				<td align="center" style="border-bottom:1px solid #b8d4e8;"><%= data.get("linkPhone") %></td>
				<td align="center" style="border-bottom:1px solid #b8d4e8;">
					<img src="/images/<%= data.get("excellentFlag").equals("1") ? "yes" : "no"%>.gif" width="15px" border="none"/>
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
	
	<input value="选定" class="button" style="width: 50px;height: 25px;" type="button" onclick="javascript:selectUsers()">

</div>
</div>
