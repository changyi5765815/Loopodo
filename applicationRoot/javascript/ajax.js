var ueditor;

function doAction(module, action) {
	var arguCount = arguments.length;
	if (arguCount == 1) {
		var trueModule = $('#pageModule').val();
		var trueAction = module;
		doAjax(trueModule, trueAction, 'hiddenSpan', '1');
	}  else {
		doAjax(module, action, 'hiddenSpan', '1');
	}
}

function openInfoWindow(module, action) {
	var arguCount = arguments.length;
	if (arguCount == 1) {
		var trueModule = $('#pageModule').val();
		var trueAction = module;
		doAjax(trueModule, trueAction, 'windowInsideDIV', '2');
	} else {
		doAjax(module, action, 'windowInsideDIV', '2');
	}
}

function refreshItem(module, action, item) {
	var arguCount = arguments.length;
	if (arguCount == 1) {
		var trueModule = $('#pageModule').val();
		var trueAction = 'refresh' + module;
		var trueItem = module;
		doAjax(trueModule, trueAction, trueItem, '3');
	} else if (arguCount == 2) {
		var trueModule = $('#pageModule').val();
		var trueAction = module;
		var trueItem = action;
		doAjax(trueModule, trueAction, trueItem, '3');
	} else {
		doAjax(module, action, item, '3');
	}
}

function refreshAppendItem(module, action, item) {
	var arguCount = arguments.length;
	if (arguCount == 1) {
		var trueModule = $('#pageModule').val();
		var trueAction = 'refresh' + module;
		var trueItem = module;
		doAjax(trueModule, trueAction, trueItem, '4');
	} else if (arguCount == 2) {
		var trueModule = $('#pageModule').val();
		var trueAction = module;
		var trueItem = action;
		doAjax(trueModule, trueAction, trueItem, '4');
	} else {
		doAjax(module, action, item, '4');
	}
}

function doAjax(module, action, item, type) {
	if (NProgress.status) {
		return;
	}
	NProgress.start();
	document.getElementById("requestType").value = type;
	document.getElementById("module").value = module;
	document.getElementById("action").value = action;
   
    var options = { 
		type:'POST', 
		dataType: 'html',
		success: function(html) {
			NProgress.done();
			if (type == '0') {
				$("[id^='ueditor_textarea']").remove();
			}
			
			try {
				if (type == '1') {
					eval(html);
				}
				else if (type == '2') {
					if (html.indexOf('reDispatchFlag') != -1) {
						html = html.replace('reDispatchFlag', '');
						eval(html);
					} else {
						$('#' + item).html(html);
						showWindow("infoWindow");
					}
   				} else if (type == '3') {
   					$('#' + item).html(html);
   				}  else if (type == '4') {
   					$('#' + item).append(html);
   				} else {
   					$('#' + item).html(html);
   				}
			} catch(e) {
		    } finally {
		    }
   		},
   		error: function() {
   			NProgress.done();
   			alert("服务器忙，请稍后重试！");
   		}
     };
    
    $('#mainForm').ajaxSubmit(options); 
}

function doGet(module, action, item) {
	if (NProgress.status) {
		return;
	}
	NProgress.start();
	document.getElementById("module").value = module;
	document.getElementById("action").value = action;
	
	$('#sys_hasModify').val('0');
	window.location.hash =  module + "/" + action;
   
     $.ajax({  type: "get",
        contentType: "application/html; charset=utf-8",
        dataType: "html",
        url: "/admin?module=" + module + "&action=" + action + "&time=" + new Date(),  //这里是网址,加上new Date()这个时间戳，防止360浏览器会根据请求地址一样的缓存
        success: function (data) {
        	NProgress.done();
        	$("[id^='ueditor_textarea']").remove();
			try {
		    	$('#' + item).html(data);
		    	
		    	$('#sys_hasModify').val('1');
			} catch(e) {
		    } finally {
		    }
        },
        error: function () {
        	$('#sys_hasModify').val('1');
			NProgress.done();
			alert("获取数据出错，请稍后重试！");
        }
    });
     
}

function initUeditor() {
	ueditor = UE.getEditor('ueditor');
	if (ueditor.getContentTxt() == "") {
		ueditor.execCommand( 'fontsize', '12px' );
	}
}


function showWindow(displayedID) {
    var displayedWindow = document.getElementById(displayedID);
    var height = parseInt(displayedWindow.clientHeight);
    var width = parseInt(displayedWindow.clientWidth);
    var position = getPosition();
    var topAdded = (position.height - height) / 2;
    var leftAdded = (position.width - width) / 2;

    displayedWindow.style.top = ( position.top + topAdded ) + "px";
    displayedWindow.style.left = ( position.left + leftAdded ) + "px";
    displayedWindow.style.visibility = "visible";
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

function closeWindow() {
	document.getElementById("windowInsideDIV").innerHTML = "";
    hideWindow("infoWindow");
}


function closeInfoWindow() {
	document.getElementById("windowInsideDIV").innerHTML = "";
    hideWindow("infoWindow");
}
