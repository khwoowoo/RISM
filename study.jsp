<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
    <%@ page import="java.sql.*" %>
    <%@ include file = "alert.jsp" %>
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" type="text/css" href="css/study.css">
</head>
<body>
<jsp:include page="menubar.jsp" flush="true"/>
<div class="elecenter" style="height:calc(100vh - 50px)">
<div class="linevert" style="overflow: auto; margin:10px; border:10px solid white">
<div class="navi">
<div>
<ul class = "navi-ul">
<li class = "navi-li"><a href="study.jsp">전체 그룹</a></li>
<li class = "navi-li"><a href="study.jsp?type=mygroup">나의 그룹</a></li>
<li class = "navi-li"><a href="study.jsp?type=makegroup">그룹 만들기</a></li>
</ul>
</div>
</div>
<hr>
	<% if("makegroup".equals(request.getParameter("type"))){
		%>
		<form class="signform" action="study-db.jsp" method="post">
      <table class="signtable">
      <tr>
        <td><input type="text" placeholder="스터디 이름을 입력하시오." id="studyname" name="studyname"></td>
      </tr>
      <tr><td><hr></td></tr>
      <tr>
        <td><textarea name="studycontent" id="signtext" rows="18" cols="62" placeholder="글을 입력해주세요"required></textarea> </td>
      </tr>
      </table> <br>
      <center>
      <input type="submit" name=""id="submitbutton" value="스터디생성">
      </center>
    </form>
   
	<% }
	else if("mygroup".equals(request.getParameter("type"))){%>
		<table class="table" align="center" width="603">
		<tr id="studytitle">
			<td id="f-child"align="left" border-left="1px solid #444444" width="275" bgcolor="#53BCA0">그룹이름</td>
			<td id="s-child" align="center" border-right="1px solid #444444" width="275" bgcolor="#53BCA0">멤버</td>
		</tr>
		<%
		String userid = (String)session.getAttribute("id");
		try {
        	Class.forName("com.mysql.jdbc.Driver");
        	String url = "jdbc:mysql://localhost:3306/rism?serverTimezone=UTC";
        	Connection conn = DriverManager.getConnection(url, "root", "0000");
        	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
        	String sql = "select * from join_tbl where userid = '"+userid+"'";
        	ResultSet rs = stmt.executeQuery(sql);
        	
        	while(rs.next()){
        	 	int studyid =  Integer.parseInt(rs.getString("studyid"));
                try {
                	Class.forName("com.mysql.jdbc.Driver");
                	String url_st = "jdbc:mysql://localhost:3306/rism?serverTimezone=UTC";
                	Connection conn_st = DriverManager.getConnection(url_st, "root", "0000");
                	Statement stmt_st = conn_st.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
                	String sql_st = String.format(" select*from study_tbl where studyid=%d",studyid);
                	ResultSet rs_st = stmt_st.executeQuery(sql_st);
                	while(rs_st.next()){
                	String studyname = rs_st.getString("studyname");
                	studyid =  Integer.parseInt(rs_st.getString("studyid"));
                	%>
                	<tr>
						<td id="f-child"><%=studyname %></td>
						<td id="s-child" align="center">게시판 이동
						<a href="study_board.jsp?studyid=<%=rs.getString("studyid")%>"><img src="images/open-door.png" width="15px" height="15px;"></a>
					</td>
					</tr>
              
                		 <%  
                	}  
                }catch (Exception e){
                	out.println("DB 연동 오류입니다.:" + e.getMessage());
                }
        	}%></table><%
        	rs.close();
        }catch(Exception e){
        	out.println("연동 오류입니다.:" + e.getMessage());
        }
        }
	else if("detail".equals(request.getParameter("type"))){
		Connection conn = null;
        Statement stmt = null;
        String sql = null;
        ResultSet rs = null;
        String studyid = request.getParameter("group");
        
		
		try {
        	Class.forName("com.mysql.jdbc.Driver");
        	String url = "jdbc:mysql://localhost:3306/rism?serverTimezone=UTC";
        	conn = DriverManager.getConnection(url, "root", "0000");
        	stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
        	sql = "select * from study_tbl where studyid = '"+studyid+"'";
        	rs = stmt.executeQuery(sql);
        	
        	while(rs.next()){
        		String studyname=rs.getString("studyname");
        		String studycontent=rs.getString("studycontent");
        		%>
        		
        		<form class="signform" action="join-db.jsp" method="post">
      				<table class="signtable">
     				 <tr>
        				<td width="700px"><font size="15px" color="gray"><%=studyname%></font></td>
      				</tr>
      				<tr><td><hr></td></tr>
      				<tr>
       				 <td><font size="10px"><%=studycontent%></font></td>
    			    </tr>
      				</table> <br>
     			 <center>
     			 	<input type="hidden" name="studyid" value=<%=studyid%>>		
      				<input type="submit" id="submitbutton" value="스터디가입">
      			</center>
    		</form>
        		<% 
        	}
		   }catch(Exception e){
	        	out.println("scrapDB 연동 오류입니다.:" + e.getMessage());
	        }
		
	}
	else {
		%>
		<table class="table" align="center" width="603">
		<tr id="studytitle">
			<td id="f-child"align="left" border-left="1px solid #444444" width="275" bgcolor="#53BCA0">그룹이름</td>
			<td id="s-child" align="center" border-right="1px solid #444444" width="275" bgcolor="#53BCA0">멤버</td>
		</tr>
		<%
			Connection conn = null;
			Statement stmt = null;
			String sql =null;
			ResultSet rs = null;
			
			try{
				Class.forName("com.mysql.jdbc.Driver");
				String url = "jdbc:mysql://localhost:3306/rism?serverTimezone=UTC";
				conn = DriverManager.getConnection(url,"root","0000");
				stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
				sql="select*from study_tbl order by studyid desc";
				rs=stmt.executeQuery(sql);
			}
			catch(Exception e){
				out.println("DB 연동 오류 입니다.: "+e.getMessage());
			}
					
			while(rs.next())
			{
				String name= rs.getString("studyname");
				int num = Integer.parseInt(rs.getString("studynum"));
			%>
			<tr>
				<td id="f-child"><%=name %></td>
				<td id="s-child" align="center"><%=num%>
				<a href="study.jsp?type=detail&group=<%=rs.getString("studyid")%>"><img src="images/profile.png" width="15px" height="15px;"></a>
				</td>
			</tr>
		<%
			}
		%>
		</table>
	<%} %>
	</div>
	</div>
</body>
</html>