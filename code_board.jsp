<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file = "alert.jsp" %>
<% request.setCharacterEncoding("UTF-8");
String searchValue = request.getParameter("searchValue");
if(searchValue == null) searchValue = "";
int pageValue = 1;
if(request.getParameter("pageValue") != null) pageValue=Integer.parseInt(request.getParameter("pageValue"));
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>코드 조각모음게시판</title>
<link rel="stylesheet" type="text/css" href="css/board.css" />
<script type="text/javascript" src="https://code.jquery.com/jquery-latest.min.js"></script>
<script>
	$(document).ready(function(){
		$(".writebtn").click(function (){
			window.location.href = "code_board_write.jsp";
		})
	})
</script>
</head>
<body>
<jsp:include page="menubar.jsp" flush="true"/>
<div class="wrapper">

	<span class="pageTitle" style="text-indent: 30px;"> 코드 조각모음게시판 </span>

	<div>
		<form name="searchForm" action="code_board.jsp" method="get">
		<table style="margin-right:20px">
		<tr>
			<td><input name="searchValue" type="text" value="<%=searchValue%>" class="searchValue"/></td>
         	<td><input type="submit" value="검색" class="searchsubmit"/></td>
		</tr>
		</table>
		</form>
	</div>
</div>
<hr>

<div class="pond">
<%

String id, title, fp;
Connection conn = null;
Statement stmt = null;
String sql = null;
ResultSet rs = null;
int it=0;
String codepath = getServletContext().getRealPath("uploadcodes");
int resultcnt = 0;

try {
	Class.forName("com.mysql.jdbc.Driver");
	String url = "jdbc:mysql://localhost:3306/rism?serverTimezone=UTC";
	conn = DriverManager.getConnection(url, "root", "0000");
	stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	sql = "select * from code_board order by id desc";
	rs = stmt.executeQuery(sql);

	while(rs.next())
	{
		title = rs.getString("title");
		id = rs.getString("id");
		fp = rs.getString("filepath");
		if(!searchValue.equals("")){
			if(!title.contains(searchValue) && !id.contains(searchValue)) {
				
				continue;
			}
		}
		if(it < (pageValue - 1) * 20) {
			it++; 
			continue;
		}
		resultcnt++;
		if(resultcnt > 20){
			continue;
		}
		%>
		<div class="post_it" onclick="location.href='code_board_show.jsp?id=<%=id%>'">
		<%
		if(fp.substring(fp.lastIndexOf(".") + 1).equals("c")){
			%><div style="width:100%; height:66%; background-image:url('images/rep_c.png'); background-size: cover;"></div><%
		}
		else if(fp.substring(fp.lastIndexOf(".") + 1).equals("cpp")){
			%><div style="width:100%; height:66%; background-image:url('images/rep_cpp.png'); background-size: cover;"></div><%
		}
		else if(fp.substring(fp.lastIndexOf(".") + 1).equals("java")){
			%><div style="width:100%; height:66%; background-image:url('images/rep_java.png'); background-size: cover;"></div><%
		}
		else if(fp.substring(fp.lastIndexOf(".") + 1).equals("jsp")){
			%><div style="width:100%; height:66%; background-image:url('images/rep_jsp.png'); background-size: cover;"></div><%
		}
		else if(fp.substring(fp.lastIndexOf(".") + 1).equals("js")){
			%><div style="width:100%; height:66%; background-image:url('images/rep_js.png'); background-size: cover;"></div><%
		}
		else{
			%><div style="width:100%; height:66%; background-image:url('images/rep_code.png'); background-size: cover;"></div><%
		}
		%>
		
		
		<div style="width:100%; height:34%; text-align: center; display:table; vertical-align: middle;"> <span style="font-size: 1.3em; text-align: center; display:table-cell; vertical-align: middle;"> <%=id%>.&nbsp;<%=title%> </span> </div>
		</div>
<%
		
	}

	resultcnt+=it;
	rs.last();
	it = rs.getRow();
	
	if(resultcnt == 0 && !searchValue.equals("")) out.println("검색 결과가 없습니다");
	stmt.close();
	conn.close();
	
}
catch (Exception e) {
	out.println("DB 연동 오류입니다.:" + e.getMessage());
}
%>
</div>
<img src="images/plusbutton.png" class="writebtn" style="margin-right: 2em; float:right" width="40em" height="40em"/>
<div class="footer">
<%
for(int i=1; i <= ((resultcnt - 1) / 20 + 1); i++){
	%><div class="pagebtn" onclick="location.href='code_board.jsp?searchValue=<%=searchValue%>&pageValue=<%=i %>'" style="background-color:#3e7ad3; width:1.3em; height:1.3em; display:table; margin-left:0.5em; margin-right:0.5em; font-size:3em"><span style="font-family:cookiel; color:white; text-align:center; vertical-align:middle; display:table-cell"><%=i%></span></div><%
}
%>
</div>
</body>
</html>