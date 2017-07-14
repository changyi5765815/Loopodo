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
<% if (JSPDataBean.getFormData("action").equals("list")) { %>
	<div class="btn_t left"><a href="javascript:postModuleAndAction('stockInBill','defaultView')"><span><strong>入库管理</strong></span></a></div>
	<div class="tip gray9" style="float: right;"><a href="javascript:postModuleAndAction('stockInBill', 'addView')" class="btn_y"><span><strong class="icon_add">添加入库单</strong></span></a> </div>
<% } %>
<% if (JSPDataBean.getFormData("action").equals("addView")) { %>
	<div class="btn_t0 left"><a href="javascript:postModuleAndAction('stockInBill','defaultView')"><span><strong>入库管理</strong></span></a></div>
	<div class="btn_t left"><a href="javascript:;"><span><strong>添加入库单</strong></span></a></div>
<% } %>
<% if (JSPDataBean.getFormData("action").equals("stockInBillItemList")) { %>
	<div class="btn_t0 left"><a href="javascript:postModuleAndAction('stockInBill','defaultView');"><span><strong>入库管理</strong></span></a></div>
	<div class="btn_t left"><a href="javascript:postModuleAndAction('stockInBill','stockInBillItemList');"><span><strong>入库详情</strong></span></a></div>
<% } %>
</div>

<div class="main clear">
	<div class="clear"></div>
	
	<% if (JSPDataBean.getFormData("action").equals("list")) { %>
	<div class="search">
	  	<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td>
				入库单ID：<input type="text" name="q_stockInBillID" id="q_stockInBillID" value="<%= JSPDataBean.getFormData("q_stockInBillID") %>" size="25" maxlength="20" onkeydown="javascript:if(event.keyCode==13) postModuleAndAction('stockInBill', 'search')"/>&nbsp;
				入库类型：<%= JSPDataBean.getFormData("queryStockInTypeSelect") %>&nbsp;
				相关单据号：<input type="text" name="q_relateID" id="q_relateID" value="<%= JSPDataBean.getFormData("q_relateID") %>" size="25" maxlength="20" onkeydown="javascript:if(event.keyCode==13) postModuleAndAction('stockInBill', 'search')"/>&nbsp;
				出库人：<input type="text" name="q_siteManagerUserName" id="q_siteManagerUserName" value="<%= JSPDataBean.getFormData("q_siteManagerUserName") %>" size="10" maxlength="50" />&nbsp;
				入库时间：	
					<input type="text" size="15" maxlength="10" id="q_fromAddTime" name="q_fromAddTime" value="<%= JSPDataBean.getFormData("q_fromAddTime") %>" onclick="calendar(this, false);" class="itime" style="cursor: pointer;" readonly />
				- 	
				<input type="text" size="15" maxlength="10" id="q_toAddTime" name="q_toAddTime" value="<%= JSPDataBean.getFormData("q_toAddTime") %>" onclick="calendar(this, false);" class="itime" style="cursor: pointer;" readonly />
				</td>
				<td class="righttd">
					<div><dl>
	               		<dt style="width: 100%;">
	                   		<a class="btn_y" onclick="javascript:postModuleAndAction('stockInBill', 'search')"><span>搜&nbsp;&nbsp;&nbsp;&nbsp;索</span></a>
	                   	</dt>
	              	</dl></div>
				</td>
			</tr>
		</table>
	</div>
	<div>
		<table class="list" border="0" cellpadding="0" cellspacing="1" width="100%" id="tab1">
			<tr>
				<th>入库单ID</th>
				<th>入库类型</th>
				<th>相关单据号</th>
				<th>入库人</th>
				<th>入库时间</th>
				<th>操作</th>
			</tr>
			<%
				Vector datas = (Vector) JSPDataBean.getJSPData("datas");
				for (int i = 0; i < datas.size(); i++) {
					Hashtable data = (Hashtable) datas.get(i);
			%>
			<tr>
				<td><%= data.get("stockInBillID") %></td>
				<td><%= LocalDataCache.getInstance().getTableDataColumnValue("c_stockInType", data.get("stockInTypeID").toString(), "c_stockInTypeName") %></td>
				<td><%= data.get("relateID") %></td>
				<td><%= data.get("siteManagerUserName") %></td>
				<td><%= data.get("addTime") %></td>
				<td align="center">
					<a href="javascript:document.getElementById('stockInBillID').value='<%= data.get("stockInBillID")%>';postModuleAndAction('stockInBill', 'stockInBillItemList')">查看详细</a>
				</td>
			</tr>
			<%	} %>
		</table>
		<div class="page blue">
		    <p class="floatl"><%@include file="common/commonJumpPage.jsp" %></p>
		    <div class="clear"></div>
		</div>
	</div>
	
	<% } else if (JSPDataBean.getFormData("action").equals("addView") || JSPDataBean.getFormData("action").equals("confirm")) { %>
	<div class="search">
	  	<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td>
				入库类型：<%= JSPDataBean.getFormData("stockInTypeSelect") %>&nbsp;
				相关单据号：<input type="text" name="q_relateID" id="q_relateID" value="<%= JSPDataBean.getFormData("q_relateID") %>" size="10" maxlength="50" />&nbsp;
				</td>
				<td class="righttd">
					<div><dl>
	               		<dt style="width: 100%;">
	                   		<a class="btn_y" onclick="$('#selectedValues').val('');openInfoWindow('stockInBill', 'selectStockBillProductWindow')"><span>添加入库商品</span></a>
	                   	</dt>
	              	</dl></div>
				</td>
			</tr>
		</table>
	</div>
	<div>
		<table class="list" border="0" cellpadding="0" cellspacing="1" width="100%" id="tab1">
			<tr>
				<th>商品ID</th>
				<th>skuID</th>
				<th>名称</th>
				<th>库存数量</th>
				<th>本次入库数量</th>
				<th>备注</th>
				<th>操作</th>
			</tr>
			<tbody id="stockBillAdd">
					
			</tbody>
		</table>
		<div align="center" style="margin:10px;">
				<div class="button">
					<a onclick="doAction('addStockInBill')" class="btn_bb1"><span>保 存</span></a>
					<a onclick="javascript:postModuleAndAction('stockInBill','defaultView')" class="btn_bb1"><span>返 回</span></a>
				</div>
			</div>
	</div>
	<% } else if (JSPDataBean.getFormData("action").equals("stockInBillItemList")) { %>	
		<div>
		<table class="list" border="0" cellpadding="0" cellspacing="1" width="100%" id="tab1">
			<tr>
				<th>商品ID</th>
				<th>skuID</th>
				<th>名称</th>
				<th>入库数量</th>
				<th>备注</th>
			</tr>
			<%
				Vector datas = (Vector) JSPDataBean.getJSPData("datas");
				String[] columns = {"name", "note"};
				AppUtil.convertToHtml(columns, JSPDataBean.getFormDatas());
				for (int i = 0; i < datas.size(); i++) {
					Hashtable data = (Hashtable) datas.get(i);
			%>
			<tr>
				<td><%= data.get("productID")%></td>
					<td><%= data.get("skuID")%></td>
					<td title="<%= data.get("name") %>"><%= AppUtil.splitString(data.get("name").toString(), 80) + (data.get("propsName").equals("") ? "" : ("(" + data.get("propsName") + ")")) %></td>
					<td><%= data.get("number")%></td>
					<td><%= data.get("note")%></td>
			</tr>
			<%	} %>
		</table>
		<div align="center" style="margin:10px;">
				<div class="button">
					<a onclick="javascript:postModuleAndAction('stockInBill','defaultView')" class="btn_bb1"><span>返 回</span></a>
				</div>
		</div>
	</div>
	<% } %>
</div>

	<input type="hidden" id="stockInBillID" name="stockInBillID" value="<%=JSPDataBean.getFormData("stockInBillID")%>" />
	<input type="hidden" name="selectedValues" id="selectedValues" value="" />
	<input type="hidden" name="hasSelectedValues" id="hasSelectedValues" value="<%= JSPDataBean.getFormData("hasSelectedValues") %>" />
	<input type="hidden" name="removeProductID" id="removeProductID" value="" />
	<input type="hidden" name="stockInBillFlag" id="stockInBillFlag" value="1" />
	
<script language="javascript">
	function selectProducts() {
		if (document.getElementById('selectedValues').value == '') {
			alert('请选择商品');
			return;
		} else {
			refreshAppendItem('stockInBill', 'addStockBillProduct', 'stockBillAdd');
		}
	}

</script>

<%@include file="common/commonFooter.jsp" %>
