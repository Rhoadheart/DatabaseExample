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
<title>Find Available Peers Handler</title>
</head>
<body>
<h2>Find Available Peers Handler</h2>

<%	
	Class.forName("org.mariadb.jdbc.Driver");
%>
<form action="studentsByCourseAndAvailabilityHandler.jsp">
<% if (myUtil.getConn() == null) // forward to login page
{
%>
<jsp:forward page="loginForm.jsp" />

<%} // end if -- the rest of the JSP file will be ignored if no connection

	String startDateTimeLength = request.getParameter("startDateTime");

	if(startDateTimeLength == null){ %>
	<h2> You have not selected any time slots.</h2>
	<% } else{	
		String startDateTime = startDateTimeLength.substring(0, startDateTimeLength.indexOf(","));
		String length = startDateTimeLength.substring(startDateTimeLength.indexOf(",") + 1, startDateTimeLength.length());

		int minutes = Time.valueOf(length).getMinutes();
		int hours = Time.valueOf(length).getHours();
		int intervals = minutes/15 + hours*4;
		
		Timestamp baseTime = Timestamp.valueOf(startDateTime);	
		Timestamp thisTime = baseTime;
		%>
		<table>
		<tr><td>
		Length of Meeting</td>
		<td><select name="meetingLength" required>
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
							</select>
							</td></tr>
		<tr><td>Course</td>
		<td><select name = "coursenum" required>
			<%ResultSet rset = myUtil.coursesEnrolledIn(myUtil.getID());
			while (rset.next()) {
				String courseNumber = rset.getString(1); %>
				<option value="<%=courseNumber%>"><%=courseNumber %></option>
			<%} %>
		
		</select></td></tr>
		</table>
		<table>
		<tr>
		<th>Select</th> <th>START_DATE_TIME</th> <th>LENGTH</th> 
		</tr><%
		for(int i = 0; i<intervals; i++){
			
			String thisTimeString = thisTime.toString();
			
			
			%>
			<tr>
				<th><input type="radio" name="timeToSearch" value="<%=thisTimeString%>"> </th>
				<th><%=thisTimeString %></th>
			</tr>
			<%
			thisTime = new Timestamp(thisTime.getTime() + 900000);
			
		}
		%></table><input type="submit" name="submit" value="Submit"></form><%
	}
%>

</body>
</html>