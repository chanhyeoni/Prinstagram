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
	out.println("<p>Welcome to Prinstagram, " + username + "</p");
	
	Database dbObj = (Database) session.getAttribute("database");
	String caption = request.getParameter("caption");
	String public_private =  request.getParameter("is_pub");
	boolean is_pub = false;
	if (public_private.equals("public")){
		is_pub = true;
	}
	
	byte[] image = "image".getBytes();
	int success = dbObj.postPhotoQuery(username, caption, null, null, null, is_pub, image);
	out.println("<p></p>");
	out.println("<p></p>");
	out.println("<p></p>");
	if(success==1){
		out.println("<p>Post Successful</p>");
	}else{
		out.println("<p>Post Failed</p>");
	}
	out.println("<p></p>");
	out.println("<p></p>");
	out.println("<p></p>");

%>
</body>
</html>