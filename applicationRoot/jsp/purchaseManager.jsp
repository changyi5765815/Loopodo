<%@page import="admin.customer.guanwangbao.LocalDataCache"%>
<%@page import="java.util.Hashtable"%>
<%@page import="java.util.Vector"%>
<%@page import="admin.customer.guanwangbao.AppUtil"%>
<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="java.util.Iterator"%>
<%@page import="simpleWebFrame.util.PriceUtil"%>
<%@page import="com.alibaba.fastjson.JSON"%>
<%@page import="com.alibaba.fastjson.TypeReference"%>
<%@page import="admin.customer.guanwangbao.AppKeys"%>
<jsp:useBean id="JSPDataBean" scope='request' class="simpleWebFrame.web.JSPDataBean" />

<%@include file="common/commonHeader.jsp"%>

<style>
.order_detail_box table.order_detail {
	background: #ccc;
	margin: 0 0 10px 0;
	border-spacing: 1px;
	border-collapse: separate;
}

.order_detail_box table.order_detail td {
	padding: 4px 8px;
	text-align: left;
	height:25px;
	line-height: 25px;
	background: #FFFFFF;
}

.childrenuser_box table.order_detail td {
	padding: 4px 8px;
	text-align: center;
	height:25px;
	line-height: 25px;
	background: #FFFFFF;
}

.order_detail_box table.order_detail tr.order_detail_title td {
	color: #5A5A5A;
	text-align: left;
	padding: 4px 15px;
	background: #F8F8F8;
}

.order_detail_box table.order_detail td.leftbg {
	color: #666;
	background: #F0F0F0;
}

.order_detail_box .order_detail_info {
	margin-top: 5px;
	color: #666666;
	text-align: center;
	line-height: 20px;
}

.order_detail_box .gift_list {
	padding: 5px 0px;
	line-height: 18px;
}

.order_detail_box .goods_txt {
	text-align: left;
}

.order_detail_box .goods_name {
	color: #666666;
}

.order_detail_box .goods_name a:link {
	color: #666666;
}

.order_detail_box .goods_name a:visited {
	color: #666666;
}

.order_detail_box .goods_name a:hover {
	color: #666666;
}

.order_detail_box .good_xiuhua {
	padding: 5px 8px;
	line-height: 25px;
}

.table {
	width: 100%;
	margin-bottom: 20px;
	text-align: center;
	border: 1px solid #ddd;
	color: #666666;
}
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
	<div class="btn_t left"><a href="javascript:postModuleAndAction('purchaseManager','defaultView')"><span><strong>供需管理</strong></span></a></div>
</div>

<div class="main clear">
	<div class="clear"></div>
		<%  if (JSPDataBean.getFormData("action").equals("list")) { %>
		<div class="search">
	  		<table border="0" cellpadding="0" cellspacing="0" width="100%">
		    	<tr>
			    	<td>　
			    		采购单ID：<input type="text" name="q_purchaseID" id="q_purchaseID" value="<%= JSPDataBean.getFormData("q_purchaseID") %>" size="10" maxlength="11"/>
						标题：<input type="text" name="q_title" id="q_title" value="<%= JSPDataBean.getFormData("q_title") %>" size="10" maxlength="50" />
						采购类型：
							<select id="q_purType" name="q_purType" class="form-control">
								<option value=""></option>
								<option value="1" <%= JSPDataBean.getFormData("q_purType").equals("1") ? "selected=\"selected\"" : "" %>>现货/标准品</option>
								<option value="2" <%= JSPDataBean.getFormData("q_purType").equals("2") ? "selected=\"selected\"" : "" %>>加工/定制品</option>
							</select>
						商品名称：<input type="text" name="q_productName" id="q_productName" value="<%= JSPDataBean.getFormData("q_productName") %>" size="10" maxlength="50" />
						添加时间：<input type="text" size="12" maxlength="20" id="q_fromAddTime" name="q_fromAddTime" value="<%= JSPDataBean.getFormData("q_fromAddTime").equals("") ? "" : JSPDataBean.getFormData("q_fromAddTime").substring(0, 10) %>" onclick="calendar(this, false);" class="itime" style="cursor: pointer;" readonly onkeydown="javascript:if(event.keyCode==13)postModuleAndAction('purchaseManager', 'search')" />&nbsp;-
			               <input type="text" size="12" maxlength="20" id="q_toAddTime" name="q_toAddTime" value="<%= JSPDataBean.getFormData("q_toAddTime").equals("") ? "" : JSPDataBean.getFormData("q_toAddTime").substring(0, 10) %>" onclick="calendar(this, false);" class="itime" style="cursor: pointer;" readonly onkeydown="javascript:if(event.keyCode==13)postModuleAndAction('purchaseManager', 'search')" />&nbsp;
						
						审核状态：
						<select id="q_auditStatus" name="q_auditStatus" class="form-control">
							<option value=""></option>
							<option value="0" <%= JSPDataBean.getFormData("q_auditStatus").equals("0") ? "selected=\"selected\"" : "" %>>待审核</option>
							<option value="1" <%= JSPDataBean.getFormData("q_auditStatus").equals("1") ? "selected=\"selected\"" : "" %>>通过</option>
							<option value="2" <%= JSPDataBean.getFormData("q_auditStatus").equals("2") ? "selected=\"selected\"" : "" %>>未通过</option>
						</select>
					</td>
					<td class="righttd">
						<div><dl>
		               		<dt style="width: 100%;">
		                   		<a class="btn_y" onclick="javascript:postModuleAndAction('purchaseManager', 'search')"><span>搜&nbsp;&nbsp;&nbsp;&nbsp;索</span></a>
		                   	</dt>
		              	</dl></div>
					</td>
				</tr>
			</table>
		</div>
		
		<div>
			<table class="list" border="0" cellpadding="0" cellspacing="1" width="100%" id="tab1">
				<tr>
					<th width="5%">采购单ID</th>
					<th width="15%">标题</th>
					<th width="10%">采购类型</th>
					<th width="15%">联系人</th>
					<th width="8%">手机号码</th>
					<th width="8%">截止日期</th>
					<th width="10%">添加时间</th>
					<th width="5%">审核状态</th>
					<th width="5%">是否已<br/>有报价</th>
					<th width="5%">是否有效</th>
					<th width="*">操作</th>
				</tr>
			<%
				Vector datas = (Vector) JSPDataBean.getJSPData("datas");
				for (int i = 0; i < datas.size(); i++) {
					Hashtable data = (Hashtable) datas.get(i);
			%>
			<tr>
				<td><%= data.get("purchaseID") %></td>
				<td><%= data.get("title") %></td>
				<td><%= data.get("purType").equals("1") ? "现货/标准品" : "加工/定制品" %></td>
				<td><%= data.get("linkMan") %></td>
				<td><%= data.get("mobile") %></td>
				<td><%= data.get("endDate") %></td>
				<td><%= data.get("addTime") %></td>
				<td><%= data.get("auditStatus").equals("0") ? "待审核" : (data.get("auditStatus").equals("1") ? "通过" : "不通过") %></td>
				<td><%= data.get("quoteFlag").equals("1") ? "是" : "否" %></td>
				<td><%= data.get("validFlag").equals("1") ? "有效" : "已关闭" %></td>
				<td align="center">
					<a href="javascript:$('#purchaseID').val('<%= data.get("purchaseID")%>');postModuleAndAction('purchaseManager', 'editView')">详细</a>
					<% if (data.get("auditStatus").equals("0")) { %>
					<a href="javascript:$('#purchaseID').val('<%= data.get("purchaseID")%>');openInfoWindow('purchaseManager', 'auditPurchaseWindow');">审核</a>
					<% } %>
					<a href="javascript:$('#purchaseID').val('<%= data.get("purchaseID")%>');postModuleAndAction('purchaseManager', 'quoteList')">报价单</a>
					<a href="javascript:if(confirm('确认删除采购单？')){$('#purchaseID').val('<%= data.get("purchaseID")%>');postModuleAndAction('purchaseManager', 'deletePurchase');}" style="color: red;">删除</a>
				</td>
			</tr>
			<% } %>
			</table>
			<div class="page blue">
			    <p class="floatl"><%@include file="common/commonJumpPage.jsp" %></p>
			    <div class="clear"></div>
			</div>
		</div>
		<% 	} else if (JSPDataBean.getFormData("action").equals("editView")) { 
				Hashtable area = AppUtil.getArea(JSPDataBean.getFormData("townID"));
		%>
		<div class="order_detail_box" >
			<table class="order_detail" cellpadding="0" cellspacing="1" width="100%">
				<tr class="order_detail_title">
					<td colspan="4">采购信息</td>
				</tr>
				<tr>
					<td class="leftbg" width="15%">标题</td>
					<td width="35%"><%= JSPDataBean.getFormData("title") %></td>
					<td class="leftbg" width="15%">采购类型</td>
					<td><%= JSPDataBean.getFormData("purType").equals("1") ? "现货/标准品" : "加工/定制品" %></td>
				</tr>
				<tr>
					<td class="leftbg" width="15%">截止日期</td>
					<td width="35%"><%= JSPDataBean.getFormData("endDate") %></td>
					<td class="leftbg" width="15%">期望收货日期</td>
					<td><%= JSPDataBean.getFormData("expectShouHuoDate") %></td>
				</tr>
				<tr>
					<td class="leftbg" width="15%">是否有商家报价</td>
					<td width="35%"><%= JSPDataBean.getFormData("quoteFla").equals("1") ? "是" : "否" %></td>
					<td class="leftbg" width="15%">是否有效</td>
					<td><%= JSPDataBean.getFormData("validFlag").equals("1") ? "有效" : "已关闭" %></td>
				</tr>
				<tr>
					<td class="leftbg" width="15%">查看报价单要求</td>
					<td width="35%"><%= JSPDataBean.getFormData("showQuotedPriceFlag").equals("1") ? "报价截止时间到期后可查看报价单" : "随时可以查看报价单" %></td>
					<td class="leftbg" width="15%">添加时间</td>
					<td><%= JSPDataBean.getFormData("addTime") %></td>
				</tr>
				<tr>
					<td class="leftbg" width="15%">补充说明</td>
					<td colspan="3"><%= JSPDataBean.getFormData("info") %></td>
				</tr>
				
				<tr class="order_detail_title">
					<td colspan="4">联系人信息</td>
				</tr>
				<tr>
					<td class="leftbg" width="15%">姓名</td>
					<td width="35%"><%= JSPDataBean.getFormData("linkMan") %></td>
					<td class="leftbg" width="15%">手机号码</td>
					<td><%= JSPDataBean.getFormData("mobile") %></td>
				</tr>
				<tr>
					<td class="leftbg" width="15%">联系电话</td>
					<td width="35%"><%= JSPDataBean.getFormData("phone") %></td>
					<td class="leftbg" width="15%">收货地址</td>
					<td><%= area.get("provinceName") %>&nbsp;<%= area.get("cityName") %>&nbsp;<%= area.get("townName") %>&nbsp;<%= JSPDataBean.getFormData("address") %></td>
				</tr>
				<tr>
					<td class="leftbg" width="15%">联系方式</td>
					<td width="35%"><%= JSPDataBean.getFormData("showLinkType").equals("1") ? "报价后可看" : "公开" %></td>
					<td class="leftbg" width="15%"></td>
					<td></td>
				</tr>
				
				<%	if (!JSPDataBean.getFormData("auditStatus").equals("0")) { %>
				<tr class="order_detail_title">
					<td colspan="4">审核信息</td>
				</tr>
				<tr>
					<td class="leftbg" width="15%">审核状态</td>
					<td width="35%"><%= JSPDataBean.getFormData("auditStatus").equals("0") ? "待审核" : (JSPDataBean.getFormData("auditStatus").equals("1") ? "通过" : "不通过") %></td>
					<td class="leftbg" width="15%">审核时间</td>
					<td><%= JSPDataBean.getFormData("auditTime") %></td>
				</tr>
				<tr>
					<td class="leftbg" width="15%">审核备注</td>
					<td colspan="3"><%= JSPDataBean.getFormData("auditNote") %></td>
				</tr>
				<% 	} %>
			</table>
			
			<div class="childrenuser_box" >
			<table class="order_detail" cellpadding="0" cellspacing="1" width="100%">
				<tr class="order_detail_title">
					<td>商品信息</td>
				</tr>
				<tr>
					<td>
					<div>
						<table class="list" border="0" cellpadding="0" cellspacing="1" width="100%" id="tab1">
						<tr id="sort_paras">
							<th>商品图片</th>
							<th id="s_userID">商品名称</th>
							<th id="s_userID">所属分类</th>
							<th id="s_userID">数量</th>
							<th id="s_userID">规格</th>
						</tr>
						<%
							Vector datas = (Vector) JSPDataBean.getJSPData("purchaseItems");
							for (int i = 0; i < datas.size(); i++) {
								Hashtable data = (Hashtable) datas.get(i);
						%>
						<tr>
							<td>
								<a href="<%= AppUtil.getImageURL("purchase", data.get("image").toString(), 0) %>" target="_blank">
									<img src="<%= AppUtil.getImageURL("purchase", data.get("image").toString(), 0) %>" width="80px" height="80px">
								</a>
							</td>
							<td><%= data.get("productName") %></td>
						  	<td><%= LocalDataCache.getInstance().getTableDataColumnValue("tinyType", data.get("tinyTypeID").toString(), "name") %></td>
						  	<td><%= data.get("number") %></td>
						  	<td><%= data.get("skuInfo") %></td>
						</tr>
						<%	} %>
						</table>
					</div>
					</td>
				</tr>
			</table>
			</div>
			
			<div align="center">
				<div class="button">
					<%	if (JSPDataBean.getFormData("auditStatus").equals("0")) { %>
					<a class="btn_bb1" onclick="javascript:openInfoWindow('purchaseManager', 'auditPurchaseWindow');" class="btn btn-warning"><span>审 核</span></a>
					<%	} %>
					<a class="btn_bb1" onclick="javascript:clearFiles();postModuleAndAction('purchaseManager', 'list');" class="btn btn-primary"><span>返 回</span></a>
				</div>
			</div>	
		</div>
		<%	} else if (JSPDataBean.getFormData("action").equals("quoteList")) { %>
		<div>
			<table class="list" border="0" cellpadding="0" cellspacing="1" width="100%" id="tab1">
				<tr id="sort_paras">
					<th width="5%">报价单ID</th>
					<th width="10%">类型</th>
					<th width="8%">供应商ID</th>
					<th width="10%">联系人</th>
					<th width="10%">手机号</th>
					<th width="10%">电话</th>
					<th width="5%">总报价</th>
					<th width="5%">运费</th>
					<th width="8%">是否被采纳</th>
					<th width="15%">备注</th>
					<th width="5%">状态</th>
					<th width="*">操作</th>
				</tr>
				<%
					Vector datas = (Vector) JSPDataBean.getJSPData("datas");
					String[] items = {"linkName", "info"};
					AppUtil.convertToHtml(items, datas);
					Vector purchaseItems = (Vector) JSPDataBean.getJSPData("purchaseItems");
					purchaseItems = purchaseItems == null ? new Vector() : purchaseItems;
					for (int i = 0; i < datas.size(); i++) {
						Hashtable data = (Hashtable) datas.get(i);
						String priceDetail = (String) data.get("priceDetail");
						Hashtable<String, String> priceDetailHash = new Hashtable<String, String>();
						if(!priceDetail.equals("")) {
							try {
								priceDetailHash = JSON.parseObject(priceDetail, new TypeReference<Hashtable<String, String>>(){});
							} catch(Exception e) {}
						}
				%>
				<tr>
					<td><%= data.get("quoteID") %></td>
					<td><%= data.get("type").equals("1") ? "网站报价" : "供应商报价" %></td>
					<td><%= data.get("supplierID") %></td>
					<td><%= data.get("linkMan") %></td>
					<td><%= data.get("mobile") %></td>
					<td><%= data.get("phone") %></td>
					<td><%= PriceUtil.formatPrice((String) data.get("totalPrice")) %></td>
					<td><%= PriceUtil.formatPrice((String)data.get("fee")) %></td>
					<td><%= data.get("adoptFlag").equals("1") ? "是" : "否" %></td>
					<td><%= data.get("info") %></td>
					<td>
						<img src="/images/<%= data.get("validFlag").equals("1") ? "yes" : "no" %>.gif" width="15px" border="none"/>
					</td>
					<td>
						<a class="moreOffer" href="javascript:;"><i></i><span>展开详情<span></a>
					</td>
				</tr>
				<tr>
					<td colspan="12" style="padding:0;border-top:0 none;height:auto;">
						<div class="moreTable" style="display:none;">
							<table class="list" cellpadding="0" cellspacing="1" width="100%" border="0"> 
								<tr>
									<th width="15%">图片</th>
									<th width="*">名称</th>
									<th width="20%">分类</th>
									<th width="10%">采购数量</th>
									<th width="10%">价格</th>
									<th width="10%">规格</th>
									<th width="10%">报价</th>
								</tr>
								<%
									for(int j = 0; j < purchaseItems.size(); j++) {
										Hashtable data2 = (Hashtable) purchaseItems.get(j);
								%>
								<tr>
									<td>
										<a href="<%= AppUtil.getImageURL("purchase", data2.get("image").toString(), 0) %>" target="_blank">
											<img src="<%= AppUtil.getImageURL("purchase", data2.get("image").toString(), 0) %>" width="80px" height="80px">
										</a>
									</td>
									<td>
										<%= data2.get("productName") %>
									</td>
									<td>
										<%= data2.get("bigTypeName") + " " + data2.get("smallTypeName") + " " + data2.get("tinyTypeName") %>
									</td>
									<td>
										<%= data2.get("number") %>
									</td>
									<td>
										<%= data2.get("price") %>
									</td>
									<td>
										<%= data2.get("skuInfo") %>
									</td>
									<td>
										<%= priceDetailHash.containsKey(data2.get("purchaseItemID")) ? priceDetailHash.get(data2.get("purchaseItemID")) : "" %>
									</td>
								</tr>
								<% } %>
							</table>
						</div>
					</td>
				</tr>
			<% } %>
			</table>
			
			<div class="page blue">
			    <p class="floatl"><%@include file="common/commonJumpPage2.jsp" %></p>
			    <div class="clear"></div>
			</div>
			
			<script>
				function showPage2(pageIndex) {
					document.getElementById("pageIndex2").value = pageIndex;
					postModuleAndAction(document.getElementById("pageModule").value, "quoteList");
				}
			</script>
			<script>
			//展开报价
			$(".index-order-content .moreTable th:last-child,.index-order-content .moreTable td:last-child").css("border-right","0 none");
			$(".moreOffer").click(function(){
				$(this).toggleClass("cur");
				$(this).parents("tr").next().find(".moreTable").slideToggle();
				if(!$(this).hasClass("cur")){
					$(this).find("span").text("展开详情");
				} else{
					$(this).find("span").text("收起详情");
				}
			});
		</script>
		</div>
		<%	} %>
</div>

<input type="hidden" id="purchaseID" name="purchaseID" value="<%=JSPDataBean.getFormData("purchaseID")%>" />

<%@include file="common/commonFooter.jsp"%>
