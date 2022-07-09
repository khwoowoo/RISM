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
	
	name = request.getParameter("name");
	id = request.getParameter("id");
	pwd = request.getParameter("pwd");
	repwd = request.getParameter("repwd");
	
	if(!name.equals("")&&!id.equals("")&&!pwd.equals("")&&!repwd.equals("")){
	if(pwd.equals(repwd)){	
	try{
		Class.forName("com.mysql.jdbc.Driver");
		String jdbcurl = "jdbc:mysql://localhost:3306/rism?serverTimezone=UTC";
		conn = DriverManager.getConnection(jdbcurl,"root","0000");
		stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
		sql = "select*from profile_tbl where id='"+id+"'";
		rs = stmt.executeQuery(sql);
		
		while(rs.next()){
			if(id.equals(rs.getString("id"))){
				response.sendRedirect("sign_in.jsp?re=same");
				return;
			}
		}
		stmt.executeUpdate("insert into profile_tbl (id,pwd,name) values ('"+id+"','"+pwd+"','"+name+"') ");	
	}
	catch(Exception e){
		out.println("DB 연동 오류 입니다. : "+e.getMessage());
	}
	
	response.sendRedirect("index.jsp");
	}//if
	else{
		response.sendRedirect("sign_in.jsp?re=re");
		
	}//else
	}
	else{
		response.sendRedirect("sign_in.jsp?re=emtry");
	}

	
%>
