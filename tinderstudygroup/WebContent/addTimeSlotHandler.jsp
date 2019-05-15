<%@ page language = "java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*"%>
<jsp:useBean id="myUtil" class="dbUtil.Utilities" scope="session"></jsp:useBean>
<jsp:include page="head.jsp"></jsp:include>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href= "style.css">
<meta charset="UTF-8">
<title>Add Free Time Slot</title>
</head>
<body>

<% if (myUtil.getConn() == null) // forward to login page
{
%>
<jsp:forward page="loginForm.jsp" />
<%} // end if -- the rest of the JSP file will be ignored if no connection
%>

<!-- Date input type is read by server as YYYY-MM-DD and Time is read by server as HH:MM:SS in 24-hour format -->

<%
	try{
		String date = request.getParameter("startDate");
		String time = request.getParameter("startTime");
		int length = Integer.parseInt(request.getParameter("length"));
		
		//public int addFreeTimeSlot(int id_Number, Timestamp start_Date_Time, int length, boolean isTutor ){
		String tutorValue = request.getParameter("tutor");
		boolean tutor = false;
		if(tutorValue != null){
			tutor = true;
		}
		
		int id = myUtil.getID();
		
		Timestamp tstamp = Timestamp.valueOf(date + " " + time + ":00");
		
		int res = myUtil.addFreeTimeSlot(id, tstamp, length, tutor); 
		
		if(res == 1){%>
			The following has been added to your free time slots!<br>
		<table>
			<tr>	<td>Date:	</td>	<td> <%=date%>	</td>	</tr>
			<tr>	<td>Time:	</td>	<td> <%=time%>	</td>	</tr>
			<tr>	<td>Length:	</td>	<td> <%=length%>	</td>	</tr>
		</table><br>
		<br>
		<%} else {%>
			Failure adding free time slot! 
			<table>
				<tr>	<td>Date:	</td>	<td> <%=date%>	</td>	</tr>
				<tr>	<td>Time:	</td>	<td> <%=time%>	</td>	</tr>
				<tr>	<td>Length:	</td>	<td> <%=length%>	</td>	</tr>
			</table><br>
			<br>
		<%}
		
	} catch (IllegalArgumentException e){ %>
	<h2> You entered in invalid data, please try again.</h2>
<% }
	
%>
<form action="generalMenu.jsp">
    	<input type="submit" value="Main Menu" />
	</form>
</body>
</html>