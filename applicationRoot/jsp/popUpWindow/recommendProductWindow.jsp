<%@ page contentType="text/html;charset=UTF-8"%>
<jsp:directive.page import="java.util.Vector"/>
<jsp:directive.page import="java.util.Hashtable"/>
<%@page import="simpleWebFrame.util.StringUtil"%>
<%@page import="admin.customer.guanwangbao.AppUtil"%>

<jsp:useBean id="JSPDataBean" scope='request' class="simpleWebFrame.web.JSPDataBean" />

<div id="popwindow">
<h2><span>推荐商品</span><a style="" class="close-button" href="javascript:closeInfoWindow('infoWindow');">关闭</a></h2>

<div style="width:400px; padding:10px">
	<div style="margin-top:10px;height:auto;">
		<table cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td width="100px" align="right" style="height:30px;font-weight:bold;"><span style="color: red">* </span>推荐理由：</td>
				<td width="220px"><input type="text" value="<%= JSPDataBean.getFormData("recommendReason") %>" name="recommendReason" maxlength="30"/></td>
			</tr>
			<tr>
				<td width="100px" align="right" style="height:30px;font-weight:bold;"><span style="color: red">* </span>推荐指数：</td>
				<td width="220px">
					<select name="recommendNum">
						<option value="1" <%= JSPDataBean.getFormData("recommendNum").equals("1") ? "selected='selected'" : ""  %>>1星</option>
						<option value="2" <%= JSPDataBean.getFormData("recommendNum").equals("2") ? "selected='selected'" : ""  %>>2星</option>
						<option value="3" <%= JSPDataBean.getFormData("recommendNum").equals("3") ? "selected='selected'" : ""  %>>3星</option>
						<option value="4" <%= JSPDataBean.getFormData("recommendNum").equals("4") ? "selected='selected'" : ""  %>>4星</option>
						<option value="5" <%= JSPDataBean.getFormData("recommendNum").equals("5") ? "selected='selected'" : ""  %>>5星</option>
					</select>
				</td>
			</tr>
		</table>
	</div>
</div>
	<div>
		<div style="text-align: center;" class="buttonsDIV">
		<a class="btn_y" onclick="javascript:doAction('product', 'confirmRecommend');"><span>确认推荐</span></a>&nbsp;
		<% if(JSPDataBean.getFormData("isRecommendFlag").equals("1")) { %>
			<a class="btn_y" onclick="javascript:doAction('product', 'cancelRecommend');"><span>取消推荐</span></a>
		<% } %>
		<a class="btn_y" onclick="javascript:closeInfoWindow('infoWindow');"><span>关闭窗口</span></a>
		</div>
	</div>
</div>
