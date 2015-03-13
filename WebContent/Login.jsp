<%@ page language="java" contentType="text/html; charset=US-ASCII"
    pageEncoding="US-ASCII"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
        <meta http-equiv="Content-Type" content="text/html; charset=windows-1256">
		<title>Login Page</title>
	</head>

	<body>
	<p>Login</p>
	<div id="login_form">
	   	<form name="f1" method="post" action="LoginServlet" id="f1">
	      	 <table>
	           <tr>
	               <td class="f1_label">User Name :</td><td><input type="text" name="username" value="" />
	               </td>
	           </tr>
	           <tr>
	               <td class="f1_label">Password  :</td><td><input type="text" name="password" value=""  />
	               </td>
	           </tr>
	           <tr>
	               <td>
	                   <input type="submit" name="login" value="Log In" style="font-size:18px; " />
	                </td>
	            </tr>
	        </table>
	    </form> 
	</div>
	</body>
</html>