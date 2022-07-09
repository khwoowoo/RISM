<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% if(null==(String)session.getAttribute("id")){
		%> 
		<script>
		alert("로그인을 먼저해주세요");
		location.href="login.jsp";
		</script>
		<%
		return;
}
%>
