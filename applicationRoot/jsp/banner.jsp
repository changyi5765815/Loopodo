<%@page import="admin.customer.guanwangbao.LocalDataCache"%>
<%@page import="admin.customer.guanwangbao.AppUtil"%>
<%@ page contentType="text/html;charset=UTF-8"%>
<jsp:directive.page import="java.util.Vector"/>
<jsp:directive.page import="java.util.Hashtable"/>
<%@page import="java.util.Iterator"%>
<jsp:useBean id="JSPDataBean" scope='request' class="simpleWebFrame.web.JSPDataBean" />

<%@include file="common/commonHeader.jsp" %>
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
    <%	if (JSPDataBean.getFormData("action").equals("groupDefaultView")) { %>
    <div class="btn_t0 left"><a href="javascript:postModuleAndAction('banner','defaultView')"><span><strong>广告图片导航</strong></span></a></div>
    <div class="btn_t left"><a href="javascript:postModuleAndAction('banner','groupDefaultView')"><span><strong>广告图片组管理</strong></span></a></div>
	<%	} else if (JSPDataBean.getFormData("action").equals("list")) { %>
    <div class="btn_t left"><a href="javascript:postModuleAndAction('banner','defaultView')"><span><strong>广告图片导航</strong></span></a></div>
    <div class="btn_t0 left"><a href="javascript:postModuleAndAction('banner','groupDefaultView')"><span><strong>广告图片组管理</strong></span></a></div>
   	<div class="tip gray9" style="float: right;"><a href="javascript:postModuleAndAction('banner', 'addView')" class="btn_y"><span><strong class="icon_add">添加</strong></span></a> </div>
    <% } %>
    <% if (JSPDataBean.getFormData("action").equals("addView") || JSPDataBean.getFormData("action").equals("editView")) { %>
    <div class="btn_t left"><a href="javascript:postModuleAndAction('banner','defaultView')"><span><strong>广告图片导航</strong></span></a></div>
    <% } %>
</div>

<div class="main clear">
	<div class="clrear"></div>
	<div style="background: none repeat scroll 0% 0% rgb(242, 249, 255);">
		<span style="margin:5px 0px 5px 10px;color: red;">注：广告图信息修改后，请重启系统缓存！</span>
	</div>
	<% if (JSPDataBean.getFormData("action").equals("list")) { %>
	<div class="search">
	  	<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td>
	                <div><dl>
	                   <dd>导航ID：<input type="text" name="q_bannerID" id="q_bannerID" value="<%= JSPDataBean.getFormData("q_bannerID") %>" size="10" maxlength="6" onkeydown="javascript:if(event.keyCode==13) postModuleAndAction('banner', 'search')"/>&nbsp;</dd>
	                   <dd>标题：<input type="text" name="q_title" id="q_title" value="<%= JSPDataBean.getFormData("q_title") %>" size="18" maxlength="20" onkeydown="javascript:if(event.keyCode==13) postModuleAndAction('banner', 'search')"/>&nbsp;</dd>
	                   <dd style="width: auto;">所属分组：<%= JSPDataBean.getFormData("queryBannerGroupSelect") %>&nbsp;</dd>
	              	</dl></div>
				</td>
				<td class="righttd">
					<div><dl>
	               		<dt style="width: 100px">
	                   		<a class="btn_y" onclick="javascript:postModuleAndAction('banner', 'search')"><span>搜&nbsp;&nbsp;&nbsp;&nbsp;索</span></a>
	                   	</dt>
	              	</dl></div>
				</td>
			</tr>
		</table>
	</div>
	<div>
		<table class="list" border="0" cellpadding="0" cellspacing="1" width="100%" id="tab1">
			<tr>
				<th>首页导航ID</th>
				<th>所属分组</th>
				<th>标题</th>
				<th>广告图片</th>
				<th>对应商品</th>
				<th>排序&nbsp;<input value="更新" onclick="$('#table').val('banner');doAction('updateSortIndexAll')" type="button"></th>
				<th>状态</th>
				<th>操作</th>
			</tr>
			<%
				Vector datas = (Vector) JSPDataBean.getJSPData("datas");
				String[] convertColumns = {"title"}; 
				AppUtil.convertToHtml(convertColumns, datas);
				for (int i = 0; i < datas.size(); i++) {
					Hashtable data = (Hashtable) datas.get(i);
					String trClass = "tr_line" + (i % 2);
			%>
			<tr class="<%= trClass %>">
				<td><%= data.get("bannerID") %></td>
				<td><%= LocalDataCache.getInstance().getTableDataColumnValue("c_bannerGroup", data.get("bannerGroupID").toString(), "c_bannerGroupName") %></td>
				<td><%= data.get("title") %></td>
				<td style="text-align: center;"><img src="<%= AppUtil.getImageURL("banner", data.get("bannerImage").toString(), 0) %>" style="max-height: 100px; max-width: 200px;" /></td>
				<td style="text-align: center;"><img src="<%= AppUtil.getImageURL("banner", data.get("productImage").toString(), 0) %>"  style="max-height: 100px" /></td>
				<td>
					<input id="sortIndex_<%= data.get("bannerID") %>" name="sortIndex_<%= data.get("bannerID") %>" value="<%= data.get("sortIndex") %>" size="5" maxlength="11" type="text">
				</td>
				<td>
					<% if (data.get("validFlag").equals("1")) { %>
					<a href="javascript:document.getElementById('bannerID').value='<%=data.get("bannerID")%>';postModuleAndAction('banner','disable')">
					<% } else { %>
					<a href="javascript:document.getElementById('bannerID').value='<%=data.get("bannerID")%>';postModuleAndAction('banner','enable')">
					<% } %>
					<img src="/images/<%= data.get("validFlag").equals("1") ? "yes" : "no"%>.gif" width="15px" border="none"/>
					</a>
				</td>
				<td>
					<a id="<%=data.get("bannerID")%>" href="javascript:document.getElementById('bannerID').value='<%= data.get("bannerID") %>';postModuleAndAction('banner','editView')">编辑</a>
				</td>
			</tr>
			<%	} %>
		</table>
		<div class="page blue">
	    	<p class="floatl"><%@include file="common/commonJumpPage.jsp" %></p>
		    <div class="clear"></div>
		</div>
	</div>
	
	<% } else if (JSPDataBean.getFormData("action").equals("groupDefaultView")) { %>
	<div>
		<table class="list" border="0" cellpadding="0" cellspacing="1" width="100%" id="tab1">
			<tr>
				<th>ID</th>
				<th>名称</th>
				<th>链接</th>
				<th>操作</th>
			</tr>
			<%
				Vector datas = (Vector) JSPDataBean.getJSPData("groupDatas");
				String[] convertColumns = {"link"}; 
				AppUtil.convertToHtml(convertColumns, datas);
				for (int i = 0; i < datas.size(); i++) {
					Hashtable data = (Hashtable) datas.get(i);
					String trClass = "tr_line" + (i % 2);
			%>
			<tr class="<%= trClass %>">
				<td><%= data.get("c_bannerGroupID") %></td>
				<td><%= data.get("c_bannerGroupName") %></td>
				<td><%= data.get("link") %></td>
				<td>
					<a id="<%= data.get("c_bannerGroupID") %>" href="javascript:document.getElementById('c_bannerGroupID').value='<%= data.get("c_bannerGroupID") %>';postModuleAndAction('banner','groupEditView')">编辑</a>
				</td>
			</tr>
			<%	} %>
		</table>
	</div>
	<input type="hidden" name="c_bannerGroupID" id="c_bannerGroupID" value="">
	<% } else if (JSPDataBean.getFormData("action").equals("groupEditView")) { %>
		<link href="/css/colpick.css" rel="stylesheet" type="text/css">
		<div class="record">
			<%@include file="common/commonEditTitle.jsp" %>
			<table border="0" cellspacing="0" cellpadding="0" width="100%">
				<tr>
				  <th>名称：</th>
				  <td height="28"><input type="text" name="c_bannerGroupName" id="c_bannerGroupName" value="<%= JSPDataBean.getFormData("c_bannerGroupName") %>" size="30" maxlength="200" /></td>
				</tr>
				<tr>
				  <th>链接：</th>
				  <td height="28"><input type="text" name="link" id="link" value="<%= JSPDataBean.getFormData("link") %>" size="30" maxlength="200" /></td>
				</tr>
			</table>
			<div align="center">
				<div class="button">
					<a class="btn_bb1" id="btnSave" onclick="javascript:postModuleAndAction('banner', 'confirmGroup')"><span>保 存</span></a>
					<a onclick="javascript:postModuleAndAction('banner', 'groupDefaultView')" class="btn_bb1"><span>返 回</span></a>
				</div>
			</div> 
		</div>
		<input type="hidden" name="c_bannerGroupID" id="c_bannerGroupID" value="<%= JSPDataBean.getFormData("c_bannerGroupID") %>">
	<% } else { %>
	<link href="/css/colpick.css" rel="stylesheet" type="text/css">
	<script src="/js/colpick.js"></script>
		<div class="record">
			<%@include file="common/commonEditTitle.jsp" %>
			<table border="0" cellspacing="0" cellpadding="0" width="100%">
				<tr>
				  <th><span class="red">* </span>所属分组：</th>
				  <td height="28"><%= JSPDataBean.getFormData("bannerGroupSelect") %></td>
				</tr>
				<tr>
				  <th><span class="red">* </span>标题：</th>
				  <td height="28"><input type="text" name="title" id="title" value="<%= JSPDataBean.getFormData("title") %>" size="30" maxlength="20" />(可以输入20个中文字符)</td>
				</tr>
				<tr>
				  <th>描述：</th>
				  <td height="28"><input type="text" name="content" id="content" value="<%= JSPDataBean.getFormData("content") %>" size="30" maxlength="50" />(可以输入50个中文字符)</td>
				</tr>
				<tr>
				  <th><span class="red">* </span>链接：</th>
				  <td height="28"><input type="text" name="link" id="link" value="<%= JSPDataBean.getFormData("link") %>" size="30" maxlength="100" />(可以输入100个英文字符)<span class="red">  请输入本站链接</span></td>
				</tr>
				<tr>
				  <th>新窗口打开：</th>
				  <td height="28">
				  	<input type="radio" name="isTarget" id="isTarget" target="_blank" value="0" <%= !JSPDataBean.getFormData("isTarget").equals("1") ? "checked=\"checked\"" : "" %> />&nbsp;是&nbsp;
				  	<input type="radio" name="isTarget" id="isTarget" target="_blank" value="1" <%= JSPDataBean.getFormData("isTarget").equals("1") ? "checked=\"checked\"" : "" %> />&nbsp;否&nbsp;
				  </td>
				</tr>
				
				<tr>
				  <th>广告图片：</th>
				  <td>
					<span>
	            	 	<img class="imgBorder" id='imagePreview' src='<%= AppUtil.getImageURL("banner", JSPDataBean.getFormData("bannerImage"), 0)%>' style="max-height: 100px"/>
	            	</span>
	            	<br />
	            	<a class="infoLink" href="javascript:void(0)" onclick="javascript:doUploadFile('banner', 'bannerImage', 'imagePreview', '')">上传</a>
	            	<a class="infoLink" href="javascript:void(0)" onclick="javascript:clearUploadFile('bannerImage', 'imagePreview')">删除</a>
	            	<input type="hidden" name="bannerImage" id="bannerImage" value="<%= JSPDataBean.getFormData("bannerImage") %>" />
	            	<input type="hidden" name="oldBannerImage" id="oldBannerImage" value="<%= JSPDataBean.getFormData("bannerImage") %>" />
				</td>
				</tr>
				
				<tr>
				  <th>wap广告图片：</th>
				  <td>
					<span>
	            	 	<img class="imgBorder" id='imagePreview_' src='<%= AppUtil.getImageURL("banner", JSPDataBean.getFormData("wapBannerImage"), 0)%>' style="max-height: 100px"/>
	            	</span>
	            	<br />
	            	<a class="infoLink" href="javascript:void(0)" onclick="javascript:doUploadFile('banner', 'wapBannerImage', 'imagePreview_', '')">上传</a>
	            	<a class="infoLink" href="javascript:void(0)" onclick="javascript:clearUploadFile('wapBannerImage', 'imagePreview_')">删除</a>
	            	<input type="hidden" name="wapBannerImage" id="wapBannerImage" value="<%= JSPDataBean.getFormData("wapBannerImage") %>" />
				</td>
				</tr>
				
				<tr>
				  <th>背景色：</th>
				  <td height="28">
				  	<div class="col-sm-4">
					<div class="picker" id="clolorDiv" style="<%= "".equals(JSPDataBean.getFormData("color")) ? "" : ("background-color: " + JSPDataBean.getFormData("color"))  %>"></div>
					&nbsp;<a href="javascript:;" onclick="$('#clolorDiv').css('background-color', '');$('#color').val('')">清除背景色</a>
					<input type="hidden" name="color" id="color" value="<%= JSPDataBean.getFormData("color") %>" />
					</div>
				  </td>
				</tr>
				<script>colorPicker('clolorDiv', 'color', '<%= JSPDataBean.getFormData("color") %>');</script>
				
				<%	 
					boolean promotionBannerFlag = false;
					if (JSPDataBean.getFormData("bannerGroupID").equals("22") || JSPDataBean.getFormData("bannerGroupID").equals("23")) {
						promotionBannerFlag = true;
					}
				%>
				<!-- 商品信息开始 -->
				<tr id="productIDTr" <% if (promotionBannerFlag) { %> style="display:none;"  <% } %>>
				  <th>商品：</th>
				  <td height="28">
				  	<input readonly="readonly" type="text" name="productID" id="productID" value="<%= JSPDataBean.getFormData("productID") %>" size="30" onclick="javascript:$('#selectedValues').val('');openInfoWindow('selectProductWindow')"  />
				  	<a class="infoLink" href="javascript:void(0)" onclick="javascript:$('#productID').val('');$('#productImage').val('/images/none.jpg');$('#productName').val('');$('#productNormalPrice').val('');$('#productPrice').val('');">删除</a>
				  </td>
				</tr>
				
				<tr id="productImageTr" <% if (promotionBannerFlag) { %> style="display:none;"  <% } %>>
				  <th>商品图片：</th>
				  <td>
					<span>
	            	 	<img class="imgBorder" id="productImage" src='<%= AppUtil.getImageURL("product", JSPDataBean.getFormData("productImage"), 0)%>' style="width:100px;height:100px"/>
	            	</span>
				</td>
				</tr>
				
				<tr id="productNameTr" <% if (promotionBannerFlag) { %> style="display:none;"  <% } %>>
				  <th>商品名称：</th>
				  <td height="28"><input readonly="readonly" type="text" name="productName" id="productName" value="<%= JSPDataBean.getFormData("productName") %>" size="30" /></td>
				</tr>
				
				<tr id="productNormalPriceTr" <% if (promotionBannerFlag) { %> style="display:none;"  <% } %>>
				  <th>商品市场价：</th>
				  <td height="28"><input readonly="readonly" type="text" name="productNormalPrice" id="productNormalPrice" value="<%= JSPDataBean.getFormData("productNormalPrice") %>" size="30"/></td>
				</tr>
				
				<tr id="productPriceTr" <% if (promotionBannerFlag) { %> style="display:none;"  <% } %>>
				  <th>商品商城价：</th>
				  <td height="28"><input readonly="readonly" type="text" name="productPrice" id="productPrice" value="<%= JSPDataBean.getFormData("productPrice") %>" size="30" /></td>
				</tr>
				<!-- 商品信息结束 -->
				<%-- 
				<tr id="activityPriceTr" <% if (!JSPDataBean.getFormData("bannerGroupID").equals("12")) { %> style="display:none;"  <% } %>>
				  <th><span class="red">* </span>抢购价：</th>
				  <td height="28"><input type="text" name="activityPrice" id="activityPrice" value="<%= JSPDataBean.getFormData("activityPrice") %>" size="30" maxlength="11" /></td>
				</tr>
				
				<tr id="activityTimeTr" <% if (!JSPDataBean.getFormData("bannerGroupID").equals("12")) { %> style="display:none;"  <% } %>>
				  <th><span class="red">* </span>抢购时间：</th>
				  <td height="28">
				  	<input  type="text" id="startTime" name="startTime" value="<%= JSPDataBean.getFormData("startTime") %>" class="itime" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" style="cursor: pointer;width:150px" readonly> - 
			    	<input  type="text" id="endTime" name="endTime" value="<%= JSPDataBean.getFormData("endTime") %>" class="itime" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" style="cursor: pointer;width:150px" readonly>
				  </td>
				</tr>
				--%>
				<tr id="_productIDs_0" <% if (!(
					JSPDataBean.getFormData("bannerGroupID").equals("13")
				|| JSPDataBean.getFormData("bannerGroupID").equals("12")
				|| JSPDataBean.getFormData("bannerGroupID").equals("17")
				|| JSPDataBean.getFormData("bannerGroupID").equals("18")
				|| JSPDataBean.getFormData("bannerGroupID").equals("19")
				|| JSPDataBean.getFormData("bannerGroupID").equals("20")
				)) { %> style="display:none;"  <% } %>>
					<th>商品：</th>
					<td>
						<div class="order_detail_box" style="margin: 10px;">
							<table class="order_detail" cellpadding="0" cellspacing="1" width="100%">
								  <tr>
									<td class="leftbg" width="15%" style="text-align: center;">商品编号</td>
									<td class="leftbg" width="35%" style="text-align: center;">商品名称</td>
									<td class="leftbg" width="35%" style="text-align: center;">操作</td>
								  </tr>
									<%
										Vector itemDatas = (Vector) JSPDataBean.getJSPData("productDatas");
										itemDatas = itemDatas == null ? new Vector() : itemDatas;
										String[] columns2 = {"name"};
										AppUtil.convertToHtml(columns2, itemDatas);
										for (int i = 0; i < itemDatas.size(); i++) {
											Hashtable data = (Hashtable) itemDatas.get(i);
									%>
								  <tr id="tr_<%= i %>">
									<td><%= data.get("productID") %></td>
									<td>
										<span class="goods_name">
											<a href="javascript:;" target="_blank" style="text-decoration: none;">
												<%= data.get("name") %>&nbsp;
											</a>
										</span>
									</td>
									<td>
										<span class="goods_name">
											<a href="javascript:;" onclick="$('#tr_<%= data.get("productID") %>').remove()">
												删除
											</a>
											<input style='display:none;' checked='checked' type='checkbox' name='productID_' value='<%= data.get("productID") %>'/>
										</span>
									</td>
								  </tr>
								 <%	} %>
							</table>
							
							<div align="center">
								<div class="button">
									<a onclick="javascript:openInfoWindow('selectProduct2Window')" class="btn_bb1"><span>选择商品</span></a>
								</div>
							</div>
						</div>
						<script>
							function selectProducts2() {
								if (document.getElementById('selectedValues').value == '') {
									alert('请选择一个商品');
									return;
								}
								var selectedValues = document.getElementById('selectedValues').value;
								var json = eval($("#json").val());
								var split = selectedValues.split(",");
								for(var i = 0; i < split.length; i++) {
									if(split[i] == "") continue;
									for(var j in json) {
										if(json[j].pID == split[i]) {
											var NowTime = new Date(); 
											var id = NowTime.getTime();
											var html_ = "<tr id='tr_" + id + "'><td>";
											html_ += json[j].pID;
											html_ += "</td>";
											html_ += "</td><td class=\"goods_txt\">";
											html_ += "<span class=\"goods_name\">";
											html_ += "<a href=\"javascript:;\" target=\"_blank\" style=\"text-decoration: none;\">";
											html_ += json[j].name;
											html_ += "</a>";
											html_ += "</span>";
											html_ += "</td>";
											html_ += "<td>";
											html_ += "<a href='javascript:;' onclick=\"$('#tr_" + id + "').remove()\">删除</a><input style='display:none;' checked='checked' type='checkbox' name='productID_' value='" + json[j].pID + "'/>";
											html_ += "</td>";
											html_ += "</tr>";
											$(".order_detail").append(html_);
										}
									}
								}
								setSelectedValues('productID_', 'context');
								closeInfoWindow('infoWindow');
							}
						</script>
						<input type="hidden" name="context" id="context" />
					</td>
				</tr>
			</table>
			<div align="center">
				<div class="button">
					<a class="btn_bb1" id="btnSave" onclick="javascript:confirm()"><span>保 存</span></a>
					<a onclick="javascript:postModuleAndAction('banner', 'list')" class="btn_bb1"><span>返 回</span></a>
				</div>
			</div> 
		</div>
		
		<input type="hidden" name="selectedValues" id="selectedValues" value=""/>
		<script>
			function selectProducts() {
				if (document.getElementById('selectedValues').value == '') {
					alert('请选择一个商品');
					return;
				} else {
					closeInfoWindow();
					doAction('selectProduct');
				}
			}
			function selectBrand() {
				if (document.getElementById('selectedValues').value == '') {
					alert('请选择一个品牌');
					return;
				} else {
					closeInfoWindow();
					doAction('selectBrand');
				}
			}
			function setBannerTr() {
				var bannerGroupID = $('#bannerGroupID').val();
				<%-- 
				if (bannerGroupID == '12') {
					$('#activityPriceTr').show();
					$('#activityTimeTr').show();
				} else {
					$('#activityPriceTr').hide();
					$('#activityTimeTr').hide();
					
					$('#activityPrice').val('');
					$('#startTime').val('');
					$('#endTime').val('');
				}
				--%>
				if(bannerGroupID == '13' 
				|| bannerGroupID == '12'
				|| bannerGroupID == '17'
				|| bannerGroupID == '18'
				|| bannerGroupID == '19'
				|| bannerGroupID == '20') {
					$("#_productIDs_0").show();
				} else {
					$("#_productIDs_0").hide();
				}
				if (bannerGroupID == '22' || bannerGroupID == '23') {
					$("[id^='product']").hide();
					$('#productID').val('');
				} else {
					$("[id^='product']").show();
				}
			}
			function confirm() {
				try {
					setSelectedValues('productID_', 'context');
				} catch(e) {}
				doAction('banner', 'confirm')
			}
		</script>
	<% } %>
</div>

<input type="hidden" id="bannerID" name="bannerID" value="<%= JSPDataBean.getFormData("bannerID") %>" />
<% if (!JSPDataBean.getFormData("action").equals("list")) { %>
	<%= JSPDataBean.getFormData("queryConditionHtml") %>
<% } %>

<%@include file="common/commonFooter.jsp" %>
