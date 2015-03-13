<%@ page language="java" contentType="text/html; charset=US-ASCII"
    pageEncoding="US-ASCII"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
<title>Insert title here</title>
</head>
<body>

<%@ page import="java.util.*" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="Prinstagram.*" %>

<%
String username = (String) session.getAttribute("username");
out.println("Welcome to Prinstagram, " + username);
out.println("<p></p>");
out.println("<p></p>");
out.println("<p></p>");
Database dbObj =(Database) session.getAttribute("database");
String username_gname = request.getParameter("username_gname");

String [] elements = username_gname.split(", ");
String username_deleted = elements[0];
String gname_deleted = elements[1];

int delete_success = dbObj.defriendQuery(username, username_deleted, gname_deleted);
if(delete_success==1){
	// call delete comment and tag functions
	out.println("<p>Successfully deleted "+ username_deleted + " from "+ gname_deleted + "</p>");
	int delete_comment_success = dbObj.deleteCommentQuery(username_deleted, gname_deleted);
	int delete_tag_success = dbObj.deleteCommentQuery(username_deleted, gname_deleted);
	if(delete_comment_success ==1){
		out.println("<p>successfully deleted the comments of"+ username_deleted + " from "+ gname_deleted + "</p>");
	}
	if(delete_tag_success == 1){
		out.println("<p>successfully deleted the tags of"+ username_deleted + " from "+ gname_deleted + "</p>");
	}
}

%>

</body>
</html>