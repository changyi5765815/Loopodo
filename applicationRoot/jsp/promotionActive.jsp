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
	<div class="btn_t left"><a href="javascript:postModuleAndAction('promotionActive','defaultView')"><span><strong>全站促销</strong></span></a></div>
	
</div>

<div class="main clear">
	<div class="clear"></div>
	
	<% if (JSPDataBean.getFormData("action").equals("list")) { %>
    <div class="search">
	  	<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td>
					店	铺：<input type="text" name="q_supplierName" id="q_supplierName" value="<%= JSPDataBean.getFormData("q_supplierName") %>" size="25" maxlength="50" onkeydown="javascript:if(event.keyCode==13) postModuleAndAction('promotionActive', 'search')"/>&nbsp;
				</td>
				<td class="righttd">
					<div><dl>
	               		<dt style="width: 100%;">
	                   		<a class="btn_y" onclick="javascript:postModuleAndAction('promotionActive', 'search')"><span>搜&nbsp;&nbsp;&nbsp;&nbsp;索</span></a>
	                   	</dt>
	              	</dl></div>
				</td>
			</tr>
		</table>
	</div>
	<div>
		<table class="list" border="0" cellpadding="0" cellspacing="1" width="100%" id="tab1">
			<tr>
				<th>ID</th>
				<% if(!JSPDataBean.getFormData("operationName").equals("0")) { %>
				<th>店铺</th>
				<% } %>				
				<th>名称</th>
				<th>促销活动类型</th>
				<th>买满</th>
				<th>送价格</th>
				<th>优惠券启用金额</th>
				<th>优惠券有效期</th>
				<th>状态</th>
			</tr>
			<%
				Vector datas = (Vector) JSPDataBean.getJSPData("datas");
				String[] columns = {"name"};
				AppUtil.convertToHtml(columns, datas);
				for (int i = 0; i < datas.size(); i++) {
					Hashtable data = (Hashtable) datas.get(i);
			%>
			<tr>
				<td><%= data.get("promotionActiveID") %></td>
				<% if(!JSPDataBean.getFormData("operationName").equals("0")) { %>
				<td><%= data.get("supplierName") %></td>
				<% } %>
				<td><%= data.get("name") %></td>
				<td><%= LocalDataCache.getInstance().getTableDataColumnValue("c_promotionActiveType", data.get("promotionActiveTypeID").toString(), "name") %></td>
				<td><%= data.get("value").equals("") ? "" : ("￥" + PriceUtil.formatPrice(data.get("value").toString())) %></td>
				<td><%= data.get("value2").equals("") ? "" : ("￥" + PriceUtil.formatPrice(data.get("value2").toString())) %></td>
				<td><%= data.get("value3").equals("") ? "" : ("￥" + PriceUtil.formatPrice(data.get("value3").toString())) %></td>
				<td><%= data.get("value4").equals("") ? "" : (data.get("value4") + "天") %></td>
				<td>
					<img src="/images/<%= data.get("validFlag").equals("1") ? "yes" : "no"%>.gif" width="15px" border="none"/>
				</td>

			</tr>
			<%	} %>
		</table>
		<div class="page blue">
		    <p class="floatl"><%@include file="common/commonJumpPage.jsp" %></p>
		    <div class="clear"></div>
		</div>
	</div>
	
	<% } else if (JSPDataBean.getFormData("action").equals("addView") || JSPDataBean.getFormData("action").equals("editView") || JSPDataBean.getFormData("action").equals("confirm")) {
		String[] columns = {"name"};
		AppUtil.convertToHtml(columns, JSPDataBean.getFormDatas());
		%>
		<div class="record">
		<%@include file="common/commonEditTitle.jsp" %>
			<table border="0" cellspacing="0" cellpadding="0" width="100%">
				<tr>
					<th><span class="red">* </span>促销活动类型：</th>
					<td>
					<% if (!JSPDataBean.getFormData("promotionActiveID").equals("")) { %>
						<%= LocalDataCache.getInstance().getTableDataColumnValue("c_promotionActiveType", JSPDataBean.getFormData("promotionActiveTypeID"), "name") %>
						<input class="form-control" type="hidden" name="promotionActiveTypeID" id="promotionActiveTypeID" value="<%= JSPDataBean.getFormData("promotionActiveTypeID") %>">
					<% } else {%>
						<%= JSPDataBean.getFormData("promotionActiveTypeSelect") %>
					<% } %>
					</td>
				</tr>
				<tr>
					<th><span class="red">* </span>活动名称：</th>
					<td><input type="text" name="name" id="name" value="<%= JSPDataBean.getFormData("name") %>" maxlength="50"></td>
				</tr>
				</table>
				
				<table id="promotionActivityParas_div" border="0" cellspacing="0" cellpadding="0" width="100%">
					<%@include file="promotionActivity/promotionActivityPara.jsp" %>
				</table>
			
		<div align="center">
			<div class="button">
				<a class="btn_bb1" id="btnSave" onclick="javascript:postModuleAndAction('promotionActive','confirm')"><span>保 存</span></a>
				<a onclick="javascript:postModuleAndAction('promotionActive','defaultView')" class="btn_bb1"><span>返 回</span></a>
			</div>
		</div>
	</div>
	<% } %>
	<%= JSPDataBean.getFormData("queryConditionHtml") %>	

	<input type="hidden" name="promotionActiveID" id="promotionActiveID" value="<%= JSPDataBean.getFormData("promotionActiveID") %>" />
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








