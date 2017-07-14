<%@page import="admin.customer.guanwangbao.LocalDataCache"%>
<%@ page contentType="text/html;charset=UTF-8"%>
<jsp:directive.page import="java.util.Vector"/>
<jsp:directive.page import="java.util.Hashtable"/>
<%@page import="admin.customer.guanwangbao.AppKeys"%>
<%@page import="admin.customer.guanwangbao.AppUtil"%>

<jsp:useBean id="JSPDataBean" scope='request' class="simpleWebFrame.web.JSPDataBean" />

<div id="popwindow">
<h2><span>选择企业</span><a style="" class="close-button" href="javascript:closeInfoWindow('infoWindow');">关闭</a></h2>

<div style="width:900px; padding:10px">
	<div style="width:100%;height:auto;">
		<table cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td style="padding-left: 20px;">
					<span>企业名称：</span><sapn><input type="text" name="q_companyName2" id="q_companyName2" value="<%= JSPDataBean.getFormData("q_companyName2") %>" size="50" maxlength="20" /></span>&nbsp;
				</td>
				<td align="right" style="padding-right: 20px;">
					<input style="width: 80px;" type="button" class="input-button" value="搜索" onclick="javascript:document.getElementById('pageIndex').value=1;openInfoWindow('famousCompany', 'selectCompanyUserWindow')" />
				</td>
			</tr>
		</table>
	</div>
	
	<div style="height:350px;overflow-y:scroll;margin-top:10px">
		<table cellpadding="0" cellspacing="0" width="99%">
			<tr style="height:30px;">
				<td width="5%" style="border-bottom:1px solid #b8d4e8;border-top:1px solid #b8d4e8;">&nbsp;</td>
				<td align="center" width="10%" style="border-bottom:1px solid #b8d4e8;border-top:1px solid #b8d4e8;"><b>会员ID</b></td>
				<td align="center" width="10%" style="border-bottom:1px solid #b8d4e8;border-top:1px solid #b8d4e8;"><b>企业名称</b></td>
				<td align="center" width="10%" style="border-bottom:1px solid #b8d4e8;border-top:1px solid #b8d4e8;"><b>联系人</b></td>
				<td align="center" width="15%" style="border-bottom:1px solid #b8d4e8;border-top:1px solid #b8d4e8;"><b>联系人手机</b></td>
				<td align="center" width="10%" style="border-bottom:1px solid #b8d4e8;border-top:1px solid #b8d4e8;"><b>企业人数</b></td>
				<td align="center" width="10%" style="border-bottom:1px solid #b8d4e8;border-top:1px solid #b8d4e8;"><b>公司行业</b></td>
				<td align="center" width="10%" style="border-bottom:1px solid #b8d4e8;border-top:1px solid #b8d4e8;"><b>公司性质</b></td>
			</tr>
			<%
			String selectedValues = "," + JSPDataBean.getFormData("selectedValues") + ",";
				Vector datas = (Vector) JSPDataBean.getJSPData("datas");
				String[] columns = {"companyName", "companyContactName"};
				AppUtil.convertToHtml(columns, datas);
				for (int i = 0; i < datas.size(); i++) {
					Hashtable data = (Hashtable) datas.get(i);
					String userID = data.get("userID").toString();
			%>
			<tr style="height:50px;">
				<td align="center"  style="border-bottom:1px solid #b8d4e8;">
					<input type="checkbox" <%= selectedValues.indexOf("," + userID + ",") != -1 ? "checked=\"checked\"" : "" %> id="selectChoice" name="selectChoice" onchange="selectValue(this, 'selectChoice', 'selectedValues')" value="<%= data.get("userID") %>" />
				</td>
				<td align="center" style="border-bottom:1px solid #b8d4e8;"><%= data.get("userID") %></td>
				<td align="center" style="border-bottom:1px solid #b8d4e8;"><%= data.get("companyName") %></td>
				<td align="center" style="border-bottom:1px solid #b8d4e8;"><%= data.get("companyContactName") %></td>
				<td align="center" style="border-bottom:1px solid #b8d4e8;"><%= data.get("companyContactMobile") %></td>
				<td align="center" style="border-bottom:1px solid #b8d4e8;"><%= LocalDataCache.getInstance().getTableDataColumnValue("c_companyScale", data.get("companyScaleID").toString(), "c_companyScaleName")  %></td>
				<td align="center" style="border-bottom:1px solid #b8d4e8;"><%= LocalDataCache.getInstance().getTableDataColumnValue("c_companyIndustry", data.get("companyIndustryID").toString(), "c_companyIndustryName")  %></td>
				<td align="center" style="border-bottom:1px solid #b8d4e8;"><%= LocalDataCache.getInstance().getTableDataColumnValue("c_companyNature", data.get("companyNatureID").toString(), "c_companyNatureName")  %></td>
			</tr>
			<%	} %>
		</table>
	</div>
</div>
<div style="text-align: center;" class="buttonsDIV">
	<%@include file="commonWindowJumpPage.jsp" %>
</div>

<div style="text-align: center;" class="buttonsDIV">
	
	<input value="选定" class="button" style="width: 50px;height: 25px;" type="button" onclick="javascript:selectCompanyUsers()">

</div>
</div>
