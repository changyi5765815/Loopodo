<%@ page contentType="text/html;charset=UTF-8"%>
<jsp:directive.page import="java.util.Vector"/>
<jsp:directive.page import="java.util.Hashtable"/>
<%@page import="simpleWebFrame.util.StringUtil"%>
<%@page import="admin.customer.guanwangbao.LocalDataCache"%>
<jsp:useBean id="JSPDataBean" scope='request' class="simpleWebFrame.web.JSPDataBean" />

<div id="popwindow">
<h2><span>商品审核</span><a style="" class="close-button" href="javascript:closeInfoWindow('infoWindow');">关闭</a></h2>
<div style="width:420px; padding:10px">
	<div style="margin-top:10px;height:auto;">
		<table cellpadding="0" cellspacing="0" width="100%">
				<% 
				if (JSPDataBean.getFormData("product_opt").equals("waitAudit")) { 
				
				%>			
			<tr>
				<td width="120px" align="right" style="height:30px;font-weight:bold;"><span class="red">* </span>审核结果：</td>
				<td width="220px">
					<select name="auditStatus" id="auditStatus">
						<option value="20">通过</option>
						<option value="90">不通过</option>
					</select>
				</td>
			</tr>
			<tr>
				<td width="120px" align="right" style="height:30px;font-weight:bold;">审核备注：</td>
				<td width="220px"><textarea class="form-control" style="weight:100px;" name="auditNote" id="auditNote" onkeyup="if(this.value.length > 100) this.value=this.value.substr(0,100)"></textarea></td>
			</tr>
				<% } else if (JSPDataBean.getFormData("product_opt").equals("hasAudit")) { 
						Vector datas112 = (Vector) JSPDataBean.getJSPData("datas112");

				%>
				<th width="13.5%" align="center">日志编号</th>
				<th width="13.5%" align="center">商品ID</th>
				<th width="13.5%" align="center">审核类型</th>
				<th width="13.5%" align="center">审核结果</th>
				<th width="*" align="center">审核备注</th>
				<th width="20%" align="center">审核时间</th>
				<th width="13.5%" align="center">审 核 人</th>
				<%
		    		for (int i = 0; i < datas112.size(); i++) {
						Hashtable data2 = (Hashtable) datas112.get(i);				
				
				 %>
				 
				 
			<tr>
				<td style="text-align: center"><%= data2.get("auditLogID") %></td>
				<td style="text-align: center"><%= data2.get("dataID") %></td>
				<td style="text-align: center"><%= data2.get("auditLogTypeID") %></td>
				<td style="text-align: center"><%= data2.get("auditResult") %></td>
				<td style="text-align: center"><%= StringUtil.convertXmlChars(data2.get("auditNote").toString()) %></td>
				<td style="text-align: center"><%= data2.get("auditTime") %></td>
				<td style="text-align: center"><%= data2.get("systemUserName") %></td>
			</tr>
				<% } %>
				<% } %>
				
		</table>
	</div>
</div>

		<div>
		
			<div style="text-align: center;" class="buttonsDIV">
			<% 
			if (JSPDataBean.getFormData("product_opt").equals("waitAudit")) { 
			
			%>				
			<a class="btn_y" onclick="doAction('product', 'auditProduct')"><span>确认</span></a>&nbsp;
			<% } else if (JSPDataBean.getFormData("product_opt").equals("hasAudit")) { %>
			<% } %>
			<a class="btn_y" onclick="javascript:closeInfoWindow('infoWindow');"><span>取消</span></a>
			</div>
		</div>
</div>