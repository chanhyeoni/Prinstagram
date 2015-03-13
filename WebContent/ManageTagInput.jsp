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
<p>Manage Tags</p>
<p></p>
<p></p>
<p></p>
<form action = "ManageTag.jsp" method="post">
<%

	Database dbObj = (Database) session.getAttribute("database");
	ResultSet rs = dbObj.getAllProposedTags(username);
	if(rs != null){
		while(rs.next()){
			String pid = Integer.toString(rs.getInt("pid"));
			String tagger = rs.getString("tagger");
			String time = rs.getTimestamp("ttime").toString();
			String tag = pid + ", " + tagger + ", " + time + ", ";
			out.print("<p>" + tag);
			out.print("<input type='radio' name='command' value='delete," + pid + "' checked>Delete");
			out.print("<input type='radio' name='command' value='update," + pid + "'>Update");
			out.print("<input type='radio' name='command' value='undetermined," + pid + "'>Undetermined");
			out.println("<br><br>");
			
		}
		out.println("<input type= 'submit' value='Submit'>");
	}else{
		out.println("<p>There is no tag to be managed.</p>");
	}

%>

</form>
</body>
</html>