<%@ page language="java" contentType="text/html; charset=US-ASCII"
    pageEncoding="US-ASCII"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
<title>Prinstagram</title>
</head>
<body>
<%
String username = (String) session.getAttribute("username");
out.println("Welcome to Prinstagram, " + username);
%>

<p>Choose one of the following items</p>
<ul style = "list-style-type:square">
	<li><a href="ViewPhoto.jsp">View Photo</a></li>
	<li><a href="PostPhotoInput.jsp">Post Photo</a></li>
	<li><a href="ManageTagInput.jsp">Manage Tag</a></li>
	<li><a href="TagPhotoInput.jsp">Tag Photo</a></li>
	<li><a href="AddFriendInput.jsp">Add Friends</a></li>
	<li><a href="DeFriendInput.jsp">Delete Friends</a></li>
	<li><a href="FriendInfo.jsp">Friends</a></li>
	<li><a href="CreateGroupInput.jsp">Create Group</a></li>
</ul>

</body>
</html>