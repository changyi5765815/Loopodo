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
	<div class="<% if (JSPDataBean.getFormData("action").equals("list")){ %>btn_t left<% } else { %>btn_t0 left<% } %>"><a href="javascript:postModuleAndAction('collection','defaultView')"><span><strong>商品专区管理</strong></span></a></div>
	<% if (JSPDataBean.getFormData("action").equals("collectionItemList")) { %>
		<div class="btn_t left"><a href="javascript:postModuleAndAction('collection','collectionItemList')"><span><strong>专区商品管理</strong></span></a></div>	
	<% } %>
</div>

<div class="main clear">
	<div class="clear"></div>
	
	<% if (JSPDataBean.getFormData("action").equals("list")) { %>
	<div>
		<table class="list" border="0" cellpadding="0" cellspacing="1" width="100%" id="tab1">
			<tr>
				<th width="50%">商品专区</th>
				<th width="*">操作</th>
			</tr>
			<%
				Vector datas = (Vector) JSPDataBean.getJSPData("datas");
				String[] columns = {"name"};
				AppUtil.convertToHtml(columns, datas);
				for (int i = 0; i < datas.size(); i++) {
					Hashtable data = (Hashtable) datas.get(i);
			%>
			<tr>
				<td><%= data.get("name") %></td>
				<td>
					<a href="javascript:document.getElementById('collectionID').value='<%= data.get("collectionID") %>';postModuleAndAction('collection', 'collectionItemList')">专区商品管理</a>
				</td>
			</tr>
			<%	} %>
		</table>
	</div>
	
	<% } else if (JSPDataBean.getFormData("action").equals("collectionItemList")) { %>
		<div>
			<table class="list" border="0" cellpadding="0" cellspacing="1" width="100%" id="tab1">
				<tr id="sort_paras">
					<th>商品ID</th>
					<th>图片</th>
					<th>商品名称</th>
					<th>最大价格/价格</th>
					<th>排序&nbsp;<input type="button" value="更新" onclick="$('#table').val('collectionItem');doAction('updateSortIndexAll')"/></th>
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
						<td><%= data.get("productID") %></td>
						<td>
							<a href="http://<%=AppKeys.DOMAIN_WWW %>/product/<%= data.get("productID")%>.html" target="_blank">
								<img src="<%= AppUtil.getProductImage(data, AppKeys.IMAGE_SIZE_SMALL) %>" style="height: 60px; width: 60px;"/>
							</a>
						</td>
						<td>
							<a href="http://<%=AppKeys.DOMAIN_WWW %>/product/<%= data.get("productID")%>.html" target="_blank">
								<%= data.get("name") %>
							</a>
							</td>
						<td><%= data.get("maxPrice")%> / <%= data.get("price") %></td>
						<td><input id="sortIndex_<%= data.get("collectionItemID") %>" name="sortIndex_<%= data.get("collectionItemID") %>" value="<%= data.get("sortIndex") %>" size="5" maxlength="11" type="text"></td>
						<td><img src="/images/<%= data.get("validFlag").equals("1") ? "yes" : "no"%>.gif" width="15px" border="none"/></td>
						<td><a href="javascript:if(confirm('是否删除')){document.getElementById('collectionItemID').value='<%=data.get("collectionItemID")%>';postModuleAndAction('collection','deleteProduct')}">删除</a></td>
					</tr>
					<%	} %>
			</table>
			
			<div align="center" style="margin:10px;">
				<div class="button">
				<a onclick="javascript:document.getElementById('selectedValues').value='';openInfoWindow('selectProductWindow')" class="btn_bb1"><span>添加</span></a>
					<a onclick="javascript:postModuleAndAction('collection','defaultView')" class="btn_bb1"><span>返 回</span></a>
				</div>
			</div>
			
		</div>

	<% } %>	
	<input type="hidden" id="collectionItemID" name="collectionItemID" value="<%=JSPDataBean.getFormData("collectionItemID")%>" />
	<input type="hidden" id="collectionID" name="collectionID" value="<%= JSPDataBean.getFormData("collectionID") %>" />
	<input type="hidden" id="selectedValues" name="selectedValues" value="<%= JSPDataBean.getFormData("selectedValues") %>" />
</div>

<%@include file="common/commonFooter.jsp" %>

<script type="text/javascript">
	function selectProducts() {
		if (document.getElementById('selectedValues').value == '') {
			alert('请选择一个商品');
			return;
		} else {
			closeInfoWindow();
			postModuleAndAction('collection', 'addProduct');
		}
	}
</script>








