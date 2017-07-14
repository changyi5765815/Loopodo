<%@ page contentType="text/html;charset=UTF-8"%>
<jsp:directive.page import="java.util.Vector"/>
<jsp:directive.page import="java.util.Hashtable"/>

<jsp:useBean id="JSPDataBean" scope='request' class="simpleWebFrame.web.JSPDataBean" />

<div id="popwindow">
<h2><span>发送测试邮件</span><a style="" class="close-button" href="javascript:closeInfoWindow('infoWindow');">关闭</a></h2>
<div style="width:420px; padding:10px">
	<div style="margin-top:10px;height:auto;">
		<table cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td width="120px" align="right" style="height:30px;font-weight:bold;"><span class="red">* </span>收件人：</td>
				<td width="220px">
					<input type="text" name="toMail" id="toMail" maxlength="50">
				</td>
			</tr>
			<tr>
				<td width="120px" align="right" style="height:30px;font-weight:bold;"><span class="red">* </span>邮件标题：</td>
				<td width="220px">
					<input type="text" name="subject" id="subject" maxlength="50">
				</td>
			</tr>
			<tr>
				<td width="120px" align="right" style="height:30px;font-weight:bold;"><span class="red">* </span>内容：</td>
				<td width="220px">
					<textarea style="width:200px;" name="body" id="body" onkeyup="if(this.value.length>500)this.value=this.value.substring(0,500)"></textarea>
				</td>
			</tr>
			<tr>
				<td width="120px" align="right" style="height:30px;font-weight:bold;"><span class="red">* </span>验证码：</td>
				<td width="220px">
					<span>
					<input name="randomString" id="randomString" class="box" tabindex="1" value="" type="text" size="10" maxlength="4" style="width: 85px;"/></span>
					<img id="randomNumberImage" src="randomNumberImage" height="24" width="80" align="absmiddle"/> 
					<span class="grayq font12"><a href="javascript:changeRandomImage()">看不清？</a></span>
				</td>
			</tr>
		</table>
	</div>
</div>
		<div>
			<div style="text-align: center;" class="buttonsDIV">
			<a class="btn_y" onclick="doAction('sysConfig', 'testSendMail');"><span>发  送</span></a>&nbsp;
			<a class="btn_y" onclick="javascript:closeInfoWindow('infoWindow');"><span>取消</span></a>
			</div>
		</div>
</div>