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
<title></title>
</head>
<body>
<h2></h2>

<%	
	Class.forName("org.mariadb.jdbc.Driver");
%>

<% if (myUtil.getConn() == null) // forward to login page
{
%>
<jsp:forward page="loginForm.jsp" />
<%} // end if -- the rest of the JSP file will be ignored if no connection
%>

<%	 //getStudentsByCourseAndAvailability(String courseNum, Timestamp startMeeting, Timestamp endMeeting){
	String coursenum = request.getParameter("coursenum");
	String startMeeting = request.getParameter("timeToSearch");
	String meetingLength = request.getParameter("meetingLength");
	
	Timestamp sMeeting = Timestamp.valueOf(startMeeting);
	long sMeetingMS = sMeeting.getTime();
	long meetingLengthMS = Integer.parseInt(meetingLength) * 60000;
	Timestamp eMeeting = new Timestamp(sMeetingMS + meetingLengthMS);
	String endMeeting = eMeeting.toString();
	
	
	ResultSet rset = myUtil.getStudentsByCourseAndAvailability(coursenum, sMeeting, eMeeting);
	
	if (rset.next()){ %>
		<h2> Students in <%= coursenum%> Available to meet on <%=startMeeting.substring(0,startMeeting.indexOf(" ")) %> from <%=startMeeting.substring(startMeeting.indexOf(" ")+1, startMeeting.length()) %> to <%=endMeeting.substring(endMeeting.indexOf(" ")+1, endMeeting.length()) %>:</h2>
		<table>
			<tr><th>Name</th><th>Email</th><th>ID_Number</th><th>Major(s)</th></tr>
			<% while(rset.next()) { %>
				<tr><td><%= rset.getString(1) %></td><td><%=rset.getString(2)%></td><td><%=rset.getString(3)%></td><td><%=rset.getString(4)%></td></tr>
			
			<%  } %>
		</table>
		
	<% 	}else { %>	
			<h2>Request could not be processed.</h2>
	<% }
%>

</body>
</html>