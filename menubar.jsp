<style>
@import 'css/font.css';
a{
	text-decoration: none;
	color: black;
}

ol, ul {
	list-style: none;
}

/* ============== navbar ============== */
.navbar{
    height: 100px;
    width: 100vw;
    display: flex;
    align-items: center;
    justify-content: space-between;
    position: fixed;
    top: 0; left: 0;
    background-color: #3e7ad3;
}

.navbar > a{
    font-size: calc(1.5rem + 2vw);
    color: white;
    margin-left: 20px;
}

.navbar > ul{
    display: flex;
    margin-right: 20px;
    
}

.navbar > ul > li{
    font-size: calc(1.2rem);
    color: white;
    margin-right: 20px;
    cursor: pointer;
}

.navbar > ul > li:hover{
    font-size: calc(calc(1.2rem) + 5px);
}
</style>
 
 <!-- nav -->
    <nav class="navbar">
        <a style="font-family: cookiel"href="index.jsp">RISM</a>
        <ul>
            <li><a style="font-family: cookier; color: white;" href="mypage.jsp">MyPage</a></li>
            
            <%
            if(session.getAttribute("id") == null){
            	%><li><a style="font-family: cookier; color: white;" href="login.jsp ">Login</a></li><%
            }
            else{
            	%><li><a style="font-family: cookier; color: white;" href="logout.jsp">Logout</a></li><%
            }
            %>
        </ul>
    </nav>
    <div style="height:100px; width:100%"></div>