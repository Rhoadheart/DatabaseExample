<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<jsp:useBean id="myUtil" class="dbUtil.Utilities" scope="session"></jsp:useBean>
<%@ page import="java.sql.*" %>
<jsp:include page="head.jsp"></jsp:include>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href= "style.css">
<meta charset="ISO-8859-1">
<title>Update Password</title>
</head>
<body>
<h2>Update Password</h2>

<%	
	Class.forName("org.mariadb.jdbc.Driver");
%>

<% if (myUtil.getConn() == null) // forward to login page
{
%>
<jsp:forward page="loginForm.jsp" />
<%} // end if -- the rest of the JSP file will be ignored if no connection
%>

<%
	String password = request.getParameter("oldPassword");
	if(myUtil.verifyPassword(myUtil.getID(), password)){ %>
		<form action = "passwordUpdateHandler.jsp" method="post">
			New Password: <input type="password" name="newPassword"><br>
			<input type="submit" value="Change Password">	
		</form> <% 
	} else { %>
		<h2> Incorrect password entered, try again on General Menu.</h2>
	<% } 
%>

</body>
</html>