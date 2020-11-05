<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.TreeMap" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %> 
<%@ page import="java.util.Collections" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.util.TimeZone" %>
<%@ page import="com.eggs.chickendash.UserBean" %>
<%@ page import="com.eggs.chickendash.StatusBean" %>
<%@ page import="com.eggs.chickendash.CommandBean" %>
<%@ page import="com.eggs.chickendash.ChickenBean" %>
<%@ page import="com.eggs.chickendash.DashboardServlet" %>
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
List<CommandBean> cmds = (List<CommandBean>)request.getAttribute("lastCommands");
StatusBean status = (StatusBean)request.getAttribute("status");
if (status==null) status = new StatusBean();
SimpleDateFormat dt = new SimpleDateFormat("y-M-d 'at' h:m a"); 
dt.setTimeZone(TimeZone.getTimeZone("CDT"));
DecimalFormat hourFormatter = new DecimalFormat("00");

List<ChickenBean> chickens = DashboardServlet.getChickens();

String doorClose = status.getDoorClose();
int doorCloseHour = -1;
int doorCloseMin = -1;
if (doorClose.length()>0 && !doorClose.startsWith("Un")) {
	String doorCloseHourString = doorClose.substring(0, 2);
	String doorCloseMinString = doorClose.substring(2, 4);
	doorCloseHour = Integer.parseInt(doorCloseHourString);
	doorCloseMin = Integer.parseInt(doorCloseMinString);
	doorClose = hourFormatter.format(doorCloseHour) + ":" + hourFormatter.format(doorCloseMin);
}

String runLightsOn = status.getRunLightsOn();
int runLightsOnHour = -1;
int runLightsOnMin = -1;
if (runLightsOn.length()>0 && !runLightsOn.startsWith("Un")) {
	String runLightsOnHourString = runLightsOn.substring(0, 2);
	String runLightsOnMinString = runLightsOn.substring(2, 4);
	runLightsOnHour = Integer.parseInt(runLightsOnHourString);
	runLightsOnMin = Integer.parseInt(runLightsOnMinString);
	runLightsOn = hourFormatter.format(runLightsOnHour) + ":" + hourFormatter.format(runLightsOnMin);
}
String runLightsOff = status.getRunLightsOff();
int runLightsOffHour = -1;
int runLightsOffMin = -1;
if (runLightsOff.length()>0 && !runLightsOff.startsWith("Un")) {
	String runLightsOffHourString = runLightsOff.substring(0, 2);
	String runLightsOffMinString = runLightsOff.substring(2, 4);
	runLightsOffHour = Integer.parseInt(runLightsOffHourString);
	runLightsOffMin = Integer.parseInt(runLightsOffMinString);
	runLightsOff = hourFormatter.format(runLightsOffHour) + ":" + hourFormatter.format(runLightsOffMin);
}
String coopLightsOn = status.getCoopLightsOn();
int coopLightsOnHour = -1;
int coopLightsOnMin = -1;
if (coopLightsOn.length()>0 && !coopLightsOn.startsWith("Un")) {
	String coopLightsOnHourString = coopLightsOn.substring(0, 2);
	String coopLightsOnMinString = coopLightsOn.substring(2, 4);
	coopLightsOnHour = Integer.parseInt(coopLightsOnHourString);
	coopLightsOnMin = Integer.parseInt(coopLightsOnMinString);
	coopLightsOn = hourFormatter.format(coopLightsOnHour) + ":" + hourFormatter.format(coopLightsOnMin);
}
String coopLightsOff = status.getCoopLightsOff();
int coopLightsOffHour = -1;
int coopLightsOffMin = -1;
if (coopLightsOff.length()>0 && !coopLightsOff.startsWith("Un")) {
	String coopLightsOffHourString = coopLightsOff.substring(0, 2);
	String coopLightsOffMinString = coopLightsOff.substring(2, 4);
	coopLightsOffHour = Integer.parseInt(coopLightsOffHourString);
	coopLightsOffMin = Integer.parseInt(coopLightsOffMinString);
	coopLightsOff = hourFormatter.format(coopLightsOffHour) + ":" + hourFormatter.format(coopLightsOffMin);
}
String waterLevelImg = "";
if (status.getWaterLevel()>=0 && status.getWaterLevel()<8) {
	waterLevelImg = "waterLevel" + status.getWaterLevel() + ".png";
}

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
function editDoorCloseDialog() {
	displayPopup('editDoorCloseDiv');
}
function editDoorCloseCancel() {
	var popUpDiv = document.getElementById('editDoorCloseDiv');
	var blanketDiv = document.getElementById('blanketDiv');
	popUpDiv.style.display = 'none';
	blanketDiv.style.display = 'none';
}
function editRunLightsDialog() {
	displayPopup('runLightsDiv');
}
function runLightsCancel() {
	var popUpDiv = document.getElementById('runLightsDiv');
	var blanketDiv = document.getElementById('blanketDiv');
	popUpDiv.style.display = 'none';
	blanketDiv.style.display = 'none';
}
function editHeaterTempDialog() {
	displayPopup('editHeaterTempDiv');
}
function heaterTempCancel() {
	var popUpDiv = document.getElementById('editHeaterTempDiv');
	var blanketDiv = document.getElementById('blanketDiv');
	popUpDiv.style.display = 'none';
	blanketDiv.style.display = 'none';
}
function editWaterHeaterTempDialog() {
	displayPopup('editWaterHeaterTempDiv');
}
function waterHeaterTempCancel() {
	var popUpDiv = document.getElementById('editWaterHeaterTempDiv');
	var blanketDiv = document.getElementById('blanketDiv');
	popUpDiv.style.display = 'none';
	blanketDiv.style.display = 'none';
}
function editCoopLightsDialog() {
	displayPopup('coopLightsDiv');
}
function coopLightsCancel() {
	var popUpDiv = document.getElementById('coopLightsDiv');
	var blanketDiv = document.getElementById('blanketDiv');
	popUpDiv.style.display = 'none';
	blanketDiv.style.display = 'none';
}
function closeDoor() {
	document.FORM.command.value = "OperateDoor";
	document.FORM.parm1.value = "Close";
	document.FORM.submit();
}
function openDoor() {
	document.FORM.command.value = "OperateDoor";
	document.FORM.parm1.value = "Open";
	document.FORM.submit();
}
function setDoorModeAuto() {
	document.FORM.command.value = "DoorMode";
	document.FORM.parm1.value = "AUTO";
	document.FORM.submit();
}
function setCoopLights(val) {
	document.FORM.command.value = "SetCoopLights";
	document.FORM.parm1.value = val;
	document.FORM.submit();
}
function setRunLights(val) {
	document.FORM.command.value = "SetRunLights";
	document.FORM.parm1.value = val;
	document.FORM.submit();
}
function changeDoorClose() {
	var hr = document.DOOR_FORM.hour.value;
	var min = document.DOOR_FORM.min.value;
	var time = hr + "" + min + "";
	
	document.FORM.command.value = "DoorCloseTime";
	document.FORM.parm1.value = time;
	document.FORM.submit();
}
function changeHeaterTemp() {
	var temp = document.HEATER_FORM.heater_temp.value;
	if (isNaN(parseFloat(temp)) || !isFinite(temp)) {
		alert(temp + " is not valid");
		return false;
	}
	
	document.FORM.command.value = "SetHeaterTemp";
	document.FORM.parm1.value = temp;
	document.FORM.submit();
}
function changeWaterHeaterTemp() {
	var temp = document.WATER_HEATER_FORM.heater_temp.value;
	if (isNaN(parseFloat(temp)) || !isFinite(temp)) {
		alert(temp + " is not valid");
		return false;
	}
	
	document.FORM.command.value = "SetWaterHeaterTemp";
	document.FORM.parm1.value = temp;
	document.FORM.submit();
}
function pad(number) {
	if (number.length==1) {
		return "0" + number;
	} else {
		return number;
	}
}
function changeRunLights() {
	var onhr = document.RUN_LIGHTS_FORM.onHour.value;
	var onmin = document.RUN_LIGHTS_FORM.onMin.value;
	var offhr = document.RUN_LIGHTS_FORM.offHour.value;
	var offmin = document.RUN_LIGHTS_FORM.offMin.value;
	var ontime = pad(onhr) + "" + pad(onmin) + "";
	var offtime = pad(offhr) + "" + pad(offmin) + "";
	
	document.FORM.command.value = "SetRunLightsTime";
	document.FORM.parm1.value = ontime;
	document.FORM.parm2.value = offtime;
	document.FORM.submit();
}
function changeCoopLights() {
	var onhr = document.COOP_LIGHTS_FORM.onHour.value;
	var onmin = document.COOP_LIGHTS_FORM.onMin.value;
	var offhr = document.COOP_LIGHTS_FORM.offHour.value;
	var offmin = document.COOP_LIGHTS_FORM.offMin.value;
	var ontime = pad(onhr) + "" + pad(onmin) + "";
	var offtime = pad(offhr) + "" + pad(offmin) + "";
	
	document.FORM.command.value = "SetCoopLightsTime";
	document.FORM.parm1.value = ontime;
	document.FORM.parm2.value = offtime;
	document.FORM.submit();
}
function setRunLightsModeAuto() {
	document.FORM.command.value = "SetRunLightsMode";
	document.FORM.parm1.value = "Auto";
	document.FORM.submit();
}
function setCoopLightsModeAuto() {
	document.FORM.command.value = "SetCoopLightsMode";
	document.FORM.parm1.value = "Auto";
	document.FORM.submit();
}
window.setTimeout(function(){
	if (blanketDiv.style.display == 'block') {
		//don't refresh if popup is up
		return false;
	}
    window.location.href = "DashboardServlet.do?action=dashboard";

}, 20000);
</script>

<body style='margin-right:0px;'>

<jsp:include page="header.jsp"></jsp:include>
<table class="navtable"><tr>
<td width=50><br></td>
<td width=50 class="navSelectedTD"><nobr>Coop Dashboard</nobr></td>
<td width=40><br></td>
<td class="navTD" width=50><a href="DashboardServlet.do?action=eggTracker"><nobr>Egg Tracker</nobr></a></td>
<td width=40><br></td>
<td class="navTD"><a href="DashboardServlet.do?action=historyData"><nobr>History Data</nobr></a></td>

<td width=80><nobr>

<td width=50><br></td>
</tr></table>


<p>
<table border=0>
<tr><td valign=top>
<!-- left -->
<table class="normalTable">
<tr><th colspan=3>Chicken Run Status</th></tr>
<tr><td>Temperature:</td><td><%=(status.getRunTemp()<-50?"Unknown":status.getRunTemp() + "&deg;F") %></td><td></td></tr>
<tr><td>Humidity:</td><td><%=(status.getRunHumid()<-50?"Unknown":status.getRunHumid() + "%") %></td><td></td></tr>
<tr><td>Outside lights:</td>
	<td valign=middle>  
		<% if (status.getRunLights().equals(StatusBean.STATUS_OFF)) { %>
			<img src="../images/LightOff.png" height=25>
		<% } else if (status.getRunLights().equals(StatusBean.STATUS_ON)) { %>
			<img src="../images/LightOn.png" height=25>
		<% } else { %>
			<%=status.getRunLights() %>
		<% } %>
	</td><td>
	<% if (status.getRunLights().equals(StatusBean.STATUS_ON)) { %>
		<span onClick="javascript:setRunLights('Off'); return false;" style="cursor:pointer; background-color: blue; color: white; border-radius: 15px; padding: 3px; font-size: 12px;"><b> &nbsp;Turn Off&nbsp; </b></span>
	<% } %>	
	<% if (status.getRunLights().equals(StatusBean.STATUS_OFF)) { %>
		<span onClick="javascript:setRunLights('On'); return false;" style="cursor:pointer; background-color: blue; color: white; border-radius: 15px; padding: 3px; font-size: 12px;"><b> &nbsp;Turn On&nbsp; </b></span>
	<% } %>	
	</td>
</tr>
<tr><td>Outside light mode:</td>
	<td><%=status.getRunLightsMode() %><br>
	<% if (status.getRunLightsMode().equals(StatusBean.STATUS_MANUAL)) { %>
		<font size=-1 color=gray><%=runLightsOn %>-<%=runLightsOff %></font>
	<% } else if (status.getRunLightsMode().equals(StatusBean.STATUS_AUTO)) { %>
		<font size=-1><%=runLightsOn %>-<%=runLightsOff %></font>
	<% } %>
	</td>
	<td>
	<% if (status.getRunLightsMode().equals(StatusBean.STATUS_MANUAL)) { %>
		<span onClick="javascript:setRunLightsModeAuto(); return false;" style="cursor:pointer; background-color: blue; color: white; border-radius: 15px; padding: 3px; font-size: 12px;"><b> &nbsp;Set Auto&nbsp; </b></span>
	<% } %>
	<a onClick="javascript:editRunLightsDialog(); return false;"><img height=20 style="cursor:pointer;" src='../images/edit_32.svg'></a>
	</td>
</tr>
</table>
<p>
<table class="normalTable">
<tr><th colspan=2>Chickens</th></tr>
<% for (ChickenBean chick: chickens) { %>
	<tr><td><b><%=chick.getName() %></b><br><%=chick.getBreed() %><br><font color=blue><%=chick.getTotalEggs() %></font> eggs</td><td><img src="../images/<%=chick.getImage() %>" height=60></td>
<% } %>
</table>



</td><td valign=top align=center>
<!-- middle -->

<img src="../images/coopDiagram1.jpg">
<p>
<table border=0><tr><td valign=top>
	<table class="normalTable">
	<tr><th>Inside Coop Cam</th></tr>
	<tr><td><img src="https://image.freepik.com/free-vector/black-webcam-icon_87739-181.jpg" height=100></td></tr>
	</table>
</td><td valign=top>
	<table class="normalTable">
	<tr><th>Outside Coop Cam</th></tr>
	<tr><td><img src="https://image.freepik.com/free-vector/black-webcam-icon_87739-181.jpg" height=100></td></tr>
	</table>
</td></tr></table>
</td><td valign=top>
<!-- right -->
<table class="normalTable">
<tr><th colspan=3>Coop Status</th></tr>
<tr><td>Temperature:</td><td><%=(status.getCoopTemp()<-50?"?":status.getCoopTemp() + "&deg;F") %></td><td></td></tr>
<tr><td>Humidity:</td><td><%=(status.getCoopHumid()<-50?"?":status.getCoopHumid() + "%") %></td><td></td></tr>
<tr><td>Water level:</td><td><%=(status.getWaterLevel()>=0 && status.getWaterLevel()<8?"<img src=\"../images/" + waterLevelImg + "\">":"?") %></td><td></td></tr>
<tr><td>Inside lights:</td>
	<td valign=middle>
		<% if (status.getCoopLights().equals(StatusBean.STATUS_OFF)) { %>
			<img src="../images/LightOff.png" height=25>
		<% } else if (status.getCoopLights().equals(StatusBean.STATUS_ON)) { %>
			<img src="../images/LightOn.png" height=25>
		<% } else { %>
			<%=status.getCoopLights() %>
		<% } %>
	</td><td>
	<% if (status.getCoopLights().equals(StatusBean.STATUS_ON)) { %>
		<span onClick="javascript:setCoopLights('Off'); return false;" style="cursor:pointer; background-color: blue; color: white; border-radius: 15px; padding: 3px; font-size: 12px;"><b> &nbsp;Turn Off&nbsp; </b></span>
	<% } %>	
	<% if (status.getCoopLights().equals(StatusBean.STATUS_OFF)) { %>
		<span onClick="javascript:setCoopLights('On'); return false;" style="cursor:pointer; background-color: blue; color: white; border-radius: 15px; padding: 3px; font-size: 12px;"><b> &nbsp;Turn On&nbsp; </b></span>
	<% } %>	
	</td>
</tr>
<tr><td>Inside light mode:</td>
	<td><%=status.getCoopLightsMode() %><br>
	<% if (status.getCoopLightsMode().equals(StatusBean.STATUS_MANUAL)) { %>
		<font size=-1 color=gray><%=coopLightsOn %>-<%=coopLightsOff %></font>
	<% } else if (status.getCoopLightsMode().equals(StatusBean.STATUS_AUTO)) { %>
		<font size=-1><%=coopLightsOn %>-<%=coopLightsOff %></font>
	<% } %>
	</td>
	<td>
	<% if (status.getCoopLightsMode().equals(StatusBean.STATUS_MANUAL)) { %>
		<span onClick="javascript:setCoopLightsModeAuto(); return false;" style="cursor:pointer; background-color: blue; color: white; border-radius: 15px; padding: 3px; font-size: 12px;"><b> &nbsp;Set Auto&nbsp; </b></span>
	<% } %>
	<a onClick="javascript:editCoopLightsDialog(); return false;"><img height=20 style="cursor:pointer;" src='../images/edit_32.svg'></a>
	</td>
</tr>
<tr><td>Heater:</td>
	<td>
	<% if (status.getCoopHeater().equals(StatusBean.STATUS_OFF)) { %>
		<img height=20 src='../images/heaterOff.png'>
	<% } else if (status.getCoopHeater().equals(StatusBean.STATUS_ON)) { %>
		<img height=20 src='../images/heaterOn.png'>
	<% } else { %>
		<%=status.getCoopHeater() %>
	<% } %>
	<% if (status.getCoopHeaterTemp()>-60) { %>
		<font size=-1> <%=status.getCoopHeaterTemp() %>&deg;F </font>
	<% } %>
	</td>
	<td>
		<a onClick="javascript:editHeaterTempDialog(); return false;"><img height=20 style="cursor:pointer;" src='../images/edit_32.svg'></a>
	</td></tr>
<tr><td>Water heater:</td>
	<td>
	<% if (status.getWaterHeater().equals(StatusBean.STATUS_OFF)) { %>
		<img height=20 src='../images/heaterOff.png'>
	<% } else if (status.getWaterHeater().equals(StatusBean.STATUS_ON)) { %>
		<img height=20 src='../images/heaterOn.png'>
	<% } else { %>
		<%=status.getWaterHeater() %>
	<% } %>
	<% if (status.getWaterHeaterTemp()>-60) { %>
		<font size=-1> <%=status.getWaterHeaterTemp() %>&deg;F </font>
	<% } %>
	</td>
	<td>
		<a onClick="javascript:editWaterHeaterTempDialog(); return false;"><img height=20 style="cursor:pointer;" src='../images/edit_32.svg'></a>
	</td></tr>
</table>
<p>
<table class="normalTable">
<tr><th colspan=3>Coop Door</th></tr>
<tr>
	<td>Status:</td><td><%=status.getDoorStatus() %></td>
	<td>
	<% if (status.getDoorStatus().equals(StatusBean.STATUS_OPEN)) { %>
		<span onClick="javascript:closeDoor(); return false;" style="cursor:pointer; background-color: blue; color: white; border-radius: 15px; padding: 3px; font-size: 12px;"><b> &nbsp;Close Door&nbsp; </b></span>
	<% } %>
	<% if (status.getDoorStatus().equals(StatusBean.STATUS_CLOSED)) { %>
		<span onClick="javascript:openDoor(); return false;" style="cursor:pointer; background-color: blue; color: white; border-radius: 15px; padding: 3px; font-size: 12px;"><b> &nbsp;Open Door&nbsp; </b></span>
	<% } %>
	</td>
<tr><td>Mode:</td><td><%=status.getDoorMode() %><br>
	<% if (status.getDoorMode().equals(StatusBean.STATUS_MANUAL)) { %>
		<font size=-1 color=gray>Dawn-<%=doorClose %></font>
	<% } else if (status.getDoorMode().equals(StatusBean.STATUS_AUTO)) { %>
		<font size=-1>Dawn-<%=doorClose %></font>
	<% } %>

	</td>
	<td>
	<% if (status.getDoorMode().equals(StatusBean.STATUS_MANUAL)) { %>
		<span onClick="javascript:setDoorModeAuto(); return false;" style="cursor:pointer; background-color: blue; color: white; border-radius: 15px; padding: 3px; font-size: 12px;"><b> &nbsp;Set Auto&nbsp; </b></span>
	<% } %>
	<a onClick="javascript:editDoorCloseDialog(); return false;"><img height=20 style="cursor:pointer;" src='../images/edit_32.svg'></a>
	</td>
</tr>
</table>


</table>
<p>
<font size=-1><i>
	Last Updated: <%=(status.getStatusTime()==null?"Unknown":dt.format(status.getStatusTime())) %>
	<%=((status.getMessage()!=null && status.getMessage().length()>0)?" (" + status.getMessage() + ")":"") %>
</i></font>


<table class=normalTable style="padding: 5px;">
<tr style="padding: 5px;"><th colspan=3 style="padding: 5px;">Commands sent to Coop</th></tr>
<% for (CommandBean cmd: cmds) { %>
	<tr style="padding: 5px;">
		<td style="padding: 5px;"><font size=-1><%=dt.format(cmd.getSendTime()) %></font></td>
		<td style="padding: 5px;"><font size=-1><%=cmd.getCommand() %></font></td>
		<td style="padding: 5px;"><font size=-1><%=(cmd.getParm1()==null?"":cmd.getParm1()) %>
			<%=(cmd.getParm2()==null || cmd.getParm2().equals("")?"":", " + cmd.getParm2()) %>
		</font></td>
	</tr>
<% } %>
</table>

<form action="DashboardServlet.do" name="FORM" method="POST">
	<input type=hidden name="action" value="runCommand">
	<input type=hidden name="command" value="">
	<input type=hidden name="parm1" value="">
	<input type=hidden name="parm2" value="">
	
</form>

<div id="blanketDiv" class="blanket" style="display:none;"></div>
<div id="editDoorCloseDiv" class="dialogBox" style="display:none;">
<center><b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Edit when coop door closes&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</b><p></center>
<form action="" name="DOOR_FORM" method="POST">

<table border=0 class="normalTable">
<tr>
	<th>Time</th>
</tr><tr>
	<td>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<select name="hour" id="hour" class="inputField">
		<% for (long i=16; i<=23; i++) { 
			String hrString = String.format("%02d", i);
		%>
			<option value="<%=hrString %>" <%=(i==doorCloseHour?"selected":"") %>><%=hrString %></option>
		<% } %>
		</select>
		:
		<select name="min" id="min" class="inputField">
		<% for (long i=0; i<=59;i++) { 
			String minString = String.format("%02d", i);
		%>
			<option value="<%=minString %>" <%=(i==doorCloseMin?"selected":"") %>><%=minString %></option>
		<% } %>
		</select>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		
	</td>

</tr></table>
<p><p>
</form>
<table border=0 width=100%><tr>
<td valign=top>
	<a id="editDoorCloseDialogButton" class="normalButton" href="" onClick="javascript:changeDoorClose();return false;">Change</a>
</td><td valign=top align=right>
	<a class="normalButton" href="" onClick="javascript:editDoorCloseCancel();return false;">Cancel</a>
</td>
</tr></table>
</div>

<!-- RUN LIGHTS DIALOG -->
<div id="runLightsDiv" class="dialogBox" style="display:none;">
<center><b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Run Lights&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</b><p></center>
<form action="" name="RUN_LIGHTS_FORM" method="POST">

<table border=0 class="normalTable">
<tr>
	<th>On Time</th><th>Off Time</th>
</tr><tr>
	<td>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<select name="onHour" id="hour" class="inputField">
		<% for (long i=4; i<=23; i++) { %>
			<option value="<%=i%>" <%=(i==runLightsOnHour?"selected":"") %>><%=i %></option>
		<% } %>
		</select>
		:
		<select name="onMin" id="min" class="inputField">
		<% for (long i=0; i<=59;i++) { %>
			<option value="<%=i %>" <%=(i==runLightsOnMin?"selected":"") %>><%=hourFormatter.format(i) %></option>
		<% } %>
		</select>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		
	</td>
	<td>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<select name="offHour" id="hour" class="inputField">
		<% for (long i=4; i<=23; i++) { %>
			<option value="<%=i%>" <%=(i==runLightsOffHour?"selected":"") %>><%=i %></option>
		<% } %>
		</select>
		:
		<select name="offMin" id="min" class="inputField">
		<% for (long i=0; i<=59;i++) { %>
			<option value="<%=i %>" <%=(i==runLightsOffMin?"selected":"") %>><%=hourFormatter.format(i) %></option>
		<% } %>
		</select>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		
	</td>

</tr></table>
<p><p>
</form>
<table border=0 width=100%><tr>
<td valign=top>
	<a id="runLightsDialogButton" class="normalButton" href="" onClick="javascript:changeRunLights();return false;">Change</a>
</td><td valign=top align=right>
	<a class="normalButton" href="" onClick="javascript:runLightsCancel();return false;">Cancel</a>
</td>
</tr></table>
</div>

<!-- COOP LIGHTS DIALOG -->
<div id="coopLightsDiv" class="dialogBox" style="display:none;">
<center><b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Coop Lights&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</b><p></center>
<form action="" name="COOP_LIGHTS_FORM" method="POST">

<table border=0 class="normalTable">
<tr>
	<th>On Time</th><th>Off Time</th>
</tr><tr>
	<td>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<select name="onHour" id="hour" class="inputField">
		<% for (long i=4; i<=23; i++) { %>
			<option value="<%=i%>" <%=(i==coopLightsOnHour?"selected":"") %>><%=i %></option>
		<% } %>
		</select>
		:
		<select name="onMin" id="min" class="inputField">
		<% for (long i=0; i<=59;i++) { %>
			<option value="<%=i %>" <%=(i==coopLightsOnMin?"selected":"") %>><%=hourFormatter.format(i) %></option>
		<% } %>
		</select>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		
	</td>
	<td>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<select name="offHour" id="hour" class="inputField">
		<% for (long i=4; i<=23; i++) { %>
			<option value="<%=i%>" <%=(i==coopLightsOffHour?"selected":"") %>><%=i %></option>
		<% } %>
		</select>
		:
		<select name="offMin" id="min" class="inputField">
		<% for (long i=0; i<=59;i++) { %>
			<option value="<%=i %>" <%=(i==coopLightsOffMin?"selected":"") %>><%=hourFormatter.format(i) %></option>
		<% } %>
		</select>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		
	</td>

</tr></table>
<p><p>
</form>
<table border=0 width=100%><tr>
<td valign=top>
	<a id="coopLightsDialogButton" class="normalButton" href="" onClick="javascript:changeCoopLights();return false;">Change</a>
</td><td valign=top align=right>
	<a class="normalButton" href="" onClick="javascript:coopLightsCancel();return false;">Cancel</a>
</td>
</tr></table>
</div>

<!-- HEATER TEMP DIV -->
<div id="editHeaterTempDiv" class="dialogBox" style="display:none;">
<center><b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Edit when heater turns on&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</b><p></center>
<form action="" name="HEATER_FORM" method="POST">

<table border=0 class="normalTable">
<tr>
	<th>Temperature</th>
</tr><tr>
	<td>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<input type=text name="heater_temp" size=5 value="<%=status.getCoopHeaterTemp() %>">&deg;F
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		
	</td>

</tr></table>
<p><p>
</form>
<table border=0 width=100%><tr>
<td valign=top>
	<a id="editHeaterTempDialogButton" class="normalButton" href="" onClick="javascript:changeHeaterTemp();return false;">Change</a>
</td><td valign=top align=right>
	<a class="normalButton" href="" onClick="javascript:heaterTempCancel();return false;">Cancel</a>
</td>
</tr></table>
</div>

<!-- WATER HEATER TEMP DIV -->
<div id="editWaterHeaterTempDiv" class="dialogBox" style="display:none;">
<center><b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Edit when water heater turns on&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</b><p></center>
<form action="" name="WATER_HEATER_FORM" method="POST">

<table border=0 class="normalTable">
<tr>
	<th>Temperature</th>
</tr><tr>
	<td>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<input type=text name="heater_temp" size=5 value="<%=status.getWaterHeaterTemp() %>">&deg;F
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		
	</td>

</tr></table>
<p><p>
</form>
<table border=0 width=100%><tr>
<td valign=top>
	<a id="editWaterHeaterTempDialogButton" class="normalButton" href="" onClick="javascript:changeWaterHeaterTemp();return false;">Change</a>
</td><td valign=top align=right>
	<a class="normalButton" href="" onClick="javascript:waterHeaterTempCancel();return false;">Cancel</a>
</td>
</tr></table>
</div>

</body>
</html>
