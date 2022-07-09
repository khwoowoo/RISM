<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file = "alert.jsp" %>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>자유게시판 글 작성</title>
<link rel="stylesheet" type="text/css" href="css/board.css" />
<script type="text/javascript" src="https://code.jquery.com/jquery-latest.min.js"></script>
<script>
	$(document).ready(function(){
		$(".submitbtn").click(function (){
			/*if($("#title").val().length < 4) {
				alert("제목은 4자 이상이어야 합니다");
				return;
			}
			if($("#content").val().length < 10) {
				alert("내용은 10자 이상이어야 합니다. 현재 : " + $("#content").val().length);
				return;
			}*/
			$("#uploadForm").submit();
		})
	})
</script>
</head>
<body>
<jsp:include page="menubar.jsp" flush="true"/>
<div class="elecenter" style="height:calc(100vh - 50px)">
<div class="linevert" style="overflow: auto; margin:10px; border:10px solid white">
<span class="pageTitle" style="text-indent: 30px;"> 자유게시판 글 작성 </span>
<div class="horizontal_line" style="height:2px; width:auto; background-color: grey; margin-top:3px; margin-bottom:10px;"></div>

<form id="uploadForm" method="post" action="BoardUpload.jsp?board_type=free_board" enctype="multipart/form-data">
<table class="inputtable">

<tr>
	<td style="font-family:cookier; text-align:right; font-size:22px;"> 제목</td>
	<td> <input id="title" name="title" type="text" style="width:600px; margin-left:15px"> </td>
	
</tr>
<tr>
	<td style="font-family:cookier; text-align:right; font-size:22px; vertical-align: middle"> 글 내용</td>
	<td> <textarea id="content" name="content" style="width:600px; height:300px;  margin-left:15px"></textarea> </td>
</tr>
<tr>
	<td style="font-family:cookier; text-align:right; font-size:22px;"> 첨부</td>
	<td style="text-indent:20px"><input type="file" name="file" accept="image/gif, image/jpeg, image/png"></td>
</tr>
<tr>
	<td colspan="2" style="text-align:center"><input type="button" class="submitbtn" value="글 작성" style="background-color:#303030; width:70px; height:35px; font-family: cookier; color: white;" /></td>
</tr>
</table>



</form>
</div>

<div class="footer">
</div>
</div>
</body>
</html>