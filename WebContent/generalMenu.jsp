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
<h2>General Menu</h2>

<%	
	Class.forName("org.mariadb.jdbc.Driver");
%>

<% if (myUtil.getConn() == null) // forward to login page
{
%>
<jsp:forward page="loginForm.jsp" />
<%} // end if -- the rest of the JSP file will be ignored if no connection
%>

<h2>Choose Menu Type</h2>
<form action = "studentMenu.jsp" method="post">
  <input type="submit" value="Student Menu"><br /> <br />
</form>

<form action = "tutorMenu.jsp" method="post">
  <input type="submit" value="Tutor Menu">
</form>

<h2> Update password </h2>
<form action = "passwordUpdateForm.jsp" method="post">
  Old password: <input type="password" name="oldPassword"><br>
  <input type="submit" value="Update Password">
</form>

<h2> Delete account </h2>
<form action = "deleteAccountForm.jsp" method="post">
  Password: <input type="password" name="password"><br>
  <input type="submit" value="Delete Account">
</form>

</body>
</html>