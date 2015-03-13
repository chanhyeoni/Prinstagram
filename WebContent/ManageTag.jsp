<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Prinstagram</title>
</head>

<body>

<%@ page import="java.util.*" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="Prinstagram.*" %>

<%
	String username = (String) session.getAttribute("username");
	out.println("Welcome to Prinstagram, " + username);
%>

<p></p>
<p></p>
<p></p>

<%
	Database dbObj = (Database) session.getAttribute("database");
	String command_pid = request.getParameter("command");
	String[] arr = command_pid.split(",");
	String command = arr[0];
	int pid = Integer.parseInt(arr[1]);
	System.out.println(command);
	System.out.println(pid);
	
	int success = dbObj.manageTagQuery(command, pid, username);
	
	if(success==1){
		out.println("<p>Successfully managed the tag</p>");
	}else{
		out.println("<p>We couldn't manage the tag. Please check back later.</p>");
	}
%>


</body>
</html>