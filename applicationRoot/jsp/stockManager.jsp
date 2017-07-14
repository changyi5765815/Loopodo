<%@ page contentType="text/html;charset=UTF-8"%>
<jsp:directive.page import="java.util.Vector"/>
<jsp:directive.page import="java.util.Hashtable"/>
<%@page import="java.util.Iterator"%>
<%@page import="admin.customer.guanwangbao.AppUtil"%>
<%@page import="admin.customer.guanwangbao.LocalDataCache"%>
<%@page import="simpleWebFrame.util.PriceUtil"%>
<%@page import="admin.customer.guanwangbao.AppKeys"%>
<%@page import="admin.customer.guanwangbao.PropUtil"%>
<%@page import="simpleWebFrame.util.StringUtil"%>
<jsp:useBean id="JSPDataBean" scope='request' class="simpleWebFrame.web.JSPDataBean" />

<%@include file="common/commonHeader.jsp" %>
<div class="headDiv">
	<% if (JSPDataBean.getFormData("action").equals("list")) { %>
		<div class="btn_t left"><a href="javascript:postModuleAndAction('stockManager','defaultView')"><span><strong>库存维护</strong></span></a></div>
		<div class="tip gray9" style="float: right;"><a href="javascript:doAction('updateProductStockNumber')" class="btn_y"><span><strong class="icon_add">批量修改库存</strong></span></a> </div>
	<% } %>
</div>

<div class="main clear">
	<div class="clear"></div>
	
	<% if (JSPDataBean.getFormData("action").equals("list")) { %>
	<div class="search">
	  	<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td>
					商品ID：<input type="text" name="q_productID" id="q_productID" value="<%= JSPDataBean.getFormData("q_productID") %>" size="25" maxlength="6" onkeydown="javascript:if(event.keyCode==13) postModuleAndAction('stockManager', 'search')"/>&nbsp;
					skuID：<input type="text" name="q_skuID" id="q_skuID" value="<%= JSPDataBean.getFormData("q_skuID") %>" size="25" maxlength="50" onkeydown="javascript:if(event.keyCode==13) postModuleAndAction('stockManager', 'search')"/>&nbsp;
					商品名称：<input type="text" name="q_name" id="q_name" value="<%= JSPDataBean.getFormData("q_name") %>" size="25" maxlength="50" onkeydown="javascript:if(event.keyCode==13) postModuleAndAction('stockManager', 'search')"/>&nbsp;
					分类：<span id="queryProductTypeSelect"><%=JSPDataBean.getFormData("queryProductTypeSelect") %>&nbsp;</span>
				</td>
				<td class="righttd">
					<div><dl>
	               		<dt style="width: 100%;">
	                   		<a class="btn_y" onclick="javascript:postModuleAndAction('stockManager', 'search')"><span>搜&nbsp;&nbsp;&nbsp;&nbsp;索</span></a>
	                   	</dt>
	              	</dl></div>
				</td>
			</tr>
		</table>
	</div>

	<div>
		<table class="list" border="0" cellpadding="0" cellspacing="1" width="100%" id="tab1">
			<tr>
				<th width="50px;">
						<input type="checkbox" id="selectAllID" name="selectAllID" onclick="selectAll('selectChoice', 'selectedValues', 'selectAllID');"/>
					</th>
					<th>商品ID</th>
					<th>skuID</th>
					<th>图片</th>
					<th>商品名称</th>
					<th>sku名称</th>
					<th>分类</th>
					<th>价格</th>
					<th>状态</th>
					<th>库存量</th>
					<th>操作</th>
			</tr>
			<%
				Vector datas = (Vector) JSPDataBean.getJSPData("datas");
				String[] columns = {"name", "tinyTypeName", "smallTypeName", "bigTypeName"};
				AppUtil.convertToHtml(columns, datas);
				for (int i = 0; i < datas.size(); i++) {
					Hashtable data = (Hashtable) datas.get(i);
			%>
			<tr>
				<td>
					<input type="checkbox" name="selectChoice" value="<%= data.get("skuID") %>" onclick="setSelectedValuesAndSelectAll('selectChoice', 'selectedValues', 'selectAllID', '<%= datas.size() %>')"/>
				</td>
				<td><%= data.get("productID") %></td>
				<td><%= data.get("skuID") %></td>
				<td>
					<a href="" class="thumbnail" target="_blank">
					<img src="<%= AppUtil.getProductImage(data, AppKeys.IMAGE_SIZE_SMALL) %>" style="height: 60px; width: 60px;"/>
					</a>
				</td>
				<td><a class="infoLink" href="" target="_blank" title="<%= data.get("name") %>"><%= AppUtil.splitString(data.get("name").toString(), 30) %></a></td>
				<td><%= StringUtil.convertXmlChars(PropUtil.getSkuPropName(data.get("props").toString(), data.get("skuPropValueAlias").toString())) %></td>
				<td><%= data.get("bigTypeName") %>-<%= data.get("smallTypeName") %>-<%= data.get("tinyTypeName") %></td>
				<td><%= data.get("productPrice") %></td>
				<td>
					<img src="/images/<%= data.get("validFlag").equals("1") ? "yes" : "no"%>.gif" width="15px" border="none"/>
				</td>
				<td>
					<input type="text" name="<%= data.get("skuID") %>_<%= data.get("productID") %>_stock" id="<%= data.get("skuID") %>_<%= data.get("productID") %>_stock" value="<%= data.get("stock")%>" size="10" maxlength="11" />
				</td>
				<td align="center">
					<a href="javascript:document.getElementById('skuID').value='<%= data.get("skuID")%>';postModuleAndAction('stockManager', 'updateStockNumber')">修改</a>
				</td>
			</tr>
			<%	} %>
		</table>
		<div class="page blue">
		    <p class="floatl"><%@include file="common/commonJumpPage.jsp" %></p>
		    <div class="clear"></div>
		</div>
	</div>
	<% } %>
	<input type="hidden" id="productID" name="productID" value="<%= JSPDataBean.getFormData("productID")%>" />
	<input type="hidden" id="skuID" name="skuID" value="<%= JSPDataBean.getFormData("skuID")%>" />
	<input type="hidden" name="selectedValues" id="selectedValues" value="" />
	<%= JSPDataBean.getFormData("queryConditionHtml") %>	
	
</div>

<%@include file="common/commonFooter.jsp" %>
