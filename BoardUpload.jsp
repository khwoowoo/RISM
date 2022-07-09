<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file = "alert.jsp" %>
<%@ page import = "java.util.*,java.io.*" %>
<%@ page import = "com.oreilly.servlet.MultipartRequest" %>
<%@ page import = "com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<% request.setCharacterEncoding("UTF-8");

//String title = request.getParameter("title");
//String content = (String) request.getParameter("content");
String content = null, title = null;
String fileName = null;
String returnpage = null;
String board_type = request.getParameter("board_type");
int new_id = 0, cnt = 0;
Connection conn = null;
Statement stmt = null;
ResultSet rs = null;
MultipartRequest multi = null;

try{
	String saveFolder = getServletContext().getRealPath("dummy");
	
	if(board_type.equals("free_board")){
		saveFolder = getServletContext().getRealPath("uploadimgs");
	}
	else if(board_type.equals("code_board")){
		saveFolder = getServletContext().getRealPath("uploadcodes");
	}
	File Folder = new File(saveFolder);
	if(!Folder.exists()){
		try{
			Folder.mkdir();
		}
		catch(Exception e){
			e.getStackTrace();
		}
	}
    String encType = "UTF-8";
    int maxSize = 5 * 1024 * 1024;
	multi = new MultipartRequest(request, saveFolder, maxSize, encType, new DefaultFileRenamePolicy());
    
    content = multi.getParameter("content");
    title = multi.getParameter("title");
    
    
    fileName = multi.getFilesystemName("file");
    String original = multi.getOriginalFileName("file");
    String type = multi.getContentType("file");
    File f = multi.getFile("file");
    
    if(f == null && board_type.equals("code_board")){
    	%><script>alert("코드 조각모음 게시판은 코드 첨부파일을 필수로 입력해야 합니다");
    	location.href="code_board.jsp";</script><%
    	return;
    }
    
    out.println("저장된 파일 이름 : " + fileName + "<br/>");
    out.println("실제 파일 이름 : " + original + "<br/>");
    out.println("파일 타입 : " + type + "<br/>");
    out.println("파일 위치 : " + saveFolder + "<br/>");
    if (f != null) {
        out.println("크기 : " + f.length()+"바이트");
        out.println("<br/>");
    }
} catch (IOException ioe) {
    System.out.println(ioe);
} catch (Exception ex) {
    System.out.println(ex);
}


try {
	Class.forName("com.mysql.jdbc.Driver");
	String url = "jdbc:mysql://localhost:3306/rism?serverTimezone=UTC";
	conn = DriverManager.getConnection(url, "root", "0000");
	stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	rs = stmt.executeQuery("select max(id) as max_id, count(*) as cnt from " + board_type);	
	
	while(rs.next())
	{
		cnt = Integer.parseInt(rs.getString("cnt"));
		if(cnt != 0) new_id = Integer.parseInt(rs.getString("max_id"));
		break;
	}
	new_id++;
	
	String temp = "insert into " + board_type + " values (";
	temp += "'" + new_id +"',";
	temp += "'" + title +"',";
	temp += "'" + (String)session.getAttribute("id") +"',";
	temp += "'" + content +"',";
	
	if(board_type.equals("study_board")){
		int studyid =Integer.parseInt(multi.getParameter("studyid"));
		
		temp += studyid +");";
		
		returnpage="study_board.jsp?studyid=" + studyid;
	}
	else{
		temp += "'" + fileName +"');";
		returnpage = board_type + ".jsp";
	}
	
	stmt.executeUpdate(temp);

	%>
	<script>alert("게시물이 성공적으로 등록되었습니다");
	location.href="<%=returnpage%>";
	</script>
	<%
}
catch (Exception e) {
	out.println("DB 연동 오류입니다.:" + e.getMessage());
}
%>
