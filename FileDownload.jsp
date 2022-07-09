<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><%
	request.setCharacterEncoding("UTF-8");
%><%@ page import="java.io.*, java.util.*, java.lang.*"
%>
<%@ include file = "alert.jsp" %>
<%
    String filePath = getServletContext().getRealPath("uploadcodes");
    String fileName = request.getParameter("filename");
    String orgFilename = fileName;
	try {
		File file = new File(filePath + "/" + fileName);
		if (file.isFile()) {
			byte b[] = new byte[(int) file.length()];
			fileName = new String(fileName.getBytes("UTF-8"), "iso-8859-1");
			orgFilename = java.net.URLEncoder.encode(orgFilename, "UTF-8");
			response.setHeader("Content-Disposition", "attachment;filename=" + orgFilename);
			BufferedInputStream fin = new BufferedInputStream(new FileInputStream(file));
			BufferedOutputStream outs = new BufferedOutputStream(response.getOutputStream());
			int read = 0;
			while ((read = fin.read(b)) != -1) {
				outs.write(b, 0, read);
			}
			outs.close();
			fin.close();
		} else {
			out.println("File does not exist!");
		}
	} catch (IOException e) {
		out.println("download.jsp error!");
	}
%>