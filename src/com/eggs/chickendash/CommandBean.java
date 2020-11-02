package com.eggs.chickendash;

import java.util.Date;

public class CommandBean {
	String command = null;
	String parm1 = null;
	String parm2 = null;
	Date sendTime = null;
	
	public CommandBean(String cmd, String parm1, String parm2) {
		this.command = cmd;
		this.parm1 = parm1;
		this.parm2 = parm2;
	}
	public String getCommand() {
		return command;
	}
	public void setCommand(String command) {
		this.command = command;
	}
	public String getParm1() {
		return parm1;
	}
	public void setParm1(String parm1) {
		this.parm1 = parm1;
	}
	public String getParm2() {
		return parm2;
	}
	public void setParm2(String parm2) {
		this.parm2 = parm2;
	}
	public Date getSendTime() {
		return sendTime;
	}
	public void setSendTime(Date sendTime) {
		this.sendTime = sendTime;
	}
	public String toString() {
		StringBuffer buff = new StringBuffer();
		buff.append(command);
		if (parm1!=null && !parm1.equals("")) {
			buff.append(":");
			buff.append(parm1);
		}
		if (parm2!=null && !parm2.equals("")) {
			buff.append(":");
			buff.append(parm2);
		}
		return buff.toString();
	}
	
	

	

}
