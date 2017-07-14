<%@ page contentType="text/html;charset=UTF-8"%>
<jsp:directive.page import="java.util.Vector"/>
<jsp:directive.page import="java.util.Hashtable"/>
<%@page import="java.util.Iterator"%>
<%@page import="admin.customer.guanwangbao.AppUtil"%>
<%@page import="simpleWebFrame.util.PriceUtil"%>
<%@page import="admin.customer.guanwangbao.AppKeys"%>
<%@page import="com.alibaba.fastjson.JSON"%>
<%@page import="com.alibaba.fastjson.TypeReference"%>
<%@page import="java.util.Comparator"%>
<%@page import="admin.customer.guanwangbao.tool.SortIndexComparator"%>
<%@page import="java.util.Collections"%>
<jsp:useBean id="JSPDataBean" scope='request' class="simpleWebFrame.web.JSPDataBean" />

<%@include file="common/commonHeader.jsp" %>
<style>
.mod-all-btn{
	float: right; 
	margin-left: 5px; 
	margin-right: 5px; 
	position: relative;
}
.mod-all-btn .arrow{
	font-style: normal;
	width: 0px;
	height: 0px;
	border-width: 5px;
	border-style: solid;
	border-color: transparent transparent #fff transparent;
	position: absolute;
	top: 24px;
	left: 30px;
	display: block;
}
.mod-all-drop{ 
	 border: 1px solid #ccc; 
	 box-sizing: border-box; 
	 border-radius: 5px;
	 position: absolute; 
	 top: 27px; 
	 left: 0px; 
	 background: #fff;
	 width: 100%;
	 display: none;
}
.mod-all-drop li{
	list-style: none;
	line-height: 26px;
	border-bottom: 1px solid #ddd;
	cursor: pointer;
	padding: 0px 10px;
}
.mod-all-drop li:hover{
	background: #f3f3f3;
}
.mod-all-drop li a{
	text-decoration: none;
	color: #333;
}
.mod-all-drop li:last-child{
	border-bottom: 0;
}
</style>

<script type="text/javascript" src="/batchUploadImage/tangram.js"></script>
	<script type="text/javascript" src="/batchUploadImage/callbacks.js"></script>
	<script type="text/javascript" src="/batchUploadImage/flashParameters.js"></script>
	<script type="text/javascript">
		flashOptions.createOptions.vars.ext = '{"type":"product", "productID":"<%= JSPDataBean.getFormData("productID")%>"}';
		function closeBUIW() {
			postModuleAndAction('product', 'productImageList');
		}
</script>

<% String title = JSPDataBean.getFormData("product_opt").equals("waitAudit") ? "商品审核" : JSPDataBean.getFormData("product_opt").equals("hasAudit") ? "已审核商品" : "商品管理"; %>

<div class="headDiv">
	<div class="<% if (JSPDataBean.getFormData("action").equals("list") || JSPDataBean.getFormData("action").equals("addView") || JSPDataBean.getFormData("action").equals("editView")) { %>btn_t left<% } else { %> btn_t0 left <% } %>"><a href="javascript:postModuleAndAction('product','defaultView')"><span><strong><%= title %></strong></span></a></div>
	<% if (JSPDataBean.getFormData("action").equals("list") && !JSPDataBean.getFormData("product_opt").equals("waitAudit") && !JSPDataBean.getFormData("product_opt").equals("hasAudit")) { %>
	<div class="gray9 mod-all-btn">
		<a href="javascript:openInfoWindow('product', 'exportProductWindow');" class="btn_y"><span><strong class="icon_add">导出</strong></span></a> 
	</div>
	<%--
	<div class="gray9 mod-all-btn">
		<a href="javascript:;" class="btn_y"><span><strong class="icon_add">批量修改</strong></span></a> 
		<ul class="mod-all-drop">
			<li><a href="javascript:openInfoWindow('batchUpdateProductTagWindow');" title="">修改标签</a></li>
			<li><a href="javascript:if(confirm('是否批量上架商品')){changeEnable();}" title="">上架</a></li>
			<li><a href="javascript:if(confirm('是否批量下架商品')){changeDisable();}" title="">下架</a></li>
		</ul>
	</div>
	 --%>
	<% } %>
	<% if (JSPDataBean.getFormData("action").equals("list") && JSPDataBean.getFormData("product_opt").equals("waitAudit")) { %>
		<div class="gray9 mod-all-btn">
			<a href="javascript:openInfoWindow('product', 'batchAuditProductWindow');" class="btn_y"><span><strong class="icon_add">批量审核</strong></span></a> 
		</div>
	<% } %>
	<% if (JSPDataBean.getFormData("action").equals("productImageList")) { %>
		<div class="btn_t left"><a href="javascript:postModuleAndAction('product','productImageList')"><span><strong>图片管理</strong></span></a></div>	
	<% } %>
	<% if (JSPDataBean.getFormData("action").equals("skuList")) { %>
		<div class="btn_t left"><a href="javascript:postModuleAndAction('product','skuList')"><span><strong>sku管理</strong></span></a></div>	
	<% } %>
	<% if (JSPDataBean.getFormData("action").equals("productRelateList")) { %>
		<div class="btn_t left"><a href="javascript:postModuleAndAction('product','productRelateList')"><span><strong>相关商品</strong></span></a></div>	
	<% } %>
</div>

<div class="main clear">
	<div class="clear"></div>
	<input type="hidden" name="productID" id="productID" value="<%= JSPDataBean.getFormData("productID") %>" />
	<% if (JSPDataBean.getFormData("action").equals("list")) { %>
	<div class="search">
	  <table border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr>
			<td>
				商品ID：<input type="text" name="q_productID" id="q_productID" value="<%= JSPDataBean.getFormData("q_productID") %>" size="10" maxlength="6" onkeydown="javascript:if(event.keyCode==13) postModuleAndAction('product', 'search')"/>&nbsp;
				
				名称：<input type="text" name="q_name" id="q_name" value="<%= JSPDataBean.getFormData("q_name") %>" size="25" maxlength="50" onkeydown="javascript:if(event.keyCode==13) postModuleAndAction('product', 'search')"/>&nbsp;
				
				店铺：<input type="text" name="q_supplierName" id="q_supplierName" value="<%= JSPDataBean.getFormData("q_supplierName") %>" size="25" onkeydown="javascript:if(event.keyCode==13) postModuleAndAction('product', 'search')"/>&nbsp;
				
				条码：<input type="text" name="q_productCode" id="q_productCode" value="<%= JSPDataBean.getFormData("q_productCode") %>" size="25" maxlength="50" onkeydown="javascript:if(event.keyCode==13) postModuleAndAction('product', 'search')"/>&nbsp;
				<br>
				分类：<span id="queryProductTypeSelect"><%=JSPDataBean.getFormData("queryProductTypeSelect") %>&nbsp;</span>

				<%-- 标签：<%=JSPDataBean.getFormData("queryProductTagSelect") %>&nbsp; --%>
			
				上架：<%=JSPDataBean.getFormData("auditStatusSelect") %>&nbsp;
				<input type="checkbox" onclick="javascript:postModuleAndAction('product', 'search')" name="q_showCheckBox" <%= JSPDataBean.getFormData("q_showCheckBox").equals("1") ? "checked='checked'" : "" %> value="1"/> 显示浏览量/收藏次数
			</td>
			<td class="righttd">
				<div><dl>
	               	<dt style="width: 100%;">
	                   	<a class="btn_y" onclick="javascript:postModuleAndAction('product', 'search')"><span>搜&nbsp;&nbsp;&nbsp;&nbsp;索</span></a>
	                  	</dt>
	              </dl></div>
			</td>
		</tr>
		</table>
	</div>
	<div>
	<table class="list" border="0" cellpadding="0" cellspacing="1" width="100%" id="tab1">
		<tr>
		<% if (JSPDataBean.getFormData("product_opt").equals("waitAudit")) { %>
			<th width="2%"><input type="checkbox" id="selectAllID" name="selectAllID" onclick="selectAll('productCheckbox', 'selectedValues', 'selectAllID');"/></th>
		<% } %>
			<th>商品ID</th>
			<th>图片</th>
			<th>名称</th>
			<th>店铺</th>
			<th>分类</th>
			<th>品牌</th>
			<%-- <th>标签</th>  --%>
			<th>价格</th>
			<th>库存量</th>
			<% if(JSPDataBean.getFormData("q_showCheckBox").equals("1")) { %>
			<th>浏览量/收藏次数</th>
			<% } %>
			<%-- if (JSPDataBean.getFormData("product_opt").equals("hasAudit")) { %>
			<th>审核状态</th>
			<% } else if (JSPDataBean.getFormData("product_opt").equals("")) { %>
			<% } --%>
			<th>排序&nbsp;<input type="button" value="更新" onclick="$('#table').val('product');doAction('updateSortIndexAll')"/></th>
			<th>上架状态</th>
			<th>操作</th>
		</tr>
		<%
			Vector datas = (Vector) JSPDataBean.getJSPData("datas");
			String[] columns = {"name", "tinyTypeName", "smallTypeName", "bigTypeName", "brandName"};
			AppUtil.convertToHtml(columns, datas);
			for (int i = 0; i < datas.size(); i++) {
				Hashtable data = (Hashtable) datas.get(i);
		%>
		<tr>
		<% if (JSPDataBean.getFormData("product_opt").equals("waitAudit")) { %>
			<td><input type="checkbox" name="productCheckbox" value="<%= data.get("productID") %>" onclick="setSelectedValuesAndSelectAll('productCheckbox', 'selectedValues', 'selectAllID', '<%= datas.size() %>')"/></td>
		<% } %>
			<td><%= data.get("productID") %></td>
			<td style="text-align: center;">
				<a href="http://<%=AppKeys.DOMAIN_WWW %>/product/<%= data.get("productID")%>.html" target="_blank">
			    	<img src="<%= AppUtil.getProductImage(data, AppKeys.IMAGE_SIZE_SMALL) %>" width="60px">
			    </a>
			</td>
		  	<td>
		  		<a href="http://<%=AppKeys.DOMAIN_WWW %>/product/<%= data.get("productID")%>.html" target="_blank" title="<%= data.get("name") %>">
		  			<%= data.get("name") %>
		  		</a>
		  	</td>
		  	<td><%= data.get("supplierName") %></td>
		  	<td><%= data.get("bigTypeName") %>-<%= data.get("smallTypeName") %>-<%= data.get("tinyTypeName") %></td>
	  		<td><%= data.get("brandName") %></td>
	  		<%-- <td><%= data.get("tag") %></td> --%>
	  		<td><%= data.get("price") %></td>
	  		<td><%= data.get("stock") %></td>
	  		<% if(JSPDataBean.getFormData("q_showCheckBox").equals("1")) { %>
	  		<td><%= data.get("viewCount") %>/<%= data.get("favoriteTime") %></td>
	  		<% } %>
	  		<% if (JSPDataBean.getFormData("product_opt").equals("hasAudit")) { %>
	  		<td>
	  		<%= LocalDataCache.getInstance().getTableDataColumnValue("c_productAuditStatus", data.get("auditStatus").toString(), "c_productAuditStatusName") %>
	  		<br><a href="javascript:document.getElementById('productID').value='<%=data.get("productID")%>';openInfoWindow('product','auditProductWindow')">查看</a></b>
	  		</td>
	  		<% } else if (JSPDataBean.getFormData("product_opt").equals("")) { %>
	  		<td>
				<input id="sortIndex_<%= data.get("productID") %>" name="sortIndex_<%= data.get("productID") %>" value="<%= data.get("sortIndex") %>" size="5" maxlength="11" type="text">
			</td>
			<td>
			<% if (data.get("auditStatus").equals("20")) { %>
				<a href="javascript:document.getElementById('productID').value='<%= data.get("productID") %>';postModuleAndAction('product','disableStatus')">
			<% } else { %>
				<a href="javascript:document.getElementById('productID').value='<%= data.get("productID") %>';postModuleAndAction('product','enableStatus')">
			<% } %>
				<img src="/images/<%= data.get("auditStatus").equals("20") ? "yes" : "no"%>.gif" width="15px" border="none"/>
				</a>
			</td>
			<% } %>
		  	<td align="center">
		  	<% if (JSPDataBean.getFormData("product_opt").equals("waitAudit")) { %>
		  		<a href="javascript:document.getElementById('productID').value='<%=data.get("productID")%>';openInfoWindow('product', 'auditProductWindow')">审核</a>
			<% } %>
				<a href="javascript:document.getElementById('productID').value='<%=data.get("productID")%>';postModuleAndAction('product', 'editView')">详细</a>
				<a href="javascript:document.getElementById('productID').value='<%=data.get("productID")%>';postModuleAndAction('product', 'productImageList')">图片</a>
				<a href="javascript:document.getElementById('productID').value='<%=data.get("productID")%>';postModuleAndAction('product', 'skuList')">SKU</a>
				<a href="javascript:document.getElementById('productID').value='<%=data.get("productID")%>';postModuleAndAction('product', 'productRelateList ')">相关商品</a>
				<a href="javascript:document.getElementById('productID').value='<%=data.get("productID")%>';openInfoWindow('product', 'recommendProductWindow')">推荐设置</a>
			</td>
		</tr>
		<%	} %>
	</table>
	<div class="page blue">
		    <p class="floatl"><%@include file="common/commonJumpPage.jsp" %></p>
		    <div class="clear"></div>
		</div>
	<input type="hidden" id="selectedValues" name="selectedValues" value="<%= JSPDataBean.getFormData("selectedValues") %>" />
	</div>
	<% } else if (JSPDataBean.getFormData("action").equals("addView") || JSPDataBean.getFormData("action").equals("editView")) { 
		String[] columns = {"name", "info", "productCode", "unit", "origin"};
		AppUtil.convertToHtml(columns, JSPDataBean.getFormDatas());
	%>
	<div class="record">
		<%@include file="common/commonEditTitle.jsp" %>
		<table border="0" cellspacing="0" cellpadding="0" width="100%">
			<tr>
			  <th><span class="red">* </span>商品名称：</th>
			  <td><input type="text" name="name" id="name" size="60" maxlength="50" value="<%= JSPDataBean.getFormData("name") %>" /></td>
			</tr>
			<tr>
			  <th>商品描述：</th>
			  <td><input type="text" name="info" id="info" size="60" maxlength="100" value="<%= JSPDataBean.getFormData("info") %>" /></td>
			</tr>
			<tr>
			  <th><span class="red">* </span>分类：</th>
			  <td id="queryProductTypeSelect2"><%= JSPDataBean.getFormData("queryProductTypeSelect2") %></td>
			</tr>
			<%-- <tr>
			  <th>标签：</th>
			  <td><%= JSPDataBean.getFormData("productTagSelect") %></td>
			</tr> --%>
			<tr>
			  <th>品牌：</th>
			  <td><%= JSPDataBean.getFormData("brandSelect") %></td>
			</tr>
			<% if (!JSPDataBean.getFormData("productID").equals("")) { %>
			<tr>
			  <th>店铺：</th>
			  <td><%= JSPDataBean.getFormData("supplierName") %></td>
			</tr>
			<% } %>
			<tr>
			  <th><span class="red">* </span>报价方式：</th>
			  <td>
			  <%= JSPDataBean.getFormData("priceModeID").equals("1") ? "按产品数量报价" : "按产品规格报价" %>
			  </td>
			</tr>
			<% if (JSPDataBean.getFormData("priceModeID").equals("1")) { %>
			<tr>
			  <th>价格区间：</th>
			  <td>
					<table width="70%" id="productConteTab"> 
			  			<tr>
			  				<th width="40%" style="text-align: left;">购买数量</th>
							<th width="40%" style="text-align: left;">产品单价</th>
			  			</tr>
			  			<% 
						   	Vector priceDatas = (Vector) JSPDataBean.getJSPData("priceDatas");
						    for (int i = 0; i < priceDatas.size(); i++) {
								Hashtable priceData = (Hashtable) priceDatas.get(i);
						%>
						<tr>
							<td>起定量：<%= priceData.get("number") %>个以上</td>
							<td><%= priceData.get("price") %>元/个</td>
						</tr>
						<% } %>
			  		</table>
			  </td>
			</tr>
			<% } else { %>
			<tr>
			  <th><span class="red">* </span>价格：</th>
			  <td><input type="text" name="price" id="price" value="<%= JSPDataBean.getFormData("price")%>" maxlength="6" size="60"></td>
			</tr>
			<tr>
			  <th><span class="red">* </span>起批量：</th>
			  <td><input type="text" name="minBuyNumber" id="minBuyNumber" value="<%= JSPDataBean.getFormData("minBuyNumber")%>" maxlength="11" size="60"></td>
			</tr>
			<% } %>
			<tr>
			  <th>商品条码：</th>
			  <td><input type="text" name="productCode" id="productCode" value="<%= JSPDataBean.getFormData("productCode")%>" maxlength="50" size="60"></td>
			</tr>
			<tr>
			  <th>库存：</th>
			  <td><input type="text" name="stock" id="stock" value="<%= JSPDataBean.getFormData("stock").equals("") ? "0" : JSPDataBean.getFormData("stock") %>" maxlength="11" size="60"></td>
			</tr>
			
			<tr>
			  <th>单位：</th>
			  <td><input type="text" name="unit" id="unit" value="<%=JSPDataBean.getFormData("unit")%>" maxlength="20" size="60"></td>
			</tr>
			<tr>
			  <th>产地：</th>
			  <td><input type="text" name="origin" id="origin" value="<%=JSPDataBean.getFormData("unit")%>" maxlength="20" size="60"></td>
			</tr>
			<tr id="prop">
				<%@include file="product/porp.jsp"%>
			</tr>
			<tr>
				<th>
					详细信息：
				</th>
				<td>
					<script id="ueditor" name="detailInfo" type="text/plain"
						style="width:700px;height:300px;"><%= JSPDataBean.getFormData("detailInfo") %></script>
					<script type="text/javascript">
						$(function(){
					    	UE.getEditor('ueditor');
						});
					</script>
				</td>
			</tr>
			
		</table>
		
		<div align="center">
			<div class="button">
				<%--<a class="btn_bb1" id="btnSave" onclick="javascript:doAction('product', 'confirmProduct')"><span>保 存</span></a> --%>
				<a onclick="javascript:postModuleAndAction('product', 'defaultView')" class="btn_bb1"><span>返 回</span></a>
			</div>
		</div> 
	<input type="hidden" id="saveValidFlag" name="saveValidFlag" value="" />
	</div>
	<% } else if (JSPDataBean.getFormData("action").equals("productImageList") || JSPDataBean.getFormData("action").equals("productImageConfirm")) { %>
	<div>
	<table class="list" border="0" cellpadding="0" cellspacing="1" width="100%" id="tab1">
		<tr>
			<th>图片</th>
			<th>是否为主图片</th>
			<th>排序&nbsp;<input type="button" value="更新" onclick="$('#table').val('productImage');doAction('updateSortIndexAll')"/></th>
			<th>操作</th>
		</tr>
		<%
			Vector datas = (Vector) JSPDataBean.getJSPData("productImageDatas");
			for (int i = 0; i < datas.size(); i++) {
				Hashtable data = (Hashtable) datas.get(i);
		%>
		<tr>
			<td>
			    <img src="<%= AppUtil.getProductImage(data, AppKeys.IMAGE_SIZE_SMALL) %>"  style="width: 100px;">
			</td>
		  	<td><%= data.get("mainFlag").equals("1") ? "是" : "否" %></td>
		  	<td>
				<input id="sortIndex_<%= data.get("productImageID") %>" name="sortIndex_<%= data.get("productImageID") %>" value="<%= data.get("sortIndex") %>" size="5" maxlength="11" type="text">
			</td>
	  		<td>
				<% if (!data.get("mainFlag").equals("1")) { %>
				<a href="javascript:document.getElementById('productImageID').value='<%= data.get("productImageID") %>';postModuleAndAction('product', 'setMainImage')">设为主图片</a>
				<% } %>
				<a href="javascript:document.getElementById('productImageID').value='<%= data.get("productImageID") %>';postModuleAndAction('product', 'productImageDelete')" onclick="javascript:if (!confirm('是否删除图片，删除后就不能恢复了！')){return false}">删除</a>
			</td>
		</tr>
		<%	} %>
	</table>
	
	<div align="center" style="margin:10px;">
		<div class="button">
			<a onclick="javascript:postModuleAndAction('product', 'defaultView')" class="btn_bb1"><span>返 回</span></a>
		</div>
		</div> 
	</div>
	<input type="hidden" name="productImageID" id="productImageID" value="<%=JSPDataBean.getFormData("productImageID") %>" />
	<input type="hidden" name="product_uploadResult" id="product_uploadResult" value="" />
	
	<% } else if (JSPDataBean.getFormData("action").equals("productRelateList")) { %>
	<div>
	<table class="list" border="0" cellpadding="0" cellspacing="1" width="100%" id="tab1">
		<tr>
			<th>商品ID</th>
			<th>图片</th>
			<th>商品名称</th>
			<th>价格</th>
			<th>排序&nbsp;<input type="button" value="更新" onclick="$('#table').val('productRelate');doAction('updateSortIndexAll')"/></th>
			<th>状态</th>
			<th>操作</th>
		</tr>
		<%
			Vector datas = (Vector) JSPDataBean.getJSPData("datas1");
			for (int i = 0; i < datas.size(); i++) {
				Hashtable data = (Hashtable) datas.get(i);
				String[] columns = {"name"};
				AppUtil.convertToHtml(columns, data);
		%>
		<tr>
			<td><%=data.get("productID2")%></td>
			<td>
				<a href="http://<%=AppKeys.DOMAIN_WWW %>/product/<%= data.get("productID")%>.html" target="_blank">
			    	<img src="<%= AppUtil.getProductImage(data, AppKeys.IMAGE_SIZE_SMALL) %>" width="100px" height="100px"/>
			    </a>
			</td>
		  	<td>
		  		<a href="http://<%=AppKeys.DOMAIN_WWW %>/product/<%= data.get("productID")%>.html" target="_blank" title="<%= data.get("name") %>">
		  			<%= AppUtil.splitString(data.get("name").toString(), 20) %>
		  		</a>
		  	</td>
		  	<td><%=data.get("normalPrice")%> / <%= data.get("price") %></td>
		  	<td>
				<input id="sortIndex_<%= data.get("productRelateID") %>" name="sortIndex_<%= data.get("productRelateID") %>" value="<%= data.get("sortIndex") %>" size="5" maxlength="11" type="text">
			</td>
			<td>
				<img src="/images/<%= data.get("validFlag").equals("1") ? "yes" : "no"%>.gif" width="15px" border="none"/>
			</td>
			<td>
				<a href="javascript:document.getElementById('productRelateID').value='<%=data.get("productRelateID")%>';postModuleAndAction('product','deleteProductRelate')">删除</a>
			</td>
		</tr>
		<%	} %>
	</table>
	
	<div align="center" style="margin:10px;">
		<div class="button">
			<a onclick="javascript:postModuleAndAction('product', 'defaultView')" class="btn_bb1"><span>返 回</span></a>
		</div>
		</div> 
	</div>	
		
		<input type="hidden" id="productRelateID" name="productRelateID" value="<%=JSPDataBean.getFormData("productRelateID")%>" />
		<input type="hidden" name="selectedValues" id="selectedValues" value="<%=JSPDataBean.getFormData("selectedValues") %>" />
	<% } else if (JSPDataBean.getFormData("action").equals("skuList")) { %>
		<div id="skuSetting">
   		<%@include file="product/skuSetting.jsp" %>
   	</div>
	
   	<script type="text/javascript" src="/js/product.js"></script>
	<% } %>
</div>

<input type="hidden" name="product_opt" id="product_opt" value="<%= JSPDataBean.getFormData("product_opt") %>"/>
<%@include file="common/commonFooter.jsp" %>

<script type="text/javascript">
$(function(){
	/*批量修改的下拉效果*/
	$(".mod-all-btn .btn_y").click(function(event){
		$(this).siblings(".mod-all-drop").stop().toggle();
		 event.stopPropagation(); 
	});
	
	$(window).click(function(){
		$(".mod-all-btn .btn_y").siblings(".mod-all-drop").hide();
	});
});

function selectProducts() {
	if (document.getElementById('selectedValues').value == '') {
		alert('请选择一个商品');
		return;
	} else {
		closeInfoWindow();
		postModuleAndAction('product', 'addProductRelate');
	}
}
</script>
