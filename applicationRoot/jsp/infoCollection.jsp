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
	<% if (JSPDataBean.getFormData("action").equals("list")) { %>
		<div class="btn_t left"><a href="javascript:postModuleAndAction('infoCollection','defaultView')"><span><strong>文章专区管理</strong></span></a></div>
	<% } else if (JSPDataBean.getFormData("action").equals("collectionItemList")) { %>
		<div class="btn_t0 left"><a href="javascript:postModuleAndAction('infoCollection','defaultView')"><span><strong>文章专区管理</strong></span></a></div>
		<div class="btn_t left"><a href="javascript:postModuleAndAction('infoCollection','collectionItemList')"><span><strong>文章管理</strong></span></a></div>
	<% } %>
</div>

<div class="main clear">
	<div class="clear"></div>
	
	<% if (JSPDataBean.getFormData("action").equals("list")) { %>

	<div>
		<table class="list" border="0" cellpadding="0" cellspacing="1" width="100%" id="tab1">
			<tr>
				<th>文章专区</th>
				<th>操作</th>
			</tr>
			<%
				Vector datas = (Vector) JSPDataBean.getJSPData("datas");
				for (int i = 0; i < datas.size(); i++) {
					Hashtable data = (Hashtable) datas.get(i);
			%>
			<tr>
				<td><%=data.get("name")%></td>
				<td>
					<a href="javascript:document.getElementById('infoCollectionID').value='<%=data.get("infoCollectionID")%>';postModuleAndAction('infoCollection','collectionItemList')">文章管理</a>
				</td>
			</tr>
			<%	} %>
		</table>
	</div>
	<% } else if (JSPDataBean.getFormData("action").equals("collectionItemList")) { %>
	<div>
		<table class="list" border="0" cellpadding="0" cellspacing="1" width="100%" id="tab1">
			<tr>
				<th>文章ID</th>
				<th>图片</th>
				<th>标题</th>
				<th>排序&nbsp;<input value="更新" onclick="$('#table').val('infoCollectionItem');doAction('updateSortIndexAll')" type="button"></th>
				<th>状态</th>
				<th>操作</th>
			</tr>
			<%
				Vector datas = (Vector) JSPDataBean.getJSPData("datas");
				for (int i = 0; i < datas.size(); i++) {
					Hashtable data = (Hashtable) datas.get(i);
			%>
			<tr>
				<td><%=data.get("infoID")%></td>
				<td><a href="" target="_blank" title="<%= data.get("title") %>"><img src="<%= AppUtil.getImageURL("other", data.get("image").toString(), 0) %>" width="100px" height="100px"/></a></td>
				<td><a class="infoLink" href="" target="_blank" title="<%= data.get("title") %>"><%= AppUtil.splitString(data.get("title").toString(), 80) %></a></td>
				<td>
					<input id="sortIndex_<%= data.get("infoCollectionItemID") %>" name="sortIndex_<%= data.get("infoCollectionItemID") %>" value="<%= data.get("sortIndex") %>" size="5" maxlength="11" type="text">
				</td>
				<td>
					<img src="/images/<%= data.get("validFlag").equals("1") ? "yes" : "no"%>.gif" width="15px" border="none"/>
				</td>
				<td>
					<a href="javascript:if(confirm('是否删除')){document.getElementById('infoCollectionItemID').value='<%=data.get("infoCollectionItemID")%>';postModuleAndAction('infoCollection','deleteItem')}">删除</a>
				</td>
			</tr>
			<%	} %>
		</table>
		
		<input type="hidden" id="infoCollectionItemID" name="infoCollectionItemID" value="<%=JSPDataBean.getFormData("infoCollectionItemID")%>" />
		<input type="hidden" name="selectedValues" id="selectedValues" value="<%=JSPDataBean.getFormData("selectedValues") %>" />
	</div>
	<div align="center" style="padding:10px;">
			<div class="button">
				<a class="btn_bb1" id="btnSave" onclick="javascript:document.getElementById('selectedValues').value='';openInfoWindow('common', 'selectInfoWindow')"><span>添加</span></a>
				<a onclick="javascript:postModuleAndAction('infoCollection','collectionItemList')" class="btn_bb1"><span>返 回</span></a>
			</div>
	</div>
	<script>
		function selectInfos() {
			if (document.getElementById('selectedValues').value == '') {
				alert('请选择一篇文章');
				return;
			} else {
				closeInfoWindow();
				postModuleAndAction('infoCollection', 'addInfo');
			}
		}
	</script>
	<% } %>
	<input type="hidden" name="infoCollectionID" id="infoCollectionID" value="<%= JSPDataBean.getFormData("infoCollectionID") %>" />
	<%= JSPDataBean.getFormData("queryConditionHtml") %>	
	
</div>

<%@include file="common/commonFooter.jsp" %>
