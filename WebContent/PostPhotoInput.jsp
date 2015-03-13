<%@ page language="java" contentType="text/html; charset=US-ASCII"
    pageEncoding="US-ASCII"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
<title>Prinstagram</title>
</head>
<body>

<%
String username = (String) session.getAttribute("username");
out.println("Welcome to Prinstagram, " + username);
%>
<p></p>
<p></p>
<p></p>
<p>Post Photo</p>
<p></p>
<p></p>
<p></p>
<form action = "PostPhoto.jsp" method = "post">
Caption: <input type="text" name="caption"><br>
Public or private : <input type="radio" name="is_pub" value='public' checked>Public
		<input type="radio" name="is_pub" value='private'>Private <br><br>
<input type="submit" value="Submit">
</form>
</body>
</html>