<%@ page contentType="text/html;charset=UTF-8" %>
<script type="text/javascript">
	ueditor.ready(function() {
		if (ueditor.getContentTxt() == "") {
			ueditor.execCommand( 'fontsize', '12px' );
		}
	});
</script>