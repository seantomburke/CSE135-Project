<%@page import="org.postgresql.util.PSQLException"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags"%>

<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>

<html>

<body>

<%
	//redirect if not logged in
	String uid = "" + session.getAttribute("uid");
	if(uid.equals("null")) 
	{
		response.sendRedirect("redirect.jsp");
	}
	
	String pid = "" + request.getAttribute("product");
	System.out.println(pid);
	String cid = "" + request.getAttribute("cid");
	session.setAttribute("order", "true");
	response.sendRedirect("productorder.jsp?product=" + pid + "&cid=" + cid);	
%>

</body>
</html>