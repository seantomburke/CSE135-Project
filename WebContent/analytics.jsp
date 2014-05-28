<%@page import="org.postgresql.util.PSQLException"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags"%>

<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>


<t:header title="Sales Analytics" />
<%

Connection conn=null;
Statement stmt,stmt_2,stmt_3;
ResultSet rs=null,rs_2=null,rs_3=null;
String SQL=null;
try
{
	try{Class.forName("org.postgresql.Driver");}catch(Exception e){System.out.println("Driver error");}
	
	/* 	conn = DriverManager.getConnection(
    "jdbc:postgresql://localhost/CSE135?" +
    "user=Bonnie");  */
            
		conn = DriverManager.getConnection("jdbc:postgresql://ec2-23-21-185-168.compute-1.amazonaws.com:5432/ddbj4k4uieorq7?ssl=true&sslfactory=org.postgresql.ssl.NonValidatingFactory",
    	"qwovydljafffgl", "cGdGZam7xcem_isgwfV3FQ_jxs");
	stmt =conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
	stmt_2 =conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
	stmt_3 =conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
	
	System.out.println("=================");
	
	//scope session variable
	String scope = ""+request.getParameter("scope");
	System.out.println("scope: " + scope);
	
	//r_offset and next_r_offset session variable
	String r_offset, next_r_offset;
	if(request.getParameter("r_offset") != null && !request.getParameter("r_offset").equals("0"))
	{
		r_offset = String.valueOf(Integer.valueOf(request.getParameter("r_offset")));
		next_r_offset = String.valueOf(Integer.valueOf(request.getParameter("r_offset"))+20);
	}
	else
	{
		r_offset = "0";
		next_r_offset = "20";
	}
	System.out.println("r_offset: " + r_offset);
	System.out.println("next_r_offset: " + next_r_offset);
	
	//c_offset and next_c_offset session variable
	String c_offset, next_c_offset;
	if(request.getParameter("c_offset") != null && !request.getParameter("c_offset").equals("0"))
	{
		c_offset = String.valueOf(Integer.valueOf(request.getParameter("c_offset")));
		next_c_offset = String.valueOf(Integer.valueOf(request.getParameter("c_offset"))+10);
	}
	else
	{
		c_offset = "0";
		next_c_offset = "10";
	}
	
	System.out.println("c_offset: " + c_offset);
	System.out.println("next_c_offset: " + next_c_offset);
	
	//state session variable
	String state = request.getParameter("state");
	System.out.println("state: " + state);
	
	//category session variable
	String category = request.getParameter("category");
	System.out.println("category: " + category);
	
	//age session variable
	String age = request.getParameter("ages");
	System.out.println("age: " + age);
	
	//Determine if buttons need to be disabled because of offset
	String disabled = "disabled";
	if(r_offset.equals("0") && c_offset.equals("0"))
	{
		disabled = "";
	}
	System.out.println(disabled);
	
	String SQL_1 = null;
	String SQL_2 = null;
	
	String SQL_11 = null;
	String SQL_21 = null;
	
	String SQL_3 = null;
	
	if(category == null || category.equals("all") || category.equals("null"))
	{
		System.out.println("columns: product - no filters");
		/** pulls product names, no filters**/
		SQL_1 ="SELECT p.id, p.name, SUM(s.quantity*s.price) AS amount" +
			" FROM products p" +
			" LEFT JOIN sales s" + 
			" ON s.pid = p.id" +
			" GROUP BY p.name,p.id" + 
			" ORDER BY p.name ASC" +
			" LIMIT 10 OFFSET "+c_offset;
		SQL_11="SELECT p.id, p.name, SUM(s.quantity*s.price) AS amount" +
				" FROM products p" +
				" LEFT JOIN sales s" + 
				" ON s.pid = p.id" +
				" GROUP BY p.name,p.id" + 
				" ORDER BY p.name ASC" +
				" LIMIT 1 OFFSET "+next_c_offset;
		
	}
	else
	{
		System.out.println("columns: product - category filters");
		/** pulls product names, category filter**/		 
		 SQL_1 ="SELECT p.id, p.name, SUM(s.quantity*s.price) AS amount" +
					" FROM products p" +
					" LEFT JOIN sales s" + 
					" ON s.pid = p.id" +
					" WHERE p.cid='"+ category +"'" +
					" GROUP BY p.name,p.id" + 
					" ORDER BY p.name ASC" +
					" LIMIT 10 OFFSET "+c_offset;
		 SQL_11 ="SELECT p.id, p.name, SUM(s.quantity*s.price) AS amount" +
					" FROM products p" +
					" LEFT JOIN sales s" + 
					" ON s.pid = p.id" +
					" WHERE p.cid='"+ category +"'" +
					" GROUP BY p.name,p.id" + 
					" ORDER BY p.name ASC" +
					" LIMIT 1 OFFSET "+next_c_offset;
	}			
	
	
	//scope = states
	if(scope.equals("states"))
	{
		if(state == null || state.equals("all") || state.equals("all"))
		{
			System.out.println("rows: states - no filters");
			/** pulls state names, no filters**/
			
		  SQL_2 ="SELECT u.state, SUM(s.quantity*s.price) AS amount"+
					" FROM users u LEFT JOIN sales s"+
					" ON s.uid = u.id"+
					" GROUP BY u.state"+
					" ORDER BY u.state ASC"+
					" LIMIT 20 OFFSET "+r_offset;
			SQL_21 ="SELECT u.state, SUM(s.quantity*s.price) AS amount"+
					" FROM users u LEFT JOIN sales s"+
					" ON s.uid = u.id"+
					" GROUP BY u.state"+
					" ORDER BY u.state ASC"+
					" LIMIT 1 OFFSET "+next_r_offset;
			
			SQL_3="SELECT s.pid, u.state, SUM(s.quantity*s.price) AS amount"+
					" FROM sales AS s, users AS u"+
					" WHERE u.state IN (SELECT DISTINCT state FROM users ORDER BY state ASC LIMIT 20 OFFSET "+r_offset+")"+
					" AND s.pid IN (SELECT id FROM products ORDER BY name ASC LIMIT 10 OFFSET "+c_offset+")"+
					" AND s.uid = u.id"+
					" GROUP BY u.state, s.pid";
		}
		else
		{
			System.out.println("rows: states - state filters");
			/* pulls state names, state filter */
			SQL_2 ="SELECT u.state, SUM(s.quantity*s.price) AS amount"+
					" FROM users u LEFT JOIN sales s"+
					" ON s.uid = u.id"+
					" WHERE u.state='"+ state +"'" + 
					" GROUP BY u.state"+
					" ORDER BY u.state ASC"+
					" LIMIT 20 OFFSET "+r_offset;
			SQL_21 ="SELECT u.state, SUM(s.quantity*s.price) AS amount"+
					" FROM users u LEFT JOIN sales s"+
					" ON s.uid = u.id"+
					" WHERE u.state='"+ state +"'" + 
					" GROUP BY u.state"+
					" ORDER BY u.state ASC"+
					" LIMIT 1 OFFSET "+next_r_offset;
			SQL_3="SELECT s.pid, u.state, SUM(s.quantity*s.price) AS amount"+
					" FROM sales AS s, users AS u"+
					" WHERE u.state IN (SELECT DISTINCT state FROM users WHERE state = '"+state+"' ORDER BY state ASC LIMIT 20 OFFSET "+r_offset+")"+
					" AND s.pid IN (SELECT id FROM products ORDER BY name ASC LIMIT 10 OFFSET "+c_offset+")"+
					" AND s.uid = u.id"+
					" GROUP BY u.state, s.pid";
		}
	}
	//scope = customers
	else
	{
		int selector = 11;
		if (state != null && !state.equals("all") && !state.equals("null"))
			selector -= 1;
		if (age != null && !age.equals("all") && !age.equals("null"))
			selector -= 10;
		System.out.println("selector: " + selector);
		
		if(selector == 11)
		{
			System.out.println("rows: user - no filters");
			/** pulls user names, no filters**/
			SQL_2 ="SELECT u.id, u.name, SUM(s.quantity*s.price) AS amount"+
					" FROM users u LEFT JOIN sales s ON s.uid = u.id"+
					" GROUP BY u.name,u.id"+
					" ORDER BY u.name ASC LIMIT 20"+
					" OFFSET "+r_offset;
			SQL_21 ="SELECT u.id, u.name, SUM(s.quantity*s.price) AS amount"+
					" FROM users u LEFT JOIN sales s ON s.uid = u.id"+
					" GROUP BY u.name,u.id"+
					" ORDER BY u.name ASC LIMIT 1"+
					" OFFSET "+next_r_offset;
			SQL_3 ="SELECT s.pid, s.uid, SUM(s.quantity*s.price) AS amount"+
					" FROM sales AS s"+
					" WHERE s.uid IN"+
					" (SELECT id FROM users ORDER BY name ASC LIMIT 20 OFFSET "+r_offset+")"+
					" AND s.pid IN (SELECT id FROM products ORDER BY name ASC LIMIT 10 OFFSET "+c_offset+")"+
					" GROUP BY s.uid, s.pid";
		}
		else if(selector == 10) 
		{
			System.out.println("rows: user - state filters");
			/* pulls user names, state filter */ 	
		    SQL_2 ="SELECT u.id, u.name, SUM(s.quantity*s.price) AS amount"+
					" FROM users u LEFT JOIN sales s ON s.uid = u.id"+
					" WHERE u.state='"+ state +"'" + 
					" GROUP BY u.name,u.id"+
					" ORDER BY u.name ASC LIMIT 20"+
					" OFFSET "+r_offset;
			SQL_21 ="SELECT u.id, u.name, SUM(s.quantity*s.price) AS amount"+
					" FROM users u LEFT JOIN sales s ON s.uid = u.id"+
					" WHERE u.state='"+ state +"'" + 
					" GROUP BY u.name,u.id"+
					" ORDER BY u.name ASC LIMIT 1"+
					" OFFSET "+next_r_offset;
			SQL_3 ="SELECT s.pid, s.uid, SUM(s.quantity*s.price) AS amount"+
					" FROM sales AS s"+
					" WHERE s.uid IN"+
					" (SELECT id FROM users WHERE state = '"+state+"' ORDER BY name ASC LIMIT 20 OFFSET "+r_offset+")"+
					" AND s.pid IN (SELECT id FROM products ORDER BY name ASC LIMIT 10 OFFSET "+c_offset+")"+
					" GROUP BY s.uid, s.pid";
		}
		else if (selector == 01)
		{
			System.out.println("rows: user - age filters");
			/* pulls user names, age filter */ 	
			SQL_2 ="SELECT u.id, u.name, SUM(s.quantity*s.price) AS amount"+
						" FROM users u LEFT JOIN sales s ON s.uid = u.id"+
						" WHERE u.age between " + age +  
						" GROUP BY u.name,u.id"+
						" ORDER BY u.name ASC LIMIT 20"+
						" OFFSET "+r_offset;
			SQL_21 ="SELECT u.id, u.name, SUM(s.quantity*s.price) AS amount"+
					" FROM users u LEFT JOIN sales s ON s.uid = u.id"+
					" WHERE u.age between " + age +  
					" GROUP BY u.name,u.id"+
					" ORDER BY u.name ASC LIMIT 1"+
					" OFFSET "+next_r_offset;
			SQL_3 ="SELECT s.pid, s.uid, SUM(s.quantity*s.price) AS amount"+
					" FROM sales AS s"+
					" WHERE s.uid IN"+
					" (SELECT id FROM users WHERE age BETWEEN "+age+" ORDER BY name ASC LIMIT 20 OFFSET "+r_offset+")"+
					" AND s.pid IN (SELECT id FROM products ORDER BY name ASC LIMIT 10 OFFSET "+c_offset+")"+
					" GROUP BY s.uid, s.pid";
		}
		else if (selector == 00)
		{
			System.out.println("rows: user - age and state filters");
			/* pulls user names, age and state filter */ 	
		   SQL_2 ="SELECT u.id, u.name, SUM(s.quantity*s.price) AS amount"+
					" FROM users u LEFT JOIN sales s ON s.uid = u.id"+
					" WHERE u.age between " + age + " AND u.state='"+ state +"'" +
					" GROUP BY u.name,u.id"+
					" ORDER BY u.name ASC LIMIT 20"+
					" OFFSET "+r_offset;
					  
		   SQL_21 ="SELECT u.id, u.name, SUM(s.quantity*s.price) AS amount"+
					" FROM users u LEFT JOIN sales s ON s.uid = u.id"+
					" WHERE u.age between " + age + " AND u.state='"+ state +"'" +
					" GROUP BY u.name,u.id"+
					" ORDER BY u.name ASC LIMIT 1"+
					" OFFSET "+next_r_offset;
		   SQL_3 ="SELECT s.pid, s.uid, SUM(s.quantity*s.price) AS amount"+
					" FROM sales AS s"+
					" WHERE s.uid IN"+
					" (SELECT id FROM users WHERE age BETWEEN "+age+" AND state = '"+state+"' ORDER BY name ASC LIMIT 20 OFFSET "+r_offset+")"+
					" AND s.pid IN (SELECT id FROM products ORDER BY name ASC LIMIT 10 OFFSET "+c_offset+")"+
					" GROUP BY s.uid, s.pid";
		}
	}
	
	/* Determine if there are more rows and columns */
	Statement stmt_11 =conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs_11=stmt_11.executeQuery(SQL_11);
	boolean moreColumns = false;
	while(rs_11.next())
	{
		moreColumns = true;
	}
	Statement stmt_21 =conn.createStatement();
	ResultSet rs_21=stmt_21.executeQuery(SQL_21);
	boolean moreRows = false;
	while(rs_21.next())
	{
		moreRows = true;
	}
	
	System.out.println("moreColumns: " + moreColumns);
	System.out.println("moreRows: " + moreRows);
	
	System.out.println(SQL_1);				
	rs=stmt.executeQuery(SQL_1);
	System.out.println(SQL_2);
	rs_2=stmt_2.executeQuery(SQL_2);
	System.out.println(SQL_3);
	rs_3=stmt_3.executeQuery(SQL_3);
	
	//state not id, many users in one state
//    out.println("product #:"+p_list.size()+"<br>state #:"+s_list.size()+"<p>");
	int i=0,j=0;	
	float amount=0;
%>


<table class="table">

<thead>
<tr>	
<td>
<a class="btn btn-default btn-primary" href='analytics.jsp' >Home</a>
</td>
		<%
			PreparedStatement c_pstmt = null;
			ResultSet c_rs = null;
			
			c_pstmt = conn.prepareStatement("SELECT * FROM categories");
			c_rs = c_pstmt.executeQuery();
		%>
	
		<!-- For Choosing States vs. Customers Table -->
		<form class="navbar-form navbar-left" role="search" action="analytics.jsp" method="GET">
				<td>
				<select class="form-control" name="scope" <%= disabled %>>
		        	<option value="customers">Customers</option>
					<option value="states">States</option>
		        </select>
				</td><td>
		        <select class="form-control" name="ages" <%= disabled %>>
		        	<option value="all">All Ages</option>
		        	<option value="12 and 18">12-18</option>
		        	<option value="18 and 45">18-45</option>
		        	<option value="45 and 65">45-65</option>
		        	<option value="65 and 150">65-</option>
		        </select>
		        </td><td>
		        <select class="form-control" name="category" <%= disabled %>>
		        	<option value="all">All Categories</option>
		        	<% while(c_rs.next())
		        		{%>
		        		<option value="<%= c_rs.getString("id") %>"><%= c_rs.getString("name")%></option>
		        		<% }
		        		%>
		        </select>
		        </td><td>
		        <select class="form-control" name="state" <%= disabled %>>
		        	<option value="all">All States</option>
					<option value="Alabama">Alabama</option>
					<option value="Alaska">Alaska</option>
					<option value="Arizona">Arizona</option>
					<option value="Arkansas">Arkansas</option>
					<option value="California">California</option>
					<option value="Colorado">Colorado</option>
					<option value="Connecticut">Connecticut</option>
					<option value="Delaware">Delaware</option>
					<option value="District Of Columbia">District Of Columbia</option>
					<option value="Florida">Florida</option>
					<option value="Georgia">Georgia</option>
					<option value="Hawaii">Hawaii</option>
					<option value="Idaho">Idaho</option>
					<option value="Illinois">Illinois</option>
					<option value="Indiana">Indiana</option>
					<option value="Iowa">Iowa</option>
					<option value="Kansas">Kansas</option>
					<option value="Kentucky">Kentucky</option>
					<option value="Louisiana">Louisiana</option>
					<option value="Maine">Maine</option>
					<option value="Maryland">Maryland</option>
					<option value="Massachusetts">Massachusetts</option>
					<option value="Michigan">Michigan</option>
					<option value="Minnesota">Minnesota</option>
					<option value="Mississippi">Mississippi</option>
					<option value="Missouri">Missouri</option>
					<option value="Montana">Montana</option>
					<option value="Nebraska">Nebraska</option>
					<option value="Nevada">Nevada</option>
					<option value="New Hampshire">New Hampshire</option>
					<option value="New Jersey">New Jersey</option>
					<option value="New Mexico">New Mexico</option>
					<option value="New York">New York</option>
					<option value="North Carolina">North Carolina</option>
					<option value="North Dakota">North Dakota</option>
					<option value="Ohio">Ohio</option>
					<option value="Oklahoma">Oklahoma</option>
					<option value="Oregon">Oregon</option>
					<option value="Pennsylvania">Pennsylvania</option>
					<option value="Rhode Island">Rhode Island</option>
					<option value="Sout Carolina">South Carolina</option>
					<option value="South Dakora">South Dakota</option>
					<option value="Tennessee">Tennessee</option>
					<option value="Texas">Texas</option>
					<option value="Utah">Utah</option>
					<option value="Vermont">Vermont</option>
					<option value="Virginia">Virginia</option>
					<option value="West Virginia">Washington</option>
					<option value="West Virginia">West Virginia</option>
					<option value="Wisconsin">Wisconsin</option>
					<option value="Wyoming">Wyoming</option>
				</select>
				</td><td>
				<input type="hidden" name="query" value="true"/>
				<% if(!disabled.equals("disabled")){
		        	%><input type="submit"  class="btn btn-default" /><%
		        }
		        %>
		        </td>
		   	</form> 
</tr>
<tr>
<%
String row_name = "";
			if(scope.equals("states")) {
				%>
				<td><strong><font color="#FF0000">STATE</font></strong></td>
				<%
				row_name = "state";
			}
			else{
				%>
				<td><strong><font color="#FF0000">USER</font></strong></td>
				<%
				row_name = "name";
			}
			%>

<%
while(rs.next()){ %>
<td><strong><%= rs.getString("name") %></strong>
<br>[ $<%=rs.getInt("amount") %> ]</td>
<%} %>


<%	
	if(moreColumns)
	{
		//out.print("<td><input type='submit' class='btn btn-primary' value='Next 10'></td>");
		int offset = Integer.valueOf(c_offset) + 10;
		%>
		<td>
		
	   	<form action="analytics.jsp" method="GET">
			<div class="form-group">
				<input type ="hidden" name=scope value="<%=scope%>">
				<input type ="hidden" name=r_offset value="<%=r_offset%>">
				<input type ="hidden" name=c_offset value="<%=offset%>">
				<input type ="hidden" name=state value="<%=state%>">
				<input type ="hidden" name=category value="<%=category%>">
				<input type ="hidden" name=ages value="<%=age%>">
			</div>
			<button type="submit" class="btn btn-primary">Next 10</button>
		</form>
		</td>
		<%
	}
%>
</tr>
</thead>

<%

rs_2.beforeFirst();
while(rs_2.next()){%>
	<tr>
	<td><strong><%=rs_2.getString(row_name)%></strong> 
	<br>[ $<%=rs_2.getInt("amount")%> ]
	</td>
	<% 
	rs.beforeFirst();
	while(rs.next())
	{
		boolean matched = false;
		rs_3.beforeFirst();
		while(rs_3.next() && !matched)
		{
			//System.out.print(rs_2.getString(1) + "==" + rs_3.getString(2) + "\t");
			//System.out.print(rs.getInt(1) +"=="+ rs_3.getInt(1) + "\n");
			if(rs.getInt("id") == rs_3.getInt("pid") && rs_2.getString(1).equals(rs_3.getString(2)))
			{	
				//System.out.println(rs_3.getInt("amount"));
				matched = true;
			%>
				<td>$<%=rs_3.getInt("amount")%></td>
			<%
			}
		}
		if(matched == false){
			%>
			<td>0</td>
		<%
		}
		//System.out.print(rs.getInt("id") +"=="+rs_3.getInt("pid") +"\t" +  rs_2.getInt("id") +"=="+ rs_3.getInt("uid") + "\n");
	}%>
	</tr>
<% }%>
<% 
	if(moreRows)
	{
		int offset = Integer.valueOf(r_offset) + 20;
		%>
		<tr><td colspan="11">
		
	   	<form action="analytics.jsp" method="GET">
			<div class="form-group">
				<input type ="hidden" name=scope value="<%=scope%>">
				<input type ="hidden" name=r_offset value="<%=offset%>">
				<input type ="hidden" name=c_offset value="<%=c_offset%>">
				<input type ="hidden" name=state value="<%=state%>">
				<input type ="hidden" name=category value="<%=category%>">
				<input type ="hidden" name=ages value="<%=age%>">
			</div>
			<button type="submit" class="btn btn-primary">Next 20</button>
		</form>
		</td></tr>
		<%
	}
%>	
	
</table>
	
	
<%
}
catch(PSQLException e)
{
	//out.println("<font color='#ff0000'>Error.<br><a href=\"login.jsp\" target=\"_self\"><i>Go Back to Home Page.</i></a></font><br>");
  out.println(e.getMessage());
}
finally
{
	conn.close();
}	
%>	
</body>
</html>