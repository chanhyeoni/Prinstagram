<%@ page language="java" contentType="text/html; charset=US-ASCII"
    pageEncoding="US-ASCII"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
<title>Prinstagram</title>
</head>
<body>

<%@ page import="java.util.*" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="Prinstagram.*" %>

<%
String username = (String) session.getAttribute("username");
out.println("<p>Welcome to Prinstagram, " + username + "</p>");
out.println("<p></p>");
out.println("<p></p>");
out.println("<p></p>");

Database dbObj = (Database) session.getAttribute("database");
String username_input = request.getParameter("username");
String fname = request.getParameter("fname");
String lname = request.getParameter("lname");
String groupname = request.getParameter("gname");

List<String> listFriends = dbObj.returnListOfFriends(username, groupname);

if(!dbObj.checkWhetherInPersonTable(fname, lname)){
	// if the person cannot be found
	out.println(fname + " " + lname + " is not registered in the Prinstagram");
}else{
	// go to the list of friends you have and see if there is any match with the name
	// you have 
	if(listFriends.contains(username_input)){
		// since if the username is the same, that means you are trying to add
		// a person you already have (username is unique), so
		out.println("you already have  "+ fname + " " + lname + " in " + groupname);
	}else{
		
		int success = dbObj.addFriendQuery(username, groupname, username_input);
		if(success==1){
			out.println("<p>Successfully added " + fname + " " + lname + " in " + groupname + "</p>");
		}else{
			out.println("<p>Nothing happened</p>");
		}
	}
}
%>

</body>
</html>