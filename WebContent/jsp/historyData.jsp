<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.TreeMap" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Collections" %>
<%@ page import="com.eggs.chickendash.UserBean" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Eggebraaten Chicken Dashboard</title>
</head>
<link rel="stylesheet" href="style.css" type="text/css" id="" media="print, projection, screen" />

<%
UserBean user = (UserBean)session.getAttribute("user");
if (user==null) {
	user = new UserBean();
	user.setFullname("None");
}
%>
<script language="javascript">
</script>

<body style='margin-right:0px;'>

<jsp:include page="header.jsp"></jsp:include>
<table class="navtable"><tr>
<td width=50><br></td>
<td width=50 class="navTD"><nobr><a href="DashboardServlet.do?action=dashboard">Coop Dashboard</nobr></a></td>
<td width=40><br></td>
<td  class="navTD" width=50><a href="DashboardServlet.do?action=eggTracker"><nobr>Egg Tracker</nobr></a></td>
<td width=40><br></td>
<td class="navSelectedTD"><nobr>History Data</nobr></td>


<td width=50><br></td>
</tr></table>


<p>
History data - under construction for now

</body>
</html>
