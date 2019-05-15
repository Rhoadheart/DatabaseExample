<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<jsp:useBean id="myUtil" class="dbUtil.Utilities" scope="session"></jsp:useBean>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href= "style.css">
<meta charset="ISO-8859-1">
<title></title>
</head>
<body>
<h2>Login/Create User Page</h2>
<%	
	Class.forName("org.mariadb.jdbc.Driver");
	myUtil.openDB();
%>

<h2> Log In</h2>
<form action = "loginHandler.jsp" method="post">
  Email: <input type="text" name="email"><br>
  Password: <input type="password" name="password"><br>
  <input type="submit" value="Login">
</form>

<h2> Create User account</h2>
<form action = "createUserHandler.jsp" method="post">
  Name: <input type="text" name="username"><br>
  ID Number: <input type="number" name="idNum"><br>
  Email(end in @plu.edu): <input type="text" name="email"><br>
  Password: <input type="password" name="password"><br>
  Student(check box for yes): <input type="checkbox" name="isStudent"><br>
  Tutor(check box for yes): <input type="checkbox" name="isTutor"><br>
  Major(s): <input type="text" name="major"><br>
  <input type="submit" value="Create User">
</form>

</body>
</html>