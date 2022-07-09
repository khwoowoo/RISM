<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file = "alert.jsp" %>
<%@ page import = "java.io.*" %>
<% request.setCharacterEncoding("UTF-8");

//String title = request.getParameter("title");
//String content = (String) request.getParameter("content");
String content = null, title = null;
String board_type = (String)request.getParameter("board_type");
String returnpage = null;
int new_id = 0, cnt = 0;
Connection conn = null;
Statement stmt = null;
ResultSet rs = null;

try {
	Class.forName("com.mysql.jdbc.Driver");
	String url = "jdbc:mysql://localhost:3306/rism?serverTimezone=UTC";
	conn = DriverManager.getConnection(url, "root", "0000");
	stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	rs = stmt.executeQuery("select * from " + (String)request.getParameter("board_type") + " where id = " + request.getParameter("id"));
	rs.next();
	if(session.getAttribute("id").equals(rs.getString("userid")) == true || session.getAttribute("id").equals("admin") == true){
		

		

		if(!board_type.equals("study_board")){
			String fileName = null;
			String saveFolder = getServletContext().getRealPath("dummy");
			if(board_type.equals("free_board")) saveFolder = getServletContext().getRealPath("uploadimgs");
			else if(board_type.equals("code_board")) saveFolder = getServletContext().getRealPath("uploadcodes");
			fileName = rs.getString("filepath");
			String filePath = saveFolder + "/";
			filePath += fileName;
			
			File f = new File(filePath);
			if(f.exists()) f.delete();
		}
		stmt.executeUpdate("delete from " + board_type + " where id = " + request.getParameter("id"));
		String bt = board_type.replace("_board", "");
		stmt.executeUpdate("delete from " + bt + "_comment where postid = " + request.getParameter("id"));
		%><script>alert("게시물이 성공적으로 삭제되었습니다");</script><%
	}
	else{
		%><script>alert("게시물을 삭제할 권한이 없습니다!");</script><%
	}
	out.println("안녕");
	String temp = null;
	if(board_type.equals("free_board")){
		returnpage="free_board.jsp";
	}
	else if(board_type.equals("code_board")){
		returnpage="code_board.jsp";
	}
	else if(board_type.equals("study_board")){
		int studyid =Integer.parseInt(request.getParameter("studyid"));
		returnpage="study_board.jsp?studyid=" + studyid;
	}

	%>
	<script>
	location.href="<%=returnpage%>";
	</script>
	<%
}
catch (Exception e) {
	out.println("DB 연동 오류입니다.:" + e.getMessage());
}
%>
