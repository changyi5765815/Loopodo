<%@page import="admin.customer.guanwangbao.AppKeys"%>
<%@ page contentType="text/html;charset=UTF-8"%>
<jsp:directive.page import="java.util.Vector"/>
<jsp:directive.page import="java.util.Hashtable"/>
<%@page import="java.util.Iterator"%>
<%@page import="admin.customer.guanwangbao.AppUtil"%>
<%@page import="admin.customer.guanwangbao.LocalDataCache"%>
<%@page import="simpleWebFrame.util.PriceUtil"%>
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
<%	 
	String supplierOptName = JSPDataBean.getFormData("supplierOptName");
%>
<div class="headDiv">
	<div class="<%= supplierOptName.equals("") ? "btn_t left" : "btn_t0 left" %>"><a href="javascript:javascript:$('#supplierOptName').val('');postModuleAndAction('userStore','defaultView')"><span><strong>店铺管理</strong></span></a></div>
	<div class="<%= supplierOptName.equals("waitAudit") ? "btn_t left" : "btn_t0 left" %>"><a href="javascript:javascript:$('#supplierOptName').val('waitAudit');postModuleAndAction('userStore','defaultView')"><span><strong>店铺审核</strong></span></a></div>	
</div>

<div class="main clear">
	<div class="clear"></div>
	
	<% if (JSPDataBean.getFormData("action").equals("list")) { %>
    <div class="search">
	  	<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td>
					店铺ID：<input type="text" name="q_supplierID" id="q_supplierID" value="<%= JSPDataBean.getFormData("q_supplierID") %>" size="10" maxlength="20" onkeydown="javascript:if(event.keyCode==13) postModuleAndAction('userStore', 'search')"/>&nbsp;
					店铺：<input type="text" name="q_name" id="q_name" value="<%= JSPDataBean.getFormData("q_name") %>" size="25" maxlength="50" onkeydown="javascript:if(event.keyCode==13) postModuleAndAction('userStore', 'search')"/>&nbsp;
                    <% if (!supplierOptName.equals("waitAudit")) { %>
					状态：<%= JSPDataBean.getFormData("querySupplierStatusSelect") %>&nbsp;
					优质供应商：
					<select id="q_excellentFlag" name="q_excellentFlag">
						<option value=""></option>
						<option value="1" <%= JSPDataBean.getFormData("q_excellentFlag").equals("1") ? "selected=\"selected\"" : "" %> >是</option>
						<option value="0" <%= JSPDataBean.getFormData("q_excellentFlag").equals("0") ? "selected=\"selected\"" : "" %> >否</option>
					</select>
					&nbsp;
					<% } %>
				</td>
				<td class="righttd">
					<div><dl>
	               		<dt style="width: 100%;">
	                   		<a class="btn_y" onclick="javascript:postModuleAndAction('userStore', 'search')"><span>搜&nbsp;&nbsp;&nbsp;&nbsp;索</span></a>
	                   	</dt>
	              	</dl></div>
				</td>
			</tr>
		</table>
	</div>
	<div>
		<table class="list" border="0" cellpadding="0" cellspacing="1" width="100%" id="tab1">
			<tr>
				<th>店铺ID</th>
				<th>店铺</th>
				<th>店铺类型</th>
				<th>经营模式</th>
				<% 	if (!supplierOptName.equals("waitAudit")) { %>
				<th>店铺信誉等级</th>
				<th>店铺信誉标签</th>
				<th>店铺等级</th>
				<%	} %>
				<th>申请时间</th>
				<th>联系人</th>
				<th>联系电话</th>
				<% if (!supplierOptName.equals("waitAudit")) { %>
				<th>店铺评分</th>
				<% } %>
				<th width="8%">排序&nbsp;<input class="btn btn-xs btn-warning" value="更新" onclick="$('#table').val('supplier');doAction('updateSortIndexAll')" type="button"></th>
				<% if (!supplierOptName.equals("waitAudit")) { %>
				<th>优质供应商</th>
				<% } %>
				<th>状态</th>
				<th>操作</th>
			</tr>
			<%
				Vector datas = (Vector) JSPDataBean.getJSPData("datas");
				String[] columns = {"name", "linkMan", "linkPhone"};
				AppUtil.convertToHtml(columns, datas);
				for (int i = 0; i < datas.size(); i++) {
					Hashtable data = (Hashtable) datas.get(i);
			%>
			<tr>
				<td height="28" align="center"><%= data.get("supplierID")%></td>
				<td align="center"><%= data.get("name") %></td>
				<td align="center"><%= data.get("supplierTypeID").equals("1") ? "企业" : data.get("supplierTypeID").equals("2") ? "个人" : "" %></td>
				<td align="center"><%= LocalDataCache.getInstance().getTableDataColumnValue("c_supplierMode", data.get("supplierModeID").toString(), "c_supplierModeName") %></td>
				<% 	if (!supplierOptName.equals("waitAudit")) { %>
				<td align="center">
					<%= LocalDataCache.getInstance().getTableDataColumnValue("c_shopReputation", data.get("reputationID").toString(), "c_shopReputationName") %>
					<% if (data.get("status").equals(AppKeys.SUPPLIER_STATUS_VALID)) { %>
					<br><a href="javascript:document.getElementById('supplierID').value='<%=data.get("supplierID")%>';openInfoWindow('userStore','shopReputationWindow')">修改</a>
					<% } %>
				</td>
				<td align="center">
					<%= LocalDataCache.getInstance().getTableDataColumnsValue("c_supplierTag", data.get("supplierTagIDs").toString(), "c_supplierTagName") %>
					<% if (data.get("status").equals(AppKeys.SUPPLIER_STATUS_VALID)) { %>
					<br><a href="javascript:document.getElementById('supplierID').value='<%=data.get("supplierID")%>';openInfoWindow('userStore','supplierTagWindow')">修改</a>
					<% } %>
				</td>
				<td align="center">
					<%= LocalDataCache.getInstance().getTableDataColumnsValue("supplierLevel", data.get("supplierLevelID").toString(), "name") %>
					<% if (data.get("status").equals(AppKeys.SUPPLIER_STATUS_VALID)) { %>
					<br><a href="javascript:document.getElementById('supplierID').value='<%=data.get("supplierID")%>';openInfoWindow('userStore','supplierLevelWindow')">修改</a>
					<% } %>
				</td>
				<%	} %>
				<td align="center"><%= data.get("applyTime") %></td>
				<td align="center"><%= data.get("linkMan") %></td>
				<td align="center"><%= data.get("linkPhone") %></td>
				<% if (!JSPDataBean.getFormData("supplierOptName").equals("waitAudit")) { %>
				<td align="center"><%= data.get("totalScoreAvg") %></td>
				<% } %>
				<td>
					<input id="sortIndex_<%= data.get("supplierID") %>" name="sortIndex_<%= data.get("supplierID") %>" value="<%= data.get("sortIndex") %>" size="5" maxlength="11" type="text">
				</td>
				<% if (!JSPDataBean.getFormData("supplierOptName").equals("waitAudit")) { %>
				<td>
					<% if (data.get("excellentFlag").equals("1")) { %>
					<a href="javascript:document.getElementById('supplierID').value='<%= data.get("supplierID") %>';postModuleAndAction('userStore','disableExcellentFlag')">
					<% } else { %>
					<a href="javascript:document.getElementById('supplierID').value='<%= data.get("supplierID") %>';postModuleAndAction('userStore','enableExcellentFlag')">
					<% } %>
					<img src="/images/<%= data.get("excellentFlag").equals("1") ? "yes" : "no"%>.gif" width="15px" border="none"/>
					</a>
				</td>
				<% } %>
				<td align="center"><%= LocalDataCache.getInstance().getTableDataColumnValue("c_supplierStatus", data.get("status").toString(), "c_supplierStatusName") %></td>
				<td align="center">
					<a href="javascript:document.getElementById('supplierID').value='<%=data.get("supplierID")%>';postModuleAndAction('userStore','detailView')">详细</a>
				<% if (data.get("status").equals(AppKeys.SUPPLIER_STATUS_WAIT_AUDIT)) { %>
					<a href="javascript:document.getElementById('supplierID').value='<%=data.get("supplierID")%>';openInfoWindow('userStore','auditSupplierWindow')">审核</a>
				<% } else if (data.get("status").equals(AppKeys.SUPPLIER_STATUS_VALID)) { %>
					<a href="javascript:if(confirm('冻结后的店铺的商品将不再前台网站显示，是否确定')){document.getElementById('supplierID').value='<%=data.get("supplierID")%>';postModuleAndAction('userStore','close')}">冻结</a>
				<% } else if (data.get("status").equals(AppKeys.SUPPLIER_STATUS_UNVALID)) { %>
					<a href="javascript:document.getElementById('supplierID').value='<%=data.get("supplierID")%>';postModuleAndAction('userStore','open')">解除冻结</a>
				<% } %>
				</td>
			</tr>
			<%	} %>
		</table>
		<div class="page blue">
		    <p class="floatl"><%@include file="common/commonJumpPage.jsp" %></p>
		    <div class="clear"></div>
		</div>
	</div>
	
	<% } else if (JSPDataBean.getFormData("action").equals("detailView")) { 
		String[] columns = {"name", "nick", "address"};
		AppUtil.convertToHtml(columns, JSPDataBean.getFormDatas());
	%>
		<div class="order_detail_box" >
			<table class="order_detail" cellpadding="0" cellspacing="1" width="100%">
				<tr class="order_detail_title"><td colspan="4">基本信息</td></tr>
				<tr>
					<td class="leftbg" width="15%">店铺</td>
					<td width="35%"><%= JSPDataBean.getFormData("name") %></td>
					<td class="leftbg" width="15%">店铺状态</td>
					<td style="color: red"><%= LocalDataCache.getInstance().getTableDataColumnValue("c_supplierStatus", JSPDataBean.getFormData("status"), "c_supplierStatusName") %></td>	
				</tr>
				<tr>
					<td class="leftbg" width="15%">店铺类型</td>
					<td width="35%"><%= JSPDataBean.getFormData("supplierTypeID").equals("1") ? "企业" : JSPDataBean.getFormData("supplierTypeID").equals("2") ? "个人" : "" %></td>
					<td class="leftbg" width="15%">经营模式</td>
					<td><%= LocalDataCache.getInstance().getTableDataColumnValue("c_supplierMode", JSPDataBean.getFormData("supplierModeID"), "c_supplierModeName") %></td>	
				</tr>
				<tr>
					<td class="leftbg" width="15%">主营行业</td>
					<td width="35%"><%= LocalDataCache.getInstance().getTableDataColumnValue("c_companyIndustry", JSPDataBean.getFormData("industryID"), "c_companyIndustryName") %></td>
					<td class="leftbg" width="15%">主营产品</td>
					<td><%= LocalDataCache.getInstance().getTableDataColumnsValue("supplierMainProduct", JSPDataBean.getFormData("supplierMainProductIDs"), "name") %></td>	
				</tr>
				<tr>
					<td class="leftbg" width="15%">店铺等级</td>
					<td><%= LocalDataCache.getInstance().getTableDataColumnValue("supplierLevel", JSPDataBean.getFormData("supplierLevelID"), "name") %></td>	
					<td class="leftbg" width="15%">Logo</td>
					<td width="35%"><img src="<%= AppUtil.getImageURL("supplier", JSPDataBean.getFormData("logo"), 0) %>" style="height: 150px;width: 200px" /></td>
				</tr>
				<tr>
					<td class="leftbg" width="15%">订单提醒手机号</td>
					<td width="35%"><%= JSPDataBean.getFormData("notifyMobile") %></td>
					<td class="leftbg" width="15%">申请时间</td>
					<td><%= JSPDataBean.getFormData("applyTime") %></td>	
				</tr>
				<tr>
					<td class="leftbg" width="15%">联系人</td>
					<td width="35%"><%= JSPDataBean.getFormData("linkMan") %></td>
					<td class="leftbg" width="15%">联系电话</td>
					<td><%= JSPDataBean.getFormData("linkPhone") %></td>	
				</tr>
				<tr>
					<td class="leftbg">联系邮箱</td>
					<td><%= JSPDataBean.getFormData("linkEmail") %></td>
					<td class="leftbg">邮编</td>
					<td><%= JSPDataBean.getFormData("postalCode") %></td>
				</tr>	
				<tr>
					<td class="leftbg">经营地址</td>
					<% Hashtable area = AppUtil.getArea(JSPDataBean.getFormData("townID")); %>
					<td colspan="3"><%= area.get("provinceName") + "&nbsp;" + area.get("cityName") + "&nbsp;" + area.get("townName") + "&nbsp;" + JSPDataBean.getFormData("address") %></td>
				</tr>	
				<tr>
					<td class="leftbg">店铺介绍</td>
					<td colspan="3"><%= JSPDataBean.getFormData("info") %></td>
				</tr>
				<% if (!JSPDataBean.getFormData("supplierOptName").equals("waitAudit")) { %>
				<tr class="order_detail_title"><td colspan="4">店铺金额</td></tr>
				<tr>
					<td class="leftbg">锁定金额</td>
					<td class="leftbg"><%= JSPDataBean.getFormData("lockAmount") %></td>
					<td class="leftbg">可提现金额</td>
					<td class="leftbg"><%= JSPDataBean.getFormData("canCashAmount") %></td>
				</tr>	
				<tr>
					<td class="leftbg">提现中的金额</td>
					<td class="leftbg"><%= JSPDataBean.getFormData("cashingAmount") %></td>
					<td class="leftbg">已提现金额</td>
					<td class="leftbg"><%= JSPDataBean.getFormData("hasCashAmount") %></td>
				</tr>
				<tr class="order_detail_title"><td colspan="4">店铺评分</td></tr>
				<tr>
					<td class="leftbg">店铺评分</td>
					<td class="leftbg"><%= JSPDataBean.getFormData("totalScoreAvg") %></td>
					<td class="leftbg">商品评分</td>
					<td class="leftbg"><%= JSPDataBean.getFormData("commentScoreAvg") %></td>
				</tr>	
				<tr>
					<td class="leftbg">卖家服务评分</td>
					<td class="leftbg"><%= JSPDataBean.getFormData("serviceScoreAvg") %></td>
					<td class="leftbg">发货速度评分</td>
					<td class="leftbg"><%= JSPDataBean.getFormData("deliveryScoreAvg") %></td>
				</tr>
				<% } %>		
				<tr class="order_detail_title"><td colspan="4">公司信息</td></tr>
				<tr>
					<td class="leftbg">公司简称</td>
					<td><%= JSPDataBean.getFormData("shortName") %></td>
					<td class="leftbg">公司全称</td>
					<td><%= JSPDataBean.getFormData("fullName") %></td>
				</tr>	
				<tr>
					<td class="leftbg">公司注册地</td>
					<% Hashtable area2 = AppUtil.getArea(JSPDataBean.getFormData("registerTownID")); %>
					<td colspan="3"><%= area2.get("provinceName") + "&nbsp;" + area2.get("cityName") + "&nbsp;" + area2.get("townName") + "&nbsp;" + JSPDataBean.getFormData("detailAddress") %></td>
				</tr>	
				<tr>
					<td class="leftbg">运营者姓名</td>
					<td><%= JSPDataBean.getFormData("operatorName") %></td>
					<td class="leftbg">联系电话</td>
					<td><%= JSPDataBean.getFormData("companyPhone") %></td>
				</tr>
				<% if (JSPDataBean.getFormData("supplierTypeID").equals("1")) { %>
				<tr>
					<td class="leftbg" width="15%">营业执照</td>
					<td width="35%">
						<a href="<%= AppUtil.getImageURL("supplier", JSPDataBean.getFormData("businessLicenseImage"), 0) %>" target="_blank">
							<img src="<%= AppUtil.getImageURL("supplier", JSPDataBean.getFormData("businessLicenseImage"), 0) %>" style="height: 150px;width: 200px" />
						</a><br/>(点击图片查看原图)
					</td>
					<td class="leftbg" width="15%">税务登记证：</td>
					<td>
						<a href="<%= AppUtil.getImageURL("supplier", JSPDataBean.getFormData("taxRegistCertificateImage"), 0) %>" target="_blank">
							<img src="<%= AppUtil.getImageURL("supplier", JSPDataBean.getFormData("taxRegistCertificateImage"), 0) %>" style="height: 150px;width: 200px" />
						</a><br/>(点击图片查看原图)
					</td>	
			    </tr>
				<tr>
					<td class="leftbg">组织机构代码或者统一社会信用代码证：</td>
					<td><%= JSPDataBean.getFormData("OrganSCreditCode") %></td>
					<td class="leftbg" width="15%">一般纳税人证明：</td>
					<td>
						<a href="<%= AppUtil.getImageURL("supplier", JSPDataBean.getFormData("taxPayerProofImage"), 0) %>" target="_blank">
							<img src="<%= AppUtil.getImageURL("supplier", JSPDataBean.getFormData("taxPayerProofImage"), 0) %>" style="height: 150px;width: 200px" />
						</a><br/>(点击图片查看原图)
					</td>	
			    </tr>
				<tr>
					<td class="leftbg">渠道类型：</td>
					<td><%= JSPDataBean.getFormData("channelType").equals("1") ? "商标注册" : (JSPDataBean.getFormData("channelType").equals("2") ? "品牌授权" : (JSPDataBean.getFormData("channelType").equals("3") ? "渠道" : "")) %></td>
					<td class="leftbg" width="15%">授权文件影印件：</td>
					<td>
						<a href="<%= AppUtil.getImageURL("supplier", JSPDataBean.getFormData("photoCopyAuthorDocImage"), 0) %>" target="_blank">
							<img src="<%= AppUtil.getImageURL("supplier", JSPDataBean.getFormData("photoCopyAuthorDocImage"), 0) %>" style="height: 150px;width: 200px" />
						</a><br/>(点击图片查看原图)
					</td>	
			    </tr>
				<tr>
					<td class="leftbg" width="15%">授权文件复印件：</td>
					<td>
						<a href="<%= AppUtil.getImageURL("supplier", JSPDataBean.getFormData("copyAuthorDocImage"), 0) %>" target="_blank">
							<img src="<%= AppUtil.getImageURL("supplier", JSPDataBean.getFormData("copyAuthorDocImage"), 0) %>" style="height: 150px;width: 200px" />
						</a><br/>(点击图片查看原图)
					</td>	
					<td class="leftbg"></td>
					<td></td>
			    </tr>
				<% } else if (JSPDataBean.getFormData("supplierTypeID").equals("2")) { %>
				<tr>
					<td class="leftbg" width="15%">身份证正面照</td>
					<td width="35%">
						<a href="<%= AppUtil.getImageURL("supplier", JSPDataBean.getFormData("idCardImage1"), 0) %>" target="_blank">
							<img src="<%= AppUtil.getImageURL("supplier", JSPDataBean.getFormData("idCardImage1"), 0) %>" style="height: 150px;width: 200px" />
						</a><br/>(点击图片查看原图)
					</td>
					<td class="leftbg" width="15%">身份证反面照</td>
					<td>
						<a href="<%= AppUtil.getImageURL("supplier", JSPDataBean.getFormData("idCardImage2"), 0) %>" target="_blank">
							<img src="<%= AppUtil.getImageURL("supplier", JSPDataBean.getFormData("idCardImage2"), 0) %>" style="height: 150px;width: 200px" />
						</a><br/>(点击图片查看原图)
					</td>
				</tr>
				<% } %>
			  	<% if (JSPDataBean.getFormData("status").equals(AppKeys.SUPPLIER_STATUS_AUDIT_NOTPASS)) { %>
				<tr>
					<td class="leftbg">审核时间</td>
					<td><%= JSPDataBean.getFormData("auditTime") %></td>
					<td class="leftbg">审核备注</td>
					<td><%= JSPDataBean.getFormData("auditNote") %></td>
			  	</tr>	
			  	<% } %>
					
			</table>
		</div>
		
		<div align="center">
			<div class="button">
				<a onclick="javascript:postModuleAndAction('userStore','defaultView')" class="btn_bb1"><span>返 回</span></a>
			</div>
		</div>
		<% } %>	
	</div>

	<input type="hidden" id="supplierID" name="supplierID" value="<%= JSPDataBean.getFormData("supplierID") %>" />
	
	<input type="hidden" id="supplierOptName" name="supplierOptName" value="<%= JSPDataBean.getFormData("supplierOptName")%>" />
	<input type="hidden" id="idCardImg" name="idCardImg" value="" />
</div>

<%@include file="common/commonFooter.jsp" %>