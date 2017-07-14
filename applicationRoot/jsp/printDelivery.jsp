<%@ page contentType="text/html;charset=UTF-8"%>
<jsp:directive.page import="java.util.Vector"/>
<jsp:directive.page import="java.util.Hashtable"/>
<jsp:directive.page import="simpleWebFrame.util.PriceUtil"/>

<jsp:useBean id="JSPDataBean" scope='request' class="simpleWebFrame.web.JSPDataBean" />

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>物流单打印</title>
</head>
<% if (JSPDataBean.getFormData("error").equals("")) { %>
<script type="text/javascript" src="/js/mootools2.js"></script>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td><div align="center"><div id="dly_printer" style="height:690.31496062992px;width:944.88188976378px">

</div></div></td>
  </tr>
</table>
<script>
	var swf = new Swiff('/flash/printermode.swf?1352110471', {
		width:  '90%',
		height: '85%',
		params:{wMode:false},
		id:'dly_printer_flash',
		container: $('dly_printer'),
		vars:{
			xml:'<printer picposition="0:0">' + 
					'<item><name>寄件人-单位</name><ucode>deliveryFromCompany</ucode><font>Arial</font><fontsize>12</fontsize><fontspace>0</fontspace><border>0</border><italic>0</italic><align>left</align><position><%= JSPDataBean.getOutputFormData("deliveryFromCompanyPosition") %></position></item>' +
					'<item><name>寄件人-姓名</name><ucode>deliveryFromPerson</ucode><font>Arial</font><fontsize>12</fontsize><fontspace>0</fontspace><border>0</border><italic>0</italic><align>left</align><position><%= JSPDataBean.getOutputFormData("deliveryFromPersonPosition") %></position></item>' +
					'<item><name>寄件人-电话</name><ucode>deliveryFromPhone</ucode><font>undefined</font><fontsize>14</fontsize><fontspace>0</fontspace><border>0</border><italic>0</italic><align>left</align><position><%= JSPDataBean.getOutputFormData("deliveryFromPhonePosition") %></position></item>' +
					'<item><name>寄件人-地址</name><ucode>deliveryFromAddress</ucode><font>Arial</font><fontsize>12</fontsize><fontspace>0</fontspace><border>0</border><italic>0</italic><align>left</align><position><%= JSPDataBean.getOutputFormData("deliveryFromAddressPosition") %></position></item>' + 
					'<item><name>寄件人-注意</name><ucode>deliveryAttention</ucode><font>Arial</font><fontsize>12</fontsize><fontspace>0</fontspace><border>0</border><italic>0</italic><align>left</align><position><%= JSPDataBean.getOutputFormData("deliveryFromAddressNextPosition") %></position></item>' + 
					'<item><name>寄件人-邮编</name><ucode>deliveryFromPostal</ucode><font></font><fontsize>14</fontsize><fontspace>0</fontspace><border>0</border><italic>0</italic><align>left</align><position><%= JSPDataBean.getOutputFormData("deliveryFromPostalPosition") %></position></item>' + 
			
					'<item><name>收货人-姓名</name><ucode>dly_name</ucode><font>Arial</font><fontsize>12</fontsize><fontspace>0</fontspace><border>0</border><italic>0</italic><align>left</align><position><%= JSPDataBean.getOutputFormData("shouHuoRenPosition")%></position></item>' +
					'<item><name>收货人-电话</name><ucode>dly_tel</ucode><font>undefined</font><fontsize>14</fontsize><fontspace>0</fontspace><border>0</border><italic>0</italic><align>left</align><position><%= JSPDataBean.getOutputFormData("mobilePosition")%></position></item>' +
					'<item><name>收货人-国家</name><ucode>dly_country</ucode><font></font><fontsize>12</fontsize><fontspace>0</fontspace><border>0</border><italic>0</italic><align>left</align><position><%= JSPDataBean.getOutputFormData("addressPosition") %></position></item>' +
					'<item><name>收货人-地址</name><ucode>dly_address</ucode><font>Arial</font><fontsize>12</fontsize><fontspace>0</fontspace><border>0</border><italic>0</italic><align>left</align><position><%= JSPDataBean.getOutputFormData("addressNextPosition")%></position></item>' + 
					'<item><name>收货人-邮编</name><ucode>dly_zip</ucode><font></font><fontsize>14</fontsize><fontspace>0</fontspace><border>0</border><italic>0</italic><align>left</align><position><%= JSPDataBean.getOutputFormData("postalCodePosition") %></position></item>' + 
				'</printer>',
			data:'<data>' +
					'<deliveryFromCompany><![CDATA[<%= JSPDataBean.getOutputFormData("deliveryFromCompany") %>]]></deliveryFromCompany>' +
					'<deliveryFromPerson><![CDATA[<%= JSPDataBean.getOutputFormData("deliveryFromPerson") %>]]></deliveryFromPerson>' +
					'<deliveryFromPhone><![CDATA[<%= JSPDataBean.getOutputFormData("deliveryFromPhone") %>]]></deliveryFromPhone>' +
					'<deliveryFromAddress><![CDATA[<%= JSPDataBean.getOutputFormData("deliveryFromAddress") %>]]></deliveryFromAddress>' +
					'<deliveryAttention><![CDATA[<%= JSPDataBean.getOutputFormData("deliveryFromAddressNext") %>]]></deliveryAttention>' +
					'<deliveryFromPostal><![CDATA[<%= JSPDataBean.getOutputFormData("deliveryFromPostal") %>]]></deliveryFromPostal>' +
					
					'<dly_name><![CDATA[<%= JSPDataBean.getOutputFormData("shouHuoRen") %>]]></dly_name>' +
					'<dly_tel><![CDATA[<%= JSPDataBean.getOutputFormData("mobile") %>]]></dly_tel>' +
					'<dly_country><![CDATA[<%= JSPDataBean.getOutputFormData("address") %>]]></dly_country>' +
					'<dly_address><![CDATA[<%= JSPDataBean.getOutputFormData("addressNext") %>]]></dly_address>' +
					'<dly_zip><![CDATA[<%= JSPDataBean.getOutputFormData("postalCode") %>]]></dly_zip>' +
				'</data>',
			bg:'<%= JSPDataBean.getOutputFormData("deliveryTypeImage") %>',
			copyright:'shopex'
		}
	});
</script>
<% } else { %>
<div><%=JSPDataBean.getFormData("error") %></div>
<% } %>
</html>