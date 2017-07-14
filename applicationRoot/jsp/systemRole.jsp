<%@ page contentType="text/html;charset=UTF-8"%>
<jsp:directive.page import="java.util.Vector"/>
<jsp:directive.page import="java.util.Hashtable"/>
<%@page import="java.util.Iterator"%>
<%@page import="admin.customer.guanwangbao.AppUtil"%>
<%@page import="admin.customer.guanwangbao.LocalDataCache"%>

<jsp:useBean id="JSPDataBean" scope='request' class="simpleWebFrame.web.JSPDataBean" />

<%@include file="common/commonHeader.jsp" %>

<div class="headDiv">
<div class="btn_t left"><a href="javascript:postModuleAndAction('systemRole','defaultView')"><span><strong>系统角色设置</strong></span></a></div>


<% if (JSPDataBean.getFormData("action").equals("list")) { %>
<div class="tip gray9" style="float: right;"><a href="javascript:postModuleAndAction('systemRole', 'addView')" class="btn_y"><span><strong class="icon_add">添加系统角色</strong></span></a> </div>
<% } %>
</div>

<div class="main clear">
<% if (JSPDataBean.getFormData("action").equals("list")) { %>
	<table class="list" cellpadding="0" cellspacing="1" width="100%" id="tab1">
		<tr>
			<th>角色名称</th>
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
			<td><%= data.get("name") %></td>
			<td >
				<%	if (data.get("validFlag").equals("1")) { %>
				<a href="javascript:document.getElementById('systemRoleID').value='<%= data.get("systemRoleID") %>';postModuleAndAction('systemRole','disable')">
				<%	} else { %>
				<a href="javascript:document.getElementById('systemRoleID').value='<%= data.get("systemRoleID") %>';postModuleAndAction('systemRole','enable')">
				<%	} %>
				<img src="/images/<%= data.get("validFlag").equals("1") ? "yes" : "no"%>.gif" width="15px" border="none"/>
				</a>
			</td>
			<td>
				<a href="javascript:document.getElementById('systemRoleID').value='<%= data.get("systemRoleID") %>';postModuleAndAction('systemRole','editView')">编辑</a>
			</td>
		</tr>
		<%	} %>
	</table>
<% } else { 
		String[] columns = {"name"};
		AppUtil.convertToHtml(columns, JSPDataBean.getFormDatas());
%>
	<div class="record">
		<%@include file="common/commonEditTitle.jsp" %>
		<table border="0" cellspacing="0" cellpadding="0" width="100%">
			<tr align="left">
				  <th><span class="red">* </span>角色名称：</th>
				  <td><input type="text" name="name" id="name" value="<%= JSPDataBean.getFormData("name") %>" size="30" maxlength="50" /></td>
			</tr>
			<tr>
				  <td></td>
				  <td>
					<%
						String priority = "," + JSPDataBean.getFormData("priority") + ",";
						Vector bigSystemModules = LocalDataCache.getInstance().getBigSystemModules();
						for (int i = 0; i < bigSystemModules.size(); i++) {
							String selectedPriority = "";
							Hashtable bigSystemModule = (Hashtable) bigSystemModules.get(i);
							String bigModuleID = bigSystemModule.get("c_bigSystemModuleID").toString();
							Vector smallSystemModules = LocalDataCache.getInstance().getSmallSystemModules(bigSystemModule.get("c_bigSystemModuleID").toString());
					%>
						<div style="font-weight: bold;<%= i == 0 ? "margin-top: 0" : "margin-top: 10px" %>">
							<input type="checkbox" id="bigModule_<%= bigModuleID %>" name="bigModule_<%= bigModuleID %>" onchange="selectAllCheckBox('bigModule_<%= bigModuleID %>', 'selectChoice_<%= bigModuleID %>', 'priority_<%= bigModuleID %>')" value="<%= bigModuleID %>" />&nbsp;<%= bigSystemModule.get("c_bigSystemModuleName") %>
						</div>
						<div style="margin-left: 15px">
						<% 
							for (int j = 0; j < smallSystemModules.size(); ++j) {
								Hashtable smallSystemModule = (Hashtable) smallSystemModules.get(j);
								if (smallSystemModule.get("c_systemModuleID").equals("133") || smallSystemModule.get("c_systemModuleName").equals("waitAudit") || smallSystemModule.get("c_systemModuleName").equals("hasAudit")) {
									// 待审核（订单）
									continue;
								}
								boolean selected = priority.indexOf("," + smallSystemModule.get("c_systemModuleName") + ",") != -1;
								if (selected) {
									selectedPriority += (smallSystemModule.get("c_systemModuleName") + ",");
								}
								
						%>							
						<span style="padding: 0 5px"><input type="checkbox" id="selectChoice_<%= bigModuleID %>" name="selectChoice_<%= bigModuleID %>" onchange="setSelectedValues('selectChoice_<%= bigModuleID %>', 'priority_<%= bigModuleID %>')" <%= selected ? "checked=\"checked\"" : "" %> value="<%= smallSystemModule.get("c_systemModuleName") %>" />&nbsp;<%= smallSystemModule.get("systemModuleViewName") %></span>
						<% } %>
						</div>
						<input type="hidden" id="priority_<%= bigModuleID %>" name="priority_<%= bigModuleID %>" value="<%= selectedPriority %>"/>
						<% if (!selectedPriority.equals("")) { %>
						<script>
							$("#bigModule_<%= bigModuleID %>").attr("checked", "checked");
						</script>
						<% } %>
					<% } %>	
				  </td>
			</tr>
		</table>
		<div align="center">
			<div class="button">
				<a class="btn_bb1" id="btnSave" onclick="javascript:postModuleAndAction('systemRole', 'confirm')"><span>保 存</span></a>
				<a onclick="javascript:postModuleAndAction('systemRole','defaultView')" class="btn_bb1"><span>返 回</span></a>
			</div>
		</div>    
	</div>      
<% } %>

<input type="hidden" id="systemRoleID" name="systemRoleID" value="<%= JSPDataBean.getFormData("systemRoleID") %>" />

</div>

</div>

<%@include file="common/commonFooter.jsp" %>
