<%@ page contentType="text/html;charset=UTF-8"%>
<jsp:directive.page import="java.util.Vector"/>
<jsp:directive.page import="java.util.Hashtable"/>
<%@page import="simpleWebFrame.util.StringUtil"%>
<%@page import="admin.customer.guanwangbao.AppUtil"%>

<jsp:useBean id="JSPDataBean" scope='request' class="simpleWebFrame.web.JSPDataBean" />
<%
	String[] columns = {"showUserName", "commentContent", "replyContent"};
	AppUtil.convertToHtml(columns, JSPDataBean.getFormDatas());
%>

<div id="popwindow">
<h2><span>设置问题订单</span><a style="" class="close-button" href="javascript:closeInfoWindow('infoWindow');">关闭</a></h2>

<div style="width:400px; padding:10px">
	<div style="margin-top:10px;height:auto;">
		<table cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td width="100px" align="right" style="height:30px;font-weight:bold;"><span style="color: red">* </span>问题类型：</td>
				<td width="220px"><%= JSPDataBean.getFormData("queryExceptionTypeSelect") %></td>
			</tr>
			<tr>
				<td width="100px" align="right" style="height:30px;font-weight:bold;"><span style="color: red">* </span>问题描述：</td>
				<td width="220px">
					<textarea style="width:200px;" name="exceptionNote" id="exceptionNote" onkeyup="if(this.value.length>100)this.value=this.value.substring(0,100)"></textarea><br>(100个英文字符以内)
				</td>
			</tr>
		</table>
	</div>
</div>

		<div>
			<div style="text-align: center;" class="buttonsDIV">
			<a class="btn_y" onclick="javascript:doAction('order', 'setExceptionOrder');"><span>确认</span></a>&nbsp;
			<a class="btn_y" onclick="javascript:closeInfoWindow('infoWindow');"><span>取消</span></a>
			</div>
		</div>
</div>
