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


<%
	try{
		String date = request.getParameter("newStartDate");
		int newLength = Integer.parseInt(request.getParameter("newLength"));
		String time = request.getParameter("newStartTime");
		String oldStartDateTime = request.getParameter("oldStartDateTime");
		Timestamp oldTstamp = Timestamp.valueOf(oldStartDateTime);
		boolean tutor = true;
		
		int id = myUtil.getID();
		
		Timestamp newTstamp = Timestamp.valueOf(date + " " + time + ":00");
		//public int updateFreeTimeSlot(int id_Number, 
		//Timestamp oldStart_Date_Time, Timestamp newStart_Date_Time, 
		//Time newLength )
		int res = myUtil.updateFreeTimeSlot(id, oldTstamp, newTstamp, newLength); 
		
		if(res == 1){%>
			The following has been updated in your free time slots!<br>
		<table>
			<tr>	<td>Date:	</td>	<td> <%=date%>	</td>	</tr>
			<tr>	<td>Time:	</td>	<td> <%=time%>	</td>	</tr>
			<tr>	<td>Length:	</td>	<td> <%=newLength%>	</td>	</tr>
		</table><br>
		<br>
		<%} else {%>
			Failure adding free time slot! 
			<table>
				<tr>	<td>Date:	</td>	<td> <%=date%>	</td>	</tr>
				<tr>	<td>Time:	</td>	<td> <%=time%>	</td>	</tr>
				<tr>	<td>Length:	</td>	<td> <%=newLength%>	</td>	</tr>
			</table><br>
			<br>
		<%}
		
	} catch (IllegalArgumentException e){ %>
	<h2> You entered in invalid data, please try again.</h2>
<% }
	
%>
</body>
</html>