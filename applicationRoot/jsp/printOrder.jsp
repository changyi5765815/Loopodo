<%@ page contentType="text/html;charset=UTF-8"%>
<jsp:directive.page import="java.util.Vector"/>
<jsp:directive.page import="java.util.Hashtable"/>
<jsp:directive.page import="simpleWebFrame.util.PriceUtil"/>
<%@page import="admin.customer.guanwangbao.AppUtil"%>
<%@page import="admin.customer.guanwangbao.LocalDataCache"%>
<%@page import="admin.customer.guanwangbao.AppKeys"%>
<jsp:useBean id="JSPDataBean" scope='request' class="simpleWebFrame.web.JSPDataBean" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<title>订单打印</title>
</head>

<style type="text/css" media="print">
	.noprint{ display : none }
</style>
<style type="text/css" media="screen,print">
	.x-barcode{padding:0;margin:0}
	body { margin:0; font-family:Arial, Helvetica, sans-serif; font-size:12px;}
	.td_frame { padding:5px 0 5px 0; border-bottom:1px solid #000000; }
	img { padding:2px; border:0;}
	p { margin:8px 0 8px 0;}
	h1 { font-size:16px; font-weight:bold; margin:0;}
	h2 { font-size:14px; font-weight:bold; margin:0;}
	.table_data_title { font-size:14px; font-weight:bold; height:25px; }
	.table_data_content { height:20px; line-height:20px;}
	#print_confirm { width:100%;  height:30px;  border-top:1px solid #999999; padding-top:4px;   background-color:#5473ae; position:absolute; }
	#btn_print { width:71px; height:24px; background-image:url(/images/btn_print.gif); cursor:pointer; margin-left:auto; margin-right:auto;}
	#barcode { width:150px; height:50px; background:url(/images/bar_code.gif) no-repeat;}
</style>

<script type="text/javascript" src="/js/mootools.js"></script>
<script type="text/javascript">
<!--
Element.implement({
 zoomImg:function(maxwidth,maxheight,v){
	   if(this.getTag()!='img')return;
       var thisSize={'width':this.width,'height':this.height};
		   if (thisSize.width>maxwidth){
		      var overSize=thisSize.width-maxwidth;
			  var zoomSizeW=thisSize.width-overSize;
			  var zommC=(zoomSizeW/thisSize.width).toFloat();
			  var zoomSizeH=(thisSize.height*zommC).toInt();
			  $extend(thisSize,{'width':zoomSizeW,'height':zoomSizeH});
		   }
		   if (thisSize.height>maxheight){
		      var overSize=thisSize.height-maxheight;
			  var zoomSizeH=thisSize.height-overSize;
			  var zommC=(zoomSizeH/thisSize.height).toFloat();
			  var zoomSizeW=(thisSize.width*zommC).toInt();
			  $extend(thisSize,{'width':zoomSizeW,'height':zoomSizeH});
		   }
	   if(!v)return this.set(thisSize);
	   return thisSize;
	 }
  });

window.addEvents({
	"domready":function() {
		if($("chk_pic_print")){
			$("chk_pic_print").addEvent("click",function(e){
				$$("#print1 img").setStyle("display",(this.checked == false?"none":'inline'));
			});
		}
		if ($("chk_pic_print1")){
			$("chk_pic_print1").addEvent("click",function(){
				$$("#print2 img").filter(function(e){return e.className!='x-barcode'}).setStyle("display",(this.checked == false?"none":'inline'));
			   $("print_confirm").setStyle("top",document.documentElement.scrollTop + window.getHeight() - 35);
			});
			$("chk_address").addEvent("click",function(){
				$("print_address").setStyle("display",(this.checked == false?"none":'inline'));
			});
		}
		$("print_confirm").setStyle("top",window.getHeight() - 35);
		$("btn_print").addEvent("click",function(){window.print()});
	},
	"scroll":function() {  
		$("print_confirm").setStyle("top",window.getSize().y+window.getScrollTop() - 35);},
	"resize":function() {
		$("print_confirm").setStyle("top",window.getSize().y+window.getScrollTop() - 35);
	}
});
window.addEvent('load',function(){
     $$("img.product").each(function(img){
         var _imgsrc=img.src;
         new Asset.image(_imgsrc,{
          onload:function(){
                img.set(this.zoomImg(60,60,1)).set('align','absmiddle');
         }});
     });
});
//-->
</script>
<body>
<div id="print1">
	<table class="table_frame" width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
		  <tr>
		    <td>
			    <table width="100%" border="0" cellspacing="0" cellpadding="0">
			      <tr>
			        <td class="td_frame">
				        <table width="100%" border="0" cellpadding="0" cellspacing="0">
					        <tr>
						        <td>&nbsp;</td>
						        <td align="right"><div id="chk_print1" class="noprint"><input name="chk_pic_print" type="checkbox" id="chk_pic_print"  checked="checked" /><label class="label_pic_print" for="chk_pic_print">打印图片</label></div></td>
					        </tr>
					        <tr>
						        <td><img src="/images/logo-s.png" width="65"  /></td>
						        <td width="25%" align="right">
							        <p>收货人：<%= JSPDataBean.getFormData("shouHuoRen")%>&nbsp;&nbsp;</p>
							        <p>联系方式：<%= JSPDataBean.getFormData("phone")%>&nbsp;<%= JSPDataBean.getFormData("mobile") %></p>
						        </td>
					         </tr>
				        </table>
			        </td>
			      </tr>
			    </table>
		    </td>
		  </tr>
		  
		  <tr>
		    <td class="td_frame">
			    <table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
			      <tr>
			        <td><h2>订单号：<%= JSPDataBean.getFormData("shopOrderID")%></h2></td>
			        <td align="right"><h2>订购日期：<%= JSPDataBean.getFormData("orderTime")%></h2></td>
			      </tr>
			    </table>
		    </td>
		  </tr>
	  
		  <tr>
		    <td class="td_frame">
			    <table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
			      <tr class="table_data_title">
			        <td>No</td>
			        <td>商品ID</td>
			        <td>商品名称</td>
			        <td>单价</td>
			        <td>数量</td>
			        <td>小计</td>
			        <td>商品状态</td>
			      </tr>
			
					<%
				       	Vector orderItem = (Vector) JSPDataBean.getJSPData("itemDatas");
				       	int index = 0;
				       	for (int i = 0; i < orderItem.size(); ++i) {
				       		index++;
				       		Hashtable item = (Hashtable) orderItem.get(i);
				    %>
				    <tr style="padding-top: 10px">
				       <td><%= index %></td>
				       <td><%= item.get("productID") %></td>
				       <td>
				       		<%= item.get("name") %>&nbsp;
				       		<%= AppUtil.splitString(item.get("propName").toString(), 48) %>
				       </td>
				       <td>￥<%= PriceUtil.formatPrice(item.get("price").toString()) %>元</td>
				       <td><%= item.get("number") %></td>
				       <td>￥<%= PriceUtil.multiPrice(item.get("price").toString(), Integer.parseInt(item.get("number").toString())) %>元</td>
				       <td><%= "3".equals(item.get("status")) ? "已退货" : "正常" %></td>
				    </tr>
				    <% } %> 

			    </table>
		    </td>
		  </tr>
		  
		  <tr>
		    <td class="td_frame">
			    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
			      <tr>
			        <td width="80%" valign="top" style="height:80px;">
		        	<%
		        		Hashtable area = AppUtil.getArea(JSPDataBean.getFormData("townID"));
					%>
			        <p>地址：<%= area.get("provinceName") %>-<%= area.get("cityName") %>-<%= area.get("townName") %>-<%= JSPDataBean.getFormData("address") %></p>
			        <p>邮编：<%= JSPDataBean.getFormData("postalCode") %></p>
			        <p>备注：<%= JSPDataBean.getFormData("note")%></p>
			      	</td>
			        
			        <td width="20%" valign="top" align="right">
			        	<p>商品总金额：￥<%= JSPDataBean.getFormData("productMoney")%></p>
			          	<p>　配送费用：￥<%= JSPDataBean.getFormData("deliveryMoney")%></p>
			         </td>
			      </tr>
			    </table>
		    </td>
		  </tr>
		  
		  <tr>
		    <td class="">
			    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
			      <tr>
			        <td width="80%"><p>蜜品</p><p>http://<%=AppKeys.DOMAIN_WWW %></p></td>
			        <td width="20%" align="right"><h2>订单总金额：￥<%=JSPDataBean.getFormData("totalPrice").toString() %>元</h2></td>
			      </tr>
			    </table>
		    </td>
		  </tr>
	</table>
</div>
<div id="print_confirm" class="noprint"><div id="btn_print"></div></div>
</body>
</html>
