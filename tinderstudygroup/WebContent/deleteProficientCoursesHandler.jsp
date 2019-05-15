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
<title>Delete Proficient Handler</title>
</head>
<body>
<h2>Delete Proficient Courses Handler</h2>

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
	String[] courses = request.getParameterValues("courseNumber");
	if(courses == null){ %>
	<h2> You have not selected any courses.</h2>
	<% } else {	
	int tuplesDeleted = myUtil.deleteProficientInCourses(myUtil.getID(), courses);
	if(tuplesDeleted == 0){ %>
		<h2> Something went wrong, try again.</h2>
	<% } else { %>
		<h2> You deleted <%=tuplesDeleted %> proficient courses.</h2>
	<% } } 
%>
</body>
</html>