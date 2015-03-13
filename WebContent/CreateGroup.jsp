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

<% 
	Database db = (Database) session.getAttribute("database");
	String groupname = request.getParameter("gname");
	String description = request.getParameter("descr");
	String duplicateCheck = db.getFriendGroupQuery(groupname, username);
	String[] elements = duplicateCheck.split(",");
	if(elements[0]==groupname && elements[1]==username){
		out.println("<p>Sorry. This group already exists. </p>");
	}else{
		int success = db.createFriendGroup(groupname, description, username);
		if(success==1){
			out.println("<p>Successfully created a group " + groupname + "</p>");
		}else{
			out.println("<p>We couldn't create " + groupname + " for some reason. Check back later.</p>");
		}
	}
%>
</body>
</html>