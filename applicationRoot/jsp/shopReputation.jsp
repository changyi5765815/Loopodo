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
	<div class="btn_t left"><a href="javascript:postModuleAndAction('shopReputation','defaultView')"><span><strong>店铺信誉管理</strong></span></a></div>
	<% if (JSPDataBean.getFormData("action").equals("list")) { %>
		<div class="tip gray9" style="float: right;"><a href="javascript:postModuleAndAction('shopReputation', 'addView')" class="btn_y"><span><strong class="icon_add">添加</strong></span></a> </div>
	<% } %>
</div>

<div class="main clear">
	<div class="clear"></div>
	
	<% if (JSPDataBean.getFormData("action").equals("list")) { %>
		<div class="search">
		  <table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td>
					店铺信誉ID：<input type="text" name="q_shopReputationID" id="q_shopReputationID" value="<%= JSPDataBean.getFormData("q_shopReputationID") %>" size="10" maxlength="6" onkeydown="javascript:if(event.keyCode==13) postModuleAndAction('shopReputation', 'search')"/>&nbsp;
					名称：<input type="text" name="q_c_shopReputationName" id="q_c_shopReputationName" value="<%= JSPDataBean.getFormData("q_c_shopReputationName") %>" size="25" maxlength="50" onkeydown="javascript:if(event.keyCode==13) postModuleAndAction('shopReputation', 'search')"/>&nbsp;
				</td>
				<td class="righttd">
					<div><dl>
		               	<dt style="width: 100%;">
		                   	<a class="btn_y" onclick="javascript:postModuleAndAction('shopReputation', 'search')"><span>搜&nbsp;&nbsp;&nbsp;&nbsp;索</span></a>
		                  	</dt>
		              </dl></div>
				</td>
			</tr>
			</table>
		</div>
	<div>
		<table class="list" border="0" cellpadding="0" cellspacing="1" width="100%" id="tab1">
			<tr>
				<th>店铺信誉ID</th>
				<th>名称</th>
				<th>图标</th>
				<th>值</th>
				<th>状态</th>
				<th>操作</th>
			</tr>
			<%
				Vector datas = (Vector) JSPDataBean.getJSPData("datas");
				String[] columns = {"c_shopReputationName"};
				AppUtil.convertToHtml(columns, datas);
				for (int i = 0; i < datas.size(); i++) {
					Hashtable data = (Hashtable) datas.get(i);
			%>
			<tr>
				<td><%= data.get("c_shopReputationID") %></td>
				<td><%= data.get("c_shopReputationName") %></td>
				<td><img src="<%= AppUtil.getImageURL("other", data.get("c_shopReputationImage").toString(), 0) %>"  style="height: 60px; width: 60px;"></td>
				<td><%= data.get("c_shopReputationValue") %></td>
				<td>
				<% if (data.get("validFlag").equals("1")) { %>
					<a href="javascript:document.getElementById('c_shopReputationID').value='<%= data.get("c_shopReputationID") %>';postModuleAndAction('shopReputation','disable')">
				<% } else { %>
					<a href="javascript:document.getElementById('c_shopReputationID').value='<%= data.get("c_shopReputationID") %>';postModuleAndAction('shopReputation','enable')">
				<% } %>
					<img src="/images/<%= data.get("validFlag").equals("1") ? "yes" : "no"%>.gif" width="15px" border="none"/>
					</a>
				</td>
				<td>
					<a href="javascript:document.getElementById('c_shopReputationID').value='<%= data.get("c_shopReputationID") %>';postModuleAndAction('shopReputation', 'editView')">编辑</a>
				</td>
			</tr>
			<% } %>
		</table>
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
			  <td><input type="text" name="c_shopReputationName" id="c_shopReputationName" size="60" maxlength="20" value="<%= JSPDataBean.getFormData("c_shopReputationName") %>" /></td>
			</tr>
			<tr>
				<th>图标：</th>
				<td>
					<span>
	            	 	<img class="imgBorder" id='imagePreview2' src='<%= AppUtil.getImageURL("other", JSPDataBean.getFormData("c_shopReputationImage"), 0)%>' style="width:100px;height:100px"/>
	            	</span>
	            	<br />
	            	<a class="infoLink" href="javascript:void(0)" onclick="javascript:doUploadFile('other', 'c_shopReputationImage', 'imagePreview2', '')">上传</a>
	            	<a class="infoLink" href="javascript:void(0)" onclick="javascript:clearUploadFile('c_shopReputationImage', 'imagePreview2')">删除</a>
	            	<font color="red">建议上传 60*60 的图片</font>
	            	<input type="hidden" name="c_shopReputationImage" id="c_shopReputationImage" value="<%= JSPDataBean.getFormData("c_shopReputationImage") %>" />
				</td>
			</tr>
			<tr>
			  <th><span class="red">* </span>值：</th>
			  <td><input type="text" name="c_shopReputationValue" id="c_shopReputationValue" size="60" maxlength="8" value="<%= JSPDataBean.getFormData("c_shopReputationValue") %>" /></td>
			</tr>
		</table>
		
		<div align="center">
			<div class="button">
				<a class="btn_bb1" id="btnSave" onclick="javascript:postModuleAndAction('shopReputation', 'confirm')"><span>保 存</span></a>
				<a onclick="javascript:postModuleAndAction('shopReputation', 'defaultView')" class="btn_bb1"><span>返 回</span></a>
			</div>
		</div> 
	</div>

	<% } %>	
	<input type="hidden" id="c_shopReputationID" name="c_shopReputationID" value="<%=JSPDataBean.getFormData("c_shopReputationID")%>" />
</div>

<%@include file="common/commonFooter.jsp" %>

<script type="text/javascript">

</script>








