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
	String email = request.getParameter("email");
	String sessionId = request.getParameter("sessionID");
	String idOfClient = Integer.toString(myUtil.getIDNumberFromEmail(email));
	int resultOfRemove = myUtil.removeFromSession(idOfClient, sessionId);
	
	if(resultOfRemove == 1){
		%> <h2> <%= request.getParameter("email") %> removed from study session.</h2>
	<% } else{
		%> <h2> Request could not be processed. </h2> 
	<% }
%>

</body>
</html>