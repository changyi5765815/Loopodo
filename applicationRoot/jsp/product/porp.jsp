<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="simpleWebFrame.web.JSPDataBean"%>
<%@page import="java.util.Vector"%>
<%@page import="java.util.Hashtable"%>


<%
	JSPDataBean JSPDataBean1 = (JSPDataBean) request.getAttribute("JSPDataBean");
	Vector properties = (Vector) JSPDataBean1.getJSPData("properties");
	Vector saleProperties = new Vector();
%>

<%-- if (properties.size() > 0) { %>
<div class="form-group">
	<label for="" class="col-sm-2 control-label">属性设置</label>
    <div class="col-sm-3"></div>
</div>

<div class="form-group">
<%
	int propCount = 0;
	for (int i = 0; i < properties.size(); i++) {
		Hashtable property = (Hashtable) properties.get(i);
		if (property.get("salePropFlag").toString().equals("1")) {
			saleProperties.add(property);
			continue;
		}
		propCount++;
%>
		<label for="" class="col-sm-<%= propCount % 2 == 0 ? "1" : "2" %> control-label"><%= property.get("name") %></label>
	    <div class="col-sm-3">
	    	<% if (!property.get("propTypeID").equals("3")) {%>
			<%= JSPDataBean1.getFormData("propertiesValue" + property.get("propertiesID") + "Select") %>
			<% } else { %>
			<input type="text" class="form-control" id="properties_<%= property.get("propertiesID") %>" name="properties_<%= property.get("propertiesID") %>" value="<%= JSPDataBean1.getFormData("properties_" + property.get("propertiesID")) %>" maxlength="100"/>
			<% } %>
	    </div>
	    <% if (propCount % 2 == 0) { %></div><div class="form-group"><% } %>
	<% } %>
</div>	
<% } --%>

<% if (properties.size() > 0) { %>
<th>属性设置：</th>

<td>
<table>
<%
	for (int i = 0; i < properties.size(); i++) {
		Hashtable property = (Hashtable) properties.get(i);
%>
		<tr><th><%= property.get("name") %>：</th>
	    <td>
	    	<% if (!property.get("propTypeID").equals("3")) { %>
			<%= JSPDataBean1.getFormData("propertiesValue" + property.get("propertiesID") + "Select") %>
			<% } else { %>
			<input type="text" id="properties_<%= property.get("propertiesID") %>" name="properties_<%= property.get("propertiesID") %>" value="<%= JSPDataBean1.getFormData("properties_" + property.get("propertiesID")) %>" maxlength="100"/>
			<% } %>
	    </td></tr>
	<% } %>
	</table>
</td>	
<% } %>