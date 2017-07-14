<%@page import="admin.customer.guanwangbao.AppKeys"%>
<%@ page contentType="text/html;charset=UTF-8"%>
<jsp:directive.page import="java.util.Vector"/>
<jsp:directive.page import="java.util.Hashtable"/>
<%@page import="java.util.Iterator"%>
<%@page import="admin.customer.guanwangbao.AppUtil"%>
<%@page import="admin.customer.guanwangbao.LocalDataCache"%>

<jsp:useBean id="JSPDataBean" scope='request' class="simpleWebFrame.web.JSPDataBean" />

<%@include file="common/commonHeader.jsp" %>
	<div class="headDiv">
		<div class="btn_t left"><a href="javascript:postModuleAndAction('payType','defaultView')"/><span><strong>付款方式设置</strong></span></a></div>
	</div>
	<div class="main clear">
		<div class="clear"></div>
		<% if(JSPDataBean.getFormData("action").equals("list")) {%>
		<div>
		<table class="list" border="0" cellpadding="0" cellspacing="1" width="100%" id="tab1">
			<tr>
				<th>付款方式ID</th>
				<th>logo</th>
				<th>名称</th>
				<th>显示端</th>
				<th>是否在线支付</th>
				<th>状态</th>
				<th>操作</th>
			</tr>
			<%
				Vector datas = (Vector)JSPDataBean.getJSPData("datas");
				String[] columns = {"name"};
				AppUtil.convertToHtml(columns, datas); 
				for (int i = 0; i < datas.size(); i++){
					Hashtable data = (Hashtable)datas.get(i);
					String trClass = "tr_line" + (i%2);
		 	%>
			<tr class="<%= trClass %>">
				<td><%= data.get("payTypeID") %></td>
				<td><img src="<%= AppUtil.getImageURL("payType", data.get("image").toString(), 0) %>" width="100px" /></td>
				<td><%= data.get("name") %></td>
				<td><%= LocalDataCache.getInstance().getTableDataColumnsValue("c_payTypeDisplayType", data.get("payTypeDisplayTypeIDs").toString(), "c_payTypeDisplayTypeName") %></td>
				<td><%= data.get("onlinePayFlag").equals("1") ? "是" : "否" %></td>
				<td>
				<% if (data.get("validFlag").equals("1")) {%>
					<a href="javascript:document.getElementById('payTypeID').value='<%=data.get("payTypeID") %>'; postModuleAndAction('payType','payTypeDisable')"/>
				<% }else{ %>
					<a href="javascript:document.getElementById('payTypeID').value='<%=data.get("payTypeID") %>'; postModuleAndAction('payType','payTypeEnable')"/>
				<% } %>
				<img src="/images/<%= data.get("validFlag").equals("1") ? "yes" : "no"%>.gif" width="15px" border="none"/>
				</a>
				</td>
				<td>
					<a href="javascript:document.getElementById('payTypeID').value='<%=data.get("payTypeID")%>';postModuleAndAction('payType','payTypeEditView')">编辑</a>
				</td>
			</tr>
			<% } %>
		</table>
		</div>
		<% 
			} else if (JSPDataBean.getFormData("action").equals("payTypeAddView") 
		          || JSPDataBean.getFormData("action").equals("payTypeEditView")
		          || JSPDataBean.getFormData("action").equals("payTypeConfirm")) {
				String[] columns = {"name"};
				AppUtil.convertToHtml(columns, JSPDataBean.getFormDatas()); 
		%>
		<div class="record">
		<%@include file="common/commonEditTitle.jsp" %>
		<table border="0" cellspacing="0" cellpadding="0" width="100%">
			<tr>
				<th>付款方式名称：</th>
				<td>
					<%=JSPDataBean.getFormData("name")%>
					<input type="hidden" name="name" id="name" value="<%= JSPDataBean.getFormData("name") %>" />
				</td>
			</tr>
			<tr>
				<th>付款方式LOGO：</th>
				<td>
					<img class="imgBorder" id='imagePreview' src='<%= AppUtil.getImageURL("payType", JSPDataBean.getFormData("image"), 0)%>' style="width:100px;height:100px"/>

					<a href="javascript:void(0)" onclick="javascript:doUploadFile('payType', 'image', 'imagePreview', '')">上传</a>
					<a class="infoLink" href="javascript:void(0)" onclick="javascript:clearUploadFile('image', 'imagePreview')">删除</a>
					<input type="hidden" value="<%= JSPDataBean.getFormData("image") %>" id="image" name="image">
				</td>
			</tr>
			<tr>
				<th><span class="red">* </span>显示端：</th>
				<td>
				<%
					Vector payTypeDisplayTypes = LocalDataCache.getInstance().getTableDatas("c_payTypeDisplayType");
					for (int i = 0; i < payTypeDisplayTypes.size(); ++i) {
						Hashtable data = (Hashtable) payTypeDisplayTypes.get(i);
				%>
				<input type="checkbox" name="payTypeDisplayTypeID" id="payTypeDisplayTypeID" value="<%= data.get("c_payTypeDisplayTypeID") %>" onclick="setSelectedValues('payTypeDisplayTypeID', 'payTypeDisplayTypeIDs')" <%= JSPDataBean.getFormData("payTypeDisplayTypeIDs").indexOf(data.get("c_payTypeDisplayTypeID").toString()) != -1 ? "checked=\"checked\"" : "" %> /><%= data.get("c_payTypeDisplayTypeName") %>
				<% } %>
				</td>
			</tr>
			<tr>
				<th><span class="red">* </span>是否在线支付：</th>
				<td>
				<input type="radio" name="onlinePayFlag" id="onlinePayFlag" value="1" <%= JSPDataBean.getFormData("onlinePayFlag").equals("1") ? "checked=\"checked\"" : "" %> />是
				<input type="radio" name="onlinePayFlag" id="onlinePayFlag" value="0" <%= !JSPDataBean.getFormData("onlinePayFlag").equals("1") ? "checked=\"checked\"" : "" %> />否
				</td>
			</tr>
			<tr>
				<th>描述：</th>
				<td>
					<textarea name="info" id="info"  style="width:308px; height:60px;"
								onkeyup="if(this.value.length>200){this.value=this.value.substring(0,200)}" ><%= JSPDataBean.getFormData("info")%></textarea>
				</td>
			</tr>
			<tr>
				<th>网址：</th>
				<td>
					<input value="<%= JSPDataBean.getFormData("siteUrl") %>" id="siteUrl" name="siteUrl" maxlength="200" size="50" type="text">
				</td>
			</tr>
			<tr>
				<th>申请网址：</th>
				<td>
					<input value="<%= JSPDataBean.getFormData("applyUrl") %>" id="applyUrl" name="applyUrl" maxlength="200" size="50" type="text">
				</td>
			</tr>
		<% String payTypeID = JSPDataBean.getFormData("payTypeID"); %>
		<% if (payTypeID.equals(AppKeys.PAY_TYPE_ID_WEIXIN) || payTypeID.equals(AppKeys.PAY_TYPE_ID_WEIXIN_APP)) { %>
			<tr>
			    <th><span class="red">* </span>微信appid：</th>
				<td>
			    	<input value="<%= JSPDataBean.getFormData("payAccountName") %>" id="payAccountName" name="payAccountName" maxlength="100" size="50" type="text">
			    </td>
		    </tr>
		    <tr>
				<th><span class="red">* </span>微信appsecret：</th>
				<td>
			    	<input value="<%= JSPDataBean.getFormData("payPara1") %>" id="payPara1" name="payPara1" maxlength="100" size="50" type="text">
			    </td>
			</tr>
			<tr>
			    <th><span class="red">* </span>微信商户支付号：</th>
				<td>
			    	<input value="<%= JSPDataBean.getFormData("payAccountID") %>" id="payAccountID" name="payAccountID" maxlength="100" size="50" type="text">
			    </td>
			</tr>
			<tr>
			    <th><span class="red">* </span>微信支付商户密钥：</th>
				<td>
			    	<input value="<%= JSPDataBean.getFormData("payPrivateKey") %>" id="payPrivateKey" name="payPrivateKey" maxlength="100" size="50" type="text">
			    </td>
			</tr>
		<% } else if (payTypeID.equals(AppKeys.PAY_TYPE_ID_ALIPAY_JSDZ) 
				|| payTypeID.equals(AppKeys.PAY_TYPE_ID_ALIPAY_JSDZ_WAP) 
				|| payTypeID.equals(AppKeys.PAY_TYPE_ID_ALIPAY_DBJY) 
				|| payTypeID.equals(AppKeys.PAY_TYPE_ID_ALIPAY_APP) 
				|| payTypeID.equals(AppKeys.PAY_TYPE_ID_ALIPAY_SBZ)) { %>
			<tr>
			    <th><span class="red">* </span>合作者ID：</th>
				<td>
			    	<input value="<%= JSPDataBean.getFormData("payAccountID") %>" id="payAccountID" name="payAccountID" maxlength="100" size="50" type="text">
			    </td>
		    </tr>
		    <tr>
				<th><span class="red">* </span>账号邮箱：</th>
				<td>
			    	<input value="<%= JSPDataBean.getFormData("payAccountName") %>" id="payAccountName" name="payAccountName" maxlength="100" size="50" type="text">
			    </td>
			</tr>
			<tr>
			    <th><span class="red">* </span>密钥：</th>
				<td>
			    	<input value="<%= JSPDataBean.getFormData("payPrivateKey") %>" id="payPrivateKey" name="payPrivateKey" maxlength="2000" size="50" type="text">
			    </td>
			</tr>
			<tr>
			    <th><span class="red">* </span>公钥：</th>
				<td>
			    	<input value="<%= JSPDataBean.getFormData("payPara1") %>" id="payPara1" name="payPara1" maxlength="500" size="50" type="text">
			    </td>
			</tr>
		<% } else if (payTypeID.equals(AppKeys.PAY_TYPE_ID_TENCENT)) { %>
			<tr>
			    <th><span class="red">* </span>商户号：</th>
				<td>
			    	<input value="<%= JSPDataBean.getFormData("payAccountID") %>" id="payAccountID" name="payAccountID" maxlength="100" size="50" type="text">
			    </td>
		    </tr>
			<tr>
			    <th><span class="red">* </span>密钥：</th>
				<td>
			    	<input value="<%= JSPDataBean.getFormData("payPrivateKey") %>" id="payPrivateKey" name="payPrivateKey" maxlength="100" size="50" type="text">
			    </td>
			</tr>
		<% } %>
		
		</table>
		<div align="center">
			<div class="button">
				<a class="btn_bb1" id="btnSave" onclick="javascript:postModuleAndAction('payType', 'payTypeConfirm')"><span>保 存</span></a>
				<a class="btn_bb1" onclick="javascript:postModuleAndAction('payType', 'defaultView')" ><span>返 回</span></a>
			</div>
		</div> 
		<input type="hidden" id="payTypeDisplayTypeIDs" name="payTypeDisplayTypeIDs" value="<%=JSPDataBean.getFormData("payTypeDisplayTypeIDs")%>" />
		<% } %>
	</div>
</div>

<input type="hidden" id="payTypeID" name="payTypeID" value="<%=JSPDataBean.getFormData("payTypeID")%>" />
<%@include file="common/commonFooter.jsp" %>