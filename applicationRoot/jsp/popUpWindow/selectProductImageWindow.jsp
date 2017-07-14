<%@ page contentType="text/html;charset=UTF-8"%>
<jsp:directive.page import="simpleWebFrame.util.StringUtil" />
<jsp:directive.page import="java.util.Vector" />
<jsp:directive.page import="java.util.Hashtable" />
<%@page import="admin.customer.guanwangbao.AppUtil"%>
<jsp:useBean id="JSPDataBean" scope='request' class="simpleWebFrame.web.JSPDataBean" />

<style>
.imgBox{
	width: 80px; 
	height: 75px; 
	overflow: hidden; 
	float: left;
	margin-top: 10px; 
	border: 1px solid #ddd; 
	border-radius: 5px;
	margin-right: 10px;
	padding: 15px;
}
.imgBox.on{
	width: 78px;
	height: 73px;
	border: 2px solid #e4393c;
	color: #e4393c;
	background: url(/images/newicon.png) no-repeat right bottom;
}
</style>

<div id="popwindow">
     
   <h2><span>选择商品图片</span><a style="" class="close-button" href="javascript:closeInfoWindow('infoWindow');">关闭</a></h2>
     
		<div style="width:600px; padding:10px; height:400px;">
			<div style="margin-top:10px;">
				<ul class="specification_ul">
				<%
					Vector datas = (Vector) JSPDataBean.getJSPData("productImages");
					for (int i = 0; i < datas.size(); ++i) {
						Hashtable data = (Hashtable) datas.get(i);
				%>
				  	<li class="imgBox" onClick="$(this).addClass('on').siblings().removeClass('on');">
				  		<div class="specification_li" onclick="$('#selectImageSrc').val('<%= AppUtil.getImageURL("product", data.get("image").toString(), 0) %>');$('#selectImageName').val('<%= data.get("image") %>');selectImage(this)">
				  			<img title="" style="margin: 0;padding: 0;max-width:100%;max-height: 100% " src="<%= AppUtil.getImageURL("product", data.get("image").toString(), 0, "") %>" />	
				  		</div>
				  	</li>
			  	<% } %>
			  	</ul>
			</div>
		</div>
		
	<div style="text-align: center;" class="buttonsDIV">
		<a class="btn_y" onclick="javascript:confirmSelectProductImage();"><span>确认</span></a>&nbsp;
		<a class="btn_y" onclick="javascript:closeInfoWindow('infoWindow');"><span>取消</span></a>
	</div>
</div>	

<input type="hidden" name="selectImageName" id="selectImageName"/>
<input type="hidden" name="selectImageSrc" id="selectImageSrc"/>
