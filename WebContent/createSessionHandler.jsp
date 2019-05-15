<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<jsp:useBean id="myUtil" class="dbUtil.Utilities" scope="session"></jsp:useBean>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
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

<!-- Date input type is read by server as YYYY-MM-DD and Time is read by server as HH:MM:SS in 24-hour format -->

<%

	try{
		String sessionName = request.getParameter("sessionName");
		String date = request.getParameter("startDate");
		String time = request.getParameter("startTime");
		int length = Integer.parseInt(request.getParameter("length"));

		int hours = length / 60; //since both are ints, you get an int
		int minutes = length % 60;
		String lengthToBeConverted = hours+":"+minutes+":00";
		Time lengthCorrectForm = Time.valueOf(lengthToBeConverted);
		
		Timestamp tstamp = Timestamp.valueOf(date + " " + time + ":00");
		
		ResultSet rset = myUtil.createStudySession(sessionName, tstamp, lengthCorrectForm); 
		
		if(rset.next()){%>
			The following has been added to study sessions!<br>
		<table>
			<tr>	<td>Date:		</td>	<td> <%=date%>				</td>	</tr>
			<tr>	<td>Time:		</td>	<td> <%=time%>				</td>	</tr>
			<tr>	<td>Length:		</td>	<td> <%=length%>			</td>	</tr>
			<tr>    <td>Session_ID:	</td>	<td> <%=rset.getString(1)%>	</td>	</tr>
		</table><br>
		<br>
		<%} else {%>
			Failure adding study session! 
			<table>
				<tr>	<td>Date:	</td>	<td> <%=date%>	</td>	</tr>
				<tr>	<td>Time:	</td>	<td> <%=time%>	</td>	</tr>
				<tr>	<td>Length:	</td>	<td> <%=length%>	</td>	</tr>
				<tr>    <td>Session_ID:	</td>	<td> <%=rset.getString(1)%>	</td>	</tr>
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