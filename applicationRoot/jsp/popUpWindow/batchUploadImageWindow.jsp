<%@ page contentType="text/html;charset=UTF-8"%>

<jsp:useBean id="JSPDataBean" scope='request' class="simpleWebFrame.web.JSPDataBean" />

<div id="popwindow">
<h2><span>图片上传</span><a style="" class="close-button" href="javascript:closeInfoWindow('infoWindow');">关闭</a></h2>

<div style="width:720px; padding:10px">
	<div style="margin-top:10px;">
		<div class="form-group">
			<div id="flashUploadContainer"></div>
		</div>
		<script type="text/javascript" src="/batchUploadImage/tangram.js"></script>
		<script type="text/javascript" src="/batchUploadImage/callbacks.js"></script>
		<script type="text/javascript" src="/batchUploadImage/flashParameters.js"></script>
		<script type="text/javascript">
			flashOptions.createOptions.vars.ext = '{"type":"product", "productID":"<%=JSPDataBean.getFormData("productID")%>"}';
			initFlash();
		</script>

	</div>
	
	<div style="text-align: center;" class="buttonsDIV">
		<%--<a class="btn_y" onclick="javascript:postModuleAndAction('product', 'productImageList');closeInfoWindow('infoWindow');"><span>关闭</span></a>--%>
		<div id="upload" style="display: none; margin:5px;">
					<img src="/batchUploadImage/upload.png" />
			</div>
	</div> 
</div>

</div>
