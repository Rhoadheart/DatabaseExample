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
<title></title>
</head>
<body>
<h2></h2>

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
	String password = request.getParameter("confirmedPassword");
	if(myUtil.verifyPassword(myUtil.getID(), password)){
		int result = myUtil.deleteClient(myUtil.getID());
		if (result == 1){ %>
			<h2> Account successfully deleted.</h2>
		<% }
	} else { %>
		<h2> Incorrect password entered, try again on General Menu.</h2>
	<% }
%>

</body>
</html>