<%@ page language="java" contentType="text/html; charset=US-ASCII"
    pageEncoding="US-ASCII"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
<title>Prinstagram</title>
</head>
<body>

<%@ page import="Prinstagram.*" %>
<%@ page import="java.sql.ResultSet" %>

<%
	String username = (String) session.getAttribute("username");
	out.println("Welcome to Prinstagram, " + username);
%>
<p></p>
<p></p>
<p></p>
<p>Create a Group</p>
<p></p>
<p></p>
<p></p>
<form action="CreateGroup.jsp" method="post">
THe name of the Group : <input type="text" name="gname">
<br>
Description : <input type="text" name = "descr">
<br>
<input type="submit" value="Create">
</form>


</body>
</html>