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
<%@ page import="java.util.*" %>
<%
String username = (String) session.getAttribute("username");
out.println("Welcome to Prinstagram, " + username);
out.println("<p></p>");
out.println("<p></p>");
out.println("<p></p>");
%>

<p> Add Friend </p>

<%
out.println("<p></p>");
out.println("<p></p>");
out.println("<p></p>");
%>

<form action = "AddFriend.jsp" method="post">
Username : <input type ="text" name = "username"><br>
First Name : <input type="text" name="fname"><br>
Last Name : <input type="text" name="lname"><br>
Group: 
<%
Database dbObj = (Database) session.getAttribute("database");
List<String> groupList = dbObj.getGroupNameQuery(username);
out.println("<input type='radio' name='gname' value='" + groupList.get(0) + "' checked>" + groupList.get(0));
for (int i = 1; i < groupList.size(); i++){
	out.println("<input type='radio' name='gname' value='" + groupList.get(i) + "'>" + groupList.get(i));
	out.println("     ");
}
out.println("<br><br>");
%>
<input type="submit" value="Add">
</form>



</body>
</html>