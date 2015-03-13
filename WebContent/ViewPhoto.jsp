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
	
	out.println("<p></p>");
	out.println("<p></p>");
	out.println("<p></p>");
	out.println("<p>View Photo</p>");
	out.println("<p></p>");
	out.println("<p></p>");
	out.println("<p></p>");
	
	Database dbObj = (Database) session.getAttribute("database");
	out.println("<p>View Photo Result for " + username + "</p>");
	LinkedHashMap<String, List<List<String>>> viewPhotoResult = dbObj.viewPhotoQuery(username);
	Set<String> keys = viewPhotoResult.keySet();
	Iterator<String> iterator = keys.iterator();
	
	while (iterator.hasNext()){
		String key = iterator.next();
		out.println("<p><font size='5'> " + key + "</font></p>");
		List<List<String>> values = viewPhotoResult.get(key);
		if(!values.isEmpty()){
			for (int i = 0; i < values.size(); i++){
				List<String> obj = values.get(i);
				if(!obj.isEmpty()){
					for (int j = 0; j < obj.size(); j++){
						out.println("<p></font size = '3'>" + obj.get(i) + "</font></p>");
					}
				}
			}
		}
	}
%>



</body>
</html>