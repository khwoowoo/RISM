<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<% request.setCharacterEncoding("UTF-8");%>
<%
   String studyid = request.getParameter("studyid");
   String userid = (String)session.getAttribute("id");
   int new_id=0,cnt=0;
   
   Connection conn = null;
   Statement stmt = null;
   ResultSet rs = null;
   String sql;
   try{
      Class.forName("com.mysql.jdbc.Driver");
      String jdbcurl = "jdbc:mysql://localhost:3306/rism?serverTimezone=UTC";
      conn = DriverManager.getConnection(jdbcurl,"root","0000");
      stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
      sql = "select * from join_tbl where userid='"+userid+"'";
      rs = stmt.executeQuery(sql);
      
      while(rs.next()){
         if(studyid.equals(rs.getString("studyid"))){
            %> 
            <script>
            alert("이미 가입된 스터디입니다.");
            location.href="study.jsp";
            </script>
            <%
            return;
         }
         
      }
   }catch(Exception e){
      out.println("종복DB 연동 오류 입니다. : "+e.getMessage());
   }
      
   try{
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
   
   try{
      Class.forName("com.mysql.jdbc.Driver");
      String jdbcurl = "jdbc:mysql://localhost:3306/rism?serverTimezone=UTC";
      conn = DriverManager.getConnection(jdbcurl,"root","0000");
      stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
      sql = "select * from study_tbl where studyid = '"+studyid+"'";
      rs = stmt.executeQuery(sql);
      
      while(rs.next()){
         int studynum = Integer.parseInt(rs.getString("studynum"));
         studynum++;
         stmt.executeUpdate("update study_tbl set studynum = '"+studynum+"' where studyid ='"+studyid+"'");
      }
   }catch(Exception e){
      out.println("DB 연동 오류 입니다. : "+e.getMessage());
   }
      
            
%>
   <script>location.href="study.jsp"</script>
