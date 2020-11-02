package com.eggs.chickendash;

import java.util.Date;

public class EggBean {
	long chickenId = -1;
	Date date = null;
	
	
	public EggBean(long chickenId, Date date) {
		this.date = date;
		this.chickenId = chickenId;
	}
	public long getChickenId() {
		return chickenId;
	}
	public Date getDate() {
		return date;
	}

	

}
