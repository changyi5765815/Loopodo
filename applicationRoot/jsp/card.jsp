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
div.tagsinput {
	border: 1px solid #CCC;
	background: #FFF;
	padding: 5px;
	width: 700px !important;
	height: 100px !important;
	overflow-y: auto;
}

div.tagsinput span.tag {
	background: #65CEA7 !important;
	border-color: #65CEA7;
	color: #fff;
	border-radius: 15px;
	-webkit-border-radius: 15px;
	padding: 2px 10px;
}
</style>
<div class="headDiv">
	<div class="btn_t left"><a href="javascript:postModuleAndAction('card','defaultView')"><span><strong>优惠券管理</strong></span></a></div>

	<% if (JSPDataBean.getFormData("action").equals("list")) { %>
		<div class="tip gray9" style="float: right;"><a href="javascript:postModuleAndAction('card', 'addView')" class="btn_y"><span><strong class="icon_add">短信群发优惠券</strong></span></a> </div>
	<% } %>
</div>

<div class="main clear">
	<div class="clear"></div>
	
	<% if (JSPDataBean.getFormData("action").equals("list")) { %>
    <div class="search">
	  	<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td>
					优惠券码：<input type="text" name="q_code" id="q_code" value="<%= JSPDataBean.getFormData("q_code") %>" size="25" maxlength="20" onkeydown="javascript:if(event.keyCode==13) postModuleAndAction('card', 'search')"/>&nbsp;
					优惠券名称：<input type="text" name="q_title" id="q_title" value="<%= JSPDataBean.getFormData("q_title") %>" size="25" maxlength="50" onkeydown="javascript:if(event.keyCode==13) postModuleAndAction('card', 'search')"/>&nbsp;
				</td>
				<td class="righttd">
					<div><dl>
	               		<dt style="width: 100%;">
	                   		<a class="btn_y" onclick="javascript:postModuleAndAction('card', 'search')"><span>搜&nbsp;&nbsp;&nbsp;&nbsp;索</span></a>
	                   	</dt>
	              	</dl></div>
				</td>
			</tr>
		</table>
	</div>
	<div>
		<table class="list" border="0" cellpadding="0" cellspacing="1" width="100%" id="tab1">
			<tr>
				<th id="s_code">优惠券码</th>
					<th>优惠券名称</th>
					<th>类型</th>
					<th>来源</th>
					<th>面值</th>
					<th>最低消费金额</th>
					<th>失效时间</th>
					<th>创建时间</th>
					<th>获赠用户</th>
					<th>状态</th>
					<th>操作</th>
			</tr>
			<%
				Vector datas = (Vector) JSPDataBean.getJSPData("datas");
				String[] columns = {"title"};
				AppUtil.convertToHtml(columns, datas);
				for (int i = 0; i < datas.size(); i++) {
					Hashtable data = (Hashtable) datas.get(i);
			%>
			<tr>
				<td><%= data.get("code") %></td>
					<td><%= data.get("title") %></td>
					<td><%= data.get("cardTypeID").equals("1") ? "线上优惠券" : "线下优惠券" %></td>
					<td><%= LocalDataCache.getInstance().getTableDataColumnValue("c_cardSourceType", data.get("source").toString(), "c_cardSourceTypeName") %></td>
					<td><%= data.get("money") %></td>
					<td><%= data.get("minBuyPrice") %></td>
					<td><%= data.get("deadDate") %></td>
					<td><%= data.get("addTime") %></td>
					<td><%= data.get("userName").equals("") ? data.get("userNick") : data.get("userName") %></td>
					<td><%= data.get("usedFlag").equals("0") ? "未使用" : "已使用" %></td>
					<td>
					</td>
			</tr>
			<%	} %>
		</table>
		<div class="page blue">
		    <p class="floatl"><%@include file="common/commonJumpPage.jsp" %></p>
		    <div class="clear"></div>
		</div>
	</div>
	
	<% } else if (JSPDataBean.getFormData("action").equals("addView")) {
		String[] columns = {"title"};
		AppUtil.convertToHtml(columns, JSPDataBean.getFormDatas());
		%>
		<div class="record">
		<%@include file="common/commonEditTitle.jsp" %>
			<table border="0" cellspacing="0" cellpadding="0" width="100%">
				<tr>
					<th><span class="red">* </span>优惠券名称：</th>
					<td><input type="text" name="title" id="title" value="<%= JSPDataBean.getFormData("title") %>" size="30" maxlength="50" /></td>
				</tr>
				<tr>
					<th><span class="red">* </span>面值：</th>
					<td><input type="text" maxlength="11" name="money" id="money" value="<%= JSPDataBean.getFormData("money") %>" size="30"/></td>
				</tr>
				<tr>
					<th><span class="red">* </span>最低消费金额：</th>
					<td><input type="text" maxlength="11" name="minBuyPrice" id="minBuyPrice" value="<%= JSPDataBean.getFormData("minBuyPrice") %>" size="30"/></td>
				</tr>
				<tr>
					<th><span class="red">* </span>失效日期：</th>
					<td>
						<input  type="text" id="deadDate" name="deadDate" value="<%= JSPDataBean.getFormData("deadDate") %>" class="itime" onclick="calendar(this, false);" style="cursor: pointer;width:150px" readonly>
					</td>
				</tr>
				<tr>
					<th><span class="red">* </span>赠送会员：</th>
					<td id="user_div"><%@include file="card/selectedUsers.jsp" %></td>
				</tr>
			</table>
		<div align="center">
			<div class="button">
				<a class="btn_bb1" id="btnSave" onclick="javascript:doAction('card', 'sendCardToUsers')"><span>保 存</span></a>
				<a onclick="javascript:postModuleAndAction('card','defaultView')" class="btn_bb1"><span>返 回</span></a>
			</div>
		</div>
	</div>
	<% } %>
	<input type="hidden" id="selectedValues" name="selectedValues" />
	<%= JSPDataBean.getFormData("queryConditionHtml") %>	
	
</div>

<%@include file="common/commonFooter.jsp" %>

<script type="text/javascript">
	function selectUsers() {
		var selectedValues = $('#selectedValues').val();
		if (selectedValues == '') {
			alert('请选择用户');
			return;
		} else {
			closeInfoWindow();
			refreshItem('common', 'selectUsers', 'user_div');
		}
	}
	
	function removeUser(userID) {
		var selectedUserCount = $('#selectedUserCount_font').html();
		var seletedValues = $('#selectedValues').val();
		
		if (("," + seletedValues + ",").indexOf("," + userID + ",") != -1) {
			seletedValues = ("," + seletedValues + ",").replace("," + userID + ",", ",");
			
			if (seletedValues.length > 0) {
				if (seletedValues.substring(0,1) == ',') {
					seletedValues = seletedValues.substring(1, seletedValues.length - 1);
				}
				if (seletedValues.substring((seletedValues.length - 2),1) == ',') {
					seletedValues = seletedValues.substring(0, seletedValues.length - 2);
				}
			}
			selectedUserCount--;
		}
		
		$('#selectedUserCount_font').html(selectedUserCount);
	    $('#selectedValues').val(seletedValues);
	    $('#user_' + userID).remove();
	}
</script>








