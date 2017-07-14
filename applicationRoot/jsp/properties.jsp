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
	<div class="btn_t0 left"><a href="javascript:postModuleAndAction('properties','defaultView')"><span><strong>属性设置</strong></span></a></div>
	<div class="btn_t left"><a href="javascript:postModuleAndAction('properties', 'propertiesValueDefaultView')"><span><strong>属性值设置</strong></span></a></div>
	<% if (JSPDataBean.getFormData("action").equals("propertiesValueDefaultView")) { %>
	<div class="tip gray9" style="float: right;"><a href="javascript:postModuleAndAction('properties', 'propertiesValueAddView')" class="btn_y"><span><strong class="icon_add">添加属性值</strong></span></a> </div>
	<% } %>
<% } else { %>
	<div class="btn_t left"><a href="javascript:postModuleAndAction('properties','defaultView')"><span><strong>属性设置</strong></span></a></div>
	<% if (JSPDataBean.getFormData("action").equals("list")) { %>
	<div class="tip gray9" style="float: right;"><a href="javascript:postModuleAndAction('properties', 'addView')" class="btn_y"><span><strong class="icon_add">添加属性</strong></span></a> </div>
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
					属性名：<input type="text" name="q_name" id="q_name" value="<%= JSPDataBean.getFormData("q_name") %>" size="25" maxlength="50" onkeydown="javascript:if(event.keyCode==13) postModuleAndAction('properties', 'search')"/>&nbsp;
	              	关联分类：
	                <span id="queryProductTypeSelect">
	                	<%= JSPDataBean.getFormData("queryProductTypeSelect") %>
	                </span>
	                 类型：
	                 <select id="q_propTypeID" name="q_propTypeID">
	                 	<option value=""></option>
	                 	<option value="1" <%= JSPDataBean.getFormData("q_propTypeID").equals("1") ? "selected='selected'" : "" %> >单选</option>
	                 	<option value="2" <%= JSPDataBean.getFormData("q_propTypeID").equals("2") ? "selected='selected'" : "" %> >多选</option>
	                 	<option value="3" <%= JSPDataBean.getFormData("q_propTypeID").equals("3") ? "selected='selected'" : "" %> >手动输入</option>
	                 </select>&nbsp;
	                 是否是销售属性：
	                 <select id="q_salePropFlag" name="q_salePropFlag">
	                 	<option value=""></option>
	                 	<option value="1" <%= JSPDataBean.getFormData("q_salePropFlag").equals("1") ? "selected='selected'" : "" %> >是</option>
	                 	<option value="0" <%= JSPDataBean.getFormData("q_salePropFlag").equals("0") ? "selected='selected'" : "" %> >否</option>
	                 </select>&nbsp;
	                 是否是搜索属性：
	                 <select id="q_searchPropFlag" name="q_searchPropFlag">
	                 	<option value=""></option>
	                 	<option value="1" <%= JSPDataBean.getFormData("q_searchPropFlag").equals("1") ? "selected='selected'" : "" %> >是</option>
	                 	<option value="0" <%= JSPDataBean.getFormData("q_searchPropFlag").equals("0") ? "selected='selected'" : "" %> >否</option>
	                 </select>
				</td>
				<td class="righttd">
					<div><dl>
	               		<dt style="width: 100%;">
	                   		<a class="btn_y" onclick="javascript:postModuleAndAction('properties', 'search')"><span>搜&nbsp;&nbsp;&nbsp;&nbsp;索</span></a>
	                   	</dt>
	              	</dl></div>
				</td>
			</tr>
		</table>
	</div>
	<div>
		<table class="list" border="0" cellpadding="0" cellspacing="1" width="100%" id="tab1">
			<tr>
				<th width="5%">属性ID</th>
				<th width="10%">属性名</th>
				<th width="15%">关联分类</th>
				<th width="10%">类型</th>
				<th width="10%">是否是销售属性</th>
				<th width="10%">是否是搜索属性</th>
				<th width="10%">状态</th>
				<th width="10%">操作</th>
			</tr>
			<%
				Vector datas = (Vector) JSPDataBean.getJSPData("datas");
				String[] columns = {"name"};
				AppUtil.convertToHtml(columns, datas); 
				for (int i = 0; i < datas.size(); i++) {
					Hashtable data = (Hashtable) datas.get(i);
					
					String typeName = "";
					if (!"".equals(data.get("bigTypeID").toString())) {
						typeName += LocalDataCache.getInstance().getTableDataColumnValue("bigType", data.get("bigTypeID").toString(), "name");
					}
					if (!"".equals(data.get("smallTypeID").toString())) {
						typeName += "-" + LocalDataCache.getInstance().getTableDataColumnValue("smallType", data.get("smallTypeID").toString(), "name");
					}
					if (!"".equals(data.get("tinyTypeID").toString())) {
						typeName += "-" + LocalDataCache.getInstance().getTableDataColumnValue("tinyType", data.get("tinyTypeID").toString(), "name");
					}
			%>
			<tr>
				<td><%= data.get("propertiesID") %></td>
				<td><%= data.get("name") %></td>
				<td><%= typeName %></td>
				<td>
					<% if (data.get("propTypeID").equals("1")) { %>
						单选
					<% } else if (data.get("propTypeID").equals("2")) { %>
						多选
					<% } else if (data.get("propTypeID").equals("3")) { %>
						手动输入
					<% } %>
				</td>
				<td>
					<% if (data.get("salePropFlag").equals("1")) { %>
						是
					<% } else if (data.get("salePropFlag").equals("0")) { %>
						否
					<% } %>
				</td>
				<td>
					<% if (data.get("searchPropFlag").equals("1")) { %>
						是
					<% } else if (data.get("searchPropFlag").equals("0")) { %>
						否
					<% } %>
				</td>
				<td>
					<% if (data.get("validFlag").equals("1")) { %>
					<a href="javascript:document.getElementById('propertiesID').value='<%= data.get("propertiesID") %>';postModuleAndAction('properties','disable')">
					<% } else { %>
					<a href="javascript:document.getElementById('propertiesID').value='<%= data.get("propertiesID") %>';postModuleAndAction('properties','enable')">
					<% } %>
					<img src="/images/<%= data.get("validFlag").equals("1") ? "yes" : "no"%>.gif" width="15px" border="none"/>
					</a>
				</td>
				<td>
					<a href="javascript:document.getElementById('propertiesID').value='<%= data.get("propertiesID") %>';postModuleAndAction('properties', 'editView')">编辑</a>
					<% if (data.get("propTypeID").equals("1") || data.get("propTypeID").equals("2")) { %>
					<a href="javascript:document.getElementById('propertiesID').value='<%= data.get("propertiesID") %>';postModuleAndAction('properties', 'propertiesValueDefaultView')">查看属性值</a>
					<% } %>
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
			String[] columns = {"name", "alias"};
			AppUtil.convertToHtml(columns, JSPDataBean.getFormDatas()); 		   
	%>
	<div class="record">
		<%@include file="common/commonEditTitle.jsp" %>
		<table border="0" cellspacing="0" cellpadding="0" width="100%">
			<tr>
			  <th width="240px">所属分类：</th>
			  <td width="*"><span id="productTypeSelect"><%= JSPDataBean.getFormData("productTypeSelect") %></span></td>
			</tr>
			<tr>
			  <th><span class="red">* </span>属性名：</th>
			  <td><input type="text" name="name" id="name" size="40" maxlength="50" value="<%= JSPDataBean.getFormData("name") %>" /></td>
			</tr>
			<tr>
			  <th>别名：</th>
			  <td><input type="text" name="alias" id="alias" size="40" maxlength="50" value="<%= JSPDataBean.getFormData("alias") %>" /></td>
			</tr>
			<tr>
			  <th><span class="red">* </span>类型：</th>
			  <td>
			  	  <input type="radio" name="propTypeID" id="propTypeID" value="1" <%= JSPDataBean.getFormData("propTypeID").equals("1") ? "checked=\"checked\"" : "" %> /> 单选&nbsp;
				  <input type="radio" name="propTypeID" id="propTypeID" value="2" <%= JSPDataBean.getFormData("propTypeID").equals("2") ? "checked=\"checked\"" : "" %> /> 多选&nbsp;
				  <input type="radio" name="propTypeID" id="propTypeID" value="3" <%= JSPDataBean.getFormData("propTypeID").equals("3") ? "checked=\"checked\"" : "" %> /> 手动输入
			  </td>
			</tr>
			<tr>
			  <th><span class="red">* </span>是否是销售属性：</th>
			  <td>
				  <input type="radio" name="salePropFlag" id="salePropFlag" value="1" <%= JSPDataBean.getFormData("salePropFlag").equals("1") ? "checked=\"checked\"" : "" %> />是&nbsp;
				  <input type="radio" name="salePropFlag" id="salePropFlag" value="0" <%= JSPDataBean.getFormData("salePropFlag").equals("0") ? "checked=\"checked\"" : "" %> />否
			  </td>
			</tr>
			<tr>
			  <th><span class="red">* </span>是否是搜索属性：</th>
			  <td>
				  <input type="radio" name="searchPropFlag" id="searchPropFlag" value="1" <%= JSPDataBean.getFormData("searchPropFlag").equals("1") ? "checked=\"checked\"" : "" %> /> 是&nbsp;
				  <input type="radio" name="searchPropFlag" id="searchPropFlag" value="0" <%= JSPDataBean.getFormData("searchPropFlag").equals("0") ? "checked=\"checked\"" : "" %> /> 否
			  </td>
			</tr>
		</table>
		<div align="center">
			<div class="button">
				<a class="btn_bb1" id="btnSave" onclick="javascript:postModuleAndAction('properties', 'confirm')"><span>保 存</span></a>
				<a onclick="javascript:postModuleAndAction('properties', 'defaultView')" class="btn_bb1"><span>返 回</span></a>
			</div>
		</div> 
	</div>
	<% } else if (JSPDataBean.getFormData("action").equals("propertiesValueDefaultView")) {%>
	<div>
		<table class="list" border="0" cellpadding="0" cellspacing="1" width="100%" id="tab1">
			<tr>
				<th>属性值ID</th>
				<th>属性值</th>
				<th>排名&nbsp;<input type="button" value="更新" onclick="javascript:$('#table').val('propertiesValue');doAction('updateSortIndexAll')"/></th>
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
				<td height="28"><%= data.get("propertiesValueID") %></td>
				<td><%= data.get("name") %></td>
				<td>
						<input type="text" id="sortIndex_<%= data.get("propertiesValueID") %>" name="sortIndex_<%= data.get("propertiesValueID") %>" value="<%= data.get("sortIndex") %>" size="5" maxlength="3"/>
					</td>
				<td>
					<% if (data.get("validFlag").equals("1")) { %>
					<a href="javascript:document.getElementById('propertiesValueID').value='<%= data.get("propertiesValueID") %>';postModuleAndAction('properties','propertiesValueDisable')">
					<% } else { %>
					<a href="javascript:document.getElementById('propertiesValueID').value='<%= data.get("propertiesValueID") %>';postModuleAndAction('properties','propertiesValueEnable')">
					<% } %>
					<img src="/images/<%= data.get("validFlag").equals("1") ? "yes" : "no"%>.gif" width="15px" border="none"/>
					</a>
				</td>
				<td>
		        	<a href="javascript:document.getElementById('propertiesValueID').value='<%= data.get("propertiesValueID") %>';postModuleAndAction('properties','propertiesValueEditView')">编辑</a>  
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
		</table>
		<div align="center">
			<div class="button">
				<a class="btn_bb1" id="btnSave" onclick="javascript:postModuleAndAction('properties', 'propertiesValueConfirm')"><span>保 存</span></a>
				<a onclick="javascript:postModuleAndAction('properties', 'propertiesValueDefaultView')" class="btn_bb1"><span>返 回</span></a>
			</div>
		</div>
	</div>
	<% } %>

	<%= JSPDataBean.getFormData("queryConditionHtml") %>	

	<input type="hidden" id="propertiesID" name="propertiesID" value="<%= JSPDataBean.getFormData("propertiesID") %>" />
	<input type="hidden" id="propertiesValueID" name="propertiesValueID" value="<%= JSPDataBean.getFormData("propertiesValueID") %>" />
</div>

<%@include file="common/commonFooter.jsp" %>
