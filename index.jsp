<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<% request.setCharacterEncoding("UTF-8");%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="shortcut icon" type="images/x-icon" href="images/logo1.png">
    <link rel="stylesheet" href="style.css">
    <script defer src="slider.js"></script>
    <title>RISM</title>
</head>
<body>
    <!-- nav -->
    <nav class="navbar">
        <a href="index.jsp" style="font-family: cookiel">RISM</a>
        <ul>
            <li><a href="#page-1">Home</a></li>
            <li><a href="#page-2">About</a></li>
            <li><a href="#page-3">Slider</a></li>
            <li><a href="#page-4">Bulletin board</a></li>
            <li><a href="#page-5">PlayRoom</a></li>
            <li><a href="#page-6">footer</a></li>
            <li><a href="mypage.jsp">MyPage</a></li>
            <%
            if(session.getAttribute("id") == null){
            	%><li><a href="login.jsp">Login</a></li><%
            }
            else{
            	%><li><a href="logout.jsp">Logout</a></li><%
            }
            %>
            
            <li><a href="sign_in.jsp">Sign in</a></li>
        </ul>
    </nav>
    <!-- Home -->
    <div class="Home" id="page-1">
        <img src="images/home1.png" alt="!home">
    </div>
    <!-- About -->
    <div class="About" id="page-2">
        <div class="About_contents">
            <h1>About</h1>
            <div class="About_contents_text">
                <p>"RSIM"은 무슨 <span>사이트</span>인가요?</p>
                <p>저희 "RSIM"은 프로그래밍 공부사이트로써,</p>
                <p>코드 조각 모음 게시물과 스터디를 통해 학습 할 수 있으며!</p>
                <p>각 게시물을 스크랩까지 가능합니다!</p>
                <p>놀이방의 게임을 통해 머리를 식히는 것 까지 가능!</p>
            </div>
        </div>
        <img src="images/mark1.png" alt="!mark">
    </div>
    <!-- Slider -->
    <div class="Slider" id="page-3">
        <br><br><br><br><br><br><br><br>
        <div class="Sldier_imageBox">
            <img id="jsSlider" src="images/slider (1).jpg" alt="">
            <img id="jsSlider" src="images/slider (2).jpg" alt="">
            <img id="jsSlider" src="images/slider (3).jpg" alt="">
        </div>
        <div class="Slider_State">
        </div>
    </div>
    <!-- Board -->
    <div class="Board" id="page-4">
        <br><br><br><br><br><br><br><br>
        <p>Bulletin board</p>
        <ul>
            <li><a href="free_board.jsp"><button style="background-color: #3e7ad3;"><img src="images/free.png" width=50px; height=50px;></button> 자유게시판</a></li>
            <li><a href="code_board.jsp"><button style="background-color: #3e7ad3;"><img src="images/puzzle.png" width=50px; height=50px;></button> 코드 조각 모음 게시판</a></li>
            <li><a href="study.jsp"><button style="background-color: #3e7ad3;"><img src="images/study.png" width=50px; height=50px;></button> 스터디 게시판</a></li>
        </ul>
    </div>
    <!-- game -->
    <div class="game" id="page-5">
        <br><br><br>
       <a href="game.html"><img src="images/game.png" alt=""></a>
    </div>
    <!-- footer -->
    <div class="footer" id="page-6">
        <img src="images/footer1.png" alt="">
    </div>
</body>
</html>