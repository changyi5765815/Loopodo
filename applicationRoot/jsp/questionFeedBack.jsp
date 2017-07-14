<%@ page contentType="text/html;charset=UTF-8"%>
<jsp:directive.page import="java.util.Vector"/>
<jsp:directive.page import="java.util.Hashtable"/>
<%@page import="java.util.Iterator"%>
<%@page import="admin.customer.guanwangbao.AppUtil"%>
<%@page import="admin.customer.guanwangbao.LocalDataCache"%>
<%@page import="simpleWebFrame.util.PriceUtil"%>
<%@page import="simpleWebFrame.util.StringUtil"%>
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
	<div class="<% if (JSPDataBean.getFormData("action").equals("list") || JSPDataBean.getFormData("action").equals("addView") || JSPDataBean.getFormData("action").equals("editView")) { %>btn_t left<% } else { %>btn_t0 left<% } %>"><a href="javascript:postModuleAndAction('questionFeedBack','defaultView')"><span><strong>意见反馈管理</strong></span></a></div>
</div>

<div class="main clear">
	<div class="clear"></div>
	
	<% if (JSPDataBean.getFormData("action").equals("list")) { %>
	<div>
		<table class="list" border="0" cellpadding="0" cellspacing="1" width="100%" id="tab1">
			<tr>
				<th width="10%">ID</th>
				<th width="5%">用户ID</th>
				<th width="15%">类型</th>
				<th width="30%">内容</th>
				<th width="10%">链接</th>
				<th width="15%">创建时间</th>
				<th width="10%">状态</th>
				<th width="*">操作</th>
			</tr>
			<%
				Vector datas = (Vector) JSPDataBean.getJSPData("datas");
				Hashtable<String, Hashtable<String, String>> data3 = (Hashtable<String, Hashtable<String, String>>) JSPDataBean.getJSPData("data");
				for (int i = 0; i < datas.size(); i++) {
					Hashtable data = (Hashtable) datas.get(i);
			%>
			<tr>
				<td><%= data.get("questionFeedBackLogID") %></td>
				<td><%= data.get("userID") %></td>
				<td><%= !data3.containsKey(data.get("questionFeedBackLogTypeID").toString()) ? "" : data3.get(data.get("questionFeedBackLogTypeID").toString()).get("c_questionFeedBackLogTypeName") %></td>
				<td title="<%= StringUtil.convertFromXmlChars(data.get("content").toString()) %>"><%= StringUtil.limitStringLength(StringUtil.convertFromXmlChars(data.get("content").toString()), 200) %></td>
				<td><%= data.get("link") %></td>
				<td><%= data.get("addTime") %></td>
				<td>
					<a href="javascript:document.getElementById('questionFeedBackLogID').value='<%= data.get("questionFeedBackLogID")%>';postModuleAndAction('questionFeedBack','<%= data.get("validFlag").equals("1") ? "disable" : "enable" %>')">
						<img src="/images/<%= data.get("validFlag").equals("1") ? "yes" : "no"%>.gif" width="15px" border="none"/>
					</a>
				</td>
				<td align="center">
					<a href="javascript:document.getElementById('questionFeedBackLogID').value='<%=data.get("questionFeedBackLogID")%>';postModuleAndAction('questionFeedBack', 'editView')">查看</a>
					<a href="javascript:if (confirm('是否删除')){document.getElementById('questionFeedBackLogID').value='<%= data.get("questionFeedBackLogID") %>';postModuleAndAction('questionFeedBack', 'deleteQuestionFeedBackLog')}">删除</a>
				</td>
			</tr>
			<% } %>
		</table>
		<div class="page blue">
		    <p class="floatl"><%@include file="common/commonJumpPage.jsp" %></p>
		    <div class="clear"></div>
		</div>
	</div>
	
	<% } else if (JSPDataBean.getFormData("action").equals("editView")) { 
		String[] columns = {"name", "nick", "address"};
		AppUtil.convertToHtml(columns, JSPDataBean.getFormDatas());
	%>
		<div class="record">
			<%@include file="common/commonEditTitle.jsp" %>
			<table border="0" cellspacing="0" cellpadding="0" width="100%">
				<tr>
				  <th>类型：</th>
				  <td>
				  	<%
			    		Hashtable<String, Hashtable<String, String>> data3 = (Hashtable<String, Hashtable<String, String>>) JSPDataBean.getJSPData("data");
			    	%>
					<%= !data3.containsKey(JSPDataBean.getFormData("questionFeedBackLogTypeID")) ? "" : data3.get(JSPDataBean.getFormData("questionFeedBackLogTypeID")).get("c_questionFeedBackLogTypeName") %>
				  </td>
				</tr>
				<tr>
				  <th>内容：</th>
				  <td>
				  	<%= StringUtil.convertFromXmlChars(JSPDataBean.getFormData("content")) %>
				  </td>
				</tr>
				<tr>
				  <th>链接：</th>
				  <td id="queryProductTypeSelect2"><%= JSPDataBean.getFormData("link") %></td>
				</tr>
			</table>
			<div align="center">
				<div class="button">
					<a onclick="javascript:postModuleAndAction('questionFeedBack', 'list')" class="btn_bb1"><span>返 回</span></a>
				</div>
			</div>
		</div>
	<% } %>
	<%= JSPDataBean.getFormData("queryConditionHtml") %>	
	<input type="hidden" id="questionFeedBackLogID" name="questionFeedBackLogID" value="<%= JSPDataBean.getFormData("questionFeedBackLogID") %>" />
	<input type="hidden" id="selectedValues" name="selectedValues" value="<%= JSPDataBean.getFormData("selectedValues") %>" />
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