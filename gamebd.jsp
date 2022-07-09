<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file = "alert.jsp" %>
<%@ page import="java.text.*" %>
<% request.setCharacterEncoding("UTF-8"); %>
 <%
 		boolean isSearch = false;
 		String userId = (String)session.getAttribute("id");
 		int score = Integer.parseInt((String)request.getParameter("score"));
 		String username = (String)session.getAttribute("name");
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;

        try { 
              Class.forName("com.mysql.jdbc.Driver");
              String jdbcurl = "jdbc:mysql://localhost:3306/rism?serverTimezone=UTC";
              conn = DriverManager.getConnection(jdbcurl, "root", "0000");
              stmt = conn.createStatement();
              String sql = "select * from game";
              rs = stmt.executeQuery(sql);
              
              //여기서 전부 탐색
              while(rs.next()){
              		//찾으면 갱신
              		if(rs.getString("userId").equals(userId)){
              			// update game set score = 123132 where name = 'dong2';
              			//전에 했던 점수가 더 높으면 갱신 안 함
              			if(rs.getInt("score") < score){
              				String temp = String.format("update game set score = %d where userId = '%s';", score, userId);
                        	stmt.executeUpdate(temp);
              			}
              			isSearch = true;
              			break;
              		}
          		}
              
              //찾지 못 하면 추가
              if(isSearch == false){
              	String temp = String.format("insert into game (userId, username, score) values ('%s', '%s', %d);", userId, username, score);
            	stmt.executeUpdate(temp);
              }

              rs = stmt.executeQuery("SELECT * FROM game ORDER BY score DESC");
        } 
        catch(Exception e) {
              out.println("DB 연동 오류입니다. : " + e.getMessage());
        }
      
        //response.sendRedirect("main.html");
   %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="shortcut icon" type="images/x-icon" href="images/mark.png">
    <title>Shooting</title>
    <style>
    @font-face{
    font-family: "font/CookieRun Bold.otf";
    src:url("font/CookieRun Bold.otf")format("truetype");
}
    body{
    font-family: "font/CookieRun Bold.otf";
}

    	a { color: black; }
        .ranking{
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        table.type10 {
            border-collapse: collapse;
            text-align: left;
            line-height: 1.5;
            border-top: 1px solid #ccc;
            border-bottom: 1px solid #ccc;
            margin: 20px 10px;
        }
        table.type10 thead th {
            width: 150px;
            padding: 10px;
            font-weight: bold;
            vertical-align: top;
            color: #fff;
            background: #e7708d;
            margin: 20px 10px;
        }
        table.type10 tbody th {
            width: 150px;
            padding: 10px;
        }
        table.type10 td {
            width: 350px;
            padding: 10px;
            vertical-align: top;
        }
        table.type10 .even {
            background: #fdf3f5;
        }
    </style>
</head>
<body>
    <div class="ranking">
        <h1>RANK</h1>
        <table class="type10">
            <thead>
                <tr>
                	<th scope="cols">RANK</th>
                    <th scope="cols">ID</th>
                    <th scope="cols">USER NAME</th>
                    <th scope="cols">SCORE</th>
                </tr>
            </thead>
            <tbody>
 <%
 		boolean isPrink = false;
		int iCount = 1;
        while(rs.next()){
        	
        	if(isPrink == false){
 %>
            <tr>
                <td scope="row" ><%= iCount %></td>
                <td ><%= rs.getString("userID") %></td>
                <td ><%= rs.getString("username") %></td>
                <td ><%= rs.getInt("score") %></td>
            </tr>
<%         		
        	}
        	else{
%>
            <tr>
                <td scope="row"  class="even"><%= iCount %></td>
                <td  class="even"><%= rs.getString("userID") %></td>
                <td  class="even"><%= rs.getString("username") %></td>
                <td  class="even"><%= rs.getInt("score") %></td>
            </tr>
<% 
        	}
        	iCount++;
			isPrink = !isPrink;
    	}
        
    	rs.close();
        stmt.close();
        conn.close();
%>
            </tbody>
          </table>
          <a href="index.jsp">홈페이지로 돌아가기</a>
    </div>
</body>
</html>