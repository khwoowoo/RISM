<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" type="text/css" href="css/login.css">
<%
if("re".equals(request.getParameter("re"))){
   %>
   <script>alert("아이디 혹은 비밀번호를 확인해주세요");</script>
<%
}
%>
</head>
<body>
<center>
    <form class="signform" action="login-db.jsp" method="post">
      <table class="signtable">
      <tr>
        <td>아이디</td>
      </tr>
      <tr>
        <td><input type="text" id="signtext" name="id" style="font-size : 25px;"></td>
      </tr>
      <tr>
        <td>비밀번호</td>
      </tr>
      <tr>
        <td><input type="password" id="signtext" name="pwd" value="" style="font-size : 25px;"></td>
      </tr>
      </table> <br>
      <center>
      <input type="submit" name=""id="signbutton" value="로그인">
      </center>
    </form>
    </center>
</body>
</html>