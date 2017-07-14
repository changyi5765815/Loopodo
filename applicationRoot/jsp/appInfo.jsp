<%@ page contentType="text/html;charset=UTF-8"%>
<jsp:directive.page import="java.util.Vector"/>
<jsp:directive.page import="java.util.Hashtable"/>
<%@page import="java.util.Iterator"%>
<%@page import="admin.customer.guanwangbao.AppUtil"%>

<jsp:useBean id="JSPDataBean" scope='request' class="simpleWebFrame.web.JSPDataBean" />

<%@include file="common/commonHeader.jsp" %>
	<div class="headDiv">
		<div class="btn_t left"><a href="javascript:postModuleAndAction('appInfo','defaultView')"/><span><strong>App管理</strong></span></a></div>
		
		<% if (JSPDataBean.getFormData("action").equals("list")) { %>
		<div class="tip gray9" style="float: right;"><a href="javascript:postModuleAndAction('appInfo', 'addView')" class="btn_y"><span><strong class="icon_add">添加</strong></span></a> </div></div>
		<% } %>
	</div>
	<div class="main clear">
		<div class="clear"></div>
		<% if(JSPDataBean.getFormData("action").equals("list")) {%>
		<div>
		<table class="list" border="0" cellpadding="0" cellspacing="1" width="100%" id="tab1">
			<tr>
				<th>应用ID</th>
				<th>应用名称</th>
				<th>应用类型</th>
				<th>用户类型</th>
				<th>版本号</th>
				<th>编号</th>
				<th>强制刷新</th>
				<th>更新时间</th>
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
			<tr class="<%= trClass %>">
				<td><%= data.get("appInfoID") %></td>
				<td><%= data.get("name") %></td>
				<td><%= data.get("appTypeID").equals("1") ? "ios手机版" : data.get("appTypeID").equals("2") ? "ios平板" : data.get("appTypeID").equals("3") ? "andriod手机版" : data.get("appTypeID").equals("4") ? "andriod平板" : "" %></td>
				<td><%= data.get("userTypeID").equals("1") ? "卖家版" : "买家版" %></td>
				<td><%= data.get("versionNumber") %></td>
				<td><%= data.get("code") %></td>
				<td><%= data.get("mandatoryFlag").equals("1") ? "是" : "否" %></td>
				<td><%= data.get("updateDate") %></td>
				<td>
					<a href="javascript:document.getElementById('appInfoID').value='<%=data.get("appInfoID")%>';postModuleAndAction('appInfo','editView')">编辑</a>
				</td>
			</tr>
			<% } %>
		</table>
		</div>
		<% 
			} else if (JSPDataBean.getFormData("action").equals("addView") 
		          || JSPDataBean.getFormData("action").equals("editView")
		          || JSPDataBean.getFormData("action").equals("confirm")) {
				String[] columns = {"name"};
				AppUtil.convertToHtml(columns, JSPDataBean.getFormDatas());
		%>
		<div class="record">
		<%@include file="common/commonEditTitle.jsp" %>
		<table border="0" cellspacing="0" cellpadding="0" width="100%">
			<tr>
				<th><span class="red">* </span>应用名称：</th>
				<td>
					<input type="text" name="name" id="name" value="<%= JSPDataBean.getFormData("name") %>" maxlength="50" size="50"/>
				</td>
			</tr>
			<tr>
				<th><span class="red">* </span>客户端类型：</th>
				<td>
					<select id="appTypeID" name="appTypeID">
						<option value="1" <%= JSPDataBean.getFormData("appTypeID").equals("1") ? "selected=\"selected\"" : "" %>>ios手机版</option>
						<option value="2" <%= JSPDataBean.getFormData("appTypeID").equals("2") ? "selected=\"selected\"" : "" %>>ios平板</option>
						<option value="3" <%= JSPDataBean.getFormData("appTypeID").equals("3") ? "selected=\"selected\"" : "" %>>andriod手机版</option>
						<option value="4" <%= JSPDataBean.getFormData("appTypeID").equals("4") ? "selected=\"selected\"" : "" %>>andriod平板</option>
					</select>
				</td>
			</tr>
			<tr>
				<th><span class="red">* </span>用户类型：</th>
				<td>
					<select id="userTypeID" name="userTypeID">
						<option value="1" <%= JSPDataBean.getFormData("userTypeID").equals("1") ? "selected=\"selected\"" : "" %>>卖家版</option>
						<option value="2" <%= JSPDataBean.getFormData("userTypeID").equals("2") ? "selected=\"selected\"" : "" %>>买家版</option>
					</select>
			</tr>
			<tr>
				<th><span class="red">* </span>强制更新：</th>
				<td>
					<select id="mandatoryFlag" name="mandatoryFlag">
						<option value="0" <%= JSPDataBean.getFormData("mandatoryFlag").equals("0") ? "selected=\"selected\"" : "" %>>否</option>
						<option value="1" <%= JSPDataBean.getFormData("mandatoryFlag").equals("1") ? "selected=\"selected\"" : "" %>>是</option>
					</select>
			</tr>
			<tr>
				<th><span class="red">* </span>版本号：</th>
				<td><input type="text" name="versionNumber" id="versionNumber" value="<%= JSPDataBean.getFormData("versionNumber") %>"  maxlength="10"/></td>
			</tr>
			<tr>
				<th>编号：</th>
				<td><input type="text" name="code" id="code" value="<%= JSPDataBean.getFormData("code") %>"  maxlength="100"/></td>
			</tr>
			<tr>
				<th><span class="red">* </span>更新日期：</th>
				<td><input type="text" size="12" maxlength="10" id="updateDate" name="updateDate" value="<%= JSPDataBean.getFormData("updateDate") %>" onclick="calendar(this, false);" class="itime" style="cursor: pointer;" readonly /></td>
			</tr>
			<tr>
				<th>描述：</th>
				<td>
					<textarea name="info" id="info"  style="width:490px; height:100px;"
								onkeyup="if(this.value.length>500){this.value=this.value.substring(0, 500)}" /><%= JSPDataBean.getFormData("info")%></textarea>
				</td>
			</tr>
			<tr>
				<th>下载地址：</th>
				<td><input type="text" name="downloadUrl" id="downloadUrl" value="<%= JSPDataBean.getFormData("downloadUrl") %>"  maxlength="1000" size="80"/></td>
			</tr>
		</table>
		<div align="center">
			<div class="button">
				<a class="btn_bb1" id="btnSave" onclick="javascript:postModuleAndAction('appInfo', 'confirm')"><span>保 存</span></a>
				<a class="btn_bb1" onclick="javascript:postModuleAndAction('appInfo', 'defaultView')" ><span>返 回</span></a>
			</div>
		</div> 
		<% } %>
	</div>
</div>

<input type="hidden" id="appInfoID" name="appInfoID" value="<%=JSPDataBean.getFormData("appInfoID")%>" />
<%@include file="common/commonFooter.jsp" %>
