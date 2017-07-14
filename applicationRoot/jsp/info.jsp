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
<div class="headDiv">
	<div class="btn_t left"><a href="javascript:postModuleAndAction('info','defaultView')"><span><strong><%= JSPDataBean.getFormData("operationName").equals("0") ? "" : "商户" %>文章管理</strong></span></a></div>

		
	<% if (JSPDataBean.getFormData("action").equals("list") && JSPDataBean.getFormData("operationName").equals("1")) { %>
		<div class="gray9 tip"  style="float: right;">
			<a href="javascript:batchUpdateInfoStatus('1');" class="btn_y"><span><strong class="icon_add">批量审核通过</strong></span></a>
			<a href="javascript:batchUpdateInfoStatus('2');" class="btn_y"><span><strong class="icon_add">批量审核不通过</strong></span></a>
		</div>
	<% } else if(JSPDataBean.getFormData("action").equals("list")){ %>
		<div class="tip gray9" style="float: right;"><a href="javascript:postModuleAndAction('info', 'addView')" class="btn_y"><span><strong class="icon_add">添加</strong></span></a> </div>
	<% } %>
</div>

<div class="main clear">
	<div class="clear"></div>
	
	<% if (JSPDataBean.getFormData("action").equals("list")) { %>
	<div class="search">
	  	<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td>
					版块：<%= JSPDataBean.getFormData("queryInfoTypeSelect") %>&nbsp;
					<% if(!JSPDataBean.getFormData("operationName").equals("0")) { %>
					审核状态：<%= JSPDataBean.getFormData("queryInfoAuditTypeSelect") %>&nbsp;
					店铺：<input type="text" name="q_supplierName" id="q_supplierName" value="<%= JSPDataBean.getFormData("q_supplierName") %>" size="25" onkeydown="javascript:if(event.keyCode==13) postModuleAndAction('info', 'search')"/>&nbsp;
					<% } %>
					文章ID：<input type="text" name="q_infoID" id="q_infoID" value="<%= JSPDataBean.getFormData("q_infoID") %>" size="10" maxlength="20" onkeydown="javascript:if(event.keyCode==13) postModuleAndAction('info', 'search')"/>&nbsp;
					标题：<input type="text" name="q_title" id="q_title" value="<%= JSPDataBean.getFormData("q_title") %>" size="25" maxlength="50" onkeydown="javascript:if(event.keyCode==13) postModuleAndAction('info', 'search')"/>&nbsp;
				</td>
				<td class="righttd">
					<div><dl>
	               		<dt style="width: 100%;">
	                   		<a class="btn_y" onclick="javascript:postModuleAndAction('info', 'search')"><span>搜&nbsp;&nbsp;&nbsp;&nbsp;索</span></a>
	                   	</dt>
	              	</dl></div>
				</td>
			</tr>
		</table>
	</div>

	<div>
		<table class="list" border="0" cellpadding="0" cellspacing="1" width="100%" id="tab1">
			<tr>
				<% if(!JSPDataBean.getFormData("operationName").equals("0")) { %>
				<th width="2%">
			    	<input type="checkbox" name="selectAllChoice" id="selectAllChoice" onclick="selectAllCheckBox('selectAllChoice', 'selectChoice', 'selectedValues')" />
			    </th>
				<% } %>
				<th>文章ID</th>
				<% if(!JSPDataBean.getFormData("operationName").equals("0")) { %>
				<th>店铺</th>
				<% } %>
				<th>版块</th>
				<th width="10%">图片</th>
				<th>标题</th>
				<th>推荐</th>
				<th>添加日期</th>
				<% if(JSPDataBean.getFormData("operationName").equals("0")) { %>
				<th>排序&nbsp;<input value="更新" onclick="$('#table').val('info');doAction('updateSortIndexAll')" type="button"></th>
				<th>状态</th>
				<% } else { %>
				<th>审核状态</th>
				<% } %>
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
				<% if(!JSPDataBean.getFormData("operationName").equals("0")) { %>
				<td align="center"  style="border-bottom:1px solid #b8d4e8;">
					<input type="checkbox" onchange="setSelectedValues('selectChoice', 'selectedValues')" id="selectChoice" name="selectChoice" value="<%= data.get("infoID") %>"/>
				</td>
				<% } %>
				<td><%= data.get("infoID") %></td>
				<% if(!JSPDataBean.getFormData("operationName").equals("0")) { %>
				<td><%= data.get("supplierName") %></td>
				<% } %>
				<td><%= data.get("infoTypeName") %></td>
				<td>
					<a href="" target="_blank">
					<img src="<%= AppUtil.getImageURL("info", data.get("image").toString(), 0) %>" width="60"/>
					</a>
				</td>
				<td >
					<a title="<%= data.get("title") %>" class="infoLink" href="http://<%= AppKeys.DOMAIN_WWW %>/community/<%= data.get("infoID") %>.html" target="_blank">
					<%= AppUtil.splitString(data.get("title").toString(), 100) %>
					</a>
				<td>
					<a href="javascript:document.getElementById('infoID').value= '<%= data.get("infoID")%>'; postModuleAndAction('info','<%= data.get("tjFlag").equals("1") ? "tjDisable" : "tjEnable" %>')">
					<img src="/images/<%= data.get("tjFlag").equals("1") ? "yes" : "no"%>.gif" width="15px" border="none"/>
					</a>
				</td>
				<td><%= data.get("addTime").toString().substring(0, 10) %></td>
				<% if(JSPDataBean.getFormData("operationName").equals("0")) { %>
				<td>
					<input id="sortIndex_<%= data.get("infoID") %>" name="sortIndex_<%= data.get("infoID") %>" value="<%= data.get("sortIndex") %>" size="5" maxlength="11" type="text">
				</td>
				<td>
					<a href="javascript:document.getElementById('infoID').value= '<%= data.get("infoID")%>'; postModuleAndAction('info','<%= data.get("validFlag").equals("1") ? "disable" : "enable" %>')">
					<img src="/images/<%= data.get("validFlag").equals("1") ? "yes" : "no"%>.gif" width="15px" border="none"/>
					</a>
				</td>
				<% } else { %>
				<td><%= LocalDataCache.getInstance().getTableDataColumnsValue("c_infoAuditType", (String)data.get("auditStatus"), "c_infoAuditTypeName") %></td>
				<% } %>
				<td>
					<a href="javascript:document.getElementById('infoID').value='<%=data.get("infoID")%>';postModuleAndAction('info','editView')">编辑</a>
					<% if(JSPDataBean.getFormData("operationName").equals("0")) { %>
					<a href="javascript:if(confirm('是否删除')){document.getElementById('infoID').value='<%= data.get("infoID")%>';postModuleAndAction('info','delete')}">删除</a>
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
	
	<% } else if (JSPDataBean.getFormData("action").equals("addView") || JSPDataBean.getFormData("action").equals("confirm") || JSPDataBean.getFormData("action").equals("editView")) {
		String[] columns = {"title", "subTitle"};
		AppUtil.convertToHtml(columns, JSPDataBean.getFormDatas());
		%>
		<div class="record">
		<%@include file="common/commonEditTitle.jsp" %>
			<table border="0" cellspacing="0" cellpadding="0" width="100%">
				<tr>
					<th width="25%"><span class="red">* </span>版块：</th>
					<td><%= JSPDataBean.getFormData("infoTypeSelect") %></td>
				</tr>
				<tr>
					<th width="25%"><span class="red">* </span>标题：</th>
					<td><input type="text" name="title" id="title" value="<%=JSPDataBean.getFormData("title")%>"  maxlength="100" size="100"></td>
				</tr>
				<tr>
					<th width="25%"><span class="red">* </span>导读：</th>
					<td><input type="text" name="subTitle" id="subTitle" value="<%=JSPDataBean.getFormData("subTitle")%>"  maxlength="200" size="100"></td>
				</tr>
				<tr>
					<th width="25%"><span class="red">* </span>图片：</th>
					<td>
						<span>
            	 			<img class="imgBorder" id='imagePreview' src='<%= AppUtil.getImageURL("info", JSPDataBean.getFormData("image"), 0)%>' style="width: 100px;"/>
            			</span>
            			<a href="javascript:void(0)" onclick="javascript:doUploadFile('info', 'image', 'imagePreview', '')">上传</a>
            			<a href="javascript:void(0)" onclick="javascript:clearUploadFile('image', 'imagePreview')">删除</a>
            			<input type="hidden" name="image" id="image" value="<%= JSPDataBean.getFormData("image") %>" />
					</td>
				</tr>
				<tr>
					<th width="25%"></th>
					<td><span style="color:red;">建议上传 4:3比例 的图片</span></td>
				</tr>
				<tr>
					<th>详细内容：</th>
					<td></td>
				</tr>
				<tr>
					<th></th>
					<td>
						<script id="ueditor" name="content" type="text/plain"
							style="width:700px;height:300px;"><%= JSPDataBean.getFormData("content") %></script>
						<script type="text/javascript">
							$(function(){
					    		UE.getEditor('ueditor');
							});
						</script>
					</td>
				</tr>

			</table>
		<div align="center">
			<div class="button">
				<% if(JSPDataBean.getFormData("operationName").equals("0")) { %>
				<a class="btn_bb1" id="btnSave" onclick="javascript:postModuleAndAction('info', 'confirm')"><span>保 存</span></a>
				<% } %>
				<a onclick="javascript:postModuleAndAction('info','defaultView')" class="btn_bb1"><span>返 回</span></a>
			</div>
		</div>
	</div>
	<% } %>
	<input type="hidden" name="infoID" id="infoID" value="<%= JSPDataBean.getFormData("infoID") %>" />
	<input type="hidden" name="operationName" id="operationName" value="<%= JSPDataBean.getFormData("operationName") %>" />
	<input type="hidden" name="typeID" id="typeID" value="" />
	<%= JSPDataBean.getFormData("queryConditionHtml") %>
	<% if(JSPDataBean.getFormData("action").equals("list") && JSPDataBean.getFormData("operationName").equals("1")) { %>
	<script>
		function batchUpdateInfoStatus(id) {
			if (document.getElementById('selectedValues').value == '') {
				alert('请选择要删除的商品');
				return;
			} else {
				$("#typeID").val(id);
				doAction('info', 'batchUpdateInfoStatus');
				
			}
		}
	</script>
	<input type="hidden" name="selectedValues" id="selectedValues" value="" />
	<% } %>	
</div>

<%@include file="common/commonFooter.jsp" %>
