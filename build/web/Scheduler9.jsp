<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %> 
<%@ page import="java.util.Properties" %> 
<%@ page import="javax.mail.Message" %> 
<%@ page import="javax.mail.MessagingException" %> 
<%@ page import="javax.mail.PasswordAuthentication" %> 
<%@ page import="javax.mail.Session" %> 
<%@ page import="javax.mail.Transport" %> 
<%@ page import="javax.mail.internet.InternetAddress" %> 
<%@ page import="javax.mail.internet.MimeMessage" %> 
<!DOCTYPE HTML>
<html>
<head>
  <title>Home</title>
  <meta http-equiv="content-type" content="text/html; charset=UTF-8" />
  <link rel="stylesheet" type="text/css" href="css/style.css" />
  <script type="text/javascript" src="js/modernizr-1.5.min.js"></script>
  </head>
<body>
  <div id="main">
 <div class="dropdown" style="float:right;">
  <button class="user dropbtn"></button>
  <div class="dropdown-content">
    <a href="UserProfile.jsp">Profile</a>
    <a href="ChangePassword.jsp">Change Password</a>
    <a href="LoginPage.html">Logout</a>
  </div>
</div>
<%
	String user = session.getAttribute("username").toString();
%>
 <h3> Hi <%=session.getAttribute("username").toString() %> !</h3>
 <%
 	session.setAttribute("username",user);
 	String campus = request.getParameter("campus");
	String dept = request.getParameter("dept");
	String course = request.getParameter("course");
	String faculty = request.getParameter("faculty");
	int noOfdays = Integer.parseInt(request.getParameter("noOfdays"));
	int room = Integer.parseInt(request.getParameter("room"));
	String[] time9 = request.getParameterValues("alltime");
	String[] time = new String[time9.length];
	if (time9 != null) 
	{
	   for (int i = 0; i < time9.length; i++) 
	   {
	 	 time[i]=time9[i];
	   }
	}
	int count=time.length;
	try
	{
		Statement statement = null;
    	ResultSet rs = null;
    	String connectionURL = "jdbc:mysql://localhost:3306/facultywebsite";
    	Connection connection = null; 
	  	Class.forName("com.mysql.jdbc.Driver").newInstance(); 
	  	connection = DriverManager.getConnection(connectionURL, "root", "root");
	  	Statement st = connection.createStatement();
	  	//Subject:facultyname:room:time
	  	String QueryString = "Select FacultyId,maild_id from faculty where FacultyName='"+faculty+"'";
	  	rs = st.executeQuery(QueryString);
	  	if(rs.next())
	  	{
	  		int k=1;
	  		while(k<=count)
	  		{
				String[] data = time[k].split(":");
	  			String day=null;
	  			if(data[1].equals("M"))
	  				day="Monday";
	  			else if(data[1].equals("T"))
	  				day="Tueday";
	  			else if(data[1].equals("W"))
	  				day="Wednesday";
	  			else if(data[1].equals("TR"))
	  				day="Thrusday";
	  			else if(data[1].equals("F"))
	  				day="Friday";
	  			try
	  			{
	  				Statement statement1 = null;
	  		    	ResultSet rs1 = null;
	  		        String connectionURL1 = "jdbc:mysql://localhost:3306/facultywebsite";
	  		    	Connection connection1 = null; 
		  			Class.forName("com.mysql.jdbc.Driver").newInstance(); 
		  			connection1 = DriverManager.getConnection(connectionURL1, "root", "root");
		  			Statement st1 = connection1.createStatement();		
		  			//facultyID-noOfdays-day-section-room-course-time//
		  			int i = st1.executeUpdate("insert into timetable values('"+rs.getString(1)+"','"+noOfdays+"','"+day+"','0','" + room + "','" + course + "','" + data[0] + "')");
		  			if(i>0)
		  			{
		  				try
		  				{
		  					Statement statement2 = null;
		  				    String connectionURL2 = "jdbc:mysql://localhost:3306/facultywebsite";
		  				    Connection connection2 = null; 
		  					Class.forName("com.mysql.jdbc.Driver").newInstance(); 
		  					connection2 = DriverManager.getConnection(connectionURL2, "root", "root");
		  					statement2 = connection2.createStatement();
		  					String query = "UPDATE faculty SET SubjectTaught = CONCAT(SubjectTaught, ';"+course+"') WHERE FacultyId='"+rs.getString(1)+"'";
		  					//PreparedStatement preparedStmt = connection.prepareStatement(query);
		  					statement2.executeUpdate(query);
		  					String to = rs.getString(2);
		  					Properties props = new Properties();
		  					props.put("mail.smtp.host", "smtp.gmail.com");
		  					props.put("mail.smtp.socketFactory.port", "587");
		  					props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
		  					props.put("mail.smtp.auth", "true");
		  					props.put("mail.smtp.port", "587");
		  					props.put("mail.smtp.starttls.enable", "true");
		  					Session sess = Session.getInstance(props, new javax.mail.Authenticator() {
		  					protected PasswordAuthentication getPasswordAuthentication() {
		  					return new PasswordAuthentication("sanketselokar1234@gmail.com", "Sandy@1992");//change accordingly  
		  					}
		  					});
		  					try {
		  					MimeMessage message = new MimeMessage(sess);
		  					message.setFrom(new InternetAddress("sanketselokar1234@gmail.com"));//change accordingly  
		  					message.addRecipient(Message.RecipientType.TO, new InternetAddress(to));
		  					message.setSubject("We have scheduled classes for you.");
		  					message.setText("Hello,\nYou have been alloted the following class:\n\n Subject : "+course+"\n Location : "+campus+"\n Room no : "+room+" \n Day : "+day+"\n Time : "+data[0]+"\n\n Thank You\n");
		  					Transport.send(message);
		  					} catch (MessagingException e) {
		  					e.printStackTrace();
		  					throw new RuntimeException(e);
		  					}
		  					out.println("<script type=\"text/javascript\">");
		  			   	    out.println("alert('Scheduled successfully!! ');");
		  			   	    out.println("location='Scheduler1.jsp';");
		  			   	    out.println("</script>");
		  				}
		  				catch(Exception e)
		  				{
		  					System.out.println("Could not Update faculty details!!");
		  					e.printStackTrace();
		  				}
		  			}
		  			else
		  			{
		  				response.sendRedirect("Scheduler1.jsp");
		  			}
	  			}
	  			catch(Exception e)
	  			{
	  				e.printStackTrace();
	  			}connection.close();
	  			k+=1;	
	  		}
	  	}
	}
	catch(Exception e)
	{
		e.printStackTrace();
	}
%>
</div>
  <!-- javascript at the bottom for fast page loading -->
  <script type="text/javascript" src="js/jquery.min.js"></script>
  <script type="text/javascript" src="js/jquery.easing.min.js"></script>
  <script type="text/javascript" src="js/jquery.lavalamp.min.js"></script>
  <script type="text/javascript" src="js/image_fade.js"></script>
  <script type="text/javascript">
    $(function() {
      $("#lava_menu").lavaLamp({
        fx: "backout",
        speed: 700
      });
    });
  </script>
</body>
</html>