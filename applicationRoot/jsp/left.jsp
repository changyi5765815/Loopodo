<%@ page contentType="text/html;charset=UTF-8"%>
<jsp:directive.page import="java.util.Vector"/>
<jsp:directive.page import="java.util.Hashtable"/>
<jsp:directive.page import="simpleWebFrame.config.AppConfig"/>
<jsp:directive.page import="simpleWebFrame.web.FrameKeys"/>
<%@page import="admin.customer.guanwangbao.AppKeys"%>

<jsp:useBean id="JSPDataBean" scope='request' class="simpleWebFrame.web.JSPDataBean" />

<%@include file="common/commonHeader.jsp" %>

<%
	Hashtable loginSystemUser = ((Hashtable)request.getSession().getAttribute(FrameKeys.LOGIN_USER));
	String systemPriority = "," + loginSystemUser.get("priority").toString() + ",";
%>

<div class="menu">
<ul class="nav">
	
	<li>
		<span><a href="javascript:void(0);" onclick="DoMenu('ChildMenu1')"><span class="m01">基础设置</span></a></span>
		<ul id="ChildMenu1" class="collapsed">
		<% if (systemPriority.indexOf(",city,") != -1) { %>
			<li><a href="javascript:postModuleAndActionToTarget('city', 'defaultView', 'rightFrame')">地域设置</a></li>
		<% } %>
		<% if (systemPriority.indexOf(",payType,") != -1) { %>
			<li><a href="javascript:postModuleAndActionToTarget('payType', 'defaultView', 'rightFrame')">付款方式设置</a></li>
		<% } %>
		<% if (systemPriority.indexOf(",deliveryFee,") != -1) { %>
			<li><a href="javascript:postModuleAndActionToTarget('deliveryType', 'defaultView', 'rightFrame')">物流方式设置</a></li>
		<% } %>
		<%--
		<% if (systemPriority.indexOf(",deliveryType,") != -1) { %>
			<li><a href="javascript:postModuleAndActionToTarget('deliveryFee', 'defaultView', 'rightFrame')">运费设置</a></li>
		<% } %>
		 --%>
		<% if (systemPriority.indexOf(",keyword,") != -1) { %>
			<li><a href="javascript:postModuleAndActionToTarget('keyword', 'defaultView', 'rightFrame')">搜索关键字</a></li>
		<% } %>
		<% if (systemPriority.indexOf(",friendshipLink,") != -1) { %>
			<li><a href="javascript:postModuleAndActionToTarget('friendshipLink', 'defaultView', 'rightFrame')">友情链接</a></li>
		<% } %>
		<% if (systemPriority.indexOf(",suppliermainproduct,") != -1) { %>
			<li><a href="javascript:postModuleAndActionToTarget('companyIndustry', 'defaultView', 'rightFrame')">主营行业</a></li>
		<% } %>	
		<% if (systemPriority.indexOf(",supplierLevel,") != -1) { %>
			<li><a href="javascript:postModuleAndActionToTarget('supplierLevel', 'defaultView', 'rightFrame')">店铺等级</a></li>
		<% } %>		
		<% if (systemPriority.indexOf(",shopReputation,") != -1) { %>
			<li><a href="javascript:postModuleAndActionToTarget('shopReputation', 'defaultView', 'rightFrame')">店铺信誉管理</a></li>
		<% } %>		
		<% if (systemPriority.indexOf(",supplierTheme,") != -1) { %>
			<li><a href="javascript:postModuleAndActionToTarget('supplierTheme', 'defaultView', 'rightFrame')">商户首页模板管理</a></li>
		<% } %>		
		<%	if (systemPriority.indexOf(",appInfo,") != -1) { %>
			<li><a href="javascript:postModuleAndActionToTarget('appInfo', 'defaultView', 'rightFrame')">APP管理</a></li>
		<%	} %>
		</ul>
	</li>
	
	<li>
		<span><a href="javascript:void(0);" onclick="DoMenu('ChildMenu18')"><span class="m02">内容管理</span></a></span>
		<ul id="ChildMenu18" class="collapsed">
		<% if (systemPriority.indexOf(",banner,") != -1) { %>
			<li><a href="javascript:postModuleAndActionToTarget('banner', 'defaultView', 'rightFrame')">广告图管理</a></li>
		<% } %>
		<%-- 
		<% if (systemPriority.indexOf(",normalSinglePage,") != -1) { %>
			<li><a href="javascript:postModuleAndActionToTarget('singlePage', 'defaultView', 'rightFrame')">普通单页</a></li>
		<% } %>
		<% if (systemPriority.indexOf(",communityPlate,") != -1) { %>
			<li><a href="javascript:postModuleAndActionToTarget('infoType', 'defaultView', 'rightFrame');">文章分类</a></li>
		<% } %>
		<% if (systemPriority.indexOf(",article,") != -1) { %>
			<li><a href="javascript:postModuleAndActionToTarget('info', 'defaultView', 'rightFrame');">文章管理</a></li>
		<% } %>
		<% if (systemPriority.indexOf(",articleArea,") != -1) { %>
			<li><a href="javascript:postModuleAndActionToTarget('infoCollection', 'defaultView', 'rightFrame');">文章专区管理</a></li>
		<% } %>
		--%>
		<% if (systemPriority.indexOf(",helpPageType,") != -1) { %>
			<li><a href="javascript:postModuleAndActionToTarget('helpPageType', 'defaultView', 'rightFrame')">帮助页分组</a></li>
		<% } %>
		<% if (systemPriority.indexOf(",helpPage,") != -1) { %>
			<li><a href="javascript:postModuleAndActionToTarget('helpPage', 'defaultView', 'rightFrame')">帮助页管理</a></li>
		<% } %>
		</ul>
	</li>
	<li>
		<span><a href="javascript:void(0);" onclick="DoMenu('ChildMenu6')"><span class="m03">商品管理</span></a></span>
		<ul id="ChildMenu6" class="collapsed">
		<% if (systemPriority.indexOf(",productType,") != -1) { %>
			<li><a href="javascript:postModuleAndActionToTarget('type', 'defaultView', 'rightFrame')">商品分类管理</a></li>
		<% } %>
		<% if (systemPriority.indexOf(",brandType,") != -1) { %>
			<li><a href="javascript:postModuleAndActionToTarget('brandType', 'defaultView', 'rightFrame')">品牌分类管理</a></li>
		<% } %>
		<% if (systemPriority.indexOf(",brand,") != -1) { %>
			<li><a href="javascript:postModuleAndActionToTarget('brand', 'defaultView', 'rightFrame')">品牌管理</a></li>
		<% } %>
		<% if (systemPriority.indexOf(",brand,") != -1) { %>
			<li><a href="javascript:postModuleAndActionToTarget('productLevel', 'defaultView', 'rightFrame')">质量星级管理</a></li>
		<% } %>
		<% if (systemPriority.indexOf(",productProp,") != -1) { %>
			<li><a href="javascript:postModuleAndActionToTarget('properties', 'defaultView', 'rightFrame')">商品属性管理</a></li>
		<% } %>
		<% if (systemPriority.indexOf(",skuProp,") != -1) { %>
			<li><a href="javascript:postModuleAndActionToTarget('skuProp', 'defaultView', 'rightFrame')">销售属性值管理</a></li>
		<% } %>
		<%-- 
		<% if (systemPriority.indexOf(",product,") != -1) { %>
			<li><a href="javascript:$('#product_opt').val('waitAudit');postModuleAndActionToTarget('product', 'defaultView', 'rightFrame')">商品审核</a></li>
		<% } %>
		<% if (systemPriority.indexOf(",product,") != -1) { %>
			<li><a href="javascript:$('#product_opt').val('hasAudit');postModuleAndActionToTarget('product', 'defaultView', 'rightFrame')">已审核商品</a></li>
		<% } %>
		--%>
		<% if (systemPriority.indexOf(",product,") != -1) { %>
			<li><a href="javascript:$('#product_opt').val('');postModuleAndActionToTarget('product', 'defaultView', 'rightFrame')">商品管理</a></li>
		<% } %>
		<% if (systemPriority.indexOf(",collection,") != -1) { %>
			<li><a href="javascript:postModuleAndActionToTarget('collection', 'defaultView', 'rightFrame')">商品专区管理</a></li>
		<% } %>
		<%-- 
		<% if (systemPriority.indexOf(",supplier,") != -1) { %>
			<li><a href="javascript:postModuleAndActionToTarget('supplier', 'defaultView', 'rightFrame')">供应商管理</a></li>
		<% } %>
		--%>
		</ul>
	</li>
	
	<li>
		<span><a href="javascript:void(0);" onclick="DoMenu('ChildMenu13')"><span class="m04">订单管理</span></a></span>
		<ul id="ChildMenu13" class="collapsed">
		<% if (systemPriority.indexOf(",allShopOrder,") != -1) { %>
		<li><a href="javascript:document.getElementById('operationName').value='';postModuleAndActionToTarget('order', 'defaultView', 'rightFrame')">全部订单</a></li>
		<% } %>
		<% if (systemPriority.indexOf(",dfkShopOrder,") != -1) { %>
		<li><a href="javascript:document.getElementById('operationName').value='zhiWeiYiFuKuan';postModuleAndActionToTarget('order', 'defaultView', 'rightFrame')">待付款</a></li>
		<% } %> 
		<% if (systemPriority.indexOf(",dshShopOrder,") != -1) { %>
		<li><a href="javascript:document.getElementById('operationName').value='daiShenHe';postModuleAndActionToTarget('order', 'defaultView', 'rightFrame')">待审核</a></li>
		<% } %>
		
		<% if (systemPriority.indexOf(",dphShopOrder,") != -1) { %>
		<li><a href="javascript:document.getElementById('operationName').value='daiPeiHuo';postModuleAndActionToTarget('order', 'defaultView', 'rightFrame')">待配货</a></li>
		<% } %>
		<% if (systemPriority.indexOf(",dfhShopOrder,") != -1) { %>
		<li><a href="javascript:document.getElementById('operationName').value='faHuoWanCheng';postModuleAndActionToTarget('order', 'defaultView', 'rightFrame')">待发货</a></li>
		<% } %>
		 <% if (systemPriority.indexOf(",fhzShopOrder,") != -1) { %>
		<li><a href="javascript:document.getElementById('operationName').value='queRenShouHuo';postModuleAndActionToTarget('order', 'defaultView', 'rightFrame')">发货中</a></li>
		<% } %>
		 <% if (systemPriority.indexOf(",ywcShopOrder,") != -1) { %>
		<li><a href="javascript:document.getElementById('operationName').value='jiaoYiWanCheng';postModuleAndActionToTarget('order', 'defaultView', 'rightFrame')">已完成</a></li>
		<% } %>
		 <% if (systemPriority.indexOf(",ygbShopOrder,") != -1) { %>
		<li><a href="javascript:document.getElementById('operationName').value='jiaoYiGuanBi';postModuleAndActionToTarget('order', 'defaultView', 'rightFrame')">已关闭</a></li>
		<% } %>
		<% if (systemPriority.indexOf(",dztShopOrder,") != -1) { %>
		<li><a href="javascript:document.getElementById('operationName').value='daiZiTi';postModuleAndActionToTarget('order', 'defaultView', 'rightFrame')">待自提</a></li>
		<% } %>

	
		
		
		<% if (systemPriority.indexOf(",ycShopOrder,") != -1) { %>
		<li><a href="javascript:document.getElementById('operationName').value='yiChangDingDan';postModuleAndActionToTarget('order', 'defaultView', 'rightFrame')">异常订单</a></li>
		<% } %>
		<% if (systemPriority.indexOf(",transaction,") != -1) { %>
		<li><a href="javascript:postModuleAndActionToTarget('transaction', 'defaultView', 'rightFrame')">付款记录</a></li>
		<% } %>
		<% if (systemPriority.indexOf(",refund,") != -1) { %>
		<li><a href="javascript:postModuleAndActionToTarget('refund', 'defaultView', 'rightFrame')">退款管理</a></li>
		<% } %>
		<% if (systemPriority.indexOf(",returnGoods,") != -1) { %>
		<li><a href="javascript:postModuleAndActionToTarget('returnGoods', 'defaultView', 'rightFrame')">退货管理</a></li>
		<% } %>
		</ul>

	</li>
	
	<li>
		<span><a href="javascript:void(0);" onclick="DoMenu('ChildMenu16')"><span class="m05">促销管理</span></a></span>
		<ul id="ChildMenu16" class="collapsed">
		<% if (systemPriority.indexOf(",promotionActive,") != -1) { %>
			<li><a href="javascript:postModuleAndActionToTarget('promotionActive', 'defaultView', 'rightFrame')">全站促销</a></li>
		<% } %>
		<% if (systemPriority.indexOf(",discount,") != -1) { %>
			<li><a href="javascript:postModuleAndActionToTarget('groupBuy', 'discountLogView', 'rightFrame')">折扣特价</a></li>
		<% } %>
		<% if (systemPriority.indexOf(",groupBuy,") != -1) { %>
			<li><a href="javascript:postModuleAndActionToTarget('groupBuy', 'defaultView', 'rightFrame')">团购秒杀</a></li>
		<% } %>
		</ul>
	</li>
	
	<li>
		<span><a href="javascript:void(0);" onclick="DoMenu('ChildMenu8')"><span class="m06">会员管理</span></a></span>
		<ul id="ChildMenu8" class="collapsed">
		<% if (systemPriority.indexOf(",user,") != -1) { %>
			<li><a href="javascript:postModuleAndActionToTarget('user', 'defaultView', 'rightFrame')">会员管理</a></li>
		<% } %>
		<% if (systemPriority.indexOf(",groupCompany,") != -1) { %>
		<li><a href="javascript:postModuleAndActionToTarget('groupCompany', 'defaultView', 'rightFrame')">集团客户管理</a></li>
		<% } %>
		<% if (systemPriority.indexOf(",famousCompany,") != -1) { %>
		<li><a href="javascript:postModuleAndActionToTarget('famousCompany', 'defaultView', 'rightFrame')">名企管理</a></li>
		<% } %>
		<%-- if (systemPriority.indexOf(",userDiscountRate,") != -1) { %>
			<li><a href="javascript:postModuleAndActionToTarget('userDiscountRate', 'defaultView', 'rightFrame')">会员折扣率设置</a></li>
		<% } --%>
		</ul>
	</li>
		
	<li>
		<span><a href="javascript:void(0);" onclick="DoMenu('ChildMenu8_1')"><span class="m06">社区管理</span></a></span>
		<ul id="ChildMenu8_1" class="collapsed">
		<% if (systemPriority.indexOf(",infoType,") != -1) { %>
			<li><a href="javascript:postModuleAndActionToTarget('infoType', 'defaultView', 'rightFrame')">分类管理</a></li>
		<% } %>
		<% if (systemPriority.indexOf(",info,") != -1) { %>
			<li><a href="javascript:$('#operationName').val('0');postModuleAndActionToTarget('info', 'defaultView', 'rightFrame')">文章管理</a></li>
		<% } %>
		<% if (systemPriority.indexOf(",info2,") != -1) { %>
			<li><a href="javascript:$('#operationName').val('1');postModuleAndActionToTarget('info', 'defaultView', 'rightFrame')">商户文章管理</a></li>
		<% } %>
		</ul>
	</li>
	
	<li>
		<span><a href="javascript:void(0);" onclick="DoMenu('ChildMenu22')"><span class="m06">店铺管理</span></a></span>
		<ul id="ChildMenu22" class="collapsed">
		<% if (systemPriority.indexOf(",supplierAudit,") != -1) { %>
			<li><a href="javascript:$('#supplierOptName').val('waitAudit');postModuleAndActionToTarget('userStore', 'defaultView', 'rightFrame')">店铺审核</a></li>
		<% } %>
		<% if (systemPriority.indexOf(",supplierManager,") != -1) { %>
			<li><a href="javascript:$('#supplierOptName').val('');postModuleAndActionToTarget('userStore', 'defaultView', 'rightFrame')">店铺管理</a></li>
		<% } %>
		<% if (systemPriority.indexOf(",supplierCash,") != -1) { %>
			<li><a href="javascript:postModuleAndActionToTarget('supplierCash', 'defaultView', 'rightFrame')">店铺提现</a></li>
		<% } %>
		</ul>
	</li>

	
	<li>
		<span><a href="javascript:void(0);" onclick="DoMenu('ChildMenu7')"><span class="m11">统计管理</span></a></span>
		<ul id="ChildMenu7" class="collapsed">
		<% if (systemPriority.indexOf(",userRegisterReport,") != -1) { %>
			<li><a href="javascript:postModuleAndActionToTarget('userRegisterReport', 'defaultView', 'rightFrame');">会员注册统计</a></li>
		<% } %>
		<% if (systemPriority.indexOf(",shopUserReport,") != -1) { %>
			<li><a href="javascript:postModuleAndActionToTarget('shopUser', 'defaultView', 'rightFrame');">会员统计</a></li>
		<% } %>
		<% if (systemPriority.indexOf(",orderReport,") != -1) { %>
			<li><a href="javascript:postModuleAndActionToTarget('orderReport', 'defaultView', 'rightFrame');">订单统计</a></li>
		<% } %>
		<% if (systemPriority.indexOf(",supplierAmountReport,") != -1) { %>
			<li><a href="javascript:postModuleAndActionToTarget('supplierAmountReport', 'defaultView', 'rightFrame');">商户交易统计</a></li>
		<% } %>
		</ul>
	</li>
	
	<%--
	<li>
		<span><a href="javascript:void(0);" onclick="DoMenu('ChildMenu20')"><span class="m07">库存管理</span></a></span>
		<ul id="ChildMenu20" class="collapsed">
		<% if (systemPriority.indexOf(",stockMaintenance,") != -1) { %>
			<li><a href="javascript:postModuleAndActionToTarget('stockManager', 'defaultView', 'rightFrame');">库存维护</a></li>
		<% } %>
		<% if (systemPriority.indexOf(",storage,") != -1) { %>
			<li><a href="javascript:postModuleAndActionToTarget('stockInBill', 'defaultView', 'rightFrame');">入库管理</a></li>
		<% } %>
		<% if (systemPriority.indexOf(",stockOut,") != -1) { %>
			<li><a href="javascript:postModuleAndActionToTarget('stockOutBill', 'defaultView', 'rightFrame');">出库管理</a></li>
		<% } %>
		</ul>
	</li>
	 --%>
	 
	<li>
		<span><a href="javascript:void(0);" onclick="DoMenu('ChildMenu19')"><span class="m08">客服管理</span></a></span>
		<ul id="ChildMenu19" class="collapsed">
		<% if (systemPriority.indexOf(",productComment,") != -1) { %>
			<li><a href="javascript:postModuleAndActionToTarget('comment', 'defaultView', 'rightFrame');">商品评论管理</a></li>
		<% } %>
		<% if (systemPriority.indexOf(",productInformation,") != -1) { %>
			<li><a href="javascript:document.getElementById('q_consultationTypeID').value='1';postModuleAndActionToTarget('consultation', 'defaultView', 'rightFrame');">商品咨询管理</a></li>
		<% } %>
		<% if (systemPriority.indexOf(",productInformation2,") != -1) { %>
			<li><a href="javascript:document.getElementById('q_consultationTypeID').value='2';postModuleAndActionToTarget('consultation', 'defaultView', 'rightFrame');">商品投诉管理</a></li>
		<% } %>
		<% if (systemPriority.indexOf(",purchaseManager,") != -1) { %>
			<li><a href="javascript:postModuleAndActionToTarget('purchaseManager', 'defaultView', 'rightFrame');">供需管理</a></li>
		<% } %>
		<% if (systemPriority.indexOf(",question,") != -1) { %>
			<li><a href="javascript:postModuleAndActionToTarget('questionFeedBack', 'defaultView', 'rightFrame');">意见反馈</a></li>
		<% } %>
		<% if (systemPriority.indexOf(",infoComment,") != -1) { %>
			<li><a href="javascript:postModuleAndActionToTarget('infoComment', 'defaultView', 'rightFrame');">文章评论</a></li>
		<% } %>
		</ul>
	</li>
	<%-- 
	<li>
		<span><a href="javascript:void(0);" onclick="DoMenu('ChildMenu21')"><span class="m09">微信公众号</span></a></span>
		<ul id="ChildMenu21" class="collapsed">
		<% if (systemPriority.indexOf(",wechatIntegrate,") != -1) { %>
			<li><a href="javascript:postModuleAndActionToTarget('weixinConfig', 'defaultView', 'rightFrame')">微信公众号集成账号</a></li>
		<% } %>
		<% if (systemPriority.indexOf(",wechatMenu,") != -1) { %>
			<li><a href="javascript:postModuleAndActionToTarget('weixinMenu', 'defaultView', 'rightFrame')">微信公众号菜单</a></li>
		<% } %>		
		</ul>
	</li>
	--%>
	
	<li>
		<span><a href="javascript:void(0);" onclick="DoMenu('ChildMenu9')"><span class="m10">系统设置</span></a></span>
		<ul id="ChildMenu9" class="collapsed">
		<% if (systemPriority.indexOf(",systemRole,") != -1) { %>
			<li><a href="javascript:postModuleAndActionToTarget('systemRole', 'defaultView', 'rightFrame')">系统角色管理</a></li>
		<% } %>
		<% if (systemPriority.indexOf(",systemUser,") != -1) { %>
			<li><a href="javascript:postModuleAndActionToTarget('systemUser', 'defaultView', 'rightFrame')">系统用户管理</a></li>
		<% } %>		
		<% if (systemPriority.indexOf(",password,") != -1) { %>
			<li><a href="javascript:postModuleAndActionToTarget('password', 'defaultView', 'rightFrame');" >密码修改</a></li>
		<% } %>		
		<% if (systemPriority.indexOf(",systemConf,") != -1) { %>
			<li><a href="javascript:postModuleAndActionToTarget('sysConfig', 'defaultView', 'rightFrame');" >系统参数</a></li>
		<% } %>
		<% if (systemPriority.indexOf(",systemUserLog,") != -1) { %>
			<li><a href="javascript:postModuleAndActionToTarget('systemUserLog', 'defaultView', 'rightFrame');" >系统操作日志</a></li>
		<% } %>
		<% if (systemPriority.indexOf(",reloadCache,") != -1) { %>
			<li><a href="javascript:if(confirm('是否要进行重启缓存？')) {postModuleAndActionToTarget('recache', 'reloadCache', 'rightFrame');}" >重启缓存</a></li>
		<% } %>
		</ul>
	</li>	
</ul>
</div>
<input type="hidden" name="recacheSystemUserID" id="recacheSystemUserID" value="<%= ((Hashtable) request.getSession().getAttribute(FrameKeys.LOGIN_USER)).get("systemUserID") %>"/>
<input type="hidden" name="recachePassword" id="recachePassword" value="<%= ((Hashtable) request.getSession().getAttribute(FrameKeys.LOGIN_USER)).get("password") %>"/>

<input type="hidden" name="operationName" id="operationName" value=""/>
<input type="hidden" name="supplierOptName" id="supplierOptName" value=""/>
<input type="hidden" name="bigTypeID" id="bigTypeID" value="999"/>
<input type="hidden" name="product_opt" id="product_opt" value=""/>
<input type="hidden" name="q_consultationTypeID" id="q_consultationTypeID" value=""/>


<script type="text/javascript">
// setInterval("timerFunction();", 60 * 1000);
function timerFunction() {
	try {
		doAction("getNotices");
	}
    catch (e) {
    }
}

$(".nav>li").each(function(){
	var $Li=$(this).find("li").length;
	if($Li==0){
		$(this).hide();
	}
});

$(".menu").css({"height":$(window).height(),"overflow":"hidden","overflow-y":"auto"});

</script>
<%@include file="common/commonFooter.jsp" %>

