<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.TreeMap" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Eggebraaten Chicken Dashboard</title>
</head>
<link rel="stylesheet" href="style.css" type="text/css" id="" media="print, projection, screen" />
<script language="javascript">
</script>




<body style='margin-right:0px;'>

<jsp:include page="header.jsp"></jsp:include>
<p>
<h3>Welcome to the Eggebraaten Chicken Dashboard</h3>
<b>Please login to use the tool:</b>

<p>
<form action="LoginServlet.do" name="FORM" method="POST">
<input type=hidden name="action" value="login">

<table border=0>
<tr><td width=20></td><td><b>Username: </b></td><td><input name="username" value="eggebraa"></td></tr>
<tr><td width=20></td><td><b>Password: </b></td><td><input name="password" type="password"></td></tr>

</table>
<p>
<input type=submit value="Login">
</form>



</font></body>
</html>
