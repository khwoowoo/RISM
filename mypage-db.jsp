<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file = "alert.jsp" %>
<%@ page import = "java.util.*,java.io.*" %>
<%@ page import = "com.oreilly.servlet.MultipartRequest" %>
<%@ page import = "com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%
	request.setCharacterEncoding("UTF-8");	
	String name, id, pwd,repwd;
	String fileName = null;
	Connection conn = null;
	Statement stmt = null;
	ResultSet rs = null;
	String sql;
	MultipartRequest multi = null;
	try{
		
		String saveFolder = getServletContext().getRealPath("profileimgs");
	    String encType = "UTF-8";
	    int maxSize = 5 * 1024 * 1024;
	    File rf = new File(saveFolder + "/" + (String)session.getAttribute("id") + ".png");
		if(rf.exists()) rf.delete();
		multi = new MultipartRequest(request, saveFolder, maxSize, encType, new DefaultFileRenamePolicy());
	    
	    
	    
	    fileName = multi.getFilesystemName("file");
	    String original = multi.getOriginalFileName("file");
	    String type = multi.getContentType("file");
	    File f = multi.getFile("file");
	    
	    out.println("저장된 파일 이름 : " + fileName + "<br/>");
	    out.println("실제 파일 이름 : " + original + "<br/>");
	    out.println("파일 타입 : " + type + "<br/>");
	    out.println("파일 위치 : " + saveFolder + "<br/>");
	    
	    String newFileName = (String)session.getAttribute("id") + ".png";
        
	    File oldFile = new File(saveFolder + "/" + fileName);
	    File newFile = new File(saveFolder + "/" + newFileName);
	   
	    oldFile.renameTo(newFile);

	    if (f != null) {
	        out.println("크기 : " + f.length()+"바이트");
	        out.println("<br/>");
	    }
	} catch (IOException ioe) {
	    System.out.println(ioe);
	} catch (Exception ex) {
	    System.out.println(ex);
	}
	name = multi.getParameter("name");
	String birth = multi.getParameter("birth");
	String address = multi.getParameter("address");
	String email = multi.getParameter("email");
	String phone = multi.getParameter("phone");
	id = (String)session.getAttribute("id");

	try{
		Class.forName("com.mysql.jdbc.Driver");
		String jdbcurl = "jdbc:mysql://localhost:3306/rism?serverTimezone=UTC";
		conn = DriverManager.getConnection(jdbcurl,"root","0000");
		stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
		sql = "update profile_tbl set name='"+name+"',birth='"+birth+"', address='"+address+"', email='"+email+"', phone='"+phone+"' where id='"+id+"'";
		session.setAttribute("name", name);
		stmt.executeUpdate(sql);
		}
	catch(Exception e){
		out.println("DB 연동 오류 입니다. : "+e.getMessage());
	}
	
	response.sendRedirect("mypage.jsp?re=re");
	
%>
	
	

