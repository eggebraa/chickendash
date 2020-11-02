<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ page import="com.eggs.chickendash.UserBean" %>

<%
UserBean user = (UserBean)session.getAttribute("user");
if (user==null) {
	user = new UserBean();
	user.setFullname("None");
}
%>
<script language="Javascript">
function expand(s)
{
  var td = s;
  var d = td.getElementsByTagName("div").item(0);

  td.className = "menuHover";
  d.className = "menuHover";
}

function collapse(s)
{
  var td = s;
  var d = td.getElementsByTagName("div").item(0);

  td.className = "menuNormal";
  d.className = "menuNormal";
}
</script>



<font color=white>
<table border=0 cellpadding=0 cellspacing=0 bgcolor="#26699e" height=45 width=100% style='margin-top:-8px; margin-left:-8px; '><tr>
<td width=50><br></td>
<td>
<table border=0><tr>
	<td valign=middle><img src="../images/EggsIcon.png" height=30 align=top></td>
	<td><font size=+1>Eggebraaten Chicken Dashboard</font></td>
</tr></table>
</td>
<% if (false) { %>
	<td width=80><nobr>
	<table class="navbar"><tr><td class="menuNormal" width=160 onmouseover="expand(this);" onmouseout="collapse(this);">
	<p><img src="../images/notices_16.svg" style="height:16px; vertical-align:middle">&nbsp;<font size=-1><b>Manage users</b>
	</font></p>
	<div class="menuNormal" width=100>
		<table class="menu" width=100>
			<tr><td class="menuNormal">
				<a href="LoginServlet.do?action=manageUsersPage" class="menuitem">Manage users</a>
			</td></tr>
			<tr><td class="menuNormal">
				<a href="LoginServlet.do?action=addUserPage" class="menuitem">Add user</a>
			</td></tr>
		</table>
	</div>
	</td></tr></table>
	</nobr></td>
	<td width=20><br></td>
<% } %>
<td width=80><nobr>
	<table class="navbar"><tr><td class="menuNormal" width=160 onmouseover="expand(this);" onmouseout="collapse(this);">
	<p><img src="../images/about_16.svg" style="height:16px; vertical-align:middle">&nbsp;<font size=-1><b>Links</b>
	</font></p>
	<div class="menuNormal" width=100>
		<table class="menu" width=100>
			<tr><td class="menuNormal">
				<a href="http://www.backyardchickens.com/" class="menuitem">Backyard Chickens</a>
			</td></tr>
			<tr><td class="menuNormal">
				<a href="http://www.mypetchicken.com/" class="menuitem">My Pet Chicken</a>
			</td></tr>
		</table>
	</div>
	</td></tr></table>
	</nobr></td>
<td width=50><br></td>
</tr></table>

</font>
<%
String msg = (String)request.getAttribute("message");
%>

<%
if (msg!=null && !msg.equals("")) {
%>
<div style="position: absolute; left: 50%; -webkit-transform: translate(-50%, -50%); transform: translate(-50%, -50%); top: 30px; border: 1px solid black;">
<table border=0 cellpadding=10 cellspacing=0>
<tr><td bgcolor="#eeeeee"><%=msg %></td></tr>
</table>
</div>
<%
}
%>
