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
<h2></h2>

<div class="header">
	<a class="active" href="loginForm.jsp">Home</a>
	<a href="generalMenu.jsp">General Menu</a>
	<a href="studentMenu.jsp">Student Menu</a>
	<a href="tutorMenu.jsp">Tutor Menu</a>
</div>

</body>
</html>