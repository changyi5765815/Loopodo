<%@ page contentType="text/html;charset=UTF-8"%>
<jsp:directive.page import="java.util.Vector"/>
<jsp:directive.page import="java.util.Hashtable"/>
<%@page import="java.util.Iterator"%>
<%@page import="admin.customer.guanwangbao.AppUtil"%>

<jsp:useBean id="JSPDataBean" scope='request' class="simpleWebFrame.web.JSPDataBean" />

<%@include file="common/commonHeader.jsp" %>
<div class="headDiv">
	<div class="btn_t left"><a href="javascript:postModuleAndAction('deliveryType','defaultView')"/><span><strong>物流方式设置</strong></span></a></div>
	<div class="main clear">
		<div class="clear"></div>
		<% if (JSPDataBean.getFormData("action").equals("list") ) {%>
			<div>
			<table class="list" border="0" cellpadding="0" cellspacing="1" width="100%" id="tab1">
				<tr>
					<th>物流方式ID</th>
					<th>名称</th>
					<th>编码</th>
					<th>物流面单</th>
					<th>状态</th>
					<th>操作</th>
				</tr>
				<%
					Vector datas = (Vector)JSPDataBean.getJSPData("datas");
					String[] columns = {"name"};
					AppUtil.convertToHtml(columns, datas);
					for (int i = 0; i < datas.size(); i++){
					Hashtable data = (Hashtable)datas.get(i);
					String trClass = "tr_line" + (i%2);
				 %>
				 <tr class="<%= trClass%>">
				 	<td><%= data.get("deliveryTypeID") %></td>
				 	<td><%= data.get("name") %></td>
				 	<td><%= data.get("code") %></td>
				 	<td><img src="<%= AppUtil.getImageURL("deliveryType", data.get("image").toString(), 0) %>" width="200px"/></td>
				 	<td>
				 	<% if (data.get("validFlag").equals("1")) {%>
				 		<a href="javascript:document.getElementById('deliveryTypeID').value='<%=data.get("deliveryTypeID") %>'; postModuleAndAction('deliveryType','deliveryTypeDisable')"/>
				 	<% }else{ %>	
				 		<a href="javascript:document.getElementById('deliveryTypeID').value='<%=data.get("deliveryTypeID") %>'; postModuleAndAction('deliveryType','deliveryTypeEable')"/>
			 		<% } %>
			 		<img src="/images/<%= data.get("validFlag").equals("1") ? "yes" : "no" %>.gif"  width="15px" border="none"/>
				 	 </td>
				 	<td>
				 		<a href="javascript:document.getElementById('deliveryTypeID').value='<%=data.get("deliveryTypeID")%>';postModuleAndAction('deliveryType','deliveryTypeEditView')">编辑</a>
				 	</td>
				 </tr>
				 <% } %>
			</table>
			<input type="hidden" id="deliveryTypeID" name="deliveryTypeID" value="<%= JSPDataBean.getFormData("deliveryTypeID")%>"/>
			</div>
		<% }else if (JSPDataBean.getFormData("action").equals("deliveryTypeAddView")
		         || JSPDataBean.getFormData("action").equals("deliveryTypeEditView")
		         || JSPDataBean.getFormData("action").equals("deliveryTypeConfirm")) { 
					String[] columns = {"name"};
					AppUtil.convertToHtml(columns, JSPDataBean.getFormDatas());
		%>
		<div class="record">
		<%@include file="common/commonEditTitle.jsp" %>
		<table border="0" cellspacing="0" cellpadding="0" width="100%">
			<tr>
				<th><span class="red">* </span>投递公司名称：</th>
				<td>
					<input type="text" name="name" id="name" value="<%=JSPDataBean.getFormData("name")%>" size="30" maxlength="50" />
				</td>
			</tr>
			<tr>
				<th>投递公司代码：</th>
				<td>
					<input type="text" name="code" id="code" value="<%=JSPDataBean.getFormData("code")%>" size="30" maxlength="50" />
				</td>
			</tr>
			<tr>
				<th>投递公司面单：</th>
				<td>
					<img class="imgBorder" id="imagePreview" src="<%= AppUtil.getImageURL("deliveryType", JSPDataBean.getFormData("image"), 0) %>" width="200" />
					<a href="javascript:void(0)" onclick="javascript:doUploadFile('deliveryType', 'image', 'imagePreview', '')">上传</a>
					<a class="infoLink" href="javascript:void(0)" onclick="javascript:clearUploadFile('image', 'imagePreview')">删除</a>
					<input type="hidden" value="<%= JSPDataBean.getFormData("image") %>" id="image" name="image">
				</td>
			</tr>
		</table>
		<input type="hidden" id="deliveryTypeID" name="deliveryTypeID" value="<%=JSPDataBean.getFormData("deliveryTypeID")%>" />
		<div align="center">
			<div class="button">
				<a class="btn_bb1" id="btnSave" onclick="javascript:postModuleAndAction('deliveryType', 'deliveryTypeConfirm')"><span>保 存</span></a>
				<a class="btn_bb1" onclick="javascript:postModuleAndAction('deliveryType', 'defaultView')" ><span>返 回</span></a>
			</div>
		</div> 
	</div>	
	<% } %>
</div>


<%@include file="common/commonFooter.jsp" %>
