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
<form action = "DeFriend.jsp" method="post">

<%
String username = (String) session.getAttribute("username");
out.println("<p>Welcome to Prinstagram, " + username + "</p>");
out.println("<p></p>");
out.println("<p></p>");
out.println("<p></p>");
%>
<p> Delete Friend </p>

<%
out.println("<p></p>");
out.println("<p></p>");
out.println("<p></p>");

Database dbObj = (Database) session.getAttribute("database");

List<String> groupList = dbObj.getGroupNameQuery(username);
List<List<String>> studentList = new ArrayList<List<String>>();

for (int i = 0; i < groupList.size(); i++){
	if(!groupList.get(i).isEmpty()){
		studentList.add(dbObj.returnListOfFriends(username, groupList.get(i)));
	}
}

for (int j = 0; j < studentList.size(); j++){
	

	List<String> group = studentList.get(j);

	if(!group.isEmpty()){
		String groupname = groupList.get(j);
		String a = group.get(0);
		out.println("<input type='radio' name='username_gname' value='" + a + ", " + groupname + "' checked>" + a + ", " + groupname );
		out.println("<br></p>");
		for (int k = 1; k < studentList.get(j).size(); k++){
			String b = group.get(k);
			out.println("<input type='radio' name='username_gname' value='" + b +  ", " + groupname  +"' >" + b + ", " + groupname );
			out.println("<p></p>");
		}
	}
}

out.println("<br><br>");

%>
<input type="submit" value="Delete">

</form>
</body>
</html>