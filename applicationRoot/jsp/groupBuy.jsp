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

<div class="headDiv">
	<% if (JSPDataBean.getFormData("action").equals("discountLogView") || JSPDataBean.getFormData("action").equals("addDiscountView") || JSPDataBean.getFormData("action").equals("editDiscountView")) { %>
		<div class="btn_t left"><a href="javascript:postModuleAndAction('groupBuy','discountLogView')"><span><strong>特价折扣</strong></span></a></div>
		
	<% } %>

	<% if (JSPDataBean.getFormData("action").equals("zekouListView")) { %>
	<div class="btn_t0 left"><a href="javascript:postModuleAndAction('groupBuy','discountLogView')"><span><strong>特价折扣</strong></span></a></div>
	<div class="btn_t left"><a href="javascript:postModuleAndAction('groupBuy','zekouListView')"><span><strong>折扣商品</strong></span></a></div>
	<% } %>
	
	<% if (JSPDataBean.getFormData("action").equals("list") || JSPDataBean.getFormData("action").equals("addView") || JSPDataBean.getFormData("action").equals("editView")) { %>
		<div class="btn_t left"><a href="javascript:postModuleAndAction('groupBuy','list')"><span><strong>团购秒杀</strong></span></a></div>
	<% } %>
</div>

<div class="main clear">
	<div class="clear"></div>
	
	<% if (JSPDataBean.getFormData("action").equals("discountLogView")) { %>
     <div class="search">
	  	<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td>
					店	铺：<input type="text" name="q_suppName" id="q_suppName" value="<%= JSPDataBean.getFormData("q_suppName") %>" size="25" maxlength="50" onkeydown="javascript:if(event.keyCode==13) postModuleAndAction('groupBuy', 'discountLogView')"/>&nbsp;
				</td>
				<td class="righttd">
					<div><dl>
	               		<dt style="width: 100%;">
	                   		<a class="btn_y" onclick="javascript:postModuleAndAction('groupBuy', 'discountLogView')"><span>搜&nbsp;&nbsp;&nbsp;&nbsp;索</span></a>
	                   	</dt>
	              	</dl></div>
				</td>
			</tr>
		</table>
	</div>
	<div>
		<table class="list" border="0" cellpadding="0" cellspacing="1" width="100%" id="tab1">
			<tr>
				<th width="10%">ID</th>
				<% if(!JSPDataBean.getFormData("operationName").equals("0")) { %>
				<th>店铺</th>
				<% } %>								
				<th width="20%">名称</th>
				<th width="20%">折扣标签</th>
				<th width="11%">折扣</th>
				<th width="11%">状态</th>
				<th width="*">操作</th>
			</tr>
			<%
				Vector datas = (Vector) JSPDataBean.getJSPData("datas");
				String[] columns = {"name", "tag"};;
				AppUtil.convertToHtml(columns, datas);
				for (int i = 0; i < datas.size(); i++) {
					Hashtable data = (Hashtable) datas.get(i);
			%>
			<tr>
				<td><%= data.get("discountLogID") %></td>
				<% if(!JSPDataBean.getFormData("operationName").equals("0")) { %>
				<td><%= data.get("supplierName") %></td>
				<% } %>	
				<td><%= data.get("name") %></td>
				<td><%= data.get("tag") %></td>
				<td>
					<%= data.get("discountRate") %>折
				</td>
				<td>
					<img src="/images/<%= data.get("validFlag").equals("1") ? "yes" : "no"%>.gif" width="15px" border="none"/>
				</td>
					<td>
						<a href="javascript:$('#discountLogID').val('<%= data.get("discountLogID") %>');postModuleAndAction('groupBuy', 'zekouListView')">折扣商品列表</a>
					</td>
			</tr>
			<%	} %>
		</table>
		<div class="page blue">
		    <p class="floatl"><%@include file="common/commonJumpPage.jsp" %></p>
		    <div class="clear"></div>
		</div>	
	</div>
	
	<% } else if (JSPDataBean.getFormData("action").equals("zekouListView")) { %>
		<div>
			<table class="list" border="0" cellpadding="0" cellspacing="1" width="100%" id="tab1">
					<tr>
						<th width="5%">
					    	<input type="checkbox" name="selectAllID" id="selectAllID" onclick="selectAll('selectChoice2', 'selectedValues2', 'selectAllID');"/>
					    </th>
						<th width="10%">商品ID</th>
						<th width="20%">图片</th>
						<th width="25%">商品名称</th>
						<th width="10%">原价</th>
						<th width="10%">折扣</th>
						<th width="10%">折扣价</th>
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
						<td><input type="checkbox" name="selectChoice2" id="selectChoice2" value="<%= data.get("productID") %>" onclick="setSelectedValuesAndSelectAll('selectChoice2', 'selectedValues2', 'selectAllID', '<%= datas.size() %>')"/></td>
						<td><%= data.get("productID") %></td>
						<td>
							<a href="http://<%=AppKeys.DOMAIN_WWW %>/product/<%= data.get("productID")%>.html" target="_blank">
								<img src="<%= AppUtil.getProductImage(data, AppKeys.IMAGE_SIZE_SMALL) %>" width="100px" />
							</a>
						</td>
						<td>
							<a href="http://<%=AppKeys.DOMAIN_WWW %>/product/<%= data.get("productID")%>.html" target="_blank">
								<%= data.get("name") %>
							</a>
						</td>
						<td><%= data.get("price") %></td>
						<td>
							<%= data.get("discountRate") %>折
						</td>
						<td><%= AppUtil.getDiscountPrice(data.get("discountRate").toString(), data.get("price").toString(), data.get("discountFlag").toString(), data.get("discountLogID").toString()) %></td>
						<td>
							<a href="javascript:if(confirm('是否删除？')){$('#table').val('product2');$('#productID').val('<%= data.get("productID") %>');postModuleAndAction('groupBuy', '<%= data.get("discountFlag").equals("1") ? "disable2" : "enable2" %>')}">删除</a>
						</td>
					</tr>
					<%	} %>
			</table>
			
			<div align="center" style="margin:10px;">
				<div class="button">
					<a onclick="javascript:postModuleAndAction('groupBuy','discountLogView')" class="btn_bb1"><span>返 回</span></a>
				</div>
			</div>
			
			<input type="hidden" name="selectedValues" id="selectedValues" value="<%=JSPDataBean.getFormData("selectedValues") %>" />
			<input type="hidden" name="selectedValues2" id="selectedValues2" value="<%=JSPDataBean.getFormData("selectedValues2") %>" />
			<input type="hidden" name="datasStr" id="datasStr" value="<%=JSPDataBean.getFormData("datasStr") %>" />
			<input type="hidden" name="discountFlag" id="discountFlag" value="0"/>
			
		</div>
		<script>
				function selectProducts() {
					if (document.getElementById('selectedValues').value == '') {
						alert('请选择一个商品');
						return;
					} else {
						closeInfoWindow();
						doAction('groupBuy', 'addProduct');
					}
				}
				function batchDeleteDiscountProducts() {
					if (document.getElementById('selectedValues2').value == '') {
						alert('请选择要删除的商品');
						return;
					} else {
						doAction('groupBuy', 'batchDisableDiscountProduct');
					}
				}
			</script>

	<% } else if (JSPDataBean.getFormData("action").equals("addDiscountView") || JSPDataBean.getFormData("action").equals("editDiscountView")) {
		String[] columns = {"name", "tag"};
		AppUtil.convertToHtml(columns, JSPDataBean.getFormDatas());
		%>
		<div class="record">
		<%@include file="common/commonEditTitle.jsp" %>
			<table border="0" cellspacing="0" cellpadding="0" width="100%">
				<tr>
					<th><span class="red">* </span>名称：</th>
					<td><input type="text" name="name" id="name" value="<%= JSPDataBean.getFormData("name") %>" size="30" maxlength="50" /></td>
				</tr>
				<tr>
					<th><span class="red">* </span>折扣标签：</th>
					<td><input type="text" maxlength="50" name="tag" id="tag" value="<%= JSPDataBean.getFormData("tag") %>" size="30"/></td>
				</tr>
				<tr>
					<th><span class="red">* </span>折扣：</th>
					<td><input type="text" maxlength="11" name="discountRate" id="discountRate" value="<%= JSPDataBean.getFormData("discountRate") %>" size="30"/> 折</td> 
				</tr>
			</table>
		<div align="center">
			<div class="button">
				<a class="btn_bb1" id="btnSave" onclick="javascript:doAction('groupBuy', 'confirmDiscountView')"><span>保 存</span></a>
				<a onclick="javascript:postModuleAndAction('groupBuy','discountLogView')" class="btn_bb1"><span>返 回</span></a>
			</div>
		</div>
	</div>
	<% } else if (JSPDataBean.getFormData("action").equals("list")) { %>
    <div class="search">
	  	<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td>
					店	铺：<input type="text" name="q_supplierName" id="q_supplierName" value="<%= JSPDataBean.getFormData("q_supplierName") %>" size="25" maxlength="50" onkeydown="javascript:if(event.keyCode==13) postModuleAndAction('groupBuy', 'search')"/>&nbsp;
				</td>
				<td class="righttd">
					<div><dl>
	               		<dt style="width: 100%;">
	                   		<a class="btn_y" onclick="javascript:postModuleAndAction('groupBuy', 'search')"><span>搜&nbsp;&nbsp;&nbsp;&nbsp;索</span></a>
	                   	</dt>
	              	</dl></div>
				</td>
			</tr>
		</table>
	</div>
	<div>
		<table class="list" border="0" cellpadding="0" cellspacing="1" width="100%" id="tab1">
			<tr>
				<th width="5%">ID</th>
				<% if(!JSPDataBean.getFormData("operationName").equals("0")) { %>
				<th>店铺</th>
				<% } %>				
				<th width="15%">图片</th>
				<th width="25%">商品</th>
				<th width="5%">原价</th>
				<th width="5%">促销价</th>
				<th width="10%">最大购买数量</th>
				<th width="6%">促销数量</th>
				<th width="6%">活动时间</th>
				<th width="5%">排序&nbsp;<input value="更新" onclick="$('#table').val('groupBuy');doAction('updateSortIndexAll')" type="button"></th>
				<th width="5%">状态</th>
			</tr>
			<%
				Vector datas = (Vector) JSPDataBean.getJSPData("datas");
				String[] columns = {"productName"};;
				AppUtil.convertToHtml(columns, datas);
				for (int i = 0; i < datas.size(); i++) {
					Hashtable data = (Hashtable) datas.get(i);
			%>
			<tr>
				<td><%= data.get("groupBuyID") %></td>
				<% if(!JSPDataBean.getFormData("operationName").equals("0")) { %>
				<td><%= data.get("supplierName") %></td>
				<% } %>					
				<td>
					<a href="http://<%=AppKeys.DOMAIN_WWW %>/product/<%= data.get("productID")%>.html" target="_blank">
						<img src="<%= AppUtil.getImageURL("other", data.get("image").toString(), 0) %>" width="100px" />
					</a>
				</td>
				<td><a href="http://<%=AppKeys.DOMAIN_WWW %>/product/<%= data.get("productID")%>.html" target="_blank"><%= data.get("productName") %></a></td>
				<td><%= PriceUtil.formatPrice(data.get("productPrice").toString()) %></td>
				<td><%= PriceUtil.formatPrice(data.get("price").toString()) %></td>
				<td><%= data.get("maxBuyNumber") %></td>
				<td><%= data.get("stock") %></td>
				<td><%= data.get("startTime") %><br><%= data.get("endTime") %></td>
				<td>
					<input id="sortIndex_<%= data.get("groupBuyID") %>" name="sortIndex_<%= data.get("groupBuyID") %>" value="<%= data.get("sortIndex") %>" size="5" maxlength="11" type="text">
				</td>
				<td><%= LocalDataCache.getInstance().getTableDataColumnValue("c_groupBuyStatus", data.get("status").toString(), "c_groupBuyStatusName") %></td>
			</tr>
			<%	} %>
		</table>
		<div class="page blue">
		    <p class="floatl"><%@include file="common/commonJumpPage.jsp" %></p>
		    <div class="clear"></div>
		</div>	
	</div>
	<% } else if (JSPDataBean.getFormData("action").equals("addView") || JSPDataBean.getFormData("action").equals("editView")) { %>
	<div class="record">
		<%@include file="common/commonEditTitle.jsp" %>
			<table border="0" cellspacing="0" cellpadding="0" width="100%">
				<tr>
					<th><span class="red">* </span>商品：</th>
					<td><input type="text" name="productName" id="productName" value="<%= JSPDataBean.getFormData("productName") %>" size="30" maxlength="50" onclick="openInfoWindow('groupBuy', 'selectOneProductWindow')" readOnly="readOnly" style="background-color: #eee;"/></td>
				</tr>
				<tr>
					<th><span class="red">* </span>促销活动类型：</th>
					<td><%= JSPDataBean.getFormData("groupBuyTypeSelect") %></td>
				</tr>
				<tr>
					<th>图片：</th>
					<td>
						<img class="imgBorder" id='imagePreview' src='<%= AppUtil.getImageURL("other", JSPDataBean.getFormData("image").toString(), 0)%>' style="max-width: 560px"/>
						<br />
	            		<a class="infoLink" href="javascript:void(0)" onclick="javascript:doUploadFile('other', 'image', 'imagePreview', '')">上传</a>
	            		<a class="infoLink" href="javascript:void(0)" onclick="javascript:clearUploadFile('image', 'imagePreview')">删除</a>
	            		<font color="red">建议上传 宽560的图片</font>
	            		<input type="hidden" name="image" id="image" value="<%= JSPDataBean.getFormData("image") %>" />
					</td> 
				</tr>
				<tr>
					<th><span class="red">* </span>原价：</th>
					<td id="productPrice"><%= JSPDataBean.getFormData("productPrice") %></td>
				</tr>
				<tr>
					<th><span class="red">* </span>促销价：</th>
					<td><input type="text" name="price" id="price" value="<%= JSPDataBean.getFormData("price") %>" size="30" maxlength="6"/></td>
				</tr>
				<tr>
					<th><span class="red">* </span>促销数量：</th>
					<td><input type="text" name="stock" id="stock" value="<%= JSPDataBean.getFormData("stock") %>" size="30" maxlength="11"/></td>
				</tr>
				<tr>
					<th><span class="red">* </span>最大购买数量：</th>
					<td><input type="text" name="maxBuyNumber" id="maxBuyNumber" value="<%= JSPDataBean.getFormData("maxBuyNumber") %>" size="30" maxlength="11"/></td>
				</tr>
				<tr>
					<th><span class="red">* </span>活动时间：</th>
					<td>
					<input  type="text" id="startTime" name="startTime" value="<%= JSPDataBean.getFormData("startTime") %>" class="itime" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" style="cursor: pointer;width:150px" readonly>
			    	<input  type="text" id="endTime" name="endTime" value="<%= JSPDataBean.getFormData("endTime") %>" class="itime" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" style="cursor: pointer;width:150px" readonly>
					</td>
				</tr>
			</table>
		<div align="center">
			<div class="button">
				<a class="btn_bb1" id="btnSave" onclick="javascript:doAction('groupBuy','confirm')"><span>保 存</span></a>
				<a onclick="javascript:postModuleAndAction('groupBuy', 'defaultView')" class="btn_bb1"><span>返 回</span></a>
			</div>
		</div>
	</div>
	<script>
				function selectProduct() {
					var selectedProductID = getRadioValue('selectChoice');
					if (selectedProductID == '') {
						alert('请选择一个商品');
					} else {
						var productName = $('#window_product_name_' + selectedProductID).html();
						var productPrice = $('#window_product_price_' + selectedProductID).html();
						$('#productName').val(productName);
						$('#productPrice').html(productPrice);
						$('#productID').val(selectedProductID);
						closeInfoWindow('infoWindow');
					}
				}
			</script>
	<% } %>
	<%= JSPDataBean.getFormData("queryConditionHtml") %>	

	<input type="hidden" name="discountLogID" id="discountLogID" value="<%= JSPDataBean.getFormData("discountLogID") %>">
	<input type="hidden" name="productID" id="productID" value="<%= JSPDataBean.getFormData("productID") %>" />
	<input type="hidden" name="groupBuyID" id="groupBuyID" value="<%= JSPDataBean.getFormData("groupBuyID") %>" />
	
</div>

<%@include file="common/commonFooter.jsp" %>

<script type="text/javascript">
$(function(){
	/*批量修改的下拉效果*/
	$(".mod-all-btn .btn_y").click(function(){
		$(this).siblings(".mod-all-drop").stop().toggle();
	});
});
</script>








