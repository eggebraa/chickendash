<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.TreeMap" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="com.eggs.chickendash.UserBean" %>
<%@ page import="com.eggs.chickendash.ChickenBean" %>
<%@ page import="com.eggs.chickendash.DashboardServlet" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Eggebraaten Chicken Dashboard</title>
</head>
<link rel="stylesheet" href="style.css" type="text/css" id="" media="print, projection, screen" />
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<%
SimpleDateFormat shortDate = new SimpleDateFormat("M/d"); 
DecimalFormat decFormatter = new DecimalFormat("##0.0#");
UserBean user = (UserBean)session.getAttribute("user");
if (user==null) {
	user = new UserBean();
	user.setFullname("None");
}
//get earliest date
SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");
Date earliestDate = formatter.parse("23/09/2017");

//Date earliestDate = new Date();
//for (ChickenBean c: DashboardServlet.getChickens()) {
//	for (Date d: c.getEggList()) {
//		if (d.before(earliestDate)) {
//			earliestDate = d;
//		}
//	}
//}
String[] monthStrings = {"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"};
String[] dowStrings = {"Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"};
%>
<script language="javascript">
function displayPopup(div_id) {
	var popUpDiv = document.getElementById(div_id);
	var blanketDiv = document.getElementById('blanketDiv');
	blanketDiv.style.display = 'block';
	popUpDiv.style.display = 'block';


	if (typeof window.innerWidth != 'undefined') {
		viewportwidth = window.innerHeight;
	} else {
		viewportwidth = document.documentElement.clientHeight;
	}
	if ((viewportwidth > document.body.parentNode.scrollWidth) && (viewportwidth > document.body.parentNode.clientWidth)) {
		window_width = viewportwidth;
	} else {
		if (document.body.parentNode.clientWidth > document.body.parentNode.scrollWidth) {
			window_width = document.body.parentNode.clientWidth;
		} else {
			window_width = document.body.parentNode.scrollWidth;
		}
	}
	var blanket_height = document.body.parentNode.clientHeight;
	var window_height = document.body.parentNode.clientHeight;
	window_width=window_width/2-300;//150 is half popup's width
	var divHeight = popUpDiv.scrollHeight - 35;// - 40;
	if (divHeight > window_height - 40) {
		divHeight = window_height - 40;
	}
	//alert(popUpDiv.scrollHeight + ":" + window_height);
	popUpDiv.style.position = 'fixed';
	popUpDiv.style.height = divHeight + 'px';
	popUpDiv.style.top = '50px';
	popUpDiv.style.left = window_width + 'px';

	blanketDiv.style.height = '10000px';//blanket_height + 'px';
}
function addEggsDialog() {
	displayPopup('addEggsDiv');
}
function addEggsCancel() {
	var popUpDiv = document.getElementById('addEggsDiv');
	var blanketDiv = document.getElementById('blanketDiv');
	popUpDiv.style.display = 'none';
	blanketDiv.style.display = 'none';
}
function addEggs() {
	document.ADD_EGGS_FORM.submit();
}
function confirmDelete(chicken, date) {
	var response = confirm('Are you sure you want to delete egg on ' + date + "?");
	if (response==true) {
		document.DELETE_EGG_FORM.date.value = date;
		document.DELETE_EGG_FORM.chicken.value = chicken;
		document.DELETE_EGG_FORM.submit();
	}
	return false;
}
$( function() {
    $( "#datepicker" ).datepicker({ maxDate: 0});
  } );
  
</script>

<body style='margin-right:0px;'>

<jsp:include page="header.jsp"></jsp:include>
<table class="navtable"><tr>
<td width=50><br></td>
<td width=50 class="navTD"><nobr><a href="DashboardServlet.do?action=dashboard">Coop Dashboard</nobr></a></td>
<td width=40><br></td>
<td  class="navSelectedTD" width=50><nobr>Egg Tracker</nobr></td>
<td width=40><br></td>
<td class="navTD"><a href="DashboardServlet.do?action=historyData"><nobr>History Data</nobr></a></td>


<td width=50><br></td>
</tr></table>


<p>
<center>
	<a class="normalButton" href="" onClick="addEggsDialog(); return false">Add Eggs</a>
</center>
<b>Egg Details</b>
<div style="width:1500px;overflow:auto;" id="eggGraphDiv">
<table class=normalTable>
<tr><th>Chicken</th>
<% 
Date thisDate = new Date(earliestDate.getTime());
Calendar cal = Calendar.getInstance();
Date endDate = new Date();
cal.setTime(endDate);
cal.add(Calendar.MONTH, 1);
Date endDatePlusOne = cal.getTime();
cal.setTime(thisDate);
while (thisDate.before(endDate)) { 
%>
	<th><%=shortDate.format(thisDate) %>
	</th>
<% 
	cal.add(Calendar.DATE, 1);
	thisDate = cal.getTime();
} %>
	<th>Chicken</th>
</tr>

<% 
int totalEggs = 0;
HashMap<Long, Integer> longestStreaks = new HashMap<Long, Integer>();
HashMap<Long, Integer> longestGaps = new HashMap<Long, Integer>();
HashMap<Long, Integer> totalDays = new HashMap<Long, Integer>();
for (ChickenBean chicken: DashboardServlet.getChickens()) {
	totalEggs += chicken.getTotalEggs();
	int longestStreak = 0;
	int currentStreak = 0;
	int longestGap = 0;
	int currentGap = -1;
	%>
	<tr>
		<td><%=chicken.getName() %></td>
		
<% 
thisDate = new Date(earliestDate.getTime());
cal.setTime(thisDate);
int thisChickenDays = -1;
while (thisDate.before(endDate)) { 

String img = "<img src='../images/" + chicken.getEggImage();
img = img + "' height=20 onClick='confirmDelete(" + chicken.getId() + ", \"";
img = img + DashboardServlet.sdf.format(thisDate) + "\"); return false;'>";
boolean eggOnThisDate = chicken.laidEggOnThisDate(thisDate);
if (eggOnThisDate) {
	currentStreak++;
	currentGap = 0;
	if (thisChickenDays<0) thisChickenDays = 0;
} else {
	if (currentGap>=0) currentGap++;
	currentStreak = 0;
}
if (currentGap>longestGap) {
	longestGap = currentGap;
}
if (currentStreak>longestStreak) {
	longestStreak = currentStreak;
}
if (thisChickenDays>=0) thisChickenDays++;

%>
	<td><%=(eggOnThisDate?img:"") %>
	</td>
<% 
	cal.add(Calendar.DATE, 1);
	thisDate = cal.getTime();
} 
longestStreaks.put(chicken.getId(), longestStreak);
longestGaps.put(chicken.getId(), longestGap);
if (thisChickenDays<0) thisChickenDays = 0;
totalDays.put(chicken.getId(), thisChickenDays);
%>		
		<td><%=chicken.getName() %></td>
	</tr>
<% } %>
</table>
</div>
<script language="javascript">
var elem = document.getElementById('eggGraphDiv');
elem.scrollLeft = elem.scrollWidth;
</script>
<p>
<table border=0><tr><td valign=top>
<b>Monthly totals</b><br>
<script type="text/javascript">
      google.charts.load('current', {'packages':['bar']});
      google.charts.setOnLoadCallback(drawCharts);

      function drawCharts() {
        var monthlyData = google.visualization.arrayToDataTable([
<%
String header = "['Month'";
for (ChickenBean chicken: DashboardServlet.getChickens()) { 
	header = header + ", '" + chicken.getName() + "'";	
}
header = header + "],";
%>                                                      
          <%=header%>
<%
thisDate = new Date(earliestDate.getTime());
cal.setTime(thisDate);
int thisChickenDays = -1;
while (thisDate.before(endDatePlusOne)) { 
	int year = cal.get(Calendar.YEAR);
	int month = cal.get(Calendar.MONTH);
	String label = monthStrings[month] + " \\'" + (year%100);
	String dataString = "['" + label + "'";
	for (ChickenBean chicken: DashboardServlet.getChickens()) {
		dataString = dataString + ", " + chicken.getEggsPerMonth(year, month+1);
	}
	dataString = dataString + "],";
%>
	<%=dataString %>
<%
	cal.add(Calendar.MONTH, 1);
	thisDate = cal.getTime();
}
%>
        ]);

        var dayOfWeekData = google.visualization.arrayToDataTable([
<%
String header2 = "['Day of week'";
for (ChickenBean chicken: DashboardServlet.getChickens()) { 
	header2 = header2 + ", '" + chicken.getName() + "'";	
}
header2 = header2 + "],";
%>                                                      
          <%=header2%>
<%
for (int i=1; i<=7; i++) { 
	String label = dowStrings[i-1];
	String dataString = "['" + label + "'";
	for (ChickenBean chicken: DashboardServlet.getChickens()) {
		dataString = dataString + ", " + chicken.getEggsPerWeekDay(i);
	}
	dataString = dataString + "],";
%>
	<%=dataString %>
<%
}
%>
        ]);
        var options1 = {
        	isStacked: true,
        };
        var options2 = {
            isStacked: true,
            legend: { position: "none" },
        };

        var chart1 = new google.charts.Bar(document.getElementById('monthlyTotals'));
        var chart2 = new google.charts.Bar(document.getElementById('dayOfWeekTotals'));

        chart1.draw(monthlyData, google.charts.Bar.convertOptions(options1));
        chart2.draw(dayOfWeekData, google.charts.Bar.convertOptions(options2));
      }
    </script>
<div id="monthlyTotals" style="width: 500px; height: 250px;"></div>

</td><td width=20></td><td valign=top>
<b>Day of week totals</b><br>
<div id="dayOfWeekTotals" style="width: 500px; height: 250px;"></div>



</td></tr></table>
<br>
<table class=normalTable>
<tr><th>Chicken</th>
	<th>Total</th>
	<th>Avg Eggs per Week</th>
	<th>Longest streak</th>
	<th>Longest gap</th>
</tr>

<% 
int allChickenLongestStreak = 0;
int allChickenLongestGap = 0;
double allChickenAvg = 0.0;
for (ChickenBean chicken: DashboardServlet.getChickens()) { 
	int longestStreak = longestStreaks.get(chicken.getId());
	if (longestStreak > allChickenLongestStreak) {
		allChickenLongestStreak = longestStreak;
	}
	int longestGap = longestGaps.get(chicken.getId());
	if (longestGap > allChickenLongestGap) {
		allChickenLongestGap = longestGap;
	}
	int days = totalDays.get(chicken.getId());
	double avgPerWeek = 0;
	if (days>0) {
		avgPerWeek = (double)chicken.getTotalEggs() / (double)days * 7.0;
	}
	allChickenAvg += avgPerWeek;
%>
	<tr>
		<td><%=chicken.getName() %></td>
		<td><%=chicken.getTotalEggs() %> eggs</td>
		<td><%=decFormatter.format(avgPerWeek) %> eggs</td>
		<td><%=longestStreak %> days</td>
		<td><%=longestGap %> days</td>
	</tr>
<% } %>
	<tr>
		<td style="background-color: #3d8cd1; color: white;"><b>All chickens</b></td>
		<td style="background-color: #3d8cd1; color: white;"><b><%=totalEggs %> eggs</b></td>
		<td style="background-color: #3d8cd1; color: white;"><b><%=decFormatter.format(allChickenAvg) %> eggs</b></td>
		<td style="background-color: #3d8cd1; color: white;"><b><%=allChickenLongestStreak %> days</b></td>
		<td style="background-color: #3d8cd1; color: white;"><b><%=allChickenLongestGap %> days</b></td>
	</tr>
</table>

<form action="DashboardServlet.do" name="DELETE_EGG_FORM" method="POST">
<input type=hidden name="action" value="deleteEgg">
<input type=hidden name="chicken" value="">
<input type=hidden name="date" value="">
</form>

<div id="blanketDiv" class="blanket" style="display:none;"></div>

<!-- ADD EGGS DIV -->
<div id="addEggsDiv" class="dialogBox" style="display:none;">
<center><b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Add Eggs&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</b><p></center>
<form action="DashboardServlet.do" name="ADD_EGGS_FORM" method="POST">
<input type=hidden name="action" value="addEggs">

Date: <input type="text" id="datepicker" value="Today" size=12 name="eggDate"> 
<p>
<table class=normalTable>
<tr><th colspan=2>Chicken</th><th><br></th></tr>
<% for (ChickenBean chicken: DashboardServlet.getChickens()) { %>
	<tr>
		<td><%=chicken.getName() %></td>
		<td valign=middle><img src="../images/<%=chicken.getImage() %>" height=35></td>
	    <td valign=middle><input type=checkbox name="chicken<%=chicken.getId() %>"></td>
	</tr>
<% } %>
</table>
<p><p>
</form>
<table border=0 width=100%><tr>
<td valign=top>
	<a id="addEggsButton" class="normalButton" href="" onClick="addEggs();return false;">Add</a>
</td><td valign=top align=right>
	<a class="normalButton" href="" onClick="javascript:addEggsCancel();return false;">Cancel</a>
</td>
</tr></table>
</div>


</body>
</html>
