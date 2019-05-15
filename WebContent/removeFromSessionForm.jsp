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
<title>Remove From Session</title>
</head>
<body>
<h2>Remove Client From Study Session</h2>

<%	
	Class.forName("org.mariadb.jdbc.Driver");
%>

<% if (myUtil.getConn() == null) // forward to login page
{
%>
<jsp:forward page="loginForm.jsp" />
<%} // end if -- the rest of the JSP file will be ignored if no connection
%>

<form action = "removeFromSessionHandler.jsp" method="post">
  Email of Client to Remove: <input type="text" name="email"><br>
  Study Session ID Number: <input type="number" name="sessionID"><br>
  <input type="submit" value="Remove Client From Session">
</form>

</body>
</html>