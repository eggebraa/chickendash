package com.eggs.chickendash;

import java.io.PrintWriter;
import java.io.Serializable;
import java.text.ParseException;
import java.util.Comparator;
import java.util.Properties;

import org.w3c.dom.Element;

public class UserBean implements Serializable, Comparator<UserBean> {
	private static final long serialVersionUID = 1L;

	String username = null;
	String password = null;
	String fullname = null;
	boolean isAdmin = false;
	boolean writeAccess = false;
	String[] sourceAccess = {};

	Properties userPrefs = new Properties();

	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getFullname() {
		return fullname;
	}
	public void setFullname(String fullname) {
		this.fullname = fullname;
	}
	public void setAdmin(boolean b) {
		isAdmin = b;
	}
	public boolean isAdmin() {
		return isAdmin;
	}
	public void setWriteAccess(boolean b) {
		writeAccess = b;
	}
	public boolean getWriteAccess() {
		return writeAccess;
	}

	public String getUserPreference(String pref) {
		return (String)userPrefs.get(pref);
	}
	public void setUserPreference(String pref, String value) {
		userPrefs.setProperty(pref, value);
	}
	public void setSourceAccess(String[] sources) {
		sourceAccess = sources;
	}
	public String[] getSourceAccess() {
		return sourceAccess;
	}
	public String getSourceAccessAsString() {
		StringBuffer buff = new StringBuffer();
		if (sourceAccess == null) return "";
		for (int i=0; i<sourceAccess.length; i++) {
			if (i>0) {
				buff.append(", ");
			}
			buff.append(sourceAccess[i]);
		}
		return buff.toString();
	}
	public boolean hasSourceAccess(String source) {
		for (String s: sourceAccess) {
			if (s.trim().equals(source)) {
				return true;
			}
		}
		return false;
	}


	public void serialize(PrintWriter pw) {
		pw.print("      <user ");
		pw.print(" username=\"" + username + "\"");
		//pw.print(" password=\"" + password + "\"");
		pw.print(" fullname=\"" + fullname + "\"");
		pw.print(" isAdmin=\"" + isAdmin + "\"");
		pw.print(" writeAccess=\"" + writeAccess + "\"");
		pw.print(" sourceAccess=\"" + getSourceAccessAsString() + "\"");
		pw.println("/>");
	}
	public static UserBean deserialize(Element element) throws ParseException {
		UserBean t = new UserBean();
		t.setUsername(element.getAttribute("username"));
		t.setPassword(element.getAttribute("password"));
		t.setFullname(element.getAttribute("fullname"));
		t.setAdmin(Boolean.parseBoolean(element.getAttribute("isAdmin")));
		t.setWriteAccess(Boolean.parseBoolean(element.getAttribute("writeAccess")));

		String sourceString = element.getAttribute("sourceAccess");
		if (sourceString!=null && !sourceString.trim().equals("")) {
			t.setSourceAccess(sourceString.split(","));
		}

		return t;
	}
	public int compare(UserBean t1, UserBean t2) {
		return t1.getUsername().compareTo(t2.getUsername());
	}


}
