<%@page import="simpleWebFrame.util.StringUtil"%>
<%@ page contentType="text/html;charset=UTF-8"%>

<%@page import="java.util.Hashtable"%>
<%@page import="java.util.Vector"%>
<%@page import="simpleWebFrame.web.JSPDataBean"%>
<%@page import="admin.customer.guanwangbao.LocalDataCache"%>
<%@page import="admin.customer.guanwangbao.AppKeys"%>
<%@page import="admin.customer.guanwangbao.AppUtil"%>
<div>
    <div class="record">
    <table border="0" cellspacing="0" cellpadding="0" width="100%">
    <tr><td style="text-align:right;" width="20%">销售属性设置：</td><td>
    <%
    	JSPDataBean JSPDataBean_skuPropPage = (JSPDataBean) request.getAttribute("JSPDataBean");
			
   		Hashtable siteInfo_skuPropPage = new Hashtable();
			
		Vector skus = (Vector) JSPDataBean_skuPropPage.getJSPData("skus");
    	Hashtable selectedSkuProp_skuPropValues = new Hashtable(); //已选中的属性-属性值hashtable
    	Vector skuProps = LocalDataCache.getInstance().getSkuProps();
		Vector selectedSkuProps = new Vector();
		String[] columns = {"name"};
		AppUtil.convertToHtml(columns, skuProps);
		for (int i = 0; i < skuProps.size(); ++i) {
			Hashtable skuProp = (Hashtable) skuProps.get(i);
			String skuPropID = skuProp.get("skuPropID").toString();
			boolean selectedFlag = JSPDataBean_skuPropPage.getFormData("skuPropIDs").indexOf(skuPropID) != -1;
			if (selectedFlag) {
				selectedSkuProps.add(skuProp);
			}
    %>
    &nbsp;<input type="checkbox" name="skuPropID" id="skuPropID" <%= selectedFlag ? "checked='checked'" : "" %> value="<%= skuPropID %>" onclick="selectSkuProp()" disabled="disabled"/>
    <span><%= StringUtil.convertXmlChars(skuProp.get("name").toString()) %></span>
    
    <% } %>
    </td>
    </tr>
    </table>
    </div>
    
<div class="record">
<table border="0" cellspacing="0" cellpadding="0" width="100%">
<%
	for (int i = 0; i < selectedSkuProps.size(); i++) {
		Hashtable skuProp = (Hashtable) selectedSkuProps.get(i);
		String skuPropID = skuProp.get("skuPropID").toString();
		Vector skuPropValues = LocalDataCache.getInstance().getSkuPropValues(skuProp.get("skuPropID").toString());
		if (selectedSkuProp_skuPropValues.get(skuPropID) == null) {
			selectedSkuProp_skuPropValues.put(skuPropID, new Vector());
		}
%>

<tr>
	<td style="text-align:right;" width="20%"><%= skuProp.get("name") %>：</td>
    <td>
    <%
    	Vector selectedSkuPorpValues = new Vector();
		AppUtil.convertToHtml(columns, skuPropValues);
    	for (int j = 0; j < skuPropValues.size(); ++j) {
    		Hashtable skuPropValue = (Hashtable) skuPropValues.get(j);
    		String skuPropValueID = skuPropValue.get("skuPropValueID").toString();
    		boolean selectedFlag = JSPDataBean_skuPropPage.getFormData("skuPropValueIDs_" + skuPropID).indexOf(skuPropValueID) != -1;
			if (selectedFlag) {
				((Vector) selectedSkuProp_skuPropValues.get(skuPropID)).add(skuPropValue);
			}
    %>
    <input type="checkbox" name="skuPropValueID_<%= skuPropID %>" <%= selectedFlag ? "checked='checked'" : "" %> id="skuPropValueID_<%= skuPropID %>" value="<%= skuPropValueID %>" onclick="selectSkuPropValue('skuPropValueID_<%= skuPropID %>', 'skuPropValueIDs_<%= skuPropID %>')" />
    <span><%= StringUtil.convertXmlChars(skuPropValue.get("name").toString()) %></span>
    <% } %>
    </td>
</td>
<%-- 某一类属性下所有选中的属性值ID --%>
<input type="hidden" name="skuPropValueIDs_<%= skuPropID %>" id="skuPropValueIDs_<%= skuPropID %>" value="<%= JSPDataBean_skuPropPage.getFormData("skuPropValueIDs_" + skuPropID) %>" />
<% } %>
</table>
</div>

<div style="margin:10px;">
<table border="0" cellspacing="0" cellpadding="0" width="100%">
	<tr><td style="text-align:right;" width="20%">自定义属性：</td><td>
	    <table border="0" width="70%" id="dataTable" style="text-align:center;">
			<tr>
				<th width="20%">属性</th>
				<th width="25%">属性值</th>
				<th width="25%">自定义名称</th>
				<th width="30%">sku图片</th>
			</tr>
		    <% 
			    for (int i = 0; i < selectedSkuProps.size(); i++) {
					Hashtable skuProp = (Hashtable) selectedSkuProps.get(i);
					String skuPropID = skuProp.get("skuPropID").toString();
					Vector skuPropValues = (Vector) selectedSkuProp_skuPropValues.get(skuPropID);
					if (skuPropValues.size() == 0) {
						continue;
					}
			%>
		
			<%	
				for (int j = 0; j < skuPropValues.size(); ++j) {
					Hashtable skuPropValue = (Hashtable) skuPropValues.get(j);
					String skuPropValueID = skuPropValue.get("skuPropValueID").toString();
			%>
			<tr>
				<% if (j == 0) { %><td rowspan="<%= skuPropValues.size() %>"><%= StringUtil.convertXmlChars(skuProp.get("name").toString()) %></td><% } %>
				<td id="old_propValueName_<%= skuPropValueID %>"><%= StringUtil.convertXmlChars(skuPropValue.get("name").toString()) %></td>
				<td><input type="text" name="alias_<%= skuPropValueID %>" id="alias_<%= skuPropValueID %>" value="<%= StringUtil.convertXmlChars(JSPDataBean_skuPropPage.getFormData("alias_" + skuPropValueID)) %>" maxlength="20" onblur="setSkuPropValueAlias('<%= skuPropValueID %>')"/></td>
				<% if (skuProp.get("allowImageFlag").equals("1")) { %>
				<td>
					<span>
						<img id="preViewSkuImg_<%= skuPropValueID %>"  src="<%= AppUtil.getImageURL("sku", JSPDataBean_skuPropPage.getFormData("skuImg_" + skuPropValueID), 0) %>" style="width: 50px;height: 50px"/><br/>
						<input type="hidden" id="skuImg_<%= skuPropValueID %>" name="skuImg_<%= skuPropValueID %>" value="<%= JSPDataBean_skuPropPage.getFormData("skuImg_" + skuPropValueID) %>"/>
						<a href="javascript:doSelectFile('product', 'skuImg_<%= skuPropValueID %>', 'preViewSkuImg_<%= skuPropValueID %>', 'sku');">选择</a>
						<a href="javascript:deleteSkuImg('<%= skuPropValueID %>')">删除</a>
					</span>
				</td>
				<% } else { %>
				<td>该属性不支持图片</td>
				<% } %>
			</tr>
			<% } %>
			<% } %>
		</table>
    </td></tr>
    </table>
</div>


<%
	String[] skuPropValueNames = (String[]) JSPDataBean_skuPropPage.getJSPData("skuPropValueNames");
	if (skus.size() > 0) {
%>
<div>
</br>
<table border="0" cellspacing="0" cellpadding="0" width="100%">
	<tr><td style="text-align:right;" width="20%">库存价格设置：</td><td>
	    <table width="90%" id="dataTable" style="text-align:center;" id="dataTable">
			<tr>
				<th>属性</th>
				<th>商品条码</th>
				<th>价格</th>
				<th>库存</th>
			</tr>
		    <% 
		    	for (int i = 0; i < skus.size(); i++) {
		    		Hashtable sku = (Hashtable) skus.get(i);
		    		String skuID = sku.get("skuID").toString();
			%>
			<tr>
				<td>
				<%
	    			String aSkuProps = sku.get("props").toString();
	    			String[] skuPropValueArray = StringUtil.split(aSkuProps, ",");
	    			for (int j = 0; j < skuPropValueArray.length; ++j) {
	    				String skuPropValueID = StringUtil.split(skuPropValueArray[j], ":")[1];
	    				String skuPropValueName = LocalDataCache.getInstance().getTableDataColumnValue("skuPropValue", skuPropValueID, "name");
	    				String alias = JSPDataBean_skuPropPage.getFormData("alias_" + skuPropValueID);
	    				if (!alias.equals("")) {
	    					skuPropValueName = alias;
	    				}
				%>
				<span data="skuPropValueName_<%= skuPropValueID %>"><%= skuPropValueName %></span>
				<input type="hidden" name="sku_<%= skuID %>" id="sku_<%= skuID %>" value="<%= skuID %>" />
				<input type="hidden" name="skuProp_<%= skuID %>" id="skuProp_<%= skuID %>" value="<%= aSkuProps %>" />
				<% } %>
				</td>
				<td><input type="text" class="form-control input-sm m-bot15" name="skuBarCode_<%= skuID %>" name="skuBarCode_<%= skuID %>" value="<%= StringUtil.convertXmlChars(sku.get("barCode").toString()) %>" maxlength="50" /></td>
				<td><input type="text" class="form-control input-sm m-bot15" name="skuPrice_<%= skuID %>" name="skuPrice_<%= skuID %>" value="<%= sku.get("price") %>" maxlength="10" /></td>
				<td><input type="text" class="form-control input-sm m-bot15" name="skuStock_<%= skuID %>" name="skuStock_<%= skuID %>" value="<%= sku.get("stock") %>" maxlength="10" /></td>
			</tr>
			<% } %>
		</table>
    </td></tr>
    </table>
</div>
<% } %>

	<div align="center"></br>
		<div class="button">
			<a onclick="javascript:postModuleAndAction('product', 'defaultView')" class="btn_bb1"><span>返 回</span></a>
		</div>
		</br>
	</div>
<%-- 所有选中的销售属性ID --%>
<input type="hidden" name="skuPropIDs" id="skuPropIDs" value="<%= JSPDataBean_skuPropPage.getFormData("skuPropIDs") %>" />
