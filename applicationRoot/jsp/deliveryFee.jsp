<%@ page contentType="text/html;charset=UTF-8"%>
<jsp:directive.page import="java.util.Vector"/>
<jsp:directive.page import="java.util.Hashtable"/>
<%@page import="java.util.Iterator"%>
<%@page import="admin.customer.guanwangbao.AppUtil"%>
<%@page import="admin.customer.guanwangbao.LocalDataCache"%>
<%@page import="simpleWebFrame.util.PriceUtil"%>
<%@page import="admin.customer.guanwangbao.AppKeys"%>
<jsp:useBean id="JSPDataBean" scope='request' class="simpleWebFrame.web.JSPDataBean" />

<%@include file="common/commonHeader.jsp" %>

<div class="headDiv">
	<div class="btn_t left"><a href="javascript:postModuleAndAction('deliveryFee','defaultView')"><span><strong>运费设置</span></a></div>
</div>

<div class="main clear">
	<div class="clear"></div>
		<div class="record">
		<%@include file="common/commonEditTitle.jsp" %>
		<table border="0" cellspacing="0" cellpadding="0" width="100%">
			<tr>
			  <th><span class="red">* </span>运费：</th>
			  <td><input type="text" name="fee" id="fee" size="40" maxlength="30" value="<%= JSPDataBean.getFormData("fee") %>" />&nbsp;元</td>
			</tr>
			<tr>
			  <th><span class="red">* </span>包邮消费金额：</th>
			  <td><input type="text" name="freeAmount" id="freeAmount" size="40" maxlength="30" value="<%= JSPDataBean.getFormData("freeAmount") %>" />&nbsp;元</td>
			</tr>
		</table>
		
		<div align="center" style="margin-top:10px;">
			<div class="button">
				<a class="btn_bb1" id="btnSave" onclick="javascript:postModuleAndAction('deliveryFee', 'confirm')"><span>保 存</span></a>
			</div>
		</div> 
	</div>
</div>

<%@include file="common/commonFooter.jsp" %>

<script type="text/javascript">

</script>








