<%@ page contentType="text/html;charset=UTF-8" %>

<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td>
			<span style="float: right">
			共 <%= JSPDataBean.getFormData("count2") %> 个
			<a href="javascript:document.getElementById('pageIndexInput2').value='1';jumpToPage2()">首页</a> 
			<a href="<%= Integer.parseInt(JSPDataBean.getFormData("pageIndex2")) > 1 ? "javascript:document.getElementById('pageIndexInput2').value='" + (Integer.parseInt(JSPDataBean.getFormData("pageIndex2")) - 1) + "';jumpToPage2()" : "#" %>">上一页</a>
			<%= JSPDataBean.getFormData("pageIndex2") %>/<%= JSPDataBean.getFormData("pageCount2") %>页 
			<a href="<%= Integer.parseInt(JSPDataBean.getFormData("pageIndex2")) < Integer.parseInt(JSPDataBean.getFormData("pageCount2")) ? "javascript:document.getElementById('pageIndexInput2').value='" + (Integer.parseInt(JSPDataBean.getFormData("pageIndex2")) + 1) + "';jumpToPage2()" : "#" %>">下一页</a> 
			<a href="javascript:document.getElementById('pageIndexInput2').value='<%= JSPDataBean.getFormData("pageCount2") %>';jumpToPage2()">末页</a> 　
			转到：第 <input type="text" id="pageIndexInput2" name="pageIndexInput2" size="3" /> 页
			<input type="button" onclick="javascript:jumpToPage2()" value="Go" />
			</span>
			<p style="clear:both"></p>
		</td>
	</tr>
</table>

<input type="hidden" id="pageCount2" name="pageCount2" value="<%= JSPDataBean.getFormData("pageCount2") %>" />
<input type="hidden" id="pageIndex2" name="pageIndex2" value="<%= JSPDataBean.getFormData("pageIndex2") %>" />
