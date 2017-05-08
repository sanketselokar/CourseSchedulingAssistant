<!--This page is dedicated for storing the data into the database for the new faculty. 
It takes the below string values from AddFacutly.jsp and stores it into database on click of add button -->
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*,java.util.*,javax.mail.*"%>
<%@ page import="javax.mail.internet.*,javax.activation.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Add Faculty</title>
        <link rel="stylesheet" type="text/css" href="css/style.css" />
          <link rel="shortcut icon" href="favicon.png" />
  <script type="text/javascript" src="js/modernizr-1.5.min.js"></script>
</head>
<%
String fname = request.getParameter("fname");
String lname = request.getParameter("lname");
String email = request.getParameter("email");
String dept = request.getParameter("dept");
String sub = request.getParameter("sub");
String loc = request.getParameter("loc");
int subid=0;
int fid = 0;
try 
{
	Statement statement = null;
  	ResultSet rs = null;
  	String connectionURL = "jdbc:mysql://localhost:3306/facultywebsite";
	Connection connection = null; 
	Class.forName("com.mysql.jdbc.Driver").newInstance();
	connection = DriverManager.getConnection(connectionURL, "root", "root");
	Statement st = connection.createStatement();
	String QueryString = "Select SubjectId from subject where Name='"+sub+"'";
    rs = st.executeQuery(QueryString);
	if(rs.next())
	{
		subid = Integer.parseInt(rs.getString(1));
		%>
		<h3><%=subid %></h3>
		<h3><%=fname %></h3>
		<h3><%=lname %></h3>
		<h3><%=email %></h3>
		<h3><%=dept %></h3>
		<h3><%=sub %></h3>
		<%
	}
}catch(Exception e)
{}
try 
{
	Statement statement = null;
  	ResultSet rs = null;
  	String connectionURL = "jdbc:mysql://localhost:3306/facultywebsite";
	Connection connection = null; 
	Class.forName("com.mysql.jdbc.Driver").newInstance();
	connection = DriverManager.getConnection(connectionURL, "root", "root");
	Statement st = connection.createStatement();
	String QueryString = "Select MAX(FacultyId) from faculty";
    rs = st.executeQuery(QueryString);
	if(rs.next())
	{
		fid = Integer.parseInt(rs.getString(1));
		fid+=1;
	}
}catch(Exception e)
{}
String jtype = request.getParameter("jtype");
int chrs = Integer.parseInt(request.getParameter("chrs"));
try
{
	Statement statement = null;
    ResultSet rs = null;
    String connectionURL = "jdbc:mysql://localhost:3306/facultywebsite";
    Connection connection = null; 
	Class.forName("com.mysql.jdbc.Driver").newInstance(); 
	connection = DriverManager.getConnection(connectionURL, "root", "root");
	Statement st = connection.createStatement();
	int i = st.executeUpdate("insert into faculty values('"+fname+" "+lname+"','"+fid+"','" + subid + "','" + dept + "','" + loc + "','" + sub + "','" + chrs + "',null,null,'" + jtype + "','" + email + "',null)");
	if(i>0)
	{
		out.println("<script type=\"text/javascript\">");
	      out.println("alert('Faculty added successfully!! ');");
	    out.println("location='AddFac.jsp';");
	    out.println("</script>");
//out.println("alert('Faculty added successfully');");
session.setAttribute("message", "added");
	 response.sendRedirect("AdminHome.jsp");
//response.sendRedirect("AddFaculty.jsp");
	}
	else
	{
	 out.println("<script type=\"text/javascript\">");
 	      out.println("alert('Could not add faculty!! ');");
 	    out.println("location='AddFaculty.jsp';");
 	    out.println("</script>");
         //   response.sendRedirect("AdminHome.jsp");
	 response.sendRedirect("AddFaculty.jsp");
	}
}
catch(Exception e)
{
	System.out.println("Could not Update faculty details!!");
	e.printStackTrace();
}
%>
