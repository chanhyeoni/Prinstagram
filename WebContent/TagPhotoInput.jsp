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
<%@ page import="java.sql.ResultSet" %>
<%
	String username = (String) session.getAttribute("username");
	out.println("Welcome to Prinstagram, " + username);
%>

<p></p>
<p></p>
<p></p>
<p>Add a Tag</p>
<p></p>
<p></p>
<p></p>

<form action="TagPhoto.jsp" method="post">
<%
	Database dbObj = (Database) session.getAttribute("database");
	ResultSet result_photo = dbObj.getPhotoInfoQuery(username);
	
	if(result_photo != null){
		out.println("<p>Photo :</p>");
		while(result_photo.next()){
			String pid = Integer.toString(result_photo.getInt("pid"));
			String pdate = result_photo.getTimestamp("pdate").toString();
			String caption = result_photo.getString("caption");
			String photo = pid+ ", " + pdate + ", " + caption;
			out.println("<input type='radio' name='photo' value = '" + pid + "'>" + photo + "<br>");	
		}
		out.println("The Taggee Username : <input type='text' name='taggee'><br>");
		out.println("<input type='submit' value='Add Taggee'>");
	}else{
		out.println("<p> There is no photo visible to you </p>");
	}

%>
</form>

</body>
</html>