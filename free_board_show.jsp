<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file = "alert.jsp" %>
<% request.setCharacterEncoding("UTF-8");%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" type="text/css" href="css/board.css" />
<style>
    body{
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        background-color: #bbdefb;
    }



    textarea{
        width: 70vw;
        height: 70vh;
        border: none;
    }

    .content{
        display: flex;
        flex-direction: column;
        padding-top: 40px;
        padding-bottom: 40px;
        align-items: center;
        width: 62vw;
        border-radius: 30px;
        background-color: white;
        box-shadow: 0 4px 6px rgba(50, 50, 93, 0.11), 0 1px 3px rgba(0, 0, 0, 0.88);
    }

    .comment{
        display: flex;
        flex-direction: column;
        padding-top: 20px;
        padding-bottom: 20px;
        align-items: center;
        width: 27vw;
        border-radius: 10px;
        background-color: white;
        box-shadow: 0 4px 6px rgba(50, 50, 93, 0.11), 0 1px 3px rgba(0, 0, 0, 0.88);
    }
    
    .comment .view{
    	background-color: #b2c7d9;
    	width: 80%;
    	height:  100%;
    	border-radius: 30px;
    }
    
    .comment .view > li{
    	display: flex;
    	align-items: center;
    	margin-top: 10px;
    	margin-left: 10px;
    }
    
    .comment .view > li > img{
   		width: 20%;
    	height: 20%;
    	margin-right: 10px;
    }
    
    .comment .view > li > div > .balloon{
   		border-radius: 10px;
   		border: 5px solid white;
        background-color: white;
    	width:80%;
    }

    .content h2{
        align-self: flex-start;
        margin-left: 5vw;
        border-bottom: solid;
        opacity: 0.8;
    }
    
    .content .writtenuser{
        align-self: flex-start;
        margin-left: 5vw;
        margin-bottom: 10px;
        margin-top: 10px;
        font-weight: bold;
        opacity: 0.6;
    }
    .content div .innercontent{
    	font-family: "cookier";
    	font-size: 18px;
    }
    
    .content div img{
    	max-width: 50vw;
    	max-height: 50vh;
    	
    }
    
    .postid{
    visibility: hidden;
            position: absolute;
            left: 0px;
            top: 0px;
    }
    }
</style>

</head>
<body>
<jsp:include page="menubar.jsp" flush="true"/>
<div class="wrapper">
   <span class="pageTitle" style="text-indent: 100px;"> 자유게시판 </span>
   <div>
		<form name="searchForm" action="free_board.jsp" method="get">
		<table style="margin-right:20px">
		<tr>
			<td><input name="searchValue" type="text" class="searchValue"/></td>
         	<td><input type="submit" value="검색" class="searchsubmit"/></td>
		</tr>
		</table>
		</form>
   </div>
</div>
<%
int contentid = Integer.parseInt(request.getParameter("id"));
Connection conn = null;
Statement stmt = null;
ResultSet rs = null;

try{
   Class.forName("com.mysql.jdbc.Driver");
   String url = "jdbc:mysql://localhost:3306/RISM?serverTimezone=UTC";
   conn = DriverManager.getConnection(url, "root", "0000");
   stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
   rs = stmt.executeQuery("select * from free_board where id = " + contentid);
   rs.next();
   String fp = rs.getString("filepath");
   %>
<br>
<div class="field" style="width:90vw; display:flex; flex-direction:row; justify-content:space-around;">
<div class="content">
	<div class="wrapper">
	<span class="pageTitle" style="margin-left:1em; text-indent: 30px;"><%=rs.getString("title")%></span>
	<div style="display:flex; flex-direction:row; padding-right:10px">
	<div class="modifybtn" onclick="location.href='BoardDelete.jsp?board_type=free_board&id=<%=contentid%>'"><img src="images/deletebtn.png" style="height:25px; width:25px;">&nbsp;삭제하기</div>
	<div class="modifybtn" onclick="location.href='scrap-db.jsp?board_type=free_board&id=<%=contentid%>'"><img src="images/star.png" style="height:25px; width:25px;">&nbsp;스크랩하기</div>
	</div>
	</div>
	<span class="writtenuser">작성자: <%=rs.getString("userid")%></span>
	<div class="horizontal_line" style="height:2px; width:94%; background-color: grey; margin-top:3px; margin-bottom:10px;"></div>
    <div style="width:85%; height:60vh; padding:10px; overflow:auto">
    
    <%
    if(!fp.equals("null")){%>
    	<img src="uploadimgs/<%=fp%>"><br>
    <%}%>
    
    <span class="innercontent"><%=rs.getString("content")%></span></div>
</div>
<div class="comment">
<%

   rs = stmt.executeQuery("select * from free_comment left join profile_tbl on free_comment.userid = profile_tbl.id where free_comment.postid = " + contentid);
   %>
	<ul class=view>
	<%
	while(rs.next()){
   %>
					<li><img alt="none" src="profileimgs/<%=rs.getString("profile_tbl.id")%>.png"><div><p style="font-family:cookiel"><%=rs.getString("profile_tbl.name")%></p><p style="font-family:nanum" class="balloon"><%=rs.getString("content")%></p></div>
		<%if(session.getAttribute("id").equals(rs.getString("profile_tbl.id"))) {%>
         <a href="comment_delete.jsp?id=<%=rs.getInt("id")%>&board_type=free_board"><img src="images/deletebtn.png" style="width : 20px; height : 20px;"></a>
         <%} %>
         </li>
		<%   }%>
	</ul>
	<form method="post" action="free_board_comment.jsp">
		<input type="text" name="comment"><input type="submit">
		<input class="postid" type="text" name="postid" value=<%=contentid%>>
	</form>
</div>
</div>
    <%

rs.close();
stmt.close();
conn.close();
}
catch (Exception e) {
out.println("DB 연동 오류입니다.:" + e.getMessage());
}   

%>

</body>
</html>