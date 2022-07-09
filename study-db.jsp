<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ include file = "alert.jsp" %>
<%@ page import="java.sql.*" %>
<%
   request.setCharacterEncoding("UTF-8");   
   String name, id, pwd,repwd;
   Connection conn = null;
   Statement stmt = null;
   ResultSet rs = null;
   String sql;
   
   int new_id =0, cnt=0;
   String studyname = request.getParameter("studyname");
   String studycontent = request.getParameter("studycontent");
   String userid = (String)session.getAttribute("id");
   int studynum =1;
   String studyid="";
   
   try{
      Class.forName("com.mysql.jdbc.Driver");
      String jdbcurl = "jdbc:mysql://localhost:3306/rism?serverTimezone=UTC";
      conn = DriverManager.getConnection(jdbcurl,"root","0000");
      stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
      sql = "select max(studyid) as max_studyid, count(*) as cnt from study_tbl";   
      rs = stmt.executeQuery(sql);
      
      while(rs.next()){
         cnt= Integer.parseInt(rs.getString("cnt"));
         if(cnt!=0)
            new_id = Integer.parseInt(rs.getString("max_studyid"));
      }
      new_id++;
      studyid=Integer.toString(new_id);
      
   sql = "insert into study_tbl values('"+new_id+"','"+studyname+"','"+studycontent+"','"+studynum+"')";   
   stmt.executeUpdate(sql);
   %>
   <script>alert("스터디가 성공적으로 생성되었습니다")
   location.href="study.jsp";</script>
   <%
   }
   catch(Exception e){
      out.println("DB 연동 오류 입니다. : "+e.getMessage());
      out.println("insert into study_tbl values('"+new_id +"','"+studyname+"','"+studycontent +"','"+studynum+"')");
   }
   
   try{
      new_id=0;cnt=0;
      Class.forName("com.mysql.jdbc.Driver");
      String jdbcurl = "jdbc:mysql://localhost:3306/rism?serverTimezone=UTC";
      conn = DriverManager.getConnection(jdbcurl,"root","0000");
      stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
      sql = "select max(id) as max_id, count(*) as cnt from join_tbl";
      rs = stmt.executeQuery(sql);
   
      while(rs.next())
      {
         cnt = Integer.parseInt(rs.getString("cnt"));
         if(cnt != 0) new_id = Integer.parseInt(rs.getString("max_id"));
         break;
      }
      new_id++;
      
   }catch(Exception e){
      out.println("DB 연동 오류 입니다. : "+e.getMessage());
   }
   try{   
      stmt.executeUpdate("insert into join_tbl values('"+new_id+"','"+studyid+"','"+userid+"')");
      rs.close();
   }
   catch(Exception e){
      out.println("DB 연동 오류 입니다. : "+e.getMessage());
   }
%>