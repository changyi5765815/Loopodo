<%@page import="admin.customer.guanwangbao.AppKeys"%>
<%@page import="admin.customer.guanwangbao.AppUtil"%>
<%@ page contentType="text/html;charset=UTF-8"%>
<jsp:directive.page import="java.util.Vector"/>
<jsp:directive.page import="java.util.Hashtable"/>
<%@page import="java.util.Iterator"%>
<%@page import="simpleWebFrame.util.StringUtil"%>

<jsp:useBean id="JSPDataBean" scope='request' class="simpleWebFrame.web.JSPDataBean" />

<%@include file="common/commonHeader.jsp" %>

<div class="headDiv">
	<div class="btn_t left"><a href="javascript:postModuleAndAction('supplierTheme','defaultView')"><span><strong>商户首页模板管理</strong></span></a></div>
	<% if (JSPDataBean.getFormData("action").equals("list")) { %>
		<div class="tip gray9" style="float: right;"><a href="javascript:postModuleAndAction('supplierTheme', 'addView')" class="btn_y"><span><strong class="icon_add">添加模板</strong></span></a> </div>
	<% } %>
</div>


<div class="main clear">
	<% if (JSPDataBean.getFormData("action").equals("list") ) { %>
	<div>
		<table class="list" border="0" cellpadding="0" cellspacing="1" width="100%" id="tab1">
			<tr>
				<th>模板ID</th>
				<th>标题</th>
				<th>图片</th>
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
			 <tr class="<%= (i+1)%2 ==0 ? "oddTr":"" %>">
			 	<td><%= data.get("supplierThemeID") %></td>
			 	<td><%= data.get("name") %></td>
			 	<td><img src="<%= AppUtil.getImageURL("supplierTheme", data.get("image").toString(), AppKeys.SUPPLIER_THEME_IMAGE_SIZE) %>" style="max-width: 100px"  /></td>
			 	<td>
					<% if (data.get("validFlag").equals("1")) { %>
					<a href="javascript:document.getElementById('supplierThemeID').value='<%=data.get("supplierThemeID")%>';postModuleAndAction('supplierTheme','disable')">
					<% } else { %>
					<a href="javascript:document.getElementById('supplierThemeID').value='<%=data.get("supplierThemeID")%>';postModuleAndAction('supplierTheme','enable')">
					<% } %>
					<img src="/images/<%= data.get("validFlag").equals("1") ? "yes" : "no"%>.gif" width="15px" border="none"/>
					</a>
				</td>
			 	<td>
			 		<a href="javascript:document.getElementById('supplierThemeID').value='<%= data.get("supplierThemeID")%>';postModuleAndAction('supplierTheme','editeView')">编辑</a>
			 	</td>
			 </tr>
			 <% } %>
		</table>
	</div>
	<% } else if (JSPDataBean.getFormData("action").equals("editeView") || JSPDataBean.getFormData("action").equals("confirm") || JSPDataBean.getFormData("action").equals("addView")) { 
		String[] columns = {"name"};
		AppUtil.convertToHtml(columns, JSPDataBean.getFormDatas()); 
	%>
	<div class="record">
		<%@include file="common/commonEditTitle.jsp" %>
		<table border="0" cellspacing="0" cellpadding="0" width="100%">
			<tr>
			 	<th width="25%"></th>
				<td width="*"></td>
			</tr>
			<tr>
				<th width="25%" ><span class="red">* </span>标题：</th>
				<td>
					<input type="text" name="name" id="name"  size="25" maxlength="100" value="<%= JSPDataBean.getFormData("name")%>">
				</td>
			</tr>
			<tr>
				<th width="25%"><span class="red">* </span>图片：</th>
				<td>
					<span>
           	 			<img class="imgBorder" id='imagePreview' src='<%= AppUtil.getImageURL("supplierTheme", JSPDataBean.getFormData("image"), 0)%>' style="width: 100px;"/>
           			</span>
           			<a href="javascript:void(0)" onclick="javascript:doUploadFile('supplierTheme', 'image', 'imagePreview', '')">上传</a>
           			<a href="javascript:void(0)" onclick="javascript:clearUploadFile('image', 'imagePreview')">删除</a>
           			<input type="hidden" name="image" id="image" value="<%= JSPDataBean.getFormData("image") %>" />
				</td>
			</tr>
			<tr>
				<th width="25%"><span class="red">* </span>内容：</th>
				<td></td>
			</tr>
			<tr>
				<th></th>
				<td>
					<script id="ueditor" name="content" type="text/plain" style="width:700px;min-height:300px;text-align: left;display:inline-block"><%= JSPDataBean.getFormData("content") %></script>
					<script type="text/javascript">
					   var ueditor = UE.getEditor('ueditor');
					</script>
				</td>
			</tr>
				
		</table>
		<div align="center">
			<div class="button">
				<a class="button2" onclick="javascript:postModuleAndAction('supplierTheme', 'confirm')" ><span>保 存</span></a>
				<a class="button2" onclick="javascript:postModuleAndAction('supplierTheme', 'list')" ><span>返 回</span></a>
			</div>
		</div> 
	</div>
	<% } %>
</div>

<input type="hidden" id="supplierThemeID" name="supplierThemeID" value="<%=JSPDataBean.getFormData("supplierThemeID")%>" />

<%@include file="common/commonFooter.jsp" %>
