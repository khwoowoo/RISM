<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file = "alert.jsp" %>
<% request.setCharacterEncoding("UTF-8");
String searchValue = request.getParameter("searchValue");
if(searchValue == null) searchValue = "";
int studyid=Integer.parseInt(request.getParameter("studyid"));
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<style type="text/css">
#submit{ 
  width : 30px; height : 30px;
  background-repeat : no repeat;
  background-size : 30px 30px;
  background-color : white;
  border:0 solid black;
}
</style>
<title>자유게시판</title>
<link rel="stylesheet" type="text/css" href="css/board.css" />
<script type="text/javascript" src="https://code.jquery.com/jquery-latest.min.js"></script>
<script>
	$(document).ready(function(){
		$(".writebtn").click(function (){
			window.location.href = "study_board_write.jsp?studyid=<%=studyid%>";
		})
	})
</script>
</head>
<body>
<jsp:include page="menubar.jsp" flush="true"/>
<div class="wrapper" style="justify-content:space-between; align-items:flex-end">

	<span class="pageTitle" style="text-indent: 30px;"> 스터디게시판 </span>

	<div>
		<form name="searchForm" action="study_board.jsp" method="get">
			<input type="hidden" name="studyid" value="<%=request.getParameter("studyid")%>">
			<input name="searchValue" type="text" class="searchValue" value="<%=searchValue%>"/>
			<input type="submit" class="searchsubmit" value="검색"/>
		</form>
	</div>
</div>
<hr>

<div class="pond">
<%

String id, title;
Connection conn = null;
Statement stmt = null;
String sql = null;
ResultSet rs = null;
int resultcnt = 0;
int count = -1;
String strcount = "";
try{
	Class.forName("com.mysql.jdbc.Driver");
	String url = "jdbc:mysql://localhost:3306/rism?serverTimezone=UTC";
	conn = DriverManager.getConnection(url, "root", "0000");
	stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	sql = "select * from study_board where studyid = "+studyid+" order by id desc";
	rs = stmt.executeQuery(sql);
	
	rs.last();
	count = rs.getRow();
	rs.beforeFirst();
	
	while(rs.next()){
		id=rs.getString("id");
		title = rs.getString("title");
		if(!searchValue.equals("")){
			if(!title.contains(searchValue) && !strcount.contains(searchValue)) {
				
				continue;
			}
		}
		%>
		<div class="post_it" onclick="location.href='study_board_show.jsp?studyid=<%=request.getParameter("studyid")%>&id=<%=id%>'">
		<table border="1px solid black" style="border-collapse: collapse;">
		<tr>
			<td style="width:13em; height:8em; background-image:url('images/image.jpg'); background-size: cover;"></td>
		</tr>
		<tr>
			<td style="width:13em; height:4em; text-align: center; vertical-align: middle;">
			<span style="font-size: 1.3em; text-align: center; vertical-align: middle;"></span>
			<%=count%>.&nbsp;<%=title%> 
			</td>
		</tr>
		</table>
		</div>
<%
		count--;
		resultcnt++;
	}
	if(resultcnt == 0 && !searchValue.equals("")) out.println("검색 결과가 없습니다");
}catch (Exception e) {
	out.println("DB 연동 오류입니다.:" + e.getMessage());
}
%>
</div>
<img src="images/plusbutton.png" class="writebtn" style="margin-right: 2em; float:right" width="40em" height="40em"/>
<div class="footer">
<%
for(int i=1; i <= ((resultcnt - 1) / 20 + 1); i++){
	%><div class="pagebtn" onclick="location.href='free_board.jsp?searchValue=<%=searchValue%>&pageValue=<%=i %>'" style="background-color:#3e7ad3; width:1.3em; height:1.3em; display:table; margin-left:0.5em; margin-right:0.5em; font-size:3em"><span style="font-family:cookiel; color:white; text-align:center; vertical-align:middle; display:table-cell"><%=i%></span></div><%
}
%>
</div>
</body>
</html>