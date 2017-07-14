<%@page import="java.util.Hashtable"%>
<%@page import="simpleWebFrame.web.JSPDataBean"%>
<%@ page contentType="text/html;charset=UTF-8"%>

<% JSPDataBean JSPDataBean1 = (JSPDataBean) request.getAttribute("JSPDataBean"); %>

<%
	String promotionActiveTypeID = JSPDataBean1.getFormData("promotionActiveTypeID");
%>

<% if (promotionActiveTypeID.equals("1")) { %>
<tr>
    <th width="44%"><span class="red">* </span>满：</th>
	<td>
		<input type="text" name="value" id="value" value="<%= JSPDataBean1.getFormData("value") %>" maxlength="11"> 元
    </td>
</tr>

<tr>
    <th><span class="red">* </span>减：</th>
	<td>
		<input type="text" name="value2" id="value2" value="<%= JSPDataBean1.getFormData("value2") %>" maxlength="11"> 元
    </td>

</tr>
<% } else if (promotionActiveTypeID.equals("2")) { %>
<tr>
    <th width="44%"><span class="red">* </span>满：</th>
	<td>
		<input type="text" name="value" id="value" value="<%= JSPDataBean1.getFormData("value") %>" maxlength="11"> 元
    </td>
</tr>

<tr>
    <th width="44%"><span class="red">* </span>赠：</th>
	<td>
		<input type="text" name="value2" id="value2" value="<%= JSPDataBean1.getFormData("value2") %>" maxlength="11"> 元优惠券
    </td>
</tr>

<tr>
    <th width="44%"><span class="red">* </span>优惠券启用金额</th>
    <td>
		<input type="text" name="value3" id="value3" value="<%= JSPDataBean1.getFormData("value3") %>" maxlength="11"> 元
    </td>
</tr>

<tr>
    <th width="44%"><span class="red">* </span>优惠券有效期</th>
   <td>
		<input type="text" class="form-control" name="value4" id="value4" value="<%= JSPDataBean1.getFormData("value4") %>" maxlength="11"> 天
   </td>
</tr>
<% } else if (promotionActiveTypeID.equals("3") || promotionActiveTypeID.equals("4") || promotionActiveTypeID.equals("5")) { %>
<tr>
    <th width="44%"><span class="red">* </span>赠：</th>
	<td>
		<input type="text" name="value2" id="value2" value="<%= JSPDataBean1.getFormData("value2") %>" maxlength="11"> 元优惠券
    </td>
</tr>

<tr>
    <th width="44%"><span class="red">* </span>优惠券启用金额</th>
    <td>
		<input type="text" name="value3" id="value3" value="<%= JSPDataBean1.getFormData("value3") %>" maxlength="11"> 元
    </td>
</tr>

<tr>
    <th width="44%"><span class="red">* </span>优惠券有效期</th>
    <td>
		<input type="text" name="value4" id="value4" value="<%= JSPDataBean1.getFormData("value4") %>" maxlength="11"> 天
    </td>
</tr>
<% } %>

