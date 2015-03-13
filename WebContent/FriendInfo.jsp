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
	List<String> groupList = dbObj.getGroupNameQuery(username); 
	
	if(groupList.size()!=0){
		for (int i = 0; i < groupList.size(); i++){
			out.println("<p><font size='5'> GroupName : " + groupList.get(i) + "</font></p>");
			List<String> friendsList = dbObj.showFriends(username, groupList.get(i));
			List<Integer> friendCount = dbObj.countFriends(username, groupList.get(i));
			if(friendsList.size()!=0){
				for (int j = 0; j < friendsList.size(); j++){
					out.println("<p><font size='3'>" + friendsList.get(j) + "</font></p>");
				}
				if(friendCount.size()!=0){
					out.println("<p><font size='3'> You have " + friendCount + " friends in this group</font></p>");
				}
			}else{
				out.println("<p><font size='3'> You have no friends in this group</font></p>");
			}
		
		}
	}else{
		out.println("<p><font size='5'> You don't own any groups</font></p>");
	}

%>

</body>
</html>