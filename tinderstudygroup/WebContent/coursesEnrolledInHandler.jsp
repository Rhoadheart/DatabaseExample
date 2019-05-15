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
<title>Courses Enrolled In</title>
</head>
<body>
<h2>Courses Enrolled In</h2>

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
	ResultSet rset = myUtil.coursesEnrolledIn(myUtil.getID());
	
	if (rset.next()){ %>
		<h2> Courses Enrolled in For <%= myUtil.getID() %>:</h2>
		<table>
			<tr><th>Course Number</th></tr>
			<tr><td><%= rset.getString(1) %></td></tr>
			<% while(rset.next()) { %>
			<tr>
				<td><%= rset.getString(1) %></td>
			</tr>
			
			<%  } %>
		</table>
		
	<% 	}else { %>	
			<h2>Request could not be processed.</h2>
	<% }
%>

</body>
</html>