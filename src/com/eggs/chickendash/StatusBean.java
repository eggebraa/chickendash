package com.eggs.chickendash;

import java.util.Date;

public class StatusBean {
	public static final String STATUS_ON = "On";
	public static final String STATUS_OFF = "Off";
	public static final String STATUS_UNKNOWN = "Unknown";
	public static final String STATUS_OPEN = "Open";
	public static final String STATUS_CLOSED = "Closed"; 
	public static final String STATUS_MANUAL = "Manual"; 
	public static final String STATUS_AUTO = "Auto"; 
	
	public static final String SETTING_DAWN = "Dawn";
	public static final String SETTING_DUSK = "Dusk";
	
	float run_temp = -99;
	float run_humid = -99;
	String run_lights = STATUS_UNKNOWN;
	String run_lights_mode = STATUS_UNKNOWN;
	String run_lights_on = STATUS_UNKNOWN;
	String run_lights_off = STATUS_UNKNOWN;
	
	float coop_temp = -99;
	float coop_humid = -99;
	String coop_lights = STATUS_UNKNOWN;
	String coop_lights_mode = STATUS_UNKNOWN;
	String coop_lights_on = STATUS_UNKNOWN;
	String coop_lights_off = STATUS_UNKNOWN;
	String coop_heater = STATUS_UNKNOWN;
	float coop_heater_temp = -99;
	String water_heater = STATUS_UNKNOWN;
	float water_heater_temp = -99;
	int water_level = -99;

	String door_status = STATUS_UNKNOWN;
	String door_open = STATUS_UNKNOWN;
	String door_close = STATUS_UNKNOWN;
	String door_mode = STATUS_UNKNOWN;
	
	String message = "";
	Date status_time = null;
	
	public float getRunTemp() {
		return run_temp;
	}
	public void setRunTemp(float run_temp) {
		this.run_temp = run_temp;
	}
	public float getRunHumid() {
		return run_humid;
	}
	public void setRunHumid(float run_humid) {
		this.run_humid = run_humid;
	}
	public String getRunLights() {
		return run_lights;
	}
	public void setRunLights(String run_lights) {
		this.run_lights = run_lights;
	}
	public String getRunLightsMode() {
		return run_lights_mode;
	}
	public void setRunLightsMode(String mode) {
		this.run_lights_mode = mode;
	}
	public String getRunLightsOn() {
		return run_lights_on;
	}
	public void setRunLightsOn(String on) {
		this.run_lights_on = on;
	}
	public String getRunLightsOff() {
		return run_lights_off;
	}
	public void setRunLightsOff(String off) {
		this.run_lights_off = off;
	}
	public float getCoopTemp() {
		return coop_temp;
	}
	public void setCoopTemp(float coop_temp) {
		this.coop_temp = coop_temp;
	}
	public float getCoopHumid() {
		return coop_humid;
	}
	public void setCoopHumid(float coop_humid) {
		this.coop_humid = coop_humid;
	}
	public String getCoopLights() {
		return coop_lights;
	}
	public void setCoopLights(String coop_lights) {
		this.coop_lights = coop_lights;
	}
	public String getCoopLightsMode() {
		return coop_lights_mode;
	}
	public void setCoopLightsMode(String mode) {
		this.coop_lights_mode = mode;
	}
	public String getCoopLightsOn() {
		return coop_lights_on;
	}
	public void setCoopLightsOn(String on) {
		this.coop_lights_on = on;
	}
	public String getCoopLightsOff() {
		return coop_lights_off;
	}
	public void setCoopLightsOff(String off) {
		this.coop_lights_off = off;
	}
	public String getCoopHeater() {
		return coop_heater;
	}
	public void setCoopHeater(String coop_heater) {
		this.coop_heater = coop_heater;
	}
	public String getWaterHeater() {
		return water_heater;
	}
	public void setWaterHeater(String water_heater) {
		this.water_heater = water_heater;
	}
	public int getWaterLevel() {
		return water_level;
	}
	public void setWaterLevel(int water_level) {
		this.water_level = water_level;
	}
	public String getDoorStatus() {
		return door_status;
	}
	public void setDoorStatus(String door_status) {
		this.door_status = door_status;
	}
	public String getDoorOpen() {
		return door_open;
	}
	public void setDoorOpen(String door_open) {
		this.door_open = door_open;
	}
	public String getDoorClose() {
		return door_close;
	}
	public void setDoorClose(String door_close) {
		this.door_close = door_close;
	}
	public String getDoorMode() {
		return door_mode;
	}
	public void setDoorMode(String door_mode) {
		this.door_mode = door_mode;
	}
	public Date getStatusTime() {
		return status_time;
	}
	public void setStatusTime(Date status_time) {
		this.status_time = status_time;
	}
	public float getCoopHeaterTemp() {
		return coop_heater_temp;
	}
	public void setCoopHeaterTemp(float temp) {
		coop_heater_temp = temp;
	}
	public float getWaterHeaterTemp() {
		return water_heater_temp;
	}
	public void setWaterHeaterTemp(float temp) {
		water_heater_temp = temp;
	}
	public void setMessage(String msg) {
		message = msg;
	}
	public String getMessage() {
		return message;
	}
	

}
