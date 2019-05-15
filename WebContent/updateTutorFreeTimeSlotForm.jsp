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
<title>Update Tutor Times</title>
</head>
<body>
<h2>Update Tutor Free Time Slots</h2>

<%	
	Class.forName("org.mariadb.jdbc.Driver");
%>

<% if (myUtil.getConn() == null) // forward to login page
{
%>
<jsp:forward page="loginForm.jsp" />
<%} // end if -- the rest of the JSP file will be ignored if no connection
%>

<form action="updateTutorFreeTimeSlotHandler.jsp">
	<% ResultSet r = myUtil.viewFreeTimeSlots(myUtil.getID(), true); %>
	<h2> Select One Tutor Free Time Slot To Update</h2>
	<table>
		<tr>
			<th>Select</th> <th>START_DATE_TIME</th> <th>LENGTH</th> 
		</tr>
		<%while (r.next()) {
			String startDateTime = r.getString(1); %>
			<tr>
				<th><input type="checkbox" name="oldStartDateTime" value="<%=startDateTime %>"> </th>
				<th><%=r.getString(1) %></th>
				<th><%=r.getString(2) %></th>
			</tr>
	<% } //while %>
	</table>
		<table>
		<tr><td>Date and Time of Updated Free Time Slot:</td><td><input type="date" name="newStartDate" value="YYYY-MM-DD" required><input type="time" name="newStartTime" value="HH:MM" required></td></tr>
		<tr><td>Length of Updated Free Time Slot</td><td><select name="newLength" required>
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
	</table>
	<input type="submit" name="submit" value="Submit">
</form>	

</body>
</html>