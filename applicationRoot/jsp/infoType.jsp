<%@ page contentType="text/html;charset=UTF-8"%>
<jsp:directive.page import="java.util.Vector"/>
<jsp:directive.page import="java.util.Hashtable"/>
<%@page import="java.util.Iterator"%>
<%@page import="admin.customer.guanwangbao.AppUtil"%>
<%@page import="admin.customer.guanwangbao.LocalDataCache"%>
<%@page import="simpleWebFrame.util.PriceUtil"%>
<jsp:useBean id="JSPDataBean" scope='request' class="simpleWebFrame.web.JSPDataBean" />

<%@include file="common/commonHeader.jsp" %>

<div class="headDiv">
	<div class="btn_t left"><a href="javascript:postModuleAndAction('infoType','defaultView')"><span><strong>文章分类</strong></span></a></div>
	<% if (JSPDataBean.getFormData("action").equals("list")) { %>
		<div class="tip gray9" style="float: right;"><a href="javascript:postModuleAndAction('infoType', 'addView')" class="btn_y"><span><strong class="icon_add">添加</strong></span></a> </div>
	<% } %>
</div>

<div class="main clear">
	<div class="clear"></div>
	
	<% if (JSPDataBean.getFormData("action").equals("list")) { %>
	<div>
		<table class="list" border="0" cellpadding="0" cellspacing="1" width="100%" id="tab1">
			<tr>
				<th>ID</th>
				<th width="10%">图标</th>
				<th>分类名称</th>
				<th>排序&nbsp;<input value="更新" onclick="$('#table').val('infoType');doAction('updateSortIndexAll')" type="button"></th>
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
				<td><%= data.get("infoTypeID") %></td>
				<td>
			 		<img src="<%= AppUtil.getImageURL("other", data.get("icon").toString(), 0) %>"  style="width: 30px;">
				</td>
				<td><%= data.get("name") %></td>
				<td>
					<input id="sortIndex_<%= data.get("infoTypeID") %>" name="sortIndex_<%= data.get("infoTypeID") %>" value="<%= data.get("sortIndex") %>" maxlength="11" size="5"  type="text">
				</td>
				<td>
					<a href="javascript:document.getElementById('infoTypeID').value= '<%= data.get("infoTypeID")%>'; postModuleAndAction('infoType','<%= data.get("validFlag").equals("1") ? "disable" : "enable" %>')">
					<img src="/images/<%= data.get("validFlag").equals("1") ? "yes" : "no"%>.gif" width="15px" border="none"/>
					</a>
				</td>
				 <td>
				 	<a href="javascript:document.getElementById('infoTypeID').value='<%= data.get("infoTypeID")%>';postModuleAndAction('infoType','editView')">编辑</a>
				 	<a href="javascript:if(confirm('是否删除')){document.getElementById('infoTypeID').value='<%= data.get("infoTypeID")%>';postModuleAndAction('infoType','delete')}">删除</a>
				 </td>
			</tr>
			<%	} %>
		</table>
	</div>
	<% } else if (JSPDataBean.getFormData("action").equals("addView")
	           || JSPDataBean.getFormData("action").equals("editView")
	           || JSPDataBean.getFormData("action").equals("confirm")) { 
			String[] columns = {"name"};
			AppUtil.convertToHtml(columns, JSPDataBean.getFormDatas());
	%>
		<div class="record">
		<%@include file="common/commonEditTitle.jsp" %>
			<table border="0" cellspacing="0" cellpadding="0" width="100%">
				<tr>
					<th width="25%"><span class="red">* </span>名称：</th>
					<td><input type="text" name="name" id="name" value="<%= JSPDataBean.getFormData("name") %>" size="30" maxlength="20" /></td>
				</tr>
				<tr>
					<th>图标：</th>
					<td>
					<span>
	            	 	<img class="imgBorder" id='preViewImage' src='<%= AppUtil.getImageURL("infoType", JSPDataBean.getFormData("icon"), 0)%>' style="width: 50px;height: 50px"/>
	            	</span>
	            	<a href="javascript:void(0)" onclick="javascript:doUploadFile('infoType', 'icon', 'preViewImage', '')">上传</a>
	            	<a href="javascript:void(0)" onclick="javascript:$('#imageNameHolderID').val('icon');$('#imageSrcHolderID').val('preViewImage');openInfoWindow('common', 'selectIconWindow')">图标库</a>
	            	<a href="javascript:void(0)" onclick="javascript:clearUploadFile('icon', 'preViewImage')">删除</a>
	            	<input type="hidden" name="icon" id="icon" value="<%= JSPDataBean.getFormData("icon") %>" />
	            	</td>
				</tr>
			</table>
		<div align="center">
			<div class="button">
				<a class="btn_bb1" id="btnSave" onclick="javascript:postModuleAndAction('infoType', 'confirm')"><span>保 存</span></a>
				<a onclick="javascript:postModuleAndAction('infoType','defaultView')" class="btn_bb1"><span>返 回</span></a>
			</div>
		</div>
	</div>
	<% } %>
	<input type="hidden" name="infoTypeID" id="infoTypeID" value="<%= JSPDataBean.getFormData("infoTypeID") %>" />
	<%= JSPDataBean.getFormData("queryConditionHtml") %>	
	
</div>

<%@include file="common/commonFooter.jsp" %>
