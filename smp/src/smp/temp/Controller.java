package smp.temp;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/smp")
public class Controller extends HttpServlet {
	private static final long serialVersionUID = 1L;

//	@Override
//	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//		requestProcess(request, response);
//	}
//	
//
////	@Override
////	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
////		request.setCharacterEncoding("utf-8");
////	}
//	
//	public void requestProcess(HttpServletRequest request, HttpServletResponse response) {
//		String command = request.getParameter("command");
//		if (command.equals("selectStudentList")) {
//			StudentController con = new StudentController();
////			con.selectStudentList(request);
//			
//		}
//		
//	}

}
