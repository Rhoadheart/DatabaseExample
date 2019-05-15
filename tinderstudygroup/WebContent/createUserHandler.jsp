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
<title>Create User Handler</title>
</head>
<body>
<h2>Create User Handler</h2>

<%	
	Class.forName("org.mariadb.jdbc.Driver");
//public int createClient(String Name, int idNum, String email, String pass, boolean isStudent, boolean isTutor, String Major)
%>

<% if (myUtil.getConn() == null) // forward to login page
{
%>
<jsp:forward page="loginForm.jsp" />
<%} // end if -- the rest of the JSP file will be ignored if no connection
%>

<%	
	String name = request.getParameter("username");
	String idNumAsString = request.getParameter("idNum");
	String email = request.getParameter("email");
	String password = request.getParameter("password");
	// Using getParameter on an unchecked checkbox returns null
	boolean isStudent = request.getParameter("isStudent") != null;
	boolean isTutor = request.getParameter("isTutor") != null;
	String major = request.getParameter("major"); 
	if (name.equals("") || idNumAsString.equals("") || email.equals("")
			|| password.equals("") || major.equals("")){ %>
		<h2> You did not fill out all of the fields.</h2>
	<% } else {
		if (!isStudent && !isTutor){ %>
			<h2> You have to choose to be a student or tutor(or both). </h2>
		<% } else {
			int idNum = Integer.parseInt(request.getParameter("idNum"));
			Class.forName("org.mariadb.jdbc.Driver");
			int usersCreated = myUtil.createClient(name,idNum,email,password,isStudent,isTutor,major);
			
			if (usersCreated == 1){ %>
				<h3> User account created successfully. </h3>
			<% } else { %>	
					<h2>User could not be created, try again.</h2>
			<% } 
		}
	}
%>

</body>
</html>