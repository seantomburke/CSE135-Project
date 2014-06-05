<%@page import="org.postgresql.util.PSQLException"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags"%>

<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>

<t:header title="Sales Analytics Precomputed" />
<%

Connection conn=null;
Statement stmt1,stmt2,stmt3;
ResultSet rs1=null,rs2=null,rs3=null;
String sql1 =null, sql2 = null, sql3 = null;


try
{
	try{Class.forName("org.postgresql.Driver");}catch(Exception e){System.out.println("Driver error");}
	conn = DriverManager.getConnection(
    	"jdbc:postgresql://localhost/cse135?" +
    	"user=Sean"); 
	
	conn.setAutoCommit(false);
	
	stmt1 =conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
	stmt2 =conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
	stmt3 =conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
	
	String scope = ""+request.getParameter("scope");
	String state = request.getParameter("state");
	String category = request.getParameter("category");
	
	//Products and Totals
	
	if(category == null || category.equals("all") || category.equals("null"))
	{
		sql1 = "SELECT * FROM products_totals ORDER BY total LIMIT 10";	
	}
	else
	{
		sql1 = "SELECT pid, total FROM products_total WHERE pid IN (SELECT * FROM products WHERE cid = " + category + " ORDER BY total LIMIT 10";
	}
	
	//Users/states and totals
	//per product per user/state
	
	if (scope.equals("states"))
	{
		if (category == null || category.equals("all") || category.equals("null"))
		{
			if (state != null && !state.equals("all") && !state.equals("null"))
				sql2 = "SELECT * FROM states_total ORDER BY total LIMIT 20";
			else
				sql2 = "SELECT * FROM states_total WHERE state = " + state;
		}
		else
		{
			if (state != null && !state.equals("all") && !state.equals("null"))
				sql2 = "SELECT * FROM states_categories_total WHERE cid = " + category + " ORDER BY total LIMIT 20";
			else
				sql2 = "SELECT * FROM states_categories_total WHERE cid = " + category + " AND state = " + state;
		}
	}
	else
	{
		if(category == null || category.equals("all") || category.equals("null"))
		{
			if (state != null && !state.equals("all") && !state.equals("null"))
			{
				sql2 = "SELECT * FROM users_total ORDER BY total LIMIT 20";
				sql3 = "SELECT * FROM users_products_total WHERE pid IN (SELECT pid FROM products_totals ORDER BY total LIMIT 10)";
			}
			else
			{
				sql2 = "SELECT * FROM users_total WHERE uid IN (SELECT uid FROM users WHERE state = " + state + ") ORDER BY total LIMIT 20";
				sql3 =  "SELECT * FROM users_products_total WHERE uid IN (SELECT uid FROM users WHERE state = " + state + ") AND pid IN (SELECT pid FROM products_totals ORDER BY total LIMIT 10)";
			}
		}
		else
		{
			if (state != null && !state.equals("all") && !state.equals("null"))
			{
				sql2 = "SELECT uid, total FROM users_categories_total ORDER BY total LIMIT 20";
				sql3 = "SELECT * FROM users_products_total WHERE pid IN (SELECT pid FROM products WHERE cid = " + category + ") ORDER BY total LIMIT 10";
			}
			else
			{
				sql2 = "SELECT * FROM users_categories_total WHERE uid IN (SELECT uid FROM users WHERE state = " + state + ") ORDER BY total LIMIT 20";
				sql3 = "SELECT * FROM users_products_total WHERE uid IN (select uid FROM users WHERE state = " + state + ") AND pid in (SELECT pid FROM products WHERE cid = " + category + ") ORDER BY total LIMIT 20";
			}
		}
	}
	
	rs1 = stmt1.executeQuery(sql1); //1 = pid, 2 = total
	rs2 = stmt2.executeQuery(sql2); //1 = uid OR state, 2 = total
	rs3 = stmt3.executeQuery(sql3);	//1 = uid OR state, 2 = pid, 3 = total
	
	/*
	conn.commit();
	conn.setAutoCommit(true);
	*/
}

catch (SQLException e)
{
	conn.rollback();
	e.printStackTrace();
}

finally
{
	if (conn != null)
		conn.close();
	if (stmt1 != null)
		stmt1.close();
	if (stmt2 != null)
		stmt2.close();
	if (stmt3 != null)
		stmt3.close();
	if (rs1 != null)
		rs1.close();
	if (rs2 != null)
		rs2.close();
	if (rs3 != null)
		rs3.close();
}