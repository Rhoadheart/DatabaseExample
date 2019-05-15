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
<title>Delete Verification</title>
</head>
<body>
<h2>Delete Account Verification</h2>

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
	String password = request.getParameter("password");
	if(myUtil.verifyPassword(myUtil.getID(), password)){
		%>
		<h2> Are you sure you want to delete your account?</h2><br>
		<h2> Enter your password again and click confirm delete if you want to delete your account.</h2>
		<form action = "deleteAccountHandler.jsp" method="post">
  			Password: <input type="password" name="confirmedPassword"><br>
  			<input type="submit" value="Delete Account">	
		</form>
		<% 
	} else { %>
		<h2> Incorrect password entered, try again on General Menu.</h2>
	<% }
%>


</body>
</html>