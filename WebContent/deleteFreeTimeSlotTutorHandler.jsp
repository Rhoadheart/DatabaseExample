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
<title>Delete Free Tutor Slots</title>
</head>
<body>
<h2>Delete Free Tutor Time Slots</h2>

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
	String[] startDateTimes = request.getParameterValues("startDateTime");
	if(startDateTimes.length == 0){ %>
	<h2> You have not selected any time slots.</h2>
	<% }	
	int tuplesDeleted = myUtil.deleteFreeTimeSlots(myUtil.getID(), startDateTimes);
	if(tuplesDeleted == 0){ %>
		<h2> Something went wrong, try again.</h2>
	<% } else { %>
		<h2> You deleted <%=tuplesDeleted %> free time slots.</h2>
	<% }
%>

</body>
</html>