<%@ page contentType="text/html;charset=UTF-8"%>

<jsp:useBean id="JSPDataBean" scope='request' class="simpleWebFrame.web.JSPDataBean" />

<div id="popwindow">
<h2><span>上传图片</span><a style="" class="close-button" href="javascript:closeInfoWindow('infoWindow');">关闭</a></h2>

<div style="width:400px; padding:10px">
	<div style="margin-top:10px;">
	<table cellpadding="0" cellspacing="0">
			<tr>
				<td style="text-align: right;width: 30%">预览：</td>
				<td style="text-align: left;width: *">
					<img name='previewImg_window' id='previewImg_window' src="/images/none.jpg" width="120px" />
					<input type="hidden" id="tmpImage_window" name="tmpImage_window"  value=""/>
				</td>
			</tr>
			<tr style="height: 5px;">
				<td colspan="2">&nbsp;</td>
			</tr>
			<tr>
				<td style="text-align: right;width: 30%">选择图片：</td>
				<td style="text-align: left;width: *">
					<input type="file" id="uploadFile" name="uploadFile" 
						value="<%= JSPDataBean.getFormData("uploadFile") %>" 
						onchange="$('#confirmBut').css('display', 'none');$('#hasNotSend_img').css('display', '');doAction('uploadImage');">
				</td>
			</tr>
			<% if (JSPDataBean.getFormData("pageModule").equals("activityPage")) { %>
			<tr>
				<td colspan="2"><span style="color:red;">请上传宽度较大的图片（推荐宽度：1920），上传完毕后请设置该图层链接</span></td>
			</tr>
			<% } %>
		</table>
	</div>
	
	<div align="center" style="margin-top: 50px">
		<div class="textCenter" id="confirmBut">
				<button type="button" class="btn btn-primary" onclick="confirmUploadImage()">确认</button>
			</div>
		<div class="textCenter" id="hasNotSend_img" style="display: none;">
				<img src="/images/waitSendEmail.gif" />
			</div>
	</div>
</div>