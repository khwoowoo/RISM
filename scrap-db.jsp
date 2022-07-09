<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file = "alert.jsp" %>
<%
   int postid = Integer.parseInt(request.getParameter("id"));
   String userid = (String)session.getAttribute("id");
   String posttype = request.getParameter("board_type");
   Connection conn = null;
   Statement stmt = null;
   ResultSet rs = null;
   String sql;
   int new_id = 0, cnt = 0;

   try{
      Class.forName("com.mysql.jdbc.Driver");
      String jdbcurl = "jdbc:mysql://localhost:3306/rism?serverTimezone=UTC";
      conn = DriverManager.getConnection(jdbcurl,"root","0000");
      stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
	  
      sql = "select * from scrap_tbl where userid='" + userid + "' and posttype='" + posttype + "' and postid=" + postid;   
      out.println(sql);
      rs = stmt.executeQuery(sql);
      rs.last();
      if(rs.getRow() > 0){
    	  %><script>alert("이미 스크랩한 게시물입니다.")</script><%
      }
      else{
    	  %><script>alert("스크랩을 성공했습니다.")</script><%
    	  String temp = "insert into scrap_tbl (postid, userid, posttype) values (";
    	  temp += postid +",";
    	  temp += "'" + userid +"',";
    	  temp += "'" + posttype +"');";
    	  stmt.executeUpdate(temp);
      }
      
   }
   catch(Exception e){
      out.println("DB 연동 오류 입니다. : "+e.getMessage());
   }
   

%>
   <%if("study_board".equals(posttype)){ %>
      <script>
      location.href="study_board.jsp?studyid=<%=request.getParameter("studyid")%>"</script>
   <%}else{ %>
      <script>
      location.href="<%=posttype%>.jsp"
      </script>
      <%} %>
