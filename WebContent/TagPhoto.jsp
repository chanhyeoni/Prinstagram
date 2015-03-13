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
	out.println("<p></p>");
	out.println("<p></p>");
	out.println("<p></p>");
	
	// get the data
	String taggee = request.getParameter("taggee"); // taggee
	// pid
	int pid = Integer.parseInt(request.getParameter("photo"));
	
	Database dbObj = (Database) session.getAttribute("database");
	
	if(username.equals(taggee)){
		// if self-tagging, set the tag status to true
		int success = dbObj.tagPhotoQuery(pid, username, username, true);
		out.println("<p>Tag for Yourself Added Successfully</p>");
	}else if(!username.equals(taggee)){
		// check to see if the photo is visible to this person
		ResultSet visible_photo_taggee =  dbObj.getPhotoInfoQuery(taggee);
		
		// make the list of pids visible to the taggee
		List<Integer> pids = new ArrayList<Integer>();
		
		if(visible_photo_taggee != null){
			while(visible_photo_taggee.next()){
				int pid_for_taggee = visible_photo_taggee.getInt("pid");
				pids.add(pid_for_taggee);
			}
			
			if(pids.contains(pid)){
				// if the photo is visible to the taggee, then 
				int success = dbObj.tagPhotoQuery(pid, username, taggee, false);
				if(success==1){
					out.println("<p>Tag for " + taggee + " Added Successfully</p>");
				}else{
					out.println("<p>Tag Failed for Unknown Error</p>");
				}

			}else{
				out.println("<p>Tag Proposal for " + taggee + " Failed because it is not visible to " + taggee + ". Check back again.</p>");
			}
		}else{
			out.println("<p>Tag Proposal for " + taggee + " Failed because it is not visible to " + taggee + ". Check back again.</p>");
		}
	}else{
		out.println("<p>Tag Proposal Failed. Check back again.</p>");
	}
	
	

%>


</body>
</html>