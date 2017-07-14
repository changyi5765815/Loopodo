<%@ page contentType="text/html;charset=UTF-8"%>
<jsp:directive.page import="java.util.Vector"/>
<jsp:directive.page import="java.util.Hashtable"/>
<%@page import="java.util.Iterator"%>
<%@page import="admin.customer.guanwangbao.AppUtil"%>
<%@page import="admin.customer.guanwangbao.LocalDataCache"%>
<jsp:useBean id="JSPDataBean" scope='request' class="simpleWebFrame.web.JSPDataBean" />

<%@include file="common/commonHeader.jsp" %>

<div class="headDiv">
<% if (JSPDataBean.getFormData("action").startsWith("propertiesValue")) { %>
	<div class="btn_t0 left"><a href="javascript:postModuleAndAction('skuProp','defaultView')"><span><strong>销售属性设置</strong></span></a></div>
	<div class="btn_t left"><a href="javascript:postModuleAndAction('skuProp', 'propertiesValueDefaultView')"><span><strong>销售属性值设置</strong></span></a></div>
	<% if (JSPDataBean.getFormData("action").equals("propertiesValueDefaultView")) { %>
	<div class="tip gray9" style="float: right;"><a href="javascript:postModuleAndAction('skuProp', 'propertiesValueAddView')" class="btn_y"><span><strong class="icon_add">添加销售属性值</strong></span></a> </div>
	<% } %>
<% } else { %>
	<div class="btn_t left"><a href="javascript:postModuleAndAction('skuProp','defaultView')"><span><strong>销售属性设置</strong></span></a></div>
	<% if (JSPDataBean.getFormData("action").equals("list")) { %>
	<div class="tip gray9" style="float: right;"><a href="javascript:postModuleAndAction('skuProp', 'addView')" class="btn_y"><span><strong class="icon_add">添加销售属性</strong></span></a> </div>
	<% } %>
<% } %>

</div>

<div class="main clear">
	<div class="clear"></div>
	
	<% if (JSPDataBean.getFormData("action").equals("list")) { %>
    <div class="search">
	  	<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td>
					属性名：<input type="text" name="q_name" id="q_name" value="<%= JSPDataBean.getFormData("q_name") %>" size="25" maxlength="50" onkeydown="javascript:if(event.keyCode==13) postModuleAndAction('skuProp', 'search')"/>&nbsp;
				</td>
				<td class="righttd">
					<div><dl>
	               		<dt style="width: 100%;">
	                   		<a class="btn_y" onclick="javascript:postModuleAndAction('skuProp', 'search')"><span>搜&nbsp;&nbsp;&nbsp;&nbsp;索</span></a>
	                   	</dt>
	              	</dl></div>
				</td>
			</tr>
		</table>
	</div>
	<div>
		<table class="list" border="0" cellpadding="0" cellspacing="1" width="100%" id="tab1">
			<tr>
				<th>属性ID</th>
				<th>属性名</th>
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
				<td><%= data.get("skuPropID") %></td>
				<td><%= data.get("name") %></td>
				<td>
					<% if (data.get("validFlag").equals("1")) { %>
					<a href="javascript:document.getElementById('skuPropID').value='<%= data.get("skuPropID") %>';postModuleAndAction('skuProp','disable')">
					<% } else { %>
					<a href="javascript:document.getElementById('skuPropID').value='<%= data.get("skuPropID") %>';postModuleAndAction('skuProp','enable')">
					<% } %>
					<img src="/images/<%= data.get("validFlag").equals("1") ? "yes" : "no"%>.gif" width="15px" border="none"/>
					</a>
				</td>
				<td>
					<a href="javascript:document.getElementById('skuPropID').value='<%= data.get("skuPropID") %>';postModuleAndAction('skuProp', 'editView')">编辑</a>
					<a href="javascript:document.getElementById('skuPropID').value='<%= data.get("skuPropID") %>';postModuleAndAction('skuProp', 'propertiesValueDefaultView')">查看属性值</a>
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
			String[] columns = {"name"};
			AppUtil.convertToHtml(columns, JSPDataBean.getFormDatas()); 		   
	%>
	<div class="record">
		<%@include file="common/commonEditTitle.jsp" %>
		<table border="0" cellspacing="0" cellpadding="0" width="100%">
			<tr>
			  <th><span class="red">* </span>属性名：</th>
			  <td><input type="text" name="name" id="name" size="40" maxlength="20" value="<%= JSPDataBean.getFormData("name") %>" /></td>
			</tr>
			<tr>
			  <th><span class="red">* </span>是否允许自定义图片：</th>
			  <td>
				  <input type="radio" name="allowImageFlag" id="allowImageFlag" value="1" <%= JSPDataBean.getFormData("allowImageFlag").equals("1") ? "checked=\"checked\"" : "" %> />是&nbsp;
				  <input type="radio" name="allowImageFlag" id="allowImageFlag" value="0" <%= JSPDataBean.getFormData("allowImageFlag").equals("0") ? "checked=\"checked\"" : "" %> />否
			  </td>
			</tr>
			<tr>
				<th>排序：</th>
				<td>
					<input type="text" name="sortIndex" id="sortIndex" value="<%= JSPDataBean.getFormData("sortIndex")%>" size="20" maxlength="11" />
				</td>
			</tr>
		</table>
		<div align="center">
			<div class="button">
				<a class="btn_bb1" id="btnSave" onclick="javascript:postModuleAndAction('skuProp', 'confirm')"><span>保 存</span></a>
				<a onclick="javascript:postModuleAndAction('skuProp', 'defaultView')" class="btn_bb1"><span>返 回</span></a>
			</div>
		</div> 
	</div>
	<% } else if (JSPDataBean.getFormData("action").equals("propertiesValueDefaultView")) { %>
	<div>
		<table class="list" border="0" cellpadding="0" cellspacing="1" width="100%" id="tab1">
			<tr>
				<th>属性值ID</th>
				<th>属性值</th>
				<th>排序值</th>
				<th>状态</th>
				<th>操作</th>
			</tr>
			<%
				Vector datas = (Vector) JSPDataBean.getJSPData("datas");
				String[] columns = {"name"};
				AppUtil.convertToHtml(columns, datas);	
				for (int i = 0; i < datas.size(); i++) {
					Hashtable data = (Hashtable) datas.get(i);
					String trClass = "tr_line" + (i % 2);
			%>
			<tr class="<%= trClass %>">
				<td height="28"><%= data.get("skuPropValueID") %></td>
				<td><%= data.get("name") %></td>
				<td>
					<input id="sortIndex_<%= data.get("skuPropValueID") %>" name="sortIndex_<%= data.get("skuPropValueID") %>" value="<%= data.get("sortIndex") %>" size="5" maxlength="11" type="text">
				</td>
				<td>
					<% if (data.get("validFlag").equals("1")) { %>
					<a href="javascript:document.getElementById('skuPropValueID').value='<%= data.get("skuPropValueID") %>';postModuleAndAction('skuProp','propertiesValueDisable')">
					<% } else { %>
					<a href="javascript:document.getElementById('skuPropValueID').value='<%= data.get("skuPropValueID") %>';postModuleAndAction('skuProp','propertiesValueEnable')">
					<% } %>
					<img src="/images/<%= data.get("validFlag").equals("1") ? "yes" : "no"%>.gif" width="15px" border="none"/>
					</a>
				</td>
				<td>
		        	<a href="javascript:document.getElementById('skuPropValueID').value='<%= data.get("skuPropValueID") %>';postModuleAndAction('skuProp','propertiesValueEditView')">编辑</a>  
				</td>
			</tr>
			<%	} %>
		</table>
	</div>
	
	<% } else if (JSPDataBean.getFormData("action").equals("propertiesValueAddView") 
			   || JSPDataBean.getFormData("action").equals("propertiesValueEditView") 
			   || JSPDataBean.getFormData("action").equals("propertiesValueConfirm")) { 
			String[] columns = {"name"};
			AppUtil.convertToHtml(columns, JSPDataBean.getFormDatas()); 		   
	%>
	<div class="record">
		<%@include file="common/commonEditTitle.jsp" %>
		<table border="0" cellspacing="0" cellpadding="0" width="100%">
			<tr>
			  <th><span class="red">* </span>属性值：</th>
			  <td height="28"><input type="text" name="name" id="name" size="30" maxlength="50" value="<%= JSPDataBean.getFormData("name") %>" /></td>
			</tr>
			<tr>
				<th>排序：</th>
				<td>
					<input type="text" name="sortIndex" id="sortIndex" value="<%= JSPDataBean.getFormData("sortIndex")%>" size="20" maxlength="11" />
				</td>
			</tr>
		</table>
		<div align="center">
			<div class="button">
				<a class="btn_bb1" id="btnSave" onclick="javascript:postModuleAndAction('skuProp', 'propertiesValueConfirm')"><span>保 存</span></a>
				<a onclick="javascript:postModuleAndAction('skuProp', 'propertiesValueDefaultView')" class="btn_bb1"><span>返 回</span></a>
			</div>
		</div>
	</div>
	<% } %>

	<%= JSPDataBean.getFormData("queryConditionHtml") %>	

	<input type="hidden" id="skuPropID" name="skuPropID" value="<%= JSPDataBean.getFormData("skuPropID") %>" />
	<input type="hidden" id="skuPropValueID" name="skuPropValueID" value="<%= JSPDataBean.getFormData("skuPropValueID") %>" />
</div>

<%@include file="common/commonFooter.jsp" %>
