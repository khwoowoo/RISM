<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file = "alert.jsp" %>
<%@page import="java.io.*" %>
<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
      	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <meta charset="UTF-8">
    <link rel="stylesheet" type="text/css" href="css/mypage.css">

      <script>
      var canclick = false;
      $(document).ready(function(){
    	var link = document.location.href;
    	if(link.indexOf("?re") != -1){
    		location.href="mypage.jsp";
    	}
        $('#submit').click(function(){
          if(($("#name").prop('readonly'))==true){
          alert("회원정보를 수정할 수 있습니다");
          $("#name").prop("readonly",false);
          $("#birth").prop("readonly",false);
          $("#address").prop("readonly",false);
          $("#email").prop("readonly",false);
          $("#phone").prop("readonly",false);
          $("#profileimg").html("<span style='display:table-cell; vertical-align:middle;'>변경하려면 클릭하세요</span>");
          canclick=true;
        }
          else {
            alert('회원정보가 수정되었습니다. 적용에 잠시 시간이 걸릴 수 있습니다.');
            $("#name").prop("readonly",true);
            $("#birth").prop("readonly",true);
            $("#address").prop("readonly",true);
            $("#email").prop("readonly",true);
            $("#phone").prop("readonly",true);
            $("#profileimg").html("");
            canclick=false;
            $("#form").attr("onsubmit","return true");
          }
          $('#profileimg').click(function(){
          	if(canclick == true) document.all.file.click();
          })
        
     	});
      });
    </script>
    <title>마이페이지</title>
  </head>
  <body>
  <jsp:include page="menubar.jsp" flush="true"/>
  
    <content id="column">
    <form action="mypage-db.jsp" method ="post" id="form" enctype="multipart/form-data" onsubmit="return false">
      <left id="profile">
        <input type="submit" value="" id="submit" style="background-image : url(images/profile.png);" onchange="setThumb(event);">
        <div id="profileimg" style="display:table; text-align:center; background-image:url(profileimgs/<%=session.getAttribute("id")%>.png); background-size:cover;"></div>
        <br>
        
        <div class="priv">
<%
String id, title;
Connection conn = null;
Statement stmt = null;
String sql = null;
ResultSet rs = null;
int resultcnt = 0;
try {
	Class.forName("com.mysql.jdbc.Driver");
	String url = "jdbc:mysql://localhost:3306/rism?serverTimezone=UTC";
	conn = DriverManager.getConnection(url, "root", "0000");
	stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	sql = "select * from profile_tbl where id = '"+(String)session.getAttribute("id")+"'";
	rs = stmt.executeQuery(sql);
	rs.next();
    	
   	%> 
   	<input type="file" name="file" accept="image/gif, image/jpeg, image/png" style="display:none">
    <b>이름</b> <input type="text" value="<%=rs.getString("name")%>" id="name" name="name" readonly><br><br>
    <b>생년월일</b> <input type="text" value="<%=rs.getString("birth")%>" id="birth" name="birth" readonly><br><br>
    <b>주소</b> <input type="text" value="<%=rs.getString("address")%>" id="address" name="address" readonly><br><br>
    <b>이메일</b> <input type="text" value="<%=rs.getString("email")%>" id="email" name="email" readonly><br><br>
    <b>연락처</b> <input type="text" value="<%=rs.getString("phone")%>" id="phone" name="phone" readonly><br><br>
    <% 
}catch (Exception e){
   	out.println("prfile_tbl 연동 오류입니다.:" + e.getMessage());
}%>
       	</div>
        </left>
        </form>
        
        
      <div class="updown"></div>
      
      <div class="right" id="mypage">
        <div class="navi">
          <ul id="profile-ul">
            <li id="profile-li"><a href="mypage.jsp?type=scrap">MY SCRAP</a></li>
            <li id="profile-li"><a href="mypage.jsp?type=post">MY 게시물</a></li>
            <li id="profile-li"><a href="mypage.jsp?type=study">MY STUDY</a></li>
          </ul>
        </div>	
        <hr>
      
        
     
        <% 
        resultcnt = 0;
        String userid = (String)session.getAttribute("id");
        title="";
        
        /*
        스 크 랩
        */
	
    try {
        if("scrap".equals(request.getParameter("type"))){	
        %>
        <table class="table" align="center" width="603">
		<tr id="studytitle">
			<td class="f-child" align="left" border-left="1px solid #444444" width="375" bgcolor="#53BCA0">그룹이름</td>
			
			<td class="s-child" align="center" border-right="1px solid #444444" width="375" bgcolor="#53BCA0">멤버</td>
		</tr><%
			rs = null;
        	sql = "select * from scrap_tbl left join free_board on scrap_tbl.postid = free_board.id where scrap_tbl.userid = '"+userid+"' and scrap_tbl.posttype = 'free_board'";
        	rs = stmt.executeQuery(sql);
        	
        	while(rs.next()){
                	%>
                	<tr>
    				<td class="f-child"><%=rs.getString("free_board.title")%></td>
    				<td class="s-child" align="center">
    				<a href="free_board_show.jsp?id=<%=rs.getInt("free_board.id")%>"><img src="images/open-door.png" width="15px" height="15px;"></a><% 
                
			}	
			
			sql = "select * from scrap_tbl left join code_board on scrap_tbl.postid = code_board.id where scrap_tbl.userid = '"+userid+"' and scrap_tbl.posttype = 'code_board'";
        	rs = stmt.executeQuery(sql);
        	
        	while(rs.next()){
                	%>
                	<tr>
    				<td class="f-child"><%=rs.getString("code_board.title")%></td>
    				<td class="s-child" align="center">
    				<a href="code_board_show.jsp?id=<%=rs.getInt("code_board.id")%>"><img src="images/open-door.png" width="15px" height="15px;"></a><% 
                
			}
        	
			sql = "select * from scrap_tbl left join study_board on scrap_tbl.postid = study_board.id where scrap_tbl.userid = '"+userid+"' and scrap_tbl.posttype = 'study_board'";
        	rs = stmt.executeQuery(sql);
        	
        	while(rs.next()){
                	%>
                	<tr>
    				<td class="f-child"><%=rs.getString("study_board.title")%></td>
    				<td class="s-child" align="center">
    				<a href="study_board_show.jsp?id=<%=rs.getInt("study_board.id")%>&studyid=<%=rs.getInt("study_board.studyid")%>"><img src="images/open-door.png" width="15px" height="15px;"></a><% 
                
			}
        	%>
            </table><%
            
            /*
            내 가 쓴 게 시 글
            */
        
        } else if("post".equals(request.getParameter("type"))){ %>
			<table class="table" align="center" width="603">
			<tr id="studytitle">
				<td class="f-child"align="left" border-left="1px solid #444444" width="375" bgcolor="#53BCA0">제목</td>
				<td class="s-child" align="center" border-right="1px solid #444444" width="375" bgcolor="#53BCA0">게시글 이동</td>
			</tr><% 
			rs = null;
        	sql = "select * from free_board where free_board.userid = '" + userid + "'";
        	rs = stmt.executeQuery(sql);
        	
        	while(rs.next()){
                	%>
                	<tr>
    				<td class="f-child"><%=rs.getString("free_board.title")%></td>
    				<td class="s-child" align="center">
    				<a href="free_board_show.jsp?id=<%=rs.getInt("free_board.id")%>"><img src="images/open-door.png" width="15px" height="15px;"></a><% 
                
			}	
			
        	sql = "select * from code_board where code_board.userid = '" + userid + "'";
        	rs = stmt.executeQuery(sql);
        	
        	while(rs.next()){
                	%>
                	<tr>
    				<td class="f-child"><%=rs.getString("code_board.title")%></td>
    				<td class="s-child" align="center">
    				<a href="code_board_show.jsp?id=<%=rs.getInt("code_board.id")%>"><img src="images/open-door.png" width="15px" height="15px;"></a><% 
                
			}
        	
        	sql = "select * from study_board where study_board.userid = '" + userid + "'";
        	rs = stmt.executeQuery(sql);
        	
        	while(rs.next()){
                	%>
                	<tr>
    				<td class="f-child"><%=rs.getString("study_board.title")%></td>
    				<td class="s-child" align="center">
    				<a href="study_board_show.jsp?id=<%=rs.getInt("study_board.id")%>&studyid=<%=rs.getInt("study_board.studyid")%>"><img src="images/open-door.png" width="15px" height="15px;"></a><% 
                
			}
        	%>
	            </table>  
	            <%
        
        
        /*
        내 가 있 는 스 터 디
        */
	    
        
        
        }else if("study".equals(request.getParameter("type"))){
			%>
			<table class="table" align="center" width="603">
			<tr id="studytitle">
				<td class="f-child"align="left" border-left="1px solid #444444" width="275" bgcolor="#53BCA0">그룹이름</td>
				<td class="s-child" align="center" border-right="1px solid #444444" width="275" bgcolor="#53BCA0">스터디 게시판</td>
			</tr>
			<%
			rs = null;
        	sql = "select * from join_tbl left join study_tbl on join_tbl.studyid = study_tbl.studyid where join_tbl.userid = '" + userid + "'";
        	rs = stmt.executeQuery(sql);
        	
        	while(rs.next()){
                	%>
                	<tr>
    				<td class="f-child"><%=rs.getString("study_tbl.studyname")%></td>
    				<td class="s-child" align="center">
    				<a href="study_board_show.jsp?studyid=<%=rs.getInt("study_tbl.studyid")%>"><img src="images/open-door.png" width="15px" height="15px;"></a><% 
                
			}
			%>
	        </table>  <%
		}
        	rs.close();
        	stmt.close();
        	conn.close();
        }catch(Exception e){
        	out.println("연동 오류입니다.:" + e.getMessage());
        }
		%> 
		
      </div>
    </content>
  </body>
</html>
    