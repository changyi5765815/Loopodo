<%@ page contentType="text/html;charset=UTF-8"%>
<jsp:directive.page import="java.util.Vector"/>
<jsp:directive.page import="java.util.Hashtable"/>
<%@page import="java.util.Iterator"%>
<%@page import="admin.customer.guanwangbao.AppUtil"%>
<%@page import="admin.customer.guanwangbao.LocalDataCache"%>
<%@page import="simpleWebFrame.util.PriceUtil"%>
<%@page import="admin.customer.guanwangbao.AppKeys"%>
<jsp:useBean id="JSPDataBean" scope='request' class="simpleWebFrame.web.JSPDataBean" />

<%@include file="common/commonHeader.jsp" %>

<div class="headDiv">
	<div class="btn_t left"><a href="javascript:postModuleAndAction('brand','defaultView')"><span><strong>品牌管理</strong></span></a></div>
	<% if (JSPDataBean.getFormData("action").equals("list")) { %>
		<div class="tip gray9" style="float: right;"><a href="javascript:postModuleAndAction('brand', 'addView')" class="btn_y"><span><strong class="icon_add">添加</strong></span></a> </div>
	<% } %>
</div>

<div class="main clear">
	<div class="clear"></div>
	
	<% if (JSPDataBean.getFormData("action").equals("list")) { %>
		<div class="search">
		  <table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td>
					品牌ID：<input type="text" name="q_brandID" id="q_brandID" value="<%= JSPDataBean.getFormData("q_brandID") %>" size="10" maxlength="6" onkeydown="javascript:if(event.keyCode==13) postModuleAndAction('brand', 'search')"/>&nbsp;
					
					名称：<input type="text" name="q_name" id="q_name" value="<%= JSPDataBean.getFormData("q_name") %>" size="25" maxlength="50" onkeydown="javascript:if(event.keyCode==13) postModuleAndAction('brand', 'search')"/>&nbsp;
					分类：<span id="queryBrandTypeSelect"><%=JSPDataBean.getFormData("queryBrandTypeSelect") %>&nbsp;</span>
				</td>
				<td class="righttd">
					<div><dl>
		               	<dt style="width: 100%;">
		                   	<a class="btn_y" onclick="javascript:postModuleAndAction('brand', 'search')"><span>搜&nbsp;&nbsp;&nbsp;&nbsp;索</span></a>
		                  	</dt>
		              </dl></div>
				</td>
			</tr>
			</table>
		</div>
	<div>
		<table class="list" border="0" cellpadding="0" cellspacing="1" width="100%" id="tab1">
			<tr>
				<th>品牌ID</th>
				<th>品牌logo</th>
				<th>品牌图片</th>
				<th>名称</th>
				<th>状态</th>
				<th>操作</th>
			</tr>
			<%
				Vector datas = (Vector) JSPDataBean.getJSPData("datas");
				String[] columns = {"name"};
				AppUtil.convertToHtml(columns, datas);
				for (int i = 0; i < datas.size(); i++) {
					Hashtable data = (Hashtable) datas.get(i);
			%>
			<tr>
				<td><%= data.get("brandID") %></td>
				<td><img src="<%= AppUtil.getImageURL("brand", data.get("logo").toString(), 0) %>"  style="height: 60px; width: 60px;"></td>
				<td><img src="<%= AppUtil.getImageURL("brand", data.get("image").toString(), 0) %>"  style="height: 60px; width: 60px;"></td>
				<td><%= data.get("name") %></td>
				<td>
				<% if (data.get("validFlag").equals("1")) { %>
					<a href="javascript:document.getElementById('brandID').value='<%= data.get("brandID") %>';postModuleAndAction('brand','disable')">
				<% } else { %>
					<a href="javascript:document.getElementById('brandID').value='<%= data.get("brandID") %>';postModuleAndAction('brand','enable')">
				<% } %>
					<img src="/images/<%= data.get("validFlag").equals("1") ? "yes" : "no"%>.gif" width="15px" border="none"/>
					</a>
				</td>
				<td>
					<a href="javascript:document.getElementById('brandID').value='<%= data.get("brandID") %>';postModuleAndAction('brand', 'editView')">编辑</a>
				</td>
			</tr>
			<%	} %>
		</table>
		<div class="page blue">
	    	<p class="floatl"><%@include file="common/commonJumpPage.jsp" %></p>
		    <div class="clear"></div>
		</div>
	</div>
	
	<% } else if (JSPDataBean.getFormData("action").equals("addView") 
				|| JSPDataBean.getFormData("action").equals("editView")
				|| JSPDataBean.getFormData("action").equals("confirm")) {  
	%>
		<div class="record">
		<%@include file="common/commonEditTitle.jsp" %>
		<table border="0" cellspacing="0" cellpadding="0" width="100%">
			<tr>
			  <th><span class="red">* </span>名称：</th>
			  <td><input type="text" name="name" id="name" size="60" maxlength="50" value="<%= JSPDataBean.getFormData("name") %>" /></td>
			</tr>
			<tr>
				<th>logo图片：</th>
				<td>
					<span>
	            	 	<img class="imgBorder" id='imagePreview2' src='<%= AppUtil.getImageURL("brand", JSPDataBean.getFormData("logo"), 0)%>' style="width:100px;height:100px"/>
	            	</span>
	            	<br />
	            	<a class="infoLink" href="javascript:void(0)" onclick="javascript:doUploadFile('brand', 'logo', 'imagePreview2', '')">上传</a>
	            	<a class="infoLink" href="javascript:void(0)" onclick="javascript:clearUploadFile('logo', 'imagePreview2')">删除</a>
	            	<font color="red">建议上传 宽100 的图片</font>
	            	<input type="hidden" name="logo" id="logo" value="<%= JSPDataBean.getFormData("logo") %>" />
				</td>
			</tr>
			<tr>
				<th>图片：</th>
				<td>
					<span>
	            	 	<img class="imgBorder" id='imagePreview' src='<%= AppUtil.getImageURL("brand", JSPDataBean.getFormData("image"), 0)%>' style="width:100px;height:100px"/>
	            	</span>
	            	<br />
	            	<a class="infoLink" href="javascript:void(0)" onclick="javascript:doUploadFile('brand', 'image', 'imagePreview', '')">上传</a>
	            	<a class="infoLink" href="javascript:void(0)" onclick="javascript:clearUploadFile('image', 'imagePreview')">删除</a>
	            	<font color="red">建议上传 宽374高210 的图片</font>
	            	<input type="hidden" name="image" id="image" value="<%= JSPDataBean.getFormData("image") %>" />
				</td>
			</tr>
		</table>
		
		<div align="center">
			<div class="button">
				<a class="btn_bb1" id="btnSave" onclick="javascript:postModuleAndAction('brand', 'confirm')"><span>保 存</span></a>
				<a onclick="javascript:postModuleAndAction('brand', 'defaultView')" class="btn_bb1"><span>返 回</span></a>
			</div>
		</div> 
	</div>

	<% } %>	
	<input type="hidden" id="brandID" name="brandID" value="<%=JSPDataBean.getFormData("brandID")%>" />
</div>

<%@include file="common/commonFooter.jsp" %>

<script type="text/javascript">

</script>








