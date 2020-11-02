package com.eggs.chickendash;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Properties;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class TrainerServlet
 */

public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private HashMap<String, UserBean> users = new HashMap<String, UserBean>();
	private static Properties props = null;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public LoginServlet() {
        super();

    }

	public void init() throws ServletException {
		super.init();

	      /* if (props==null) {
	        	props = new Properties();
	        	try {
	        		FileInputStream fis = new FileInputStream(this.getServletContext().getRealPath("/chickendash.properties"));
	        		props.load(fis);
	        		fis.close();
	        	} catch (Exception e) {
	        		e.printStackTrace();
	        	}
	        }*/

		//hard-code users
	    UserBean eggebraa = new UserBean();
	    eggebraa.setFullname("Eggebraaten");
	    eggebraa.setPassword("7eggs18");
	    eggebraa.setUsername("eggebraa");
	    eggebraa.setAdmin(true);
	    users.put("eggebraa", eggebraa);

	    UserBean guest = new UserBean();
	    guest.setFullname("Guest");
	    guest.setPassword("guest");
	    guest.setUsername("guest");
	    guest.setAdmin(false);
	    users.put("guest", guest);

	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request,response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		routeRequest(request,response);
	}

	private void routeRequest(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {

		String action = request.getParameter("action");
		if (action==null) action = "";

		if (action.equals("login")) {
			login(request, response);
			return;
		}

		//first check if logged in...
		HttpSession session = request.getSession();
		UserBean user = (UserBean)session.getAttribute("user");
		if (user==null) {
			goLoginPage(request, response);
			return;
		}

		if (action.equals("logout")) {
			logout(request, response);
		} else if (action.equals("changeProfilePage")) {
			changeProfilePage(request, response);
		} else if (action.equals("changeProfile")) {
			changeProfile(request, response);
		} else if (action.equals("manageUsersPage")) {
			manageUsersPage(request, response);
		} else if (action.equals("addUserPage")) {
			addUserPage(request, response);
		} else if (action.equals("editUserPage")) {
			editUserPage(request, response);
		} else if (action.equals("addUser")) {
			addUser(request, response);
		} else if (action.equals("editUser")) {
			editUser(request, response);
		} else if (action.equals("deleteUser")) {
			deleteUser(request, response);
		} else {
			goLoginPage(request, response);
		}

	}

	private void goLoginPage(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		RequestDispatcher dispatcher = getServletContext().getRequestDispatcher("/jsp/login.jsp");
		dispatcher.forward(request, response);

	}
	private void addUserPage(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		RequestDispatcher dispatcher = getServletContext().getRequestDispatcher("/jsp/addUser.jsp");
		dispatcher.forward(request, response);

	}
	private void editUserPage(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		UserBean editUser = users.get(request.getParameter("username"));
		request.setAttribute("editUser", editUser);
		RequestDispatcher dispatcher = getServletContext().getRequestDispatcher("/jsp/editUser.jsp");
		dispatcher.forward(request, response);

	}
	private void changeProfilePage(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		RequestDispatcher dispatcher = getServletContext().getRequestDispatcher("/jsp/changeProfile.jsp");
		dispatcher.forward(request, response);

	}
	private void manageUsersPage(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		request.setAttribute("users", users);

		RequestDispatcher dispatcher = getServletContext().getRequestDispatcher("/jsp/manageUsers.jsp");
		dispatcher.forward(request, response);

	}

	private void changeProfile(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		HttpSession session = request.getSession();
		UserBean sessionUser = (UserBean)session.getAttribute("user");

		UserBean user = users.get(sessionUser.getUsername());
		user.setFullname(request.getParameter("fullname"));
		//user.setPassword(pw1);

		session.setAttribute("user", user);
		users.put(user.getUsername(), user);

		goHome(request, response);
	}
	private void addUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String username = request.getParameter("username");
		String fullname = request.getParameter("fullname");
		String admin = request.getParameter("admin");
		String writeAccess = request.getParameter("writeAccess");
		String[] sources = request.getParameterValues("sourceAccess");

		if (users.containsKey(username)) {
			request.setAttribute("message", " Error: User with username '" + username + "' already exists.");
			addUserPage(request, response);
			return;
		}

		UserBean user = new UserBean();
		user.setUsername(username);
		user.setFullname(fullname);
		user.setSourceAccess(sources);

		if (admin!=null) user.setAdmin(true);
		if (writeAccess!=null) user.setWriteAccess(true);

		users.put(user.getUsername(), user);

		manageUsersPage(request, response);
	}
	private void editUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String username = request.getParameter("username");
		String fullname = request.getParameter("fullname");
		//String pw1 = request.getParameter("password");
		//String pw2 = request.getParameter("password2");
		String admin = request.getParameter("admin");
		String writeAccess = request.getParameter("writeAccess");
		String[] sources = request.getParameterValues("sourceAccess");

		UserBean user = users.get(username);
		user.setUsername(username);
		user.setFullname(fullname);
		if (admin!=null) {
			user.setAdmin(true);
		} else {
			user.setAdmin(false);
		}
		if (writeAccess!=null) {
			user.setWriteAccess(true);
		} else {
			user.setWriteAccess(false);
		}
		user.setSourceAccess(sources);

		users.put(user.getUsername(), user);

		manageUsersPage(request, response);
	}
	private void deleteUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String username = request.getParameter("username");

		users.remove(username);
		manageUsersPage(request, response);
	}

	private void goHome(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		//CartridgeServlet cs = new CartridgeServlet();
		//cs.init();
		//cs.goHome(request, response);
		//request.setAttribute("stats", TrainerUtils.getCaseStats(TrainerServlet.getCases()));
		RequestDispatcher dispatcher = getServletContext().getRequestDispatcher("/jsp/DashboardServlet.do?action=dashboard");
		dispatcher.forward(request, response);

	}
	private void logout(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
		session.removeAttribute("user");

		goLoginPage(request, response);
	}
	private void login(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		//login
		String username = request.getParameter("username");
		String password = request.getParameter("password");

		if (!isValidUser(username)) {
			request.setAttribute("message", " Error: '" + username + "' is not a valid user. ");
			goLoginPage(request, response);
			return;
		}
		if (!isAuthenticated(username, password)) {
			request.setAttribute("message", " Error: Password is not valid for user '" + username + "'. ");
			goLoginPage(request, response);
			return;
		}

		//authenticated, so create session
		HttpSession session = request.getSession(true);
		session.setMaxInactiveInterval(86400);

		UserBean user = users.get(username);
		//set prefs
		user.setUserPreference("showMetadata", "true");
		user.setUserPreference("showAttrs", "false");
		user.setUserPreference("showAnswers", "true");
		user.setUserPreference("showCreateModify", "false");
		user.setUserPreference("usageTypeFilter", "All");
		user.setUserPreference("sourceFilter", "All");
		user.setUserPreference("stageFilter", "All");

		session.setAttribute("user", users.get(username));


		goHome(request, response);

	}

	private boolean isValidUser(String username) {
		//System.out.println("User key set is " + users.keySet());
		//System.out.println("Input user name is " + username);
		if (users.keySet().contains(username)) {
			return true;
		} else {
			return false;
		}
	}
	private boolean isAuthenticated(String username, String password) {

		UserBean user = users.get(username);
		if (user==null) return false;
		if (user.getPassword().equals(password)) {
			return true;
		} else {
			return false;
		}
	}

}
