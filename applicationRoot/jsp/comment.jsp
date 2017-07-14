<%@ page contentType="text/html;charset=UTF-8"%>
<jsp:directive.page import="java.util.Vector"/>
<jsp:directive.page import="java.util.Hashtable"/>
<%@page import="java.util.Iterator"%>
<%@page import="admin.customer.guanwangbao.AppUtil"%>
<%@page import="admin.customer.guanwangbao.LocalDataCache"%>
<%@page import="simpleWebFrame.util.PriceUtil"%>
<%@page import="admin.customer.guanwangbao.AppKeys"%>
<%@page import="simpleWebFrame.util.StringUtil"%>
<jsp:useBean id="JSPDataBean" scope='request' class="simpleWebFrame.web.JSPDataBean" />

<%@include file="common/commonHeader.jsp" %>

<div class="headDiv">	
	<% if (JSPDataBean.getFormData("action").equals("list") || JSPDataBean.getFormData("action").equals("addView")) { %>
		<div class="btn_t left"><a href="javascript:postModuleAndAction('comment','defaultView')"><span><strong>商品评论</strong></span></a></div>
	<% } %>
</div>

<div class="main clear">
	<div class="clear"></div>
	
	<% if (JSPDataBean.getFormData("action").equals("list")) { %>
    <div class="search">
	  	<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td>
					评论ID：<input type="text" name="q_commentID" id="q_commentID" value="<%= JSPDataBean.getFormData("q_commentID") %>" size="25" maxlength="6" onkeydown="javascript:if(event.keyCode==13) postModuleAndAction('comment', 'search')"/>&nbsp;
					商品名称：<input type="text" name="q_productName" id="q_productName" value="<%= JSPDataBean.getFormData("q_productName") %>" size="25" maxlength="50" onkeydown="javascript:if(event.keyCode==13) postModuleAndAction('comment', 'search')"/>&nbsp;
					是否回复：<%= AppUtil.getSelectString("q_replyFlag", JSPDataBean.getFormData("q_replyFlag"), "1:已回复,0:未回复") %>&nbsp;
				</td>
				<td class="righttd">
					<div><dl>
	               		<dt style="width: 100%;">
	                   		<a class="btn_y" onclick="javascript:postModuleAndAction('comment', 'search')"><span>搜&nbsp;&nbsp;&nbsp;&nbsp;索</span></a>
	                   	</dt>
	              	</dl></div>
				</td>
			</tr>
		</table>
	</div>
	<div>
		<table class="list" border="0" cellpadding="0" cellspacing="1" width="100%" id="tab1">
			<tr>
				<th width="5%">评论ID</th>
				<th width="5%">评论人</th>
				<th width="5%">商品信息</th>
				<th width="15%">商品名称</th>
				<th width="5%">商品评分</th>
				<th width="5%">服务评分</th>
				<th width="5%">发货速度</th>
				<th width="5%">物流评分</th>
				<th width="*">评论内容</th>
				<th width="5%">评论时间</th>
				<th width="15%">回复内容</th>
				<th width="5%">回复时间</th>
				<th width="5%">状态</th>
				<% if(LocalDataCache.getInstance().getSysConfig("openAutoGoodCommentFlag").equals("1")) { %>
				<th width="5%">审核状态</th>
				<th width="5%">操作</th>
				<% } %>
			</tr>
			<%
				Vector datas = (Vector) JSPDataBean.getJSPData("datas");
				String[] columns = {"showUserName", "productName", "commentContent", "replyContent"};
				AppUtil.convertToHtml(columns, datas);
				for (int i = 0; i < datas.size(); i++) {
					Hashtable data = (Hashtable) datas.get(i);
			%>
			<tr>
				<td><%= data.get("commentID") %></td>
				<td><%= data.get("showUserName") %></td>
				<td>
					<a href="http://<%= AppKeys.DOMAIN_WWW %>/product/<%= data.get("productID") %>.html" class="thumbnail" target="_blank">
			          <img src="<%= AppUtil.getProductImage(data, AppKeys.IMAGE_SIZE_SMALL) %>"  style="height: 60px; width: 60px;">
			        </a>
				</td>
				<td><a href="http://<%= AppKeys.DOMAIN_WWW %>/product/<%= data.get("productID") %>.html" target="_blank"><%= data.get("productName") %></a></td>
				<td><%= data.get("commentScore") %>分</td>
				<td><%= data.get("serviceScore") %>分</td>
				<td><%= data.get("deliveryScore") %>分</td>
				<td><%= data.get("deliveryServiceScore") %>分</td>
				<td title="<%= data.get("commentContent") %>"><%= AppUtil.splitString(data.get("commentContent").toString(), 50) %></td>
				<td><%= data.get("postTime") %></td>
				<td title="<%= data.get("replyContent") %>"><%= AppUtil.splitString(data.get("replyContent").toString(), 50) %></td>
				<td><%= data.get("replyTime") %></td>
				<td>
					<a href="javascript:document.getElementById('commentID').value='<%= data.get("commentID") %>';postModuleAndAction('comment','<%= data.get("validFlag").equals("1") ? "disable" : "enable" %>')">
					<img src="/images/<%= data.get("validFlag").equals("1") ? "yes" : "no"%>.gif" width="15px" border="none"/>
					</a>
				</td>
				<% if(LocalDataCache.getInstance().getSysConfig("openAutoGoodCommentFlag").equals("1")) { %>
				<td>
					<%= data.get("auditFlag").equals("1") ? "通过" : (data.get("auditFlag").equals("0") ? "待审核" : "不通过") %>
				</td>
				<td>
					<% if(data.get("auditFlag").equals("0")) { %>
						<a href="javascript:document.getElementById('commentID').value='<%= data.get("commentID") %>';openInfoWindow('comment','auditCommentWindow')">审核</a>
					<% } %>
				</td>
				<% } %>
			</tr>
			<%	} %>
		</table>
		<div class="page blue">
		    <p class="floatl"><%@include file="common/commonJumpPage.jsp" %></p>
		    <div class="clear"></div>
		</div>
	</div>
	
	<% } else if (JSPDataBean.getFormData("action").equals("addView")) { %>
	<div class="record">
		<%@include file="common/commonEditTitle.jsp" %>
			<table border="0" cellspacing="0" cellpadding="0" width="100%">
				<tr>
					<th><span class="red">* </span>商品：</th>
					<td><input type="text" name="productName" id="productName" value="<%= JSPDataBean.getFormData("productName") %>" size="30" maxlength="50" onclick="openInfoWindow('selectSkuWindow')" readOnly="readOnly" style="background:#eee;"/></td>
				</tr>
				<tr>
					<th><span class="red">* </span>sku名称：</th>
					<td><input type="text" name="propName" id="propName" value="<%= JSPDataBean.getFormData("propName") %>" size="30" maxlength="50" readOnly="readOnly" style="background:#eee;"/></td>
				</tr>
				<tr>
					<th><span class="red">* </span>评论分数：</th>
					<td>
						<select class="form-control" id="commentScore" name="commentScore">
							<option value="5">5分</option>
							<option value="4">4分</option>
							<option value="3">3分</option>
							<option value="2">2分</option>
							<option value="1">1分</option>
						</select>
					</td>
				</tr>
				<tr>
					<th><span class="red">* </span>购买时间：</th>
					<td><input type="text" maxlength="10" id="orderTime" name="orderTime" value="<%= JSPDataBean.getFormData("orderTime") %>" onclick="calendar(this, false);" class="itime" readonly /></td>
				</tr>
				<tr>
					<th><span class="red">* </span>购买数量：</th>
					<td><input type="text" name="number" id="number" value="<%= JSPDataBean.getFormData("number") %>" size="30" maxlength="11"/></td>
				</tr>
				<tr>
					<th><span class="red">* </span>评论人：</th>
					<td><input type="text" name="showUserName" id="showUserName" value="<%= JSPDataBean.getFormData("showUserName") %>" size="30" maxlength="100"/></td>
				</tr>
				<tr>
					<th><span class="red">* </span>评论内容：</th>
					<td>
					<textarea name="commentContent" id="commentContent" onkeyup="if(this.value.length>500)this.value=this.value.substring(0,500)" style="width: 60%;"><%= JSPDataBean.getFormData("commentContent") %></textarea>
					</td>
				</tr>
				<tr>
					<th><span class="red">* </span>评论时间：</th>
					<td><input type="text" maxlength="10" id="postTime" name="postTime" value="<%= JSPDataBean.getFormData("postTime") %>" onclick="calendar(this, false);" class="itime" style="cursor: pointer;" readonly /></td>
				</tr>
				<tr>
					<th>回复内容：</th>
					<td>
					<textarea name="replyContent" id="replyContent" onkeyup="if(this.value.length>500)this.value=this.value.substring(0,500)" style="width: 60%;"><%= JSPDataBean.getFormData("replyContent") %></textarea>
					</td>
				</tr>
			</table>
		<div align="center">
			<div class="button">
				<a class="btn_bb1" id="btnSave" onclick="javascript:postModuleAndAction('comment','confirm')"><span>保 存</span></a>
				<a onclick="javascript:postModuleAndAction('comment', 'defaultView')" class="btn_bb1"><span>返 回</span></a>
			</div>
		</div>
		<input type="hidden" name="productID" id="productID" />
		<input type="hidden" name="skuID" id="skuID" />
		<input type="hidden" name="price" id="price" />
		<input type="hidden" name="userID" id="userID" value="0" />
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
				
		function selectProducts() {
		var selectedProductID = getRadioValue('selectChoice');
		if (selectedProductID == '') {
			alert('请选择一个商品');
		} else {
			closeInfoWindow('infoWindow');
		}
	}
			</script>
	<% } %>
	<%= JSPDataBean.getFormData("queryConditionHtml") %>	

	<input type="hidden" id="commentID" name="commentID" value="<%=JSPDataBean.getFormData("commentID")%>" />
	
</div>

<%@include file="common/commonFooter.jsp" %>









