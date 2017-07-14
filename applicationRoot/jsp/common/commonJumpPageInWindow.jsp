<%@ page contentType="text/html;charset=UTF-8" %>

<div class="page blue">
    <p class="floatl">
	    <table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td>
					<span style="float: right">
					共 <%= JSPDataBean.getFormData("windowCount") %> 个
					<a href="javascript:document.getElementById('windowPageIndexInput').value='1';jumpToWindowPage()">首页</a> 
					<a href="<%= Integer.parseInt(JSPDataBean.getFormData("windowPageIndex")) > 1 ? "javascript:document.getElementById('windowPageIndexInput').value='" + (Integer.parseInt(JSPDataBean.getFormData("windowPageIndex")) - 1) + "';jumpToWindowPage()" : "#" %>">上一页</a>
					<%= JSPDataBean.getFormData("windowPageIndex") %>/<%= JSPDataBean.getFormData("windowPageCount") %>页 
					<a href="<%= Integer.parseInt(JSPDataBean.getFormData("windowPageIndex")) < Integer.parseInt(JSPDataBean.getFormData("windowPageCount")) ? "javascript:document.getElementById('windowPageIndexInput').value='" + (Integer.parseInt(JSPDataBean.getFormData("windowPageIndex")) + 1) + "';jumpToWindowPage()" : "#" %>">下一页</a> 
					<a href="javascript:document.getElementById('windowPageIndexInput').value='<%= JSPDataBean.getFormData("windowPageCount") %>';jumpToWindowPage()">末页</a> 　
					转到：第 <input type="text" id="windowPageIndexInput" name="windowPageIndexInput" size="3" /> 页
					<input type="button" onclick="javascript:jumpToWindowPage()" value="Go" />
					</span>
					<p style="clear:both"></p>
				</td>
			</tr>
		</table>
		<input type="hidden" id="windowPageCount" name="windowPageCount" value="<%= JSPDataBean.getFormData("windowPageCount") %>" />
		<input type="hidden" id="windowPageIndex" name="windowPageIndex" value="<%= JSPDataBean.getFormData("windowPageIndex") %>" />
	</p>
    <div class="clear"></div>
</div>