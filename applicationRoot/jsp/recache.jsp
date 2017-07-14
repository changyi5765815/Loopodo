<%@ page contentType="text/html;charset=UTF-8"%>
<jsp:directive.page import="simpleWebFrame.web.FrameKeys"/>

<jsp:useBean id="JSPDataBean" scope='request' class="simpleWebFrame.web.JSPDataBean" />
<script>
alert('<%= JSPDataBean.getControlData(FrameKeys.INFO_MESSAGE) %>');
</script>
