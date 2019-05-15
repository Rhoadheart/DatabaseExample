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
<title>Delete Student Free Times</title>
</head>
<body>
<h2>Delete Student Free Time Slots</h2>

<%	
	Class.forName("org.mariadb.jdbc.Driver");
%>

<% if (myUtil.getConn() == null) // forward to login page
{
%>
<jsp:forward page="loginForm.jsp" />
<%} // end if -- the rest of the JSP file will be ignored if no connection
%>

<% ResultSet r = myUtil.viewFreeTimeSlots(myUtil.getID(), false); %>
<form action="deleteFreeTimeSlotStudentHandler.jsp" method="get">
<p><input type="submit" value="Delete All Checked Tuples"> </p>
<table>
<tr>
<th>Select</th> <th>START_DATE_TIME</th> <th>LENGTH</th> 
</tr>
<%while (r.next()) {
	String startDateTime = r.getString(1); %>
	<tr>
	<th><input type="checkbox" name="startDateTime" value="<%=startDateTime %>"> </th>
	<th><%=r.getString(1) %></th>
	<th><%=r.getString(2) %></th>
</tr>
<% } //while %>
</table>
</form>

</body>
</html>