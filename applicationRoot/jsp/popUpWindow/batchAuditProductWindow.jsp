<%@ page contentType="text/html;charset=UTF-8"%>
<jsp:directive.page import="java.util.Vector"/>
<jsp:directive.page import="java.util.Hashtable"/>

<jsp:useBean id="JSPDataBean" scope='request' class="simpleWebFrame.web.JSPDataBean" />

<div id="popwindow">
<h2><span>商品审核</span><a style="" class="close-button" href="javascript:closeInfoWindow('infoWindow');">关闭</a></h2>
<div style="width:420px; padding:10px">
	<div style="margin-top:10px;height:auto;">
		<table cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td width="120px" align="right" style="height:30px;font-weight:bold;"><span class="red">* </span>审核结果：</td>
				<td width="220px">
					<select name="auditStatus" id="auditStatus">
						<option value="20">通过</option>
						<option value="90">不通过</option>
					</select>
				</td>
			</tr>
			<tr>
				<td width="120px" align="right" style="height:30px;font-weight:bold;">审核备注：</td>
				<td width="220px"><textarea class="form-control" style="weight:100px;" name="auditNote" id="auditNote" onkeyup="if(this.value.length > 100) this.value=this.value.substr(0,100)"></textarea></td>
			</tr>
		</table>
	</div>
</div>
		<div>
			<div style="text-align: center;" class="buttonsDIV">
			<a class="btn_y" onclick="doAction('product', 'batchAuditProduct')"><span>确认</span></a>&nbsp;
			<a class="btn_y" onclick="javascript:closeInfoWindow('infoWindow');"><span>取消</span></a>
			</div>
		</div>
</div>