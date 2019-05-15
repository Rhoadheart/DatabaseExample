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
<title>Delete Enrolled Courses</title>
</head>
<body>
<h2>Deleted Enrolled In Courses</h2>

<%	
	Class.forName("org.mariadb.jdbc.Driver");
%>

<% if (myUtil.getConn() == null) // forward to login page
{
%>
<jsp:forward page="loginForm.jsp" />
<%} // end if -- the rest of the JSP file will be ignored if no connection
%>

<% ResultSet r = myUtil.coursesEnrolledIn(myUtil.getID()); %>
<form action="deleteEnrolledCoursesHandler.jsp" method="get">
<p><input type="submit" value="Delete All Checked Tuples"> </p>
<table>
<tr>
<th>Select</th> <th>COURSE NUMBER</th> 
</tr>
<%while (r.next()) {
	String courseNumber = r.getString(1); %>
	<tr>
	<th><input type="checkbox" name="courseNumber" value="<%=courseNumber %>"> </th>
	<th><%=r.getString(1) %></th>
</tr>
<% } //while %>
</table>
</form>

</body>
</html>