<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.*" %>
<%@ include file = "alert.jsp" %>
<% request.setCharacterEncoding("UTF-8"); %>
 <%
 		boolean isSearch = false;
 		String comment = request.getParameter("comment");
 		String username = (String)session.getAttribute("name");
 		String userid = (String)session.getAttribute("id");
 		int postid = Integer.parseInt(request.getParameter("postid"));
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        
        System.out.print(comment);

        try { 
              Class.forName("com.mysql.jdbc.Driver");
              String jdbcurl = "jdbc:mysql://localhost:3306/rism?serverTimezone=UTC";
              conn = DriverManager.getConnection(jdbcurl, "root", "0000");
              stmt = conn.createStatement();
              
              String temp = String.format("insert into code_comment(postid, content, userid) values (%d, '%s', '%s');", postid, comment, userid);
          	  stmt.executeUpdate(temp);
              
        } 
        catch(Exception e) {
              out.println("DB 연동 오류입니다. : " + e.getMessage());
        }
        
        stmt.close();
        conn.close();
        
        response.sendRedirect("code_board_show.jsp?id="+request.getParameter("postid"));
   %>
   
   