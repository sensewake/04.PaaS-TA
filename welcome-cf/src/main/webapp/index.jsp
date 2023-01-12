<%@ page import = "java.sql.*" %>
<%@ page import = "org.json.simple.JSONArray" %>
<%@ page import = "org.json.simple.JSONObject" %>
<%@ page import = "org.json.simple.parser.JSONParser" %>
<%@ page import = "org.json.simple.parser.ParseException" %>

<html>
<body>
<div align="center">

<%
	out.println("hello PaaS-TA world!!!<br>");

	JSONParser jsonParser = new JSONParser();
	
	if(System.getenv("VCAP_SERVICES")!=null){
		JSONObject jsonObject = (JSONObject)jsonParser.parse(System.getenv("VCAP_SERVICES"));
		JSONArray mySqlArray = (JSONArray)jsonObject.get("Mysql-DB");
		
		if (mySqlArray == null){
			  out.println("Please, bind the database<br>");
		}else{
			JSONObject jsonMysql = (JSONObject)mySqlArray.get(0); 
			JSONObject jsonCredential = (JSONObject)jsonMysql.get("credentials");
			
			String db_hostname = (String)jsonCredential.get("hostname");
			String db_port = (String)jsonCredential.get("port");
			String db_name = (String)jsonCredential.get("name");
			String db_username = (String)jsonCredential.get("username");
			String db_password = (String)jsonCredential.get("password");
			
			try{
				Connection conn = null;   
				String url = "jdbc:mysql://"+db_hostname+":"+db_port+"/"+db_name;	
				Class.forName("com.mysql.jdbc.Driver");
				conn=DriverManager.getConnection(url,db_username,db_password);	
				out.println("DB connected!!!<br><br>");
				
				Statement stmt = conn.createStatement();
				ResultSet rs = stmt.executeQuery("select * from user");
				
				
				while(rs.next()){
					out.print(rs.getString("username")+" / ");
					out.print(rs.getString("depart")+"<br>");
				}
				
				rs.close();
				stmt.close();
				
				
			}catch(Exception e){
				e.printStackTrace();
				System.out.println(e);
			}
			
		
		}
	}else{
		out.println("This is localtest Environment....");
	}
	

%>
</div>
</body>
</html>