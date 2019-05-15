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
	String sessionID = request.getParameter("sessionID");
	if (sessionID.equals("")){ %>
		<h2>You did not enter a session ID.</h2>
	<% } else {
		ResultSet rset = myUtil.inSession(sessionID);
		
		if (rset.next()){ %>
			<h2> Clients in Study Session: <%= sessionID %></h2>
			<table>
				<tr><th>Name</th> <th>Email</th> <th>Major</th></tr>
				<tr>
					<td><%= rset.getString(1) %></td>
					<td><%= rset.getString(2) %></td>
					<td><%= rset.getString(3) %></td>
				</tr>
				<% while(rset.next()) { %>
				<tr>
					<td><%= rset.getString(1) %></td>
					<td><%= rset.getString(2) %></td>
					<td><%= rset.getString(3) %></td>
				</tr>
				
				<%  } %>
			</table>
			
		<% 	}else { %>	
				<h2>Request could not be processed.</h2>
		<% }
	}
%>

</body>
</html>