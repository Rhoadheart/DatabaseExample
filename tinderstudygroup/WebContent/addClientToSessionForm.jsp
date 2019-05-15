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
<title>Add To Study Session</title>
</head>
<body>
<h2>Add Client to Study Session</h2>

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
//public int addClientToSession(int idNum, int sessionID, boolean asTutor)
%>

<form action = "addClientToSessionHandler.jsp" method="post">
  Email of client to add(end in @plu.edu): <input type="text" name="email"><br>
  Study Session ID: <input type="number" name="sessionID"><br>
  Is the client a tutor?(check box for yes): <input type="checkbox" name="isTutor"><br>
  <input type="submit" value="Add Client">
</form>

</body>
</html>