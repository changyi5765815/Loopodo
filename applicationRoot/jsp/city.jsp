<%@ page contentType="text/html;charset=UTF-8"%>
<jsp:directive.page import="java.util.Vector"/>
<jsp:directive.page import="java.util.Hashtable"/>
<%@page import="java.util.Iterator"%>
<%@page import="admin.customer.guanwangbao.AppUtil"%>

<jsp:useBean id="JSPDataBean" scope='request' class="simpleWebFrame.web.JSPDataBean" />

<%@include file="common/commonHeader.jsp" %>
<div class="headDiv">

<% if (JSPDataBean.getFormData("action").equals("list") || JSPDataBean.getFormData("action").equals("provinceAddView") || JSPDataBean.getFormData("action").equals("provinceEditView") || JSPDataBean.getFormData("action").equals("provinceConfirm")) {%>
	<div class="btn_t left"><a href="javascript:postModuleAndAction('city','defaultView')"><span><strong>省份设置</strong></span></a></div>
<% } else if (JSPDataBean.getFormData("action").equals("cityDefaultView") || JSPDataBean.getFormData("action").equals("cityAddView") || JSPDataBean.getFormData("action").equals("cityEditView") || JSPDataBean.getFormData("action").equals("cityConfirm")) {%>
	<div class="btn_t0 left"><a href="javascript:postModuleAndAction('city','defaultView')"><span><strong>省份设置</strong></span></a></div>
	<div class="btn_t left"><a href="javascript:postModuleAndAction('city', 'cityDefaultView')"><span><strong>城市设置</strong></span></a></div>
<% } else if (JSPDataBean.getFormData("action").equals("townDefaultView") || JSPDataBean.getFormData("action").equals("townAddView") || JSPDataBean.getFormData("action").equals("townEditView") || JSPDataBean.getFormData("action").equals("townConfirm")) {%>
	<div class="btn_t0 left"><a href="javascript:postModuleAndAction('city','defaultView')"><span><strong>省份设置</strong></span></a></div>
	<div class="btn_t0 left"><a href="javascript:postModuleAndAction('city', 'cityDefaultView')"><span><strong>城市设置</strong></span></a></div>
	<div class="btn_t left"><a href="javascript:postModuleAndAction('city', 'townDefaultView')"><span><strong>区域设置</strong></span></a></div>
<% } %>

<% if(JSPDataBean.getFormData("action").equals("list")) {%>
	<div class="tip gray9" style="float: right;"><a href="javascript:postModuleAndAction('city', 'provinceAddView')" class="btn_y"><span><strong class="icon_add">添加省份</strong></span></a> </div>
<% } else if (JSPDataBean.getFormData("action").equals("cityDefaultView")) { %>
	<div class="tip gray9" style="float: right;"><a href="javascript:postModuleAndAction('city','cityAddView')" class="btn_y"><span><strong class="icon_add">添加城市</strong></span></a> </div>
<% } else if (JSPDataBean.getFormData("action").equals("townDefaultView")) { %>
	<div class="tip gray9" style="float: right;"><a href="javascript:postModuleAndAction('city','townAddView')" class="btn_y"><span><strong class="icon_add">添加区域</strong></span></a> </div>
<% } %>
</div>

<div class="main clear">
	<div class="clear"></div>
	<% if (JSPDataBean.getFormData("action").equals("list")) {%>
	<div>
		<table class="list" border="0" cellpadding="0" cellspacing="1" width="100%" id="tab1">
			<tr>
				<th>省份ID</th>
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
					String trClass = "tr_line" + (i % 2);
			%>
			<tr class="<%=trClass %>">
				<td><%= data.get("provinceID") %></td>
				<td><%= data.get("name") %></td>
				<td>
					<% if (data.get("validFlag").equals("1")) {%>
					<a href="javascript:document.getElementById('provinceID').value= '<%= data.get("provinceID")%>'; postModuleAndAction('city','provinceDisable')"/>
					<% }else{ %>
					<a href="javascript:document.getElementById('provinceID').value= '<%= data.get("provinceID")%>'; postModuleAndAction('city','provinceEnable')"/>
					<% } %>
					<img src="/images/<%= data.get("validFlag").equals("1") ? "yes" : "no"%>.gif" width="15px" border="none"/>
				</td>
				<td>
					<a href="javascript:document.getElementById('provinceID').value='<%=data.get("provinceID")%>';postModuleAndAction('city','provinceEditView')">编辑</a>
					<a href="javascript:document.getElementById('provinceID').value='<%=data.get("provinceID")%>';postModuleAndAction('city','cityDefaultView')">城市设置</a>
				</td>
			</tr>
			<% } %>		
		</table>
	</div>
	<% } else if(JSPDataBean.getFormData("action").equals("cityDefaultView")) {%>
	<div>
		<table class="list" border="0" cellpadding="0" cellspacing="1" width="100%" id="tab1">
			<tr>
				<th>城市ID</th>
				<th>名称</th>
				<th>状态</th>
				<th>操作</th>
			</tr>
			<%
				Vector datas = (Vector) JSPDataBean.getJSPData("datas");
				String[] columns = {"name"};
				AppUtil.convertToHtml(columns, datas);
				for (int i = 0; i < datas.size(); i++){
				Hashtable data = (Hashtable) datas.get(i);
				String trClass = "tr_lint" + (i%2);
			 %>
			 <tr class="<%= trClass %>">
			 	<td><%= data.get("cityID") %></td>
			 	<td><%= data.get("name") %></td>
			 	<td>
			 		<% if (data.get("validFlag").equals("1")) {%>
			 		<a href="javascript:document.getElementById('cityID').value='<%= data.get("cityID")%>'; postModuleAndAction('city','cityDisable')"/>
			 		<% }else{ %>
			 		<a href="javascript:document.getElementById('cityID').value='<%= data.get("cityID")%>'; postModuleAndAction('city','cityEnable')"/>
			 		<% } %>
			 		<img src="/images/<%= data.get("validFlag").equals("1") ? "yes" : "no"%>.gif" width="15px" border="none"/>
			 	</td>
			 	<td>
			 		<a href="javascript:document.getElementById('cityID').value='<%=data.get("cityID")%>';postModuleAndAction('city','cityEditView')">编辑</a>
					<a href="javascript:document.getElementById('cityID').value='<%=data.get("cityID")%>';postModuleAndAction('city','townDefaultView')">区域设置</a>
			 	</td>
			 </tr>
			 <% } %>
		 </table>
	 </div>
	 <% } else if(JSPDataBean.getFormData("action").equals("townDefaultView")) {%>
	<div>
		<table class="list" border="0" cellpadding="0" cellspacing="1" width="100%" id="tab1">
			<tr>
				<th>区域ID</th>
				<th>名称</th>
				<th>状态</th>
				<th>操作</th>
			</tr>
			<%
				Vector datas = (Vector) JSPDataBean.getJSPData("datas");
				String[] columns = {"name"};
				AppUtil.convertToHtml(columns, datas);
				for (int i = 0; i < datas.size(); i++){
				Hashtable data = (Hashtable) datas.get(i);
				String trClass = "tr_lint" + (i%2);
			 %>
			 <tr class="<%= trClass %>">
			 	<td><%= data.get("townID") %></td>
			 	<td><%= data.get("name") %></td>
			 	<td>
			 		<% if (data.get("validFlag").equals("1")) {%>
			 		<a href="javascript:document.getElementById('townID').value='<%= data.get("townID")%>'; postModuleAndAction('city','townDisable')"/>
			 		<% }else{ %>
			 		<a href="javascript:document.getElementById('townID').value='<%= data.get("townID")%>'; postModuleAndAction('city','townEnable')"/>
			 		<% } %>
			 		<img src="/images/<%= data.get("validFlag").equals("1") ? "yes" : "no"%>.gif" width="15px" border="none"/>
			 	</td>
			 	<td>
			 		<a href="javascript:document.getElementById('townID').value='<%=data.get("townID")%>';postModuleAndAction('city','townEditView')">编辑</a>
			 	</td>
			 </tr>
			 <% } %>
		 </table>
	 </div>
	<% } %>
	<% 
	   if (JSPDataBean.getFormData("action").equals("provinceAddView")
		   || JSPDataBean.getFormData("action").equals("provinceEditView")
		   || JSPDataBean.getFormData("action").equals("provinceConfirm")) {
		   	String[] columns = {"name"};
			AppUtil.convertToHtml(columns, JSPDataBean.getFormDatas());
	%>
	<div class="record">
		<%@include file="common/commonEditTitle.jsp" %>
		<table border="0" cellspacing="0" cellpadding="0" width="100%">
			<tr>
				<th><span class="red">* </span>省份名称：</th>
				<td>
					<input type="text" name="name" id="name" value="<%=JSPDataBean.getFormData("name")%>" size="30" maxlength="20" />
				</td>
			</tr>
		</table>
		<div align="center">
			<div class="button">
				<a class="btn_bb1" id="btnSave" onclick="javascript:postModuleAndAction('city', 'provinceConfirm')"><span>保 存</span></a>
				<a class="btn_bb1" onclick="javascript:postModuleAndAction('city', 'defaultView')" ><span>返 回</span></a>
			</div>
		</div> 
	</div>	
	<% } %>
	<% 
	   if (JSPDataBean.getFormData("action").equals("cityAddView")
		   || JSPDataBean.getFormData("action").equals("cityEditView")
		   || JSPDataBean.getFormData("action").equals("cityConfirm")) {
		   	String[] columns = {"name"};
			AppUtil.convertToHtml(columns, JSPDataBean.getFormDatas());
	%>
	<div class="record">
		<%@include file="common/commonEditTitle.jsp" %>
		<table border="0" cellspacing="0" cellpadding="0" width="100%">
			<tr>
				<th><span class="red">* </span>城市名称：</th>
				<td>
					<input type="text" name="name" id="name" value="<%=JSPDataBean.getFormData("name")%>" size="30" maxlength="20" />
				</td>
			</tr>
		</table>
		<div align="center">
			<div class="button">
				<a class="btn_bb1" id="btnSave" onclick="javascript:postModuleAndAction('city', 'cityConfirm')"><span>保 存</span></a>
				<a class="btn_bb1" onclick="javascript:postModuleAndAction('city', 'cityDefaultView')" ><span>返 回</span></a>
			</div>
		</div> 
	</div>	
	<% } %>
	<% 
	   if (JSPDataBean.getFormData("action").equals("townAddView")
		   || JSPDataBean.getFormData("action").equals("townEditView")
		   || JSPDataBean.getFormData("action").equals("townConfirm")) {
		   	String[] columns = {"name"};
			AppUtil.convertToHtml(columns, JSPDataBean.getFormDatas());
	%>
	<div class="record">
		<%@include file="common/commonEditTitle.jsp" %>
		<table border="0" cellspacing="0" cellpadding="0" width="100%">
			<tr>
				<th><span class="red">* </span>区域名称：</th>
				<td>
					<input type="text" name="name" id="name" value="<%=JSPDataBean.getFormData("name")%>" size="30" maxlength="20" />
				</td>
			</tr>
			<tr>
				<th>邮编:</th>
				<td>
					<input type="text" name="zip" id="zip" value="<%=JSPDataBean.getFormData("zip")%>" size="20" maxlength="10" />
				</td>
			</tr>
			<tr>
				<th>区号:</th>
				<td>
					<input type="text" name="telZip" id="telZip" value="<%=JSPDataBean.getFormData("telZip")%>" size="20" maxlength="10" />
				</td>
			</tr>
		</table>
		<input type="hidden" id="townID" name="townID" value="<%=JSPDataBean.getFormData("townID")%>" />
		<div align="center">
			<div class="button">
				<a class="btn_bb1" id="btnSave" onclick="javascript:postModuleAndAction('city', 'townConfirm')"><span>保 存</span></a>
				<a class="btn_bb1" onclick="javascript:postModuleAndAction('city', 'townDefaultView')" ><span>返 回</span></a>
			</div>
		</div> 
	</div>	
	<% } %>
</div>

<input type="hidden" id="provinceID" name="provinceID" value="<%=JSPDataBean.getFormData("provinceID")%>" />
<input type="hidden" id="cityID" name="cityID" value="<%= JSPDataBean.getFormData("cityID")%>"/>
<input type="hidden" id="townID" name="townID" value="<%= JSPDataBean.getFormData("townID")%>"/>

<%@include file="common/commonFooter.jsp" %>
