function confirmSelectProductImage() {
	var selectedImage = $('#selectImageName').val();
	var selectedImageSrc = $('#selectImageSrc').val();
	if (selectedImage == '') {
		 alert('请选择一张图片');
		 return;
	}
	var imageNameHolderID = $('#imageNameHolderID').val();
	var imageSrcHolderID = $('#imageSrcHolderID').val();
	$('#' + imageSrcHolderID).attr('src', selectedImageSrc);
	$('#' + imageNameHolderID).val(selectedImage);
	doAction('uploadSkuImage');
}

function addImage() {
	var tempI = $(".uploadUl").children().size();
	if (tempI - 1 >= 5) {
		alert("最大添加5张图片！");
		return;
	}
	
	var tempStr = "<div class='col-xs-2 col-md-2'>"
					+ "<div class='uploadImgDivImg' id='preViewDiv_" + tempI + "'>"
						+ "<img id='preView_" + tempI + "' src='/images/none.jpg' style='margin-top: 10px;' width='100' height='100'>"
						+ "<div id='image_" + tempI + "_WaitDiv' class='waitDiv'></div>"
					+ "</div>"
					+ "<div class='uploadImgDivBtn' style='border-bottom:0;'>"
						+ "<a href='javascript:;'>"
							+ "<span class='uploadImgSpanBtn' style='cursor: pointer;'" 
							+ " onclick=\"doUploadFile('product', 'image_" + tempI + "', 'preView_" + tempI + "', 'product');\">上传</span>"
						+ "</a>"
						+ "<a href='javascript:;' onclick=\"deleteImage('" + tempI + "');\">"
							+ "<span class='uploadImgSpanBtn' style='z-index: 20;position: relative; border-right:0;'>删除</span>"
						+ "</a>"
						+ "<div class='clear'></div>"
					+ "</div>"
					+ "<div class='uploadImgDivBtn'>"
						+ "<a href='javascript:changeMainImage();'>"
							+ "<span class='uploadImgSpanBtn' style='z-index: 20;position: relative;width:100%;'>设置为主图</span>"
						+ "</a>"
						+ "<div class='clear'></div>"
					+ "</div>"
					+ "<input type='hidden' id='image_" + tempI + "' name='image_" + tempI + "' value=''>"
					+ "<input type='hidden' id='oldImage_" + tempI + "' name='oldImage_" + tempI + "' value=''>"
				+ "</div>"; 
	$("#addImageLi").before(tempStr);
	initUploadImgDivImg();
	if($('.uploadUl').children().size() - 1 == 1) {
		$('.uploadUl').children().click();
	}
}
function initUploadImgDivImg() {
	$(".uploadUl .uploadImgDivImg").click(function(){
		if ($(this).children("img").attr("src") == "/images/none.jpg") {
			return;
		}
		$("#mainImageID").val($(this).attr("id").replace('preViewDiv_', ''));
		$(".uploadImgDivImg").css("border", "2px solid #ddd");
		$(this).css("border", "2px solid #F9BD3D");
	}).mouseover(function(){
		if ($(this).children("img").attr("src") == "/images/none.jpg") {
			return;
		}
		$(this).css("border", "2px solid #F9BD3D");
		$(this).css("cursor", "pointer");
		$(this).attr("title", "设为主图");
	}).mouseout(function(){
		if ($(this).attr("id").replace('preViewDiv_', '') == $("#mainImageID").val()) {
			return;
		}
		$(this).css("border", "2px solid #ddd");
	});
	
	$(".uploadImgDivBtn").find("a").click(function(){
		$(this).parent().parent().find(".uploadImgDivImg").click();
		$(".uploadUl").children().each(function(){
		var id2 = $(this).find("div").eq(0).attr("id").replace('preViewDiv_', '');
		if(id2 != '') {
				id += "," + id2;
			}
		});
	});
}

function deleteImage(id) {
	$("#image_" + id).val("");
	$("#preView_" + id).attr("src", "/images/none.jpg");
	$("#preViewDiv_" + id).css("border", "1px solid #DCDCDC");
	resetProductImages();
	resetMainImageID();
}

function resetProductImages() {
	var productImageIDs = '';
	var count = 0;
	$("input[id^='image_']").each(function(i){
		var id = $($("input[id^='image_']")[i]).attr('id').replace('image_', '');
		if ($("#image_" + id).val() != '') {
			productImageIDs += ((count != 0 ? "," : "") + id);	
			count++;
		}
	});
	$('#productImageIDs').val(productImageIDs);
}

function resetMainImageID() {
	var productImageIDs = $('#productImageIDs').val();
	var mainImageID = $('#mainImageID').val();
	var productImageID_array = productImageIDs.split(',');
	
	var newMainImageID = '';
	if (productImageID_array.length == 0) {
		newMainImageID = '';
	} else {
		for (var i = 0; i < productImageID_array.length; ++i) {
			if (mainImageID == productImageID_array[i]) {
				newMainImageID = productImageID_array[i];
				break;
			}
		}
	}
	
	if (newMainImageID != '') {
		$('#mainImageID').val(newMainImageID);
		$('#preViewDiv_' + newMainImageID).css("border", "2px solid #F9BD3D");
	} else if (productImageID_array.length > 0) {
		$('#mainImageID').val(productImageID_array[0]);
		$('#preViewDiv_' + productImageID_array[0]).css("border", "2px solid #F9BD3D");
	} else {
		$('#mainImageID').val('');
	}
}

//sku
function selectSkuProp() {
	setSelectedValues('skuPropID', 'skuPropIDs');
	refreshItem('product', 'skuSetting', 'skuSetting');
}

function selectSkuPropValue(skuPropID, saveValueInputID) {
	setSelectedValues(skuPropID, saveValueInputID);
	refreshItem('product', 'skuSetting', 'skuSetting');
}

function setSkuPropValueAlias(skuPropValueID) {
	var alias = $('#alias_' + skuPropValueID).val();
	if (alias == '') {
		alias = $('#old_propValueName_' + skuPropValueID).html();
	}
	if (alias.indexOf(',') != -1 || alias.indexOf(':') != -1 || alias.indexOf(';') != -1) {
		alert('自定义名称不能包含,号:号;号');
		return;
	}
	$("[data='skuPropValueName_" + skuPropValueID + "']").html(alias);
}

function deleteSkuImg(skuPropValueID) {
	$('#preViewSkuImg_' + skuPropValueID).attr('src', '/images/none.jpg');
	$('#skuImg_' + skuPropValueID).val('');
}
