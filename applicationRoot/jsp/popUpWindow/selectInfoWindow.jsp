<%@ page contentType="text/html;charset=UTF-8"%>
<jsp:directive.page import="java.util.Vector"/>
<jsp:directive.page import="java.util.Hashtable"/>
<%@page import="admin.customer.guanwangbao.AppUtil"%>
<%@page import="admin.customer.guanwangbao.AppKeys"%>

<jsp:useBean id="JSPDataBean" scope='request' class="simpleWebFrame.web.JSPDataBean" />

<div id="popwindow">
<h2><span>选择文章</span><a style="" class="close-button" href="javascript:closeInfoWindow('infoWindow');">关闭</a></h2>

<div style="width:900px; padding:10px">
	<div style="width:100%;height:auto;">
		<table cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td style="padding-left: 20px;">
					<span>文章ID：</span><sapn><input type="text" name="q_infoID" id="q_infoID" value="<%= JSPDataBean.getFormData("q_infoID") %>" size="5" maxlength="6" /></span>&nbsp;
					<span>标题：</span><sapn><input type="text" name="q_title" id="q_title" value="<%= JSPDataBean.getFormData("q_title") %>" size="10" maxlength="50" /></span>&nbsp;
					<span>版块：</span><sapn id="queryProductTypeSelect"><%= JSPDataBean.getFormData("queryInfoTypeSelect") %></span>
				</td>
				<td align="right" style="padding-right: 20px;">
					<input style="width: 80px;" type="button" class="input-button" value="搜索" onclick="javascript:document.getElementById('pageIndex').value=1;openInfoWindow('common', 'selectInfoWindow')" />
				</td>
			</tr>
		</table>
	</div>
	
	<div style="height:350px;overflow-y:scroll;margin-top:10px">
		<table cellpadding="0" cellspacing="0" width="99%">
			<tr style="height:30px;">
				<td width="5%" style="border-bottom:1px solid #b8d4e8;border-top:1px solid #b8d4e8;">&nbsp;</td>
				<td align="center" width="15%" style="border-bottom:1px solid #b8d4e8;border-top:1px solid #b8d4e8;"><b>文章ID</b></td>
				<td align="center" width="15%" style="border-bottom:1px solid #b8d4e8;border-top:1px solid #b8d4e8;"><b>图片</b></td>
				<td align="center" width="25%" style="border-bottom:1px solid #b8d4e8;border-top:1px solid #b8d4e8;"><b>标题</b></td>
				<td align="center" width="*" style="border-bottom:1px solid #b8d4e8;border-top:1px solid #b8d4e8;"><b>版块</b></td>
			</tr>
			<%
				Vector datas = (Vector) JSPDataBean.getJSPData("datas");
				String[] columns = {"title", "infoTypeName"};
				AppUtil.convertToHtml(columns, datas);
				for (int i = 0; i < datas.size(); i++) {
					Hashtable data = (Hashtable) datas.get(i);
			%>
			<tr>
				<td align="center"  style="border-bottom:1px solid #b8d4e8;">
					<input type="checkbox" name="selectChoice" onchange="setSelectedValues('selectChoice', 'selectedValues')" value="<%= data.get("infoID") %>" />
				</td>
				<td align="center" style="border-bottom:1px solid #b8d4e8;"><%= data.get("infoID") %></td>
				<td align="center" style="border-bottom:1px solid #b8d4e8;">
					<img src="<%= AppUtil.getImageURL("other", data.get("image").toString(), 0) %>"  style="height: 60px; width: 55px; display: block;">
				</td>
				<td align="center" style="border-bottom:1px solid #b8d4e8;" title="<%= data.get("title") %>"><%= AppUtil.splitString(data.get("title").toString(), 50) %></td>
				<td align="center" style="border-bottom:1px solid #b8d4e8;">
					<%= data.get("infoTypeName") %>
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
	
	<input value="选定" class="button" style="width: 50px;height: 25px;" type="button" onclick="javascript:selectInfos()">

</div>
</div>
