<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
 <link rel="stylesheet" type="text/css" href="css/sign_in.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script type="text/javascript">
<%
if("re".equals(request.getParameter("re"))){
	%>
	alert("비밀번호와 비밀번호 확인이 일치하지 않습니다");
<%
}else if("emtry".equals(request.getParameter("re"))){%>
	alert("입력하지 않은 항목이 있습니다");
	<%
}else if("same".equals(request.getParameter("re"))){%>
	alert("아이디가 중복됩니다.");
<%
}
%>
</script>
</head>
<body>
  <img src="" alt="">
    <center>
    <form class="signform" action="sign_in-db.jsp" method="post">
      <table class="signtable">
      <tr>
        <td>이름</td>
      </tr>
      <tr>
        <td><input type="text" id="signtext" name="name" style="font-size : 25px;"></td>
      </tr>
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
        <td><input type="password" id="signtext" name="pwd" style="font-size : 25px;"></td>
      </tr>
      <tr>
        <td>비밀번호 확인</td>
      </tr>
      <tr>
        <td><input type="password" id="signtext" name="repwd" style="font-size : 25px;"></td>
      </tr>
      </table> <br>
      <center>
      <input type="submit" name=""id="signbutton" value="회원가입">
      </center>
    </form>
    </center>
</body>
</html>