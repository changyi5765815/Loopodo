<%@ page contentType="text/html;charset=UTF-8"%>
<jsp:directive.page import="simpleWebFrame.util.StringUtil" />
<jsp:directive.page import="java.util.Vector" />
<jsp:directive.page import="java.util.Hashtable" />
<%@page import="admin.customer.guanwangbao.AppUtil"%>
<jsp:useBean id="JSPDataBean" scope='request' class="simpleWebFrame.web.JSPDataBean" />

<style>
.tubiaoWrap{
	width: 110px; 
	height: 105px; 
	overflow: hidden; 
	float: left;
	margin-top: 10px;
	border: 1px solid #ddd;
	border-radius: 5px;
	margin-right: 10px;
}
.tubiaoWrap.on{
	width: 108px;
	height: 103px;
	border: 2px solid #e4393c;
	color: #e4393c;
	background: url(/images/newicon.png) no-repeat right bottom;
}
</style>

<div id="popwindow">
     
   <h2><span>图片库</span><a style="" class="close-button" href="javascript:closeInfoWindow('infoWindow');">关闭</a></h2>
     
		<div style="width:600px; padding:10px; height:400px;">
			<div style="margin-top:10px;">
				<ul class="specification_ul">
				<%
					Vector datas = (Vector) JSPDataBean.getJSPData("datas");
					for (int i = 0; i < datas.size(); ++i) {
						Hashtable data = (Hashtable) datas.get(i);
						String name = data.get("name").toString();
				%>
				  	<li class="tubiaoWrap" onClick="$(this).addClass('on').siblings().removeClass('on');">
				  		<div class="specification_li" onclick="$('#selectedImage').val('/uploadFile/default/<%= data.get("image") %>');$('#selectedImageSrc').val('/uploadFile/default/<%= data.get("image") %>');selectImage(this)">
				  			<table width="100%" height="100px" cellpadding="0" cellspacing="0" class="" >
								<tbody>
								<tr>
								<td valign="middle" style="border: none;text-align: center;height: 100px">
									<img title="<%= name %>" style="margin: 0;padding: 0;max-width:100px;max-height: 100px " src="/uploadFile/default/<%= data.get("image") %>" />									
								</td>
								</tr>
								</tbody>
							</table>
				  		</div>
				  	</li>
			  	<% } %>
			  	</ul>
			</div>
		</div>
		
	<div style="text-align: center;" class="buttonsDIV">
		<a class="btn_y" onclick="javascript:confirmSelectImage();"><span>确认</span></a>&nbsp;
		<a class="btn_y" onclick="javascript:closeInfoWindow('infoWindow');"><span>取消</span></a>
	</div>
</div>	

<input type="hidden" name="selectedImage" id="selectedImage"/>
<input type="hidden" name="selectedImageSrc" id="selectedImageSrc"/>
