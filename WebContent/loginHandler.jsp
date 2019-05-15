<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<jsp:useBean id="myUtil" class="dbUtil.Utilities" scope="session"></jsp:useBean>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href= "style.css">
<meta charset="ISO-8859-1">
<title>Login Handler</title>
</head>
<body>
<h2>Login Handler</h2>

<% if (myUtil.getConn() == null) // forward to login page
{
%>
<jsp:forward page="loginForm.jsp" />
<%} // end if -- the rest of the JSP file will be ignored if no connection
%>


<%	
	String email = request.getParameter("email");
	String password = request.getParameter("password");
	Class.forName("org.mariadb.jdbc.Driver");
	boolean loginSuccessful = myUtil.attemptLogin(email, password);
	
	if (loginSuccessful){ %>
		<jsp:forward page="generalMenu.jsp" />
	<% } else { %>	
			<h2> Login attempt unsuccessful, go back and try again.</h2>
	<% }
%>



</body>
</html>