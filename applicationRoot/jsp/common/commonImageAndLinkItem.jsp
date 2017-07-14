<%@page import="jxl.read.biff.FooterRecord"%>
<%@page import="admin.customer.guanwangbao.LocalDataCache"%>
<%@page import="java.util.Hashtable"%>
<%@page import="java.util.Vector"%>
<%@page import="admin.customer.guanwangbao.AppUtil"%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@page import="simpleWebFrame.web.JSPDataBean"%>

<% Hashtable floorGroup = (Hashtable) JSPDataBean.getJSPData("floorGroup"); %>
<table border="0" cellspacing="0" cellpadding="0" width="100%">
	<tr><th /><th /></tr>
	<tr>
		<th style="padding-top: 12px;" valign="top">快速设置：</th>
		<td>
			<a href="javascript:void(0)" onclick="openWindow('selectOneProductWindow')">选择商品</a>
		</td>
	</tr>
	<%
		Vector floorElementProps = LocalDataCache.getInstance().getTableDatas("c_floorElementProp");
		for (int i = 0; i < floorElementProps.size(); ++i) {
			Hashtable floorElementProp = (Hashtable) floorElementProps.get(i);
			String prop = floorElementProp.get("c_floorElementPropID").toString();
			String propName = floorElementProp.get("c_floorElementPropName").toString();
	%>
	<% if (prop.equals("image")) { %>
	<tr style="display: <%= floorGroup.get("floorElementProps").toString().indexOf(prop) != -1 ? "" : "none" %>">
		<th style="padding-top: 12px;" valign="top">图片：</th>
		<td>
			<img id="preViewImage" src="<%= JSPDataBean.getFormData(prop).equals("") ? "/images/none.jpg" : JSPDataBean.getFormData(prop) %>" style="max-width: 500px;max-height: 200px"/>
			<br/>
			宽 <input type="text" size="4" value="<%= JSPDataBean.getFormData(prop + "_width") %>" id="<%= prop + "_width" %>" name="<%= prop + "_width" %>" />
			高 <input type="text" size="4" value="<%= JSPDataBean.getFormData(prop + "_height") %>" id="<%= prop + "_height" %>" name="<%= prop + "_height" %>" />
			<br/>
			<a style="20px;" href="javascript:void(0)" onclick="openWindow('uploadImageWindow')">上传图片</a>
           	<a style="margin-left:20px;color: #0067CB" href="javascript:void(0)" onclick="javascript:$('#image').val('');$('#preViewImage').attr('src', '/images/none.jpg')">删除</a>
			<input type="hidden" id="uploadDir" name="uploadDir" value="other" />
			<input type="hidden" value="<%= JSPDataBean.getFormData(prop) %>" id="<%= prop %>" name="<%= prop %>">
			<br/><font style="color: red">上传完后点击“保存”按钮生效</font>
		</td>
	</tr>
	<% } else if (prop.equals("color")) { %>
	<tr style="display: <%= floorGroup.get("floorElementProps").toString().indexOf(prop) != -1 ? "" : "none" %>">
		<th style="padding-top: 12px;" valign="top">背景色：</th>
		<td>
			<div class="picker" id="clolorDiv" style="<%= "".equals(JSPDataBean.getFormData(prop)) ? "" : ("background-color: " + JSPDataBean.getFormData(prop))  %>"></div>
			<input type="hidden" name="<%= prop %>" id="<%= prop %>" value="<%= JSPDataBean.getFormData(prop) %>" />
		</td>
	</tr>
	<% } else { %>
	<tr style="display: <%= floorGroup.get("floorElementProps").toString().indexOf(prop) != -1 ? "" : "none" %>">
		<th style="padding-top: 12px;" valign="top"><%= propName %>：</th>
		<td>
			<input value="<%= JSPDataBean.getFormData(prop) %>" id="<%= prop %>" name="<%= prop %>" size="50" type="text">
		</td>
	</tr>
	<% } } %>
	
	<%--
	<tr style="display: <%= floorGroup.get("floorElementProps").toString().indexOf("image") != -1 ? "" : "none" %>">
		<th style="padding-top: 12px;" valign="top">图片：</th>
		<td>
			<img id="preViewImage" src="<%= JSPDataBean.getFormData("image").equals("") ? "/images/none.jpg" : JSPDataBean.getFormData("image") %>" style="max-width: 500px;max-height: 200px"/>
			<a style="margin-left:20px;" href="javascript:void(0)" onclick="openWindow('uploadImageWindow')">上传图片</a>
           	<a style="margin-left:20px;color: #0067CB" href="javascript:void(0)" onclick="javascript:$('#image').val('');$('#preViewImage').attr('src', '/images/none.jpg')">删除</a>
			<input type="hidden" id="uploadDir" name="uploadDir" value="other" />
			<input type="hidden" value="<%= JSPDataBean.getFormData("image") %>" id="image" name="image">
			<br/><font style="color: red">上传完后点击“保存”按钮生效</font>
		</td>
	</tr>
	<tr style="display: <%= floorGroup.get("floorElementProps").toString().indexOf("text") != -1 ? "" : "none" %>">
		<th style="padding-top: 12px;" valign="top">文字：</th>
		<td>
			<input value="<%= JSPDataBean.getFormData("text") %>" id="text" name="text" maxlength="200" size="50" type="text">
		</td>
	</tr>
	<tr style="display: <%= floorGroup.get("floorElementProps").toString().indexOf("link") != -1 ? "" : "none" %>">
		<th style="padding-top: 12px;" valign="top">链接：</th>
		<td>
			<input value="<%= JSPDataBean.getFormData("link") %>" id="link" name="link" maxlength="200" size="50" type="text">
		</td>
	</tr>
	<tr style="display: <%= floorGroup.get("floorElementProps").toString().indexOf("info") != -1 ? "" : "none" %>">
		<th style="padding-top: 12px;" valign="top">描述：</th>
		<td>
			<input value="<%= JSPDataBean.getFormData("info") %>" id="info" name="info" maxlength="200" size="50" type="text">
		</td>
	</tr>
	<tr style="display: <%= floorGroup.get("floorElementProps").toString().indexOf("date") != -1 ? "" : "none" %>">
		<th style="padding-top: 12px;" valign="top">日期：</th>
		<td>
			<input value="<%= JSPDataBean.getFormData("date") %>" id="date" name="date" maxlength="19" size="50" type="text">
		</td>
	</tr>
	<tr style="display: <%= floorGroup.get("floorElementProps").toString().indexOf("normalPrice") != -1 ? "" : "none" %>">
		<th style="padding-top: 12px;" valign="top">市场价：</th>
		<td>
			<input value="<%= JSPDataBean.getFormData("normalPrice") %>" id="normalPrice" name="normalPrice" maxlength="11" size="50" type="text">
		</td>
	</tr>
	<tr style="display: <%= floorGroup.get("floorElementProps").toString().indexOf("price") != -1 ? "" : "none" %>">
		<th style="padding-top: 12px;" valign="top">价格：</th>
		<td>
			<input value="<%= JSPDataBean.getFormData("price") %>" id="price" name="price" maxlength="11" size="50" type="text">
		</td>
	</tr>
	<tr style="display: <%= floorGroup.get("floorElementProps").toString().indexOf("color") != -1 ? "" : "none" %>">
		<th style="padding-top: 12px;" valign="top">颜色：</th>
		<td>
			<div class="picker" id="clolorDiv" style="<%= JSPDataBean.getFormData("color").equals("") ? "" : ("background-color: " + JSPDataBean.getFormData("color"))  %>"></div>
			<input type="hidden" name="color" id="color" value="<%= JSPDataBean.getFormData("color") %>" />
		</td>
	</tr>
	 --%>
</table>

<script>
	function setData(productID, image, text, link, info, date, normalPrice, price) {
		$('#productID').val(productID);
		$('#image').val(image);
		$('#preViewImage').attr('src', image);
		$('#text').val(text);
		$('#link').val(link);
		$('#info').val(info);
		$('#date').val(date);
		$('#normalPrice').val(normalPrice);
		$('#price').val(price);
	}
	
	function confirmUploadImage() {
		var previewImg_window = $('#previewImg_window').attr('src');
		var tmpImage_window = $('#tmpImage_window').val();
		if (tmpImage_window == '') {
			alert('请先上传一张图片');
			return;
		}
		
		$('#preViewImage').attr('src', previewImg_window);
		$('#image').val(previewImg_window);
		closeInfoWindow();
	}
	
	colorPicker('clolorDiv', 'color', '<%= JSPDataBean.getFormData("color") %>');
</script>