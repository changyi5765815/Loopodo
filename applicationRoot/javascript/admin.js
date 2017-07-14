function jumpToPage() {
	var jumpToPageIndex = document.getElementById("pageIndexInput").value;
	var jumpToPageIndexValue = parseInt(jumpToPageIndex);
	if (!jumpToPageIndexValue) {
		alert("请输入一个正确的数值");
		document.getElementById("pageIndexInput").focus();
		return;
	}
	var jumpToPageMaxValue = parseInt(document.getElementById("pageCount").value);
	if (jumpToPageIndex < 1 || jumpToPageIndex > jumpToPageMaxValue) {
		alert("请输入一个介于1和" + jumpToPageMaxValue + "的数值");
		document.getElementById("pageIndexInput").focus();
		return;
	}
	showPage(jumpToPageIndex);
}

function jumpToPage2() {
	var jumpToPageIndex = document.getElementById("pageIndexInput2").value;
	var jumpToPageIndexValue = parseInt(jumpToPageIndex);
	if (!jumpToPageIndexValue) {
		alert("请输入一个正确的数值");
		document.getElementById("pageIndexInput2").focus();
		return;
	}
	var jumpToPageMaxValue = parseInt(document.getElementById("pageCount2").value);
	if (jumpToPageIndex < 1 || jumpToPageIndex > jumpToPageMaxValue) {
		alert("请输入一个介于1和" + jumpToPageMaxValue + "的数值");
		document.getElementById("pageIndexInput2").focus();
		return;
	}
	showPage2(jumpToPageIndex);
}

function returnCurrentPage() {
	clearFiles();
	showPage(document.getElementById("pageIndex").value);
}

function showPage(pageIndex) {
	document.getElementById("pageIndex").value = pageIndex;
//	postModuleAndAction(document.getElementById("pageModule").value, "list");
	postModuleAndAction(document.getElementById("pageModule").value, document.getElementById("pageAction").value);
}

function clearFiles() {
    var nodeArray = document.getElementsByTagName("input");
    for(i=0;i<nodeArray.length;i++) {
        var tmpobj = nodeArray[i];
        var stype = tmpobj.type;
        if (stype == "file") {
        	tmpobj.outerHTML=tmpobj.outerHTML;
        }
    }
}

function refreshDiscount(yiTiJia, shiChangJia){
	var discount = yiTiJia / shiChangJia +"";
	discount = discount.substring(0,4);
	if(isNaN(discount)){
		document.getElementById("discount").innerHTML="";
	} else {
		document.getElementById("discount").innerHTML=discount;
	}
}

//弹出Div效果
function setCoordination() {
    document.getElementById("mask").style.height = document.documentElement.clientHeight + "px";
    document.getElementById("mask").style.width = document.documentElement.clientWidth + "px";
}

function showWindow(displayedID) {
    var displayedWindow = document.getElementById(displayedID);
    var height = parseInt(displayedWindow.clientHeight);
    var width = parseInt(displayedWindow.clientWidth);
    var position = getPosition();
    var topAdded = (position.height - height) / 2;
//  var topAdded = (document.getElementById("wrapper").clientHeight - height ) / 2;
    var leftAdded = (position.width - width) / 2;

    displayedWindow.style.top = ( position.top + topAdded ) + "px";
    displayedWindow.style.left = ( position.left + leftAdded ) + "px";
    displayedWindow.style.visibility = "visible";
//    displayedWindow.style.display = "block";
    var mask = document.getElementById("mask");
    mask.style.visibility = "visible";
}

function hideWindow(hiddenID) {
    var hiddenWindow = document.getElementById(hiddenID);
    hiddenWindow.style.visibility = "hidden";
//   hiddenWindow.style.display = "none"; 
    var mask = document.getElementById("mask");
    mask.style.visibility = "hidden";
}

function getPosition() {
    var top    = 0;
    var left   = 0;
    var height = 0;
    var width  = 0;
    if (document.compatMode == "\"BackCompat\"") {
		width =document.documentElement.clientWidth;
		height = document.documentElement.clientHeight;
		left = document.documentElement.scrollLeft;
		top = document.documentElement.scrollTop;
	}
	else { 
		width = document.documentElement.clientWidth;
		height = document.documentElement.clientHeight;
		left = document.documentElement.scrollLeft == 0 ? document.body.scrollLeft : document.documentElement.scrollLeft;
		top = document.documentElement.scrollTop == 0 ? document.body.scrollTop : document.documentElement.scrollTop;
	} 
	return {top:top,left:left,height:height,width:width};
}

function openWindow(action) {
    try {
        document.getElementById("ajaxAction").value = action;
        refreshItem("windowInsideDIV");
    }
    catch(e) {
        alert("提交数据出错");
    }
}

function closeWindow() {
    document.getElementById("windowInsideDIV").innerHTML = "";
    hideWindow("infoWindow");
}

function trLine0(obj) {
    obj.onmouseover = function () {
        obj.style.backgroundColor = "#EEEEFF";
    }
    
    obj.onmouseout = function () {
        obj.style.backgroundColor = "#FFFFFF";
    }
}

function trLine1(obj) {
    obj.onmouseover = function () {
        obj.style.backgroundColor = "#EEEEFF";
    }
    
    obj.onmouseout = function () {
        obj.style.backgroundColor = "#ECE9D8";
    }
}

function closeInfoWindow() {
    document.getElementById("windowInsideDIV").innerHTML = "";
    hideWindow("infoWindow");
}

function calendar(object) {
    WdatePicker({onpicking:function () {
        object.focus();
    }, skin:"whyGreen", minDate:""});
}

var LastLeftID='';
function DoMenu(emid) {
	var obj = document.getElementById(emid); 
	obj.className = (obj.className.toLowerCase() == "expanded"?"collapsed":"expanded");
	if(LastLeftID!="" && LastLeftID!=emid) {
		document.getElementById(LastLeftID).className = "collapsed";
	}
	LastLeftID = emid;
}
function initIndexSelectedValues(index) {
    var valueString = ", " + document.getElementById("selectedValues"+index).value + ", ";
    var choices = document.getElementsByName("selectChoice"+index);
    for (var i = 0; i < choices.length; i++) {
        if (valueString.search(", " + choices[i].value + ", ") >= 0) {
            choices[i].checked = true;
        }
        else {
            choices[i].checked = false;
        }
    }
}

function setIndexSelectedValues(index) {
    var valueString = "";
    var choices = document.getElementsByName("selectChoice"+index);
    for (var i = 0; i < choices.length; i++) {
        if (choices[i].checked) {
            valueString += choices[i].value + ", ";
        }
    }
    valueString = valueString.substring(0, valueString.length - 2);
    document.getElementById("selectedValues"+index).value = valueString;
}



function confirmUploadImage() {
	var previewImg_window = $('#previewImg_window').attr('src');
	var tmpImage_window = $('#tmpImage_window').val();
	if (tmpImage_window == '') {
		alert('请先上传一张图片');
		return;
	}
	
	var imageNameHolderID = $('#imageNameHolderID').val();
	var imageSrcHolderID = $('#imageSrcHolderID').val();
	$('#' + imageSrcHolderID).attr('src', previewImg_window);
	$('#' + imageNameHolderID).val(tmpImage_window);
	
	closeInfoWindow();
	
	if ($('#pageModule').val() == 'activityPage') {
		postModuleAndAction('activityPage', 'pageElementConfirm');
	}
	
}

function confirmUploadImage2() {
	var previewImg_window = $('#previewImg_window').attr('src');
	var tmpImage_window = $('#tmpImage_window').val();
	if (tmpImage_window == '') {
		alert('请先上传一张图片');
		return;
	}
	
	$('#preViewWapImage').attr('src', previewImg_window);
	$('#wapImage').val(tmpImage_window);
	closeInfoWindow();
	
}

function getTimeMills() {
	var myDate = new Date();
	return myDate.getTime();
}

function setDataIndex() {
	var time = getTimeMills();
	$('#dataIndex').val(time);
}

function checkAdd(dataName) {
	var maxElementCount = $('#maxElementCount_' + dataName).val();
	var dataCount = $('#data_table_' + dataName).find('tr').length - 2;
	if (maxElementCount != '' && parseInt(dataCount) >= parseInt(maxElementCount)) {
		alert('该组最大元素个数为：' + maxElementCount + '，无法继续添加');
		return false;
	}
	
	return true;
}

function checkDelete(dataName) {
	var minElementCount = $('#minElementCount_' + dataName).val();
	var dataCount = $('#data_table_' + dataName).find('tr').length - 2;
	if (minElementCount != '' && parseInt(dataCount) <= parseInt(minElementCount)) {
		alert('该组最小元素个数为：' + minElementCount + '，无法继续删除');
		return false;
	}
	
	return true;
}

function selectAllCheckBox(id, selectChoiceName, saveValueElementID){
	var choices = $("input[name='" + selectChoiceName + "']");
	var topSelect = document.getElementById(id).checked;
    for (var i = 0; i < choices.length; i++) {
        choices[i].checked = topSelect;
    }
    setSelectedValues(selectChoiceName, saveValueElementID);
}

function jumpToWindowPage() {
	var jumpToPageIndex = document.getElementById("windowPageIndexInput").value;
	var jumpToPageIndexValue = parseInt(jumpToPageIndex);
	if (!jumpToPageIndexValue) {
		alert("请输入一个正确的数值");
		document.getElementById("windowPageIndexInput").focus();
		return;
	}
	var jumpToPageMaxValue = parseInt(document.getElementById("windowPageCount").value);
	if (jumpToPageIndex < 1 || jumpToPageIndex > jumpToPageMaxValue) {
		alert("请输入一个介于1和" + jumpToPageMaxValue + "的数值");
		document.getElementById("windowPageIndexInput").focus();
		return;
	}
	windowShowPage(jumpToPageIndex);
}
function windowShowPage(pageIndex) {
	document.getElementById("windowPageIndex").value = pageIndex;
	var module = document.getElementById('module').value;
	var action = document.getElementById('action').value;
	openInfoWindow(module, action);
}


function selectProductsCheck() {
	if (document.getElementById('selectedValues').value == '') {
		alert('请选择一个商品');
		return false;
	}  
	
	return true;
}

function changeEnable() {
	if (selectProductsCheck()) {
		doAction('changeEnable');
	}
}

function changeDisable() {
	if (selectProductsCheck()) {
		doAction('changeDisable');
	}
}


function doUploadFile(toDir, fileNameHolder, srcHolder, uploadItemType) {
	$('#uploadDir').val(toDir);
	$('#uploadItemType').val(uploadItemType);
	$('#imageNameHolderID').val(fileNameHolder);
	$('#imageSrcHolderID').val(srcHolder);
	openInfoWindow('uploadImageWindow');
}

function clearUploadFile(fileNameHolder, srcHolder) {
	$('#' + fileNameHolder).val('');
	$('#' + srcHolder).attr('src', '/images/none.jpg');
}

function doSelectFile(toDir, fileNameHolder, srcHolder, uploadItemType) {
	$('#uploadDir').val(toDir);
	$('#uploadItemType').val(uploadItemType);
	$('#imageNameHolderID').val(fileNameHolder);
	$('#imageSrcHolderID').val(srcHolder);
	openInfoWindow('selectProductImageWindow');
}

function selectImage(obj) {
	$('.specification_ul div.specification_li_on').attr('class', 'specification_li');
	$(obj).attr('class', 'specification_li_on');
	$(obj).children(".opt").show();
}

function selectValue(obj, checkboxName, saveSelectedCheckboxValueInputID) {
	var seletedValues = $('#' + saveSelectedCheckboxValueInputID).val();
	var curValue = $(obj).val();
	var curCheckFlag = $(obj).prop('checked');
	//curCheckFlag = (curCheckFlag == 'checked' ? true : false);
	if (curCheckFlag && ("," + seletedValues + ",").indexOf("," + curValue + ",") == -1) {
		if (seletedValues == '') {
			seletedValues = curValue;
		} else {
			seletedValues += ("," + curValue);
		}
	} 
	
	if (!curCheckFlag && ("," + seletedValues + ",").indexOf("," + curValue + ",") != -1) {
		seletedValues = ("," + seletedValues + ",").replace("," + curValue + ",", ",");
		
		if (seletedValues.length > 0) {
			if (seletedValues.substring(0,1) == ',') {
				seletedValues = seletedValues.substring(1, seletedValues.length - 1);
			}
			if (seletedValues.substring((seletedValues.length - 2),1) == ',') {
				seletedValues = seletedValues.substring(0, seletedValues.length - 2);
			}
		}
	}
	
    $('#' + saveSelectedCheckboxValueInputID).val(seletedValues);
}

function confirmSelectImage() {
	var selectedImage = $('#selectedImage').val();
	var selectedImageSrc = $('#selectedImageSrc').val();
	if (selectedImage == '') {
		 alert('请选择一张图片');
		 return;
	}
	
	if ($('#pageModule').val() == 'product') {
		confirmSelectImageOfProduct();
	} else {
		var imageNameHolderID = $('#imageNameHolderID').val();
		var imageSrcHolderID = $('#imageSrcHolderID').val();
		$('#' + imageSrcHolderID).attr('src', selectedImageSrc);
		$('#' + imageNameHolderID).val(selectedImage);
	} 
	closeInfoWindow();
}

function removeSku(skuID) {
	$('#sku_' + skuID + '_tr').remove();
	var hasSelectedValues = "," + $('#hasSelectedValues').val() + ",";
	var index = hasSelectedValues.indexOf("," + skuID + ",");
	if (index != -1) {
		hasSelectedValues = hasSelectedValues.replace("," + skuID + ",", ",");
	}
	
	$('#hasSelectedValues').val(hasSelectedValues);
}

function setDataLink(link) {
	if (link == '') {
		$('#show_link_a').attr('href', 'javascript:;');
		$('#show_link_a').hide();
	} else {
		$('#show_link_a').attr('href', link);
		$('#show_link_a').show();
	}
}

/*颜色选择*/
function colorPicker(elementID, saveColorValueID, curColor) {
	if (curColor == '') {
		$('#' + elementID).colpick({
	    	layout:'hex',
	    	submit:0,
	    	colorScheme:'dark',
	    	onChange:function(hsb,hex,rgb,el,bySetColor) {
	    		$(el).css('background-color','#'+hex);
	    		if(!bySetColor) $('#' + saveColorValueID).val('#' + hex);
	    	}
	    });
	} else {
		$('#' + elementID).colpick({
	    	layout:'hex',
	    	submit:0,
	    	colorScheme:'dark',
	    	color: curColor,
	    	onChange:function(hsb,hex,rgb,el,bySetColor) {
	    		$(el).css('background-color','#'+hex);
	    		if(!bySetColor) $('#' + saveColorValueID).val('#' + hex);
	    	}
	    });
	}
}
/*颜色选择*/

function selectCompanyUsers() {
	var pageModule = $('#pageModule').val();
	var pageAction = $('#pageAction').val();
	
	var selectedValues = $('#selectedValues').val();
	if (selectedValues == '') {
		alert('请选择企业');
	} else {
		doAction('addCompanyUsers');
	}
}