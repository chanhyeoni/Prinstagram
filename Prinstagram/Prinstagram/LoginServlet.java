package Prinstagram;
import java.io.IOException;  
import java.io.PrintWriter;  
  
import java.sql.SQLException;

import javax.servlet.annotation.WebServlet;
import javax.servlet.ServletException;  
import javax.servlet.http.HttpServlet;  
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpServletRequest;  
import javax.servlet.http.HttpServletResponse; 

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet{
	// by inheriting from the HttpServlet, it initiates a session automatically

	@Override
	public void doPost(HttpServletRequest request, HttpServletResponse response)  
			throws ServletException, IOException {  
		
		Database dbObj= new Database();
	
			response.setContentType("text/html");  
			PrintWriter out = response.getWriter();
			String user=request.getParameter("username");  
			String pw=request.getParameter("password");  
			// get the necessary parameters, which are username and password that 
	
			if(dbObj.loginValidate(user, pw)){
				// uses the loginValidate from Database_API code to launch the main menu
				// if the user and password is found from the database
				// create the MenuServlet object and use its doGet method to generate the 
				// menu page
			    HttpSession session = request.getSession(true);	
			    session.setAttribute("username", user);
			    session.setAttribute("database", dbObj);
			    response.sendRedirect("Menu.jsp");
			}else{  
				response.sendRedirect("invalidLogin.jsp");
			}
	}
	

}   


