<%@ page contentType="text/html;charset=UTF-8"%>
<jsp:directive.page import="java.util.Vector"/>
<jsp:directive.page import="java.util.Hashtable"/>
<%@page import="simpleWebFrame.util.StringUtil"%>
<%@page import="admin.customer.guanwangbao.AppUtil"%>

<jsp:useBean id="JSPDataBean" scope='request' class="simpleWebFrame.web.JSPDataBean" />

<div id="popwindow">
<h2><span>咨询回复</span><a style="" class="close-button" href="javascript:closeInfoWindow('infoWindow');">关闭</a></h2>
<%
	String[] columns = {"showUserName", "consultationContent", "replyContent"};
	AppUtil.convertToHtml(columns, JSPDataBean.getFormDatas());
%>
<div style="width:400px; padding:10px">
	<div style="margin-top:10px;height:auto;">
		<table cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td width="100px" align="right" style="height:30px;font-weight:bold;">咨询人：</td>
				<td width="220px"><%= JSPDataBean.getFormData("showUserName") %></td>
			</tr>
			<tr>
				<td width="100px" align="right" style="height:30px;font-weight:bold;">咨询信息：</td>
				<td width="220px" style="word-break:break-all;word-wrap:break-word"><%= JSPDataBean.getFormData("consultationContent") %></td>
			</tr>
			<tr>
				<td width="100px" align="right" style="height:30px;font-weight:bold;">时间：</td>
				<td width="220px"><%= JSPDataBean.getFormData("postTime") %></td>
			</tr>
			<tr>
				<td width="100px" align="right" style="height:30px;font-weight:bold;"><% if (!JSPDataBean.getFormData("replyFlag").equals("1")) { %> <span style="color: red">* </span> <% } %>回复：</td>
				<td width="220px">
				<%
					if(JSPDataBean.getFormData("replyFlag").equals("1")) {
				%>
					<%= JSPDataBean.getFormData("replyContent") %>
				<% } else { %>
					<textarea style="width:200px;" name="replyContent" id="replyContent" onkeyup="if(this.value.length>500)this.value=this.value.substring(0,500)"><%= JSPDataBean.getFormData("replyContent") %></textarea>
				<% } %>
				</td>
			</tr>
		</table>
	</div>
</div>

		<%
			if(!JSPDataBean.getFormData("replyFlag").equals("1")) {
		%>
		<div>
			<div style="text-align: center;" class="buttonsDIV">
			<a class="btn_y" onclick="javascript:doAction('consultation', 'saveReply');"><span>确认</span></a>&nbsp;
			<a class="btn_y" onclick="javascript:closeInfoWindow('infoWindow');"><span>取消</span></a>
			</div>
		</div>
		<% } %>
</div>
