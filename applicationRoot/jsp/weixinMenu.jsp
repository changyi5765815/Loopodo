<%@ page contentType="text/html;charset=UTF-8"%>
<jsp:directive.page import="java.util.Vector"/>
<jsp:directive.page import="java.util.Hashtable"/>
<%@page import="java.util.Iterator"%>
<%@page import="admin.customer.guanwangbao.AppUtil"%>
<%@page import="admin.customer.guanwangbao.LocalDataCache"%>
<%@page import="simpleWebFrame.util.PriceUtil"%>
<%@page import="admin.customer.guanwangbao.AppKeys"%>
<%@page import="admin.customer.guanwangbao.weixin.Button"%>
<%@page import="simpleWebFrame.util.StringUtil"%>
<jsp:useBean id="JSPDataBean" scope='request' class="simpleWebFrame.web.JSPDataBean" />

<%@include file="common/commonHeader.jsp" %>

<div class="headDiv">
	<div class="btn_t left"><a href="javascript:postModuleAndAction('weixinMenu','defaultView')"><span><strong>微信公众号菜单</strong></span></a></div>
	<% if (JSPDataBean.getFormData("action").equals("list")) { %>
		<div class="tip gray9" style="float: right;"><a href="javascript:document.getElementById('selectMenuName').value='';setShowAddLinkWindowData('','','');openInfoWindow('common', 'addLinkWindow');" class="btn_y"><span><strong class="icon_add">添加</strong></span></a> </div>
	<% } %>
</div>

<div class="main clear">
	<% if (JSPDataBean.getFormData("action").equals("list")) { %>
	<div class="search">
	    	<table>
	    	<tr>
                <td  style="color: red;" colspan="4">注：自定义菜单最多包括3个一级菜单，每个一级菜单最多包含5个二级菜单。菜单标题，不超过16个字节，子菜单不超过40个字节，一个中文按2个字符算。</td>
		    </tr>
			</table>
	</div>
	<div class="clear"></div>
	<div class="pt5">
		<table class="list" border="0" cellpadding="0" cellspacing="1" width="100%" id="tab1">
			<tr>
				<th width="15%">菜单</th>
					<th width="*">链接</th>
					<th width="20%">操作</th>
			</tr>
			<%
				Vector<Button> buttons = (Vector<Button>) JSPDataBean.getJSPData("buttons");
				int index = 0;
				for (int i = 0; i < buttons.size(); i++) {
					Button b = buttons.get(i);
			%>
			<tr>
				<td style="text-align:left"><%= StringUtil.convertXmlChars(b.getName()) %></td>
					<td style="text-align:left"><%= b.getUrl() == null ? "" : b.getUrl() %></td>
					<td>
						<a href="javascript:document.getElementById('editMenuName').value='';document.getElementById('selectMenuName').value='<%= b.getName() %>';setShowAddLinkWindowData('','','');openInfoWindow('common', 'addLinkWindow')">添加子菜单</a>
						<a href="javascript:document.getElementById('editMenuName').value='<%= b.getName() %>';document.getElementById('selectMenuName').value='<%= b.getName() %>';setShowAddLinkWindowData('<%= b.getName() %>', '<%= b.getUrl() == null ? "" : b.getUrl() %>', '');openInfoWindow('common', 'addLinkWindow')">编辑</a>
						<a href="javascript:if(confirm('该菜单删除后将无法恢复，是否确认删除？')){document.getElementById('selectMenuName').value='<%= b.getName() %>';postModuleAndAction('weixinMenu', 'delete')}">删除</a>
					</td>
					<%
						Vector<Button> subButtons = b.getSubButtons();
						for (int j = 0; j < subButtons.size(); j++) {
							Button sb = subButtons.get(j);
					%>
					<tr class="<%= (++index)%2 ==0 ? "oddTr":"" %>">
						<td style="text-align:left"><%= "∟　" + StringUtil.convertXmlChars(sb.getName()) %></td>
						<td style="text-align:left"><%= sb.getUrl() == null ? "" : sb.getUrl() %></td>
						<td>
							<a href="javascript:document.getElementById('editMenuName').value='<%= sb.getName() %>';setShowAddLinkWindowData('<%= sb.getName() %>', '<%= sb.getUrl() == null ? "" : sb.getUrl() %>', '');openInfoWindow('common', 'addLinkWindow')">编辑</a>
							<a href="javascript:if(confirm('该菜单删除后将无法恢复，是否确认删除？')){document.getElementById('selectMenuName').value='<%= sb.getName() %>';postModuleAndAction('weixinMenu', 'delete')}">删除</a>
						</td>
					</tr>
					<%
						}
					%>
			</tr>
			<%	} %>
		</table>
	</div>
	
	<% } %>	
	<input type="hidden" name="selectMenuName" id="selectMenuName" value="">
	<input type="hidden" name="editMenuName" id="editMenuName" value="">
</div>

<script type="text/javascript">
function setPageLinkItem() {
	doAction('weixinMenu', 'addWeixinMenu');
}

function setShowAddLinkWindowData(old_dataAlias, old_dataLink, old_isTarget) {
	$('#old_dataAlias').val(old_dataAlias);
	$('#old_dataLink').val(old_dataLink);
	$('#old_isTarget').val(old_isTarget);
}
</script>
<input type="hidden" name="old_dataAlias" id="old_dataAlias" />
<input type="hidden" name="old_dataLink" id="old_dataLink" />
<input type="hidden" name="old_isTarget" id="old_isTarget" />

<%@include file="common/commonFooter.jsp" %>

<script type="text/javascript">

</script>








