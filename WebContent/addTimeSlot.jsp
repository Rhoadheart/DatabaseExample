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
<title>Create a Time Slot</title>
</head>
<body>

<% if (myUtil.getConn() == null) // forward to login page
{
%>
<jsp:forward page="loginForm.jsp" />
<%} // end if -- the rest of the JSP file will be ignored if no connection
%>

<h2><b>Add a Free Time Slot</b></h2>
<!-- Use Utilities class to store user ID after a login occurs (e.g. Connection Object is not null) -->
<!-- Date input type is read by server as YYYY-MM-DD and Time is read by server as HH:MM:SS in 24-hour format -->
<form action="addTimeSlotHandler.jsp">
	<table>
	<tr><td>Date and Time of Free Time Slot:</td><td><input type="date" name="startDate" value="YYYY-MM-DD" required><input type="time" name="startTime" value="HH:MM" required></td></tr>
	<tr><td>Length of Free Time Slot</td><td><select name="length" required>
								<option value="15">15 mins</option>
								<option value="30">30 mins</option>
								<option value="45">45 mins</option>
								<option selected="selected" value="60">1 hour</option>
								<option value="75">1 hour 15 mins</option>
								<option value="90">1 hour 30 mins</option>
								<option value="105">1 hour 45 mins</option>
								<option value="120">2 hours</option>
								<option value="135">2 hours 15 mins</option>
								<option value="150">2 hours 30 mins</option>
								<option value="165">2 hours 45 mins</option>
								<option value="180">3 hours</option>
							</select></td></tr>
	<tr><td> As Tutor? </td><td><input type="checkbox" name="tutor" value="yes"></td></tr>
	</table>
	<input type="submit" name="submit" value="Submit">
</form>	
</body>
</html>