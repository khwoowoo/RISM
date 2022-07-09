<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file = "alert.jsp" %>
<%@ page import="java.text.*" %>
<% request.setCharacterEncoding("UTF-8"); %>
 <%
 	int id = Integer.parseInt(request.getParameter("id"));
 	String board_type = request.getParameter("board_type");
	String passwd="",sql,sql1;
	Connection conn = null;
	Statement stmt = null;
	ResultSet rs = null;
	String postid = null;
	
	String bt = board_type.replace("_board", "");
 	
	try{
		Class.forName("com.mysql.jdbc.Driver");
		String jdbcurl="jdbc:mysql://localhost:3306/rism?serverTimeZone=UTC";
		conn = DriverManager.getConnection(jdbcurl,"root","0000");
		stmt = conn.createStatement();
		sql="delete from " + bt + "_comment where id="+id;
		stmt.executeUpdate(sql);
	}
	catch(Exception e){
		out.println("DB 연동 오류 입니다." +e.getMessage());
	}
 %>
 <script>alert("선택한 댓글을 삭제했습니다.")
 		location.href = document.referrer;
 </script>