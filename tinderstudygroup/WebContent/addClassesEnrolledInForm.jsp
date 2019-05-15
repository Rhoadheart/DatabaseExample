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
<title>Add Enrolled In Classes</title>
</head>
<body>
<h2>Add Classes You Are Enrolled In</h2>

<%	
	Class.forName("org.mariadb.jdbc.Driver");
%>

<% if (myUtil.getConn() == null) // forward to login page
{
%>
<jsp:forward page="loginForm.jsp" />
<%} // end if -- the rest of the JSP file will be ignored if no connection
%>

<% ResultSet r = myUtil.getListOfAllCourses(); %>
<form action="addClassesEnrolledInHandler.jsp" method="get">
<p><input type="submit" value="Add All Checked Courses"> </p>
<table>
<tr>
<th>Select</th> <th>Course Number</th> <th>Course Name</th>
</tr>
<%while (r.next()) {
	String courseNumber = r.getString(1); %>
	<tr>
	<th><input type="checkbox" name="courseNumber" value="<%=courseNumber %>"> </th>
	<th><%=r.getString(1) %></th>
	<th><%=r.getString(2) %></th>
</tr>
<% } //while %>
</table>
</form>

</body>
</html>