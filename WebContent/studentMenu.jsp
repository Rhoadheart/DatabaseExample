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
<title>Student Menu</title>
</head>
<body>
<h2>Student Menu</h2>

<%	
	Class.forName("org.mariadb.jdbc.Driver");
%>

<% if (myUtil.getConn() == null) // forward to login page
{
%>
<jsp:forward page="loginForm.jsp" />
<%} // end if -- the rest of the JSP file will be ignored if no connection

if(!myUtil.isClientStudent(myUtil.getID())){ %>
	<h2> You are not a student, go back and select tutor menu.</h2>
<% } else {
%>
	<h3>Select one of these options:</h3>
	<ol>
	<li><a href="addTimeSlot.jsp"> Add Free Time Slot</a>
	<li><a href="freeStudentTimeSlotsViewHandler.jsp"> View My Free Time Slots</a>
	<li><a href="deleteFreeTimeSlotStudentForm.jsp"> Delete Free Time Slot</a>
	<li><a href="createSessionForm.jsp"> Create Study Session</a>
	<li><a href="addClientToSessionForm.jsp"> Add user to study session.</a>
	<li><a href="removeFromSessionForm.jsp"> Remove Client from Study_Session</a>
	<li><a href="clientsByStudySessionForm.jsp"> Clients by study session</a>
	<li><a href="coursesEnrolledInHandler.jsp"> Courses you are enrolled in.</a>
	<li><a href="deleteEnrolledCoursesForm.jsp"> Remove classes enrolled in.</a>
	<li><a href="addClassesEnrolledInForm.jsp"> Add classes enrolled in.</a>
	<li><a href="studentsByCourseAndAvailabilityForm.jsp"> Students by Course and Availability</a>
	<li><a href="updateStudentFreeTimeSlotForm.jsp"> Update Free Time Slot</a>
	</ol>
<% } %>
</body>
</html>