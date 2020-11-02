package com.eggs.chickendash;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;

public class ChickenBean {
	long id = -1;
	String name = null;
	String breed = null;
	String image = null;
	String eggImage = null;
	List<Date> eggList = new ArrayList<Date>();
	static SimpleDateFormat shortDate = new SimpleDateFormat("M/d"); 

	
	public ChickenBean(long id, String name) {
		this.id = id;
		this.name = name;
	}
	public long getId() {
		return id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getBreed() {
		return breed;
	}
	public void setBreed(String breed) {
		this.breed = breed;
	}
	public String getImage() {
		return image;
	}
	public void setImage(String image) {
		this.image = image;
	}
	public String getEggImage() {
		return eggImage;
	}
	public void setEggImage(String eggImage) {
		this.eggImage = eggImage;
	}
	public List<Date> getEggList() {
		return eggList;
	}
	public int getEggsPerMonth(int year, int month) {
		int count = 0;
		Calendar cal = new GregorianCalendar();
		for (Date d: eggList) {
			cal.setTime(d);
			if (cal.get(Calendar.YEAR) == year && cal.get(Calendar.MONTH)+1 == month) {
				count++;
			}
		}
		return count;
	}

	public int getEggsPerWeekDay(int dow) {
		int count = 0;
		Calendar cal = new GregorianCalendar();
		for (Date d: eggList) {
			cal.setTime(d);
			if (cal.get(Calendar.DAY_OF_WEEK) == dow) {
				count++;
			}
		}
		return count;
	}

	public void addEgg(Date date) {
		String newDate = DashboardServlet.sdf.format(date);
		for (Date d: eggList) {
			String thisDate = DashboardServlet.sdf.format(d);
			if (thisDate.equals(newDate)) {
				return;
			}
		}
		eggList.add(date);
	}
	public void deleteEgg(Date date) {
		String newDate = DashboardServlet.sdf.format(date);
		List<Date> datesToDelete = new ArrayList<Date>();
		for (Date d: eggList) {
			String thisDate = DashboardServlet.sdf.format(d);
			if (thisDate.equals(newDate)) {
				datesToDelete.add(d);
			}
		}		
		for (Date d: datesToDelete) {
			eggList.remove(d);
		}
	}
	public long getTotalEggs() {
		return eggList.size();
	}
	public boolean laidEggOnThisDate(Date date) {
		String compareDate = shortDate.format(date);
		
		for (Date d: eggList) {
			String dString = shortDate.format(d);
			if (dString.equals(compareDate)) {
				return true;
			}
		}
		
		return false;
	}

	

}
