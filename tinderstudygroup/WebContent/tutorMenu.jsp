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
<title>Tutor Menu</title>
</head>
<body>
<h2>Tutor Menu</h2>

<%	
	Class.forName("org.mariadb.jdbc.Driver");
%>

<% if (myUtil.getConn() == null) // forward to login page
{
%>
<jsp:forward page="loginForm.jsp" />
<%} // end if -- the rest of the JSP file will be ignored if no connection

if (!myUtil.isClientTutor(myUtil.getID())){ %>
	<h2> You are not a tutor, go back and select student menu.</h2>
<% } else {
%>
	<h3>Select one of these options:</h3>
	<ol>
	<li><a href="addTimeSlot.jsp"> Add Free Time Slot</a>
	<li><a href="freeTutorTimeSlotsViewHandler.jsp"> View My Free Time Slots</a>
	<li><a href="deleteFreeTimeSlotTutorForm.jsp"> Delete Free Time Slot</a>
	<li><a href="clientsByStudySessionForm.jsp"> Clients by study session</a>
	<li><a href="addClientToSessionForm.jsp"> Add user to study session.</a>
	<li><a href="coursesProficientInHandler.jsp"> Courses You Are Proficient In</a>
	<li><a href="deleteProficientCoursesForm.jsp"> Remove Courses You Are Proficient In</a>
	<li><a href="addProficientInCoursesForm.jsp"> Add Courses You Are Proficient In</a>
	<li><a href="updateTutorFreeTimeSlotForm.jsp"> Update Free Time Slot</a>
	</ol>
<% } %>

</body>
</html>