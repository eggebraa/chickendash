package com.eggs.chickendash;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.StringReader;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.TimeZone;

import javax.servlet.ServletContext;
import javax.ws.rs.GET;
import javax.ws.rs.PUT;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;

import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.Response.ResponseBuilder;
import javax.ws.rs.core.UriInfo;


@Path("")
@Api(value = "/", description = "Services to post chicken data")
@Produces({MediaType.APPLICATION_JSON})
public class ChickenService {

	static DecimalFormat timeFormatter = new DecimalFormat("0000");
	static protected long msb0baseTime = 2085978496000L;
	static protected long msb1baseTime = -2208988800000L;

	public ChickenService(@Context ServletContext ctx) {
		
	}

	/*static {
		TimeZone utcZone = TimeZone.getTimeZone("UTC");
		Calendar cal = Calendar.getInstance(utcZone);
		cal.set(1900, Calendar.JANUARY, 1, 0, 0, 0);
		cal.set(Calendar.MILLISECOND, 0);
		msb1baseTime = cal.getTime().getTime();
		cal.set(2036, Calendar.FEBRUARY, 7, 6, 28, 16);
		cal.set(Calendar.MILLISECOND, 0);
		msb0baseTime = cal.getTime().getTime();
	}*/
	
	@GET
	@Path("/status")
	@Produces(MediaType.TEXT_HTML)
	public Response getStatus(
			@Context UriInfo info) {


		StatusBean status = DashboardServlet.getLatestStatus();
		StringBuffer rsp = new StringBuffer();
		rsp.append("Run temp: " + status.getRunTemp() + "<br>");

		ResponseBuilder builder = Response.ok(rsp.toString());
		return builder.build();
	}

	@PUT
	@Path("/sendStatus")
	@ApiOperation(value = "Send a status", 
    	notes = "RunTemp=30.8\n\nRunHumid=89.4\n\nRunLights=On\n\n"
    			+ "RunLightsMode=Auto\n\nRunLightsOn=17:30\n\nRunLightsOff=21:30\n\n"
    			+ "CoopTemp=39.2\n\nCoopHumid=84.6\n\nCoopLights=Off\n\n"
    			+ "CoopLightsMode=Auto\n\nCoopLightsOn=17:30\n\nCoopLightsOff=21:30\n\n"
    			+ "CoopHeater=Off\n\nWaterHeater=Off\n\nWaterLevel=4\n\n"
    			+ "CoopHeaterTemp=20.0\n\nWaterHeaterTemp=32.0\n\n"
    			+ "DoorMode=Auto\n\nDoorStatus=Open\n\nDoorClose=15:00\n\n", 
    	response = String.class
	)	
		
	@Produces(MediaType.TEXT_HTML)
	public Response sendStatus(
			InputStream is,
			@Context UriInfo info) {


		StatusBean status = new StatusBean();
		status.setMessage("No problems");
		status.setStatusTime(getTime());
		BufferedReader br = new BufferedReader(new InputStreamReader(is));
		String line = null;
		try {
			while ((line = br.readLine())!=null) {
				System.out.println("Line: " + line);
				String[] parts = line.split("=");
				if (parts.length==2) {
					if (parts[0].equals("RunTemp")) {
						float temp = Float.parseFloat(parts[1]);
						status.setRunTemp(temp);
					} else if (parts[0].equals("RunHumid")) {
						float humid = Float.parseFloat(parts[1]);
						status.setRunHumid(humid);
					} else if (parts[0].equals("RunLights")) {
						status.setRunLights(parts[1]);
					} else if (parts[0].equals("RunLightsMode")) {
						status.setRunLightsMode(parts[1]);
					} else if (parts[0].equals("RunLightsOn")) {
						status.setRunLightsOn(padNumber(parts[1]));
					} else if (parts[0].equals("RunLightsOff")) {
						status.setRunLightsOff(padNumber(parts[1]));
					} else if (parts[0].equals("CoopTemp")) {
						float temp = Float.parseFloat(parts[1]);
						status.setCoopTemp(temp);
					} else if (parts[0].equals("CoopHumid")) {
						float humid = Float.parseFloat(parts[1]);
						status.setCoopHumid(humid);
					} else if (parts[0].equals("CoopLights")) {
						status.setCoopLights(parts[1]);
					} else if (parts[0].equals("CoopLightsMode")) {
						status.setCoopLightsMode(parts[1]);
					} else if (parts[0].equals("CoopLightsOn")) {
						status.setCoopLightsOn(padNumber(parts[1]));
					} else if (parts[0].equals("CoopLightsOff")) {
						status.setCoopLightsOff(padNumber(parts[1]));
					} else if (parts[0].equals("CoopHeater")) {
						status.setCoopHeater(parts[1]);
					} else if (parts[0].equals("WaterHeater")) {
						status.setWaterHeater(parts[1]);
					} else if (parts[0].equals("WaterLevel")) {
						int level = Integer.parseInt(parts[1]);
						status.setWaterLevel(level);
					} else if (parts[0].equals("DoorStatus")) {
						status.setDoorStatus(parts[1]);
					} else if (parts[0].equals("DoorOpenTime")) {
						status.setDoorOpen(parts[1]);
					} else if (parts[0].equals("DoorCloseTime")) {
						status.setDoorClose(parts[1]);
					} else if (parts[0].equals("DoorMode")) {
						status.setDoorMode(parts[1]);
					} else if (parts[0].equals("CoopHeaterTemp")) {
						float temp = Float.parseFloat(parts[1]);
						status.setCoopHeaterTemp(temp);
					} else if (parts[0].equals("WaterHeaterTemp")) {
						float temp = Float.parseFloat(parts[1]);
						status.setWaterHeaterTemp(temp);
					} else if (parts[0].equals("StatusTime")) {
						//try {
						//	long ntpTime = Long.parseLong(parts[1]);
						//	long javaTime = getJavaTime(ntpTime);
						//	status.setStatusTime(new java.util.Date(javaTime));
						//} catch (Exception e) {
						//	status.setMessage("Error with status time: " + e.getMessage());
						//}
					}
				}
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			ResponseBuilder builder = Response.ok("Error reading status: " + e.getMessage());
			return builder.build();
		}
		DashboardServlet.addStatus(status);
		
		
		ResponseBuilder builder = Response.ok("Success");
		return builder.build();
	}
	
	private java.util.Date getTime() {
		Calendar cal = Calendar.getInstance();
		cal.setTime(new java.util.Date());
		cal.add(Calendar.HOUR, -5);
		return cal.getTime();
	}

	private String padNumber(String numString) {
		int num = 0;
		try {
			num = Integer.parseInt(numString);
		} catch (Exception e) {
			e.printStackTrace();
			return "Error";
		}
		return timeFormatter.format(num);
	}
	
	private long getJavaTime(long ntpTime) {
		
		long javaSecs = (ntpTime - 2208988800L) * 1000;
		return ntpTime;
		
		/*long secs = (ntpTime >>> 32) & 0xffffffffL;
		long fraction = ntpTime & 0xffffffffL;
		
		fraction = Math.round(1000D * fraction / 0x100000000L);
		//long msb = secs & 0x80000000L;
		//if (msb == 0) {
		//	return msb0baseTime + (secs * 1000) + fraction;
		//} else {
			return msb1baseTime + (secs * 1000) + fraction;
		//}*/
	}



}

