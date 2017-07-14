<%@ page contentType="text/html;charset=UTF-8" %>
<%@page import="simpleWebFrame.web.JSPDataBean"%>

<%
	String frameHiddenHtml = JSPDataBean.getFrameHiddenHtml();
	if (frameHiddenHtml.equals("")) {
%>
<input type="hidden" name="module" id="module" value="<%= JSPDataBean.getFormData("module") %>" />
<input type="hidden" id="action" name="action" value="<%= JSPDataBean.getFormData("action") %>" />
<%	} else { %>
<%= frameHiddenHtml %>
<%	} %>

<%= JSPDataBean.getFormData("queryConditionHtml") %>

<input type="hidden" name="moduleBeforeAjax" id="moduleBeforeAjax" value="<%= JSPDataBean.getFormData("module") %>" />
<input type="hidden" id="pageModule" name="pageModule" value="<%= JSPDataBean.getFormData("module") %>" />
<input type="hidden" id="pageAction" name="pageAction" value="<%= JSPDataBean.getFormData("action") %>" />
<input type="hidden" id="pageIndex" name="pageIndex" value="<%= JSPDataBean.getFormData("pageIndex") %>" />
<input type="hidden" name="requestType" id="requestType" value="<%=JSPDataBean.getFormData("requestType") %>" />
<input type="hidden" name="ajaxAction" id="ajaxAction" value=""/>
<input type="hidden" name="checkUserID" id="checkUserID" value=""/>
<input type="hidden" name="table" id="table" value=""/>
<input type="hidden" name="sortIndexColumnName" id="sortIndexColumnName" value=""/>

<!-- 上传图片 -->
<input type="hidden" id="imageSrcHolderID" name="imageSrcHolderID" value="<%= JSPDataBean.getFormData("imageSrcHolderID")%>" />
<input type="hidden" id="imageNameHolderID" name="imageNameHolderID" value="<%= JSPDataBean.getFormData("imageNameHolderID")%>" />
<input type="hidden" id="uploadDir" name="uploadDir" value="<%= JSPDataBean.getFormData("uploadDir")%>" />
<input type="hidden" id="uploadItemType" name="uploadItemType" value="<%= JSPDataBean.getFormData("uploadItemType")%>" />

<%@include file="commonPageInit.jsp" %>

<span style="display:none;" id="hiddenSpan"></span>
<div id="mask"></div>
<div id="infoWindow" class="window">
	<table class="window">
		<tr>
			<td class="left_top"></td>
			<td class="border"></td>
			<td class="right_top"></td>
		</tr>
		<tr>
			<td class="border"></td>
			<td class="content" id="windowInsideDIV">
			</td>
			<td class="border"></td>
		</tr>
		<tr>
			<td class="left_bottom"></td>
			<td class="border"></td>
			<td class="right_bottom"></td>
		</tr>
	</table>
</div>
</form>
<iframe name="hiddenIframe" style="display:none"></iframe>
</body>
</html>

