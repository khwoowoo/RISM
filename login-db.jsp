<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
	request.setCharacterEncoding("UTF-8");
	String name, id, pwd,repwd;
	Connection conn = null;
	Statement stmt = null;
	ResultSet rs = null;
	String sql;
	
	id = request.getParameter("id");
	pwd = request.getParameter("pwd");
	
	try{
		Class.forName("com.mysql.jdbc.Driver");
		String jdbcurl = "jdbc:mysql://localhost:3306/rism?serverTimezone=UTC";
		conn = DriverManager.getConnection(jdbcurl,"root","0000");
		stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
		sql = "select * from profile_tbl where id='"+id+"'";
		rs = stmt.executeQuery(sql);
	}
	catch(Exception e){
		out.println("DB 연동 오류 입니다. : "+e.getMessage());
	}
	while(rs.next()){
		if(pwd.equals(rs.getString("pwd"))){
			name=rs.getString("name");
			pwd=rs.getString("pwd");
			session.setAttribute("id", id);
			session.setAttribute("name", name);
			%>
			<script>location.href="index.jsp"</script>
			<%
			return;
		}
	}
	%>
	<script>location.href="login.jsp?re=re"</script>
	<%
	
	stmt.close();
	conn.close();
%>