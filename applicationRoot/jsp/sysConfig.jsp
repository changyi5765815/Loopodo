<%@ page contentType="text/html;charset=UTF-8"%>
<jsp:directive.page import="java.util.Vector"/>
<jsp:directive.page import="java.util.Hashtable"/>
<%@page import="java.util.Iterator"%>
<%@page import="admin.customer.guanwangbao.AppUtil"%>
<%@page import="simpleWebFrame.util.PriceUtil"%>
<jsp:useBean id="JSPDataBean" scope='request' class="simpleWebFrame.web.JSPDataBean" />

<%@include file="common/commonHeader.jsp" %>

<div class="headDiv">
	<div class="btn_t left"><a href="javascript:postModuleAndAction('sysConfig','defaultView')"><span><strong>系统参数设置</strong></span></a></div>
	<div class="btn_t left"><a href="javascript:postModuleAndAction('sysConfig','list2')"><span><strong>商城信息</strong></span></a></div>
	<div class="btn_t left"><a href="javascript:postModuleAndAction('sysConfig','list3')"><span><strong>邮件服务器</strong></span></a></div>
</div>

<div class="main clear">
	<div class="clear"></div>
	
	<% if (JSPDataBean.getFormData("action").equals("list")) { %>
	<table class="list" border="0" cellpadding="0" cellspacing="1" width="100%" id="tab1">
		<tr>
			<th>参数名称</th>
			<th>参数值</th>
			<th>参数说明</th>
			<th>操作</th>
		</tr>
		<%
			Vector datas = (Vector) JSPDataBean.getJSPData("datas");
			String[] columns = {"name"};
			AppUtil.convertToHtml(columns, datas);
			for (int i = 0; i < datas.size(); i++) {
				Hashtable data = (Hashtable) datas.get(i);
				if(data.get("name").equals("qqServiceNum") 
				|| data.get("name").equals("servicePhone")
				|| data.get("name").equals("serviceEmail")
				|| data.get("name").equals("serviceTownID")
				|| data.get("name").equals("serviceAddress")
				|| data.get("name").equals("serviceQrCode")
				|| data.get("name").equals("serviceWeiBolink")
				|| data.equals("mailServer.smtpHost")
				|| data.equals("mailServer.userName")
				|| data.equals("mailServer.password")
				) continue;
		%>
		<tr>
		  	<td><%= data.get("name") %></td>
		  	<td>
		  		<input id="<%= data.get("name") %>" name="<%= data.get("name") %>" value="<%= data.get("value") %>" maxlength="100" size="50"/>
	  		</td>
	  		<td><%= data.get("info") %></td>
		  	<td>
		  		<a href="javascript:document.getElementById('name').value='<%= data.get("name") %>';postModuleAndAction('sysConfig', 'update')">更新</a>
		  	</td>
		</tr>
		<%	} %>
	</table>
	<input type="hidden" name="name" id="name" value="<%= JSPDataBean.getFormData("name") %>" />
	<% 
		} else if(JSPDataBean.getFormData("action").equals("list2")) {
	%>
		<div class="record">
			<%@include file="common/commonEditTitle.jsp" %>
			<table border="0" cellspacing="0" cellpadding="0" width="100%">
				<tr>
					<th>QQ客服：</th>
					<td><input type="text" name="qqServiceNum" id="qqServiceNum" value="<%= JSPDataBean.getFormData("qqServiceNum") %>" size="30" maxlength="50" /><span>多个客户以英文逗号可开</span></td>
				</tr>
				<tr>
					<th>平台方客服联系电话：</th>
					<td><input type="text" name="servicePhone" id="servicePhone" value="<%= JSPDataBean.getFormData("servicePhone") %>" size="30" maxlength="50" /></td>
				</tr>
				<tr>
					<th>平台方客服电子邮件：</th>
					<td><input type="text" name="serviceEmail" id="serviceEmail" value="<%= JSPDataBean.getFormData("serviceEmail") %>" size="30" maxlength="50" /></td>
				</tr>
				<tr>
					<th>所在地区：</th>
					<td id="citySelect"><%= JSPDataBean.getFormData("selectTown") %></td>
				</tr>
				<tr>
					<th>详细地址：</th>
					<td><input type="text" name="serviceAddress" id="serviceAddress" value="<%= JSPDataBean.getFormData("serviceAddress") %>" size="30" maxlength="50" /></td>
				</tr>
				<tr>
					<th>商城微信二维码：</th>
					<td>
						<img class="imgBorder" id='imagePreview' src='<%= AppUtil.getImageURL("other", JSPDataBean.getFormData("serviceQrCode"), 0)%>' style="width:100px;height:100px"/>
						<a href="javascript:void(0)" onclick="javascript:doUploadFile('other', 'serviceQrCode', 'imagePreview', '')">上传</a>
						<a class="infoLink" href="javascript:void(0)" onclick="javascript:clearUploadFile('serviceQrCode', 'imagePreview')">删除</a>
						<input type="hidden" value="<%= JSPDataBean.getFormData("serviceQrCode") %>" id="serviceQrCode" name="serviceQrCode">
					</td>
				</tr>
				<tr>
					<th>平台方客服微博链接：</th>
					<td><input type="text" name="serviceWeiBolink" id="serviceWeiBolink" value="<%= JSPDataBean.getFormData("serviceWeiBolink") %>" size="30" maxlength="50" /></td>
				</tr>
			</table>
			<div align="center">
				<div class="button">
					<a class="btn_bb1" id="btnSave" onclick="javascript:doAction('sysConfig', 'confirm')"><span>保 存</span></a>
				</div>
			</div>
		</div>
	<% 
		} else if(JSPDataBean.getFormData("action").equals("list3")) {
	%>
		<div class="record">
			<%@include file="common/commonEditTitle.jsp" %>
			<table border="0" cellspacing="0" cellpadding="0" width="100%">
				<tr>
					<th>email服务器主机名：</th>
					<td>
						<%= JSPDataBean.getFormData("smtpHostSelect") %>
					</td>
				</tr>
				<tr>
					<th>email服务器用户名：</th>
					<td><input type="text" name="mailServer.userName" id="mailServer.userName" value="<%= JSPDataBean.getFormData("mailServer.userName") %>" size="30" maxlength="50" /></td>
				</tr>
				<tr>
					<th>email服务器密码：</th>
					<td><input type="text" name="mailServer.password" id="mailServer.password" value="<%= JSPDataBean.getFormData("mailServer.password") %>" size="30" maxlength="50" /></td>
				</tr>
			</table>
			<div align="center">
				<div class="button">
					<a class="btn_bb1" id="btnSave" onclick="javascript:doAction('sysConfig', 'confirm2')"><span>保 存</span></a>
					<a class="btn_bb1" id="btnSave" onclick="javascript:openInfoWindow('sendEmailWindow')"><span>发送测试邮件</span></a>
				</div>
			</div>
		</div>
	<% } %>
</div>

<%@include file="common/commonFooter.jsp" %>
