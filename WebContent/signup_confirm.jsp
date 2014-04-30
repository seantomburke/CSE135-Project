<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags"%>

<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*" %>

<%
	PrintWriter o = response.getWriter();

	boolean successful = false;
	String name = request.getParameter("username");
	if (name != null) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			// Registering Postgresql JDBC driver with the DriverManager
			Class.forName("org.postgresql.Driver");

			// Open a connection to the database using DriverManager
			conn = DriverManager.getConnection(
					"jdbc:postgresql://ec2-23-21-185-168.compute-1.amazonaws.com:5432/ddbj4k4uieorq7?ssl=true&sslfactory=org.postgresql.ssl.NonValidatingFactory",
					"qwovydljafffgl", "cGdGZam7xcem_isgwfV3FQ_jxs"); //TODO: Change name of database accordingly
			
			if (name != null) {
				// Create the statement
				Statement statement = conn.createStatement();
				// Use the created statement to SELECT
				// the student attributes FROM the Student table.
				pstmt = conn
						.prepareStatement("SELECT * FROM users WHERE name=?"); //TODO: Change accordingly
				pstmt.setString(1, name);
				System.out.println(name);
				rs = pstmt.executeQuery();
				//out.println("<h1>" + "test" + "</h1>");
				if (rs.next())
				{
					System.out.print("There is an entry already! " + rs.findColumn("name"));
					successful = false; //match found
				}
				else
				{
					System.out.print("good to go! " + rs.findColumn("name"));
					successful = true;
				}
					
				if(successful)
				{
					//TODO: Change accordingly: 
					pstmt = conn.prepareStatement("INSERT INTO users (name, role, age, state) VALUES (?,?,?,?)");
					pstmt.setString(1, name);
					pstmt.setString(2, request.getParameter("role"));
					pstmt.setInt(3, Integer.parseInt(request.getParameter("age")));
					pstmt.setString(4, request.getParameter("state"));
					
					pstmt.executeUpdate();
				}

				// Close the ResultSet
				rs.close();
				// Close the Statement
				statement.close();
				// Close the Connection
				conn.close();
			}
		} catch (SQLException e) {
            e.printStackTrace();
            out.println("<h1>" + "Shit happened" + "</h1>");
            
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
			out.println("<h1>org.postgresql.Driver Not Found</h1>");
		}
	}
%>

<t:header title='Registration Confirmation'/>

	<% 
	if(successful)
	{ 
	%>
		<h1>Registration Successful!</h1>
		<h3>Thank you for signing up with us!</h3>
		<%
		String role = ""+session.getAttribute("role");
		if(role.equals("Owner")) { %>
			<a class="btn btn-default" href="/CSE135Project/categories.jsp">Go to Categories</a>
		<% }
		if(role.equals("Customer")) { %>
			<a class="btn btn-default" href="/CSE135Project/product_browsing.jsp" >Go to Product Browsing</a>
		<%}%>
		
		<a class="btn btn-default" href="/CSE135Project/login.jsp" >Go to Log In</a>
		
	<% }
	
	else{ %>
		<h1>Registration Not Successful!</h1>
		<h3>Unfortunately, someone else is using your username. Please go back and choose another username</h3>
		<a class="btn btn-default" href="/CSE135Project/signup.jsp">Go
		Back</a>
	<% } %>
<t:footer/>