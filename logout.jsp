<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<% HttpSession sess = request.getSession(false);
if(sess!=null){
	session.invalidate();
}
%>
<script>location.href="index.jsp"</script>