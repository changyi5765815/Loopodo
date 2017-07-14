<%@ page contentType="text/html;charset=UTF-8"%>
<jsp:directive.page import="java.util.Vector"/>
<jsp:directive.page import="java.util.Hashtable"/>
<%@page import="java.util.Iterator"%>
<%@page import="admin.customer.guanwangbao.AppUtil"%>

<jsp:useBean id="JSPDataBean" scope='request' class="simpleWebFrame.web.JSPDataBean" />

<%@include file="common/commonHeader.jsp" %>
<div class="headDiv">
	<% if(JSPDataBean.getFormData("action").equals("list")) {%>
	<div class="btn_t left"><a href="javascript:postModuleAndAction('companyIndustry','defaultView')"><span><strong>主营行业</strong></span></a></div>
	<% } %>
	<% if(JSPDataBean.getFormData("action").equals("companyIndustryAddView") || JSPDataBean.getFormData("action").equals("companyIndustryEditView")) {%>
	<div class="btn_t left"><a href="javascript:postModuleAndAction('companyIndustry','defaultView')"><span><strong>主营行业</strong></span></a></div>
	<% } %>
	<% if(JSPDataBean.getFormData("action").equals("list")) {%>
	<div class="tip gray9" style="float: right;"><a href="javascript:postModuleAndAction('companyIndustry', 'companyIndustryAddView')" class="btn_y"><span><strong class="icon_add">添加主营行业</strong></span></a></div>
	<% } %>
	<% if(JSPDataBean.getFormData("action").equals("supplierMainProductAddView") || JSPDataBean.getFormData("action").equals("mainProductConfirm")) {%>
	<div class="btn_t left"><a href="javascript:postModuleAndAction('companyIndustry','supplierMainProductAddView')"><span><strong>主营产品</strong></span></a></div>
	<% } %>
	<% if(JSPDataBean.getFormData("action").equals("mainProductList")) {%>
	<div class="btn_t0 left"><a href="javascript:postModuleAndAction('companyIndustry','defaultView')"><span><strong>主营行业</strong></span></a></div>
	<div class="btn_t left"><a href="javascript:postModuleAndAction('companyIndustry','mainProductList')"><span><strong>主营产品</strong></span></a></div>
	<% } %>
</div>	
<div class="main clear">
	<div class="clear"></div>
	<% if (JSPDataBean.getFormData("action").equals("list")) { %>
	<div>
		<table class="list" border="0" cellpadding="0" cellspacing="1" width="100%" id="tab1">
			<tr>
				<th>主营行业ID</th>
				<th>主营行业名称</th>
				<th>操作</th>
			</tr>
			<%
				Vector datas = (Vector) JSPDataBean.getJSPData("datas");
				String[] convertColumns = {"c_companyIndustryName"}; 
				AppUtil.convertToHtml(convertColumns, datas); 
				for (int i = 0; i < datas.size(); i++) {
					Hashtable data = (Hashtable) datas.get(i);
					String trClass = "tr_line" + (i % 2);
			%>
			<tr class="<%=trClass %>">
				<td><%= data.get("c_companyIndustryID") %></td>
				<td><%= data.get("c_companyIndustryName") %></td>
				<td>
					<a href="javascript:document.getElementById('c_companyIndustryID').value='<%=data.get("c_companyIndustryID")%>';postModuleAndAction('companyIndustry','companyIndustryEditView')">编辑</a>
					<a href="javascript:if (confirm('是否删除')) {document.getElementById('c_companyIndustryID').value='<%=data.get("c_companyIndustryID")%>';postModuleAndAction('companyIndustry','delete')}">删除</a>
					<a href="javascript:document.getElementById('c_companyIndustryID').value='<%=data.get("c_companyIndustryID")%>';postModuleAndAction('companyIndustry', 'mainProductList')">主营产品</a>
				</td>
			</tr>
			<% } %>		
		</table>
	</div>
	<% } else if (JSPDataBean.getFormData("action").equals("companyIndustryAddView")
	    || JSPDataBean.getFormData("action").equals("companyIndustryEditView")
		|| JSPDataBean.getFormData("action").equals("companyIndustryConfirm")) {
	%>
	<div class="record">
		<%@include file="common/commonEditTitle.jsp" %>
		<table border="0" cellspacing="0" cellpadding="0" width="100%">
			<tr>
				<th><span class="red">* </span>主营行业名称：</th>
				<td>
					<input type="text" name="c_companyIndustryName" id="c_companyIndustryName" value="<%=JSPDataBean.getFormData("c_companyIndustryName")%>" size="30" maxlength="20" />
				</td>
			</tr>
		</table>
		<div align="center">
			<div class="button">
				<a class="btn_bb1" id="btnSave" onclick="javascript:postModuleAndAction('companyIndustry', 'companyIndustryConfirm')"><span>保 存</span></a>
				<a class="btn_bb1" onclick="javascript:postModuleAndAction('companyIndustry', 'defaultView')" ><span>返 回</span></a>
			</div>
		</div> 
	</div>
	<% } else if (JSPDataBean.getFormData("action").equals("supplierMainProductAddView") || JSPDataBean.getFormData("action").equals("mainProductConfirm")) { %>
	<div class="record">
		<%@include file="common/commonEditTitle.jsp" %>
		<table border="0" cellspacing="0" cellpadding="0" width="100%">
			<tr>
				<th><span class="red">* </span>主营产品名称：</th>
				<td>
					<input type="text" name="name" id="name" value="<%=JSPDataBean.getFormData("name")%>" size="30" maxlength="20" />
				</td>
			</tr>
		</table>
		<div align="center">
			<div class="button">
				<a class="btn_bb1" id="btnSave" onclick="javascript:postModuleAndAction('companyIndustry', 'mainProductConfirm')"><span>保 存</span></a>
				<a class="btn_bb1" onclick="javascript:postModuleAndAction('companyIndustry', 'mainProductList')" ><span>返 回</span></a>
			</div>
		</div> 
	</div>		
	<% } else if (JSPDataBean.getFormData("action").equals("mainProductList")) { %>
	<div>
	<table class="list" border="0" cellpadding="0" cellspacing="1" width="100%" id="tab1">
		<tr>
			<th>产品ID</th>
			<th>产品名称</th>
			<th>操作</th>
		</tr>
		<%
			Vector datas1 = (Vector) JSPDataBean.getJSPData("datas1");
			for (int i = 0; i < datas1.size(); i++) {
				Hashtable data = (Hashtable) datas1.get(i);
				String[] columns = {"name"};
				AppUtil.convertToHtml(columns, data);
		%>
		<tr>
			<td><%=data.get("supplierMainProductID")%></td>
			<td><%=data.get("name")%></td>
			<td>
				<a href="javascript:document.getElementById('supplierMainProductID').value='<%=data.get("supplierMainProductID")%>';postModuleAndAction('companyIndustry', 'deleteMainProduct')">删除</a>
			</td>
		</tr>
		<%	} %>
	</table>
	
	<div align="center" style="margin:10px;">
		<div class="button">
			<a href="javascript:postModuleAndAction('companyIndustry', 'supplierMainProductAddView')" class="btn_bb1"><span>添 加</span></a>
			<a onclick="javascript:postModuleAndAction('companyIndustry', 'defaultView')" class="btn_bb1"><span>返 回</span></a>
		</div>
		</div> 
	</div>
		<input type="hidden" name="selectedValues" id="selectedValues" value="<%=JSPDataBean.getFormData("selectedValues") %>" />
	<% } %>
</div>

<input type="hidden" id="c_companyIndustryID" name="c_companyIndustryID" value="<%=JSPDataBean.getFormData("c_companyIndustryID")%>" />
<input type="hidden" id="table" name="table" value="<%=JSPDataBean.getFormData("table")%>" />
<%@include file="common/commonFooter.jsp" %>
