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
	String email = request.getParameter("email");
	String testingString = request.getParameter("sessionID");
	if (email == null || testingString.equals("") ){ %>
		<h2> No data entered. </h2>
	<% } else {
			int sessionID = Integer.parseInt(request.getParameter("sessionID"));
			int idNum = myUtil.getIDNumberFromEmail(email);
			// Using getParameter on an unchecked checkbox returns null
			boolean isTutor = request.getParameter("isTutor") != null;
			int userAdded = myUtil.addClientToSession(idNum, sessionID, isTutor);
			
			if (userAdded == 1){ %>
				<h3> Client successfully added to study session. </h3>
			<% } else { %>	
					<h2> Client could not be added, try again.</h2>
	<% 			} }
%>

</body>
</html>