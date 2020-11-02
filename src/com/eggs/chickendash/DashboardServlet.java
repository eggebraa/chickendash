package com.eggs.chickendash;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.FileInputStream;
import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.cloud.storage.Blob;
import com.google.cloud.storage.BlobId;
import com.google.cloud.storage.BlobInfo;
import com.google.cloud.storage.Storage;
import com.google.cloud.storage.StorageOptions;

/**
 * Servlet implementation class TrainerServlet
 */

public class DashboardServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	static List<StatusBean> statusList = new ArrayList<StatusBean>();
	static List<CommandBean> lastCommands = new ArrayList<CommandBean>();
	static List<ChickenBean> chickens = new ArrayList<ChickenBean>();
	
	static private InetAddress controllerAddress = null;
	static private int port = 2391;
    static public SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");
    static GoogleCredentials credentials = null;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public DashboardServlet() {
        super();        
                
        try {
        	controllerAddress = InetAddress.getByName("24.197.219.152");
        } catch (Exception e) {
        	e.printStackTrace();
        }
    }

	public void init() throws ServletException {
		super.init();
        try {
        	FileInputStream fis = new FileInputStream(this.getServletContext().getRealPath("/ChickenDash-335368a50705.json"));
        	credentials = GoogleCredentials.fromStream(fis);
        } catch (Exception e) {
        	e.printStackTrace();
        }
        //hardcode chicken list
        ChickenBean chicken1 = new ChickenBean(1, "Penny");
        ChickenBean chicken2 = new ChickenBean(2, "Amy");
        ChickenBean chicken3 = new ChickenBean(3, "Bernadette");
        ChickenBean chicken4 = new ChickenBean(4, "Hallie");
        
        chicken1.setBreed("White Leghorn");
        chicken1.setImage("WhiteLeghorn.jpg");
        chicken1.setEggImage("whiteEgg.png");
        
        chicken2.setBreed("Australorp");
        chicken2.setImage("Australorp.jpg");
        chicken2.setEggImage("lightBrownEgg.png"); 

        chicken3.setBreed("Welsummer");
        chicken3.setImage("Welsummer.jpg");
        chicken3.setEggImage("brownEgg.png");

        chicken4.setBreed("Easter Egger");
        chicken4.setImage("EasterEgger.jpg");
        chicken4.setEggImage("blueEgg.png");

        chickens.add(chicken1);
        chickens.add(chicken2);
        chickens.add(chicken3);
        chickens.add(chicken4);
        //test
        try {
        	//chicken1.addEgg(sdf.parse("08/01/2017"));
            readEggFile();
       } catch (Exception e) {
        	e.printStackTrace();
        }
	}
	public static List<ChickenBean> getChickens() {
		return chickens;
	}
	public static ChickenBean getChicken(long id) {
		for (ChickenBean chicken: getChickens()) {
			if (chicken.getId()==id) {
				return chicken;
			}
		}
		return null;
	}

	public static StatusBean getLatestStatus() {
		StatusBean status = new StatusBean();
		if (statusList.size()>0) {
			status = statusList.get(0);
		}
		return status;
	}
	public static void addStatus(StatusBean s) {
		statusList.add(0, s);
	}
	public static void runCommand(CommandBean cmd) {
		//TODO: run cmd

		String msg = cmd.toString();
	    try {
		    DatagramPacket packet = new DatagramPacket(msg.getBytes(), msg.length(), controllerAddress, port);
	        DatagramSocket dsocket = new DatagramSocket();
	        dsocket.send(packet);
	        dsocket.close();
	    } catch (Exception e) {
	        System.err.println(e);
	    }


		cmd.setSendTime(new java.util.Date());
		lastCommands.add(0, cmd);
		if (lastCommands.size()>5) {
			lastCommands.remove(5);
		}
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request,response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		routeRequest(request,response);
	}

	private void routeRequest(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {

		String action = request.getParameter("action");
		if (action==null) action = "";

		//first check if logged in...
		HttpSession session = request.getSession();
		UserBean user = (UserBean)session.getAttribute("user");
		if (user==null) {
			goLoginPage(request, response);
			return;
		}
		System.out.println("Action: " + action);
		if (action.equals("dashboard")) {
			goDashboard(request, response);
		} else if (action.equals("eggTracker")) {
			goEggTracker(request, response);
		} else if (action.equals("historyData")) {
			goHistoryData(request, response);
		} else if (action.equals("runCommand")) {
			runCommand(request, response);
		} else if (action.equals("addEggs")) {
			addEggs(request, response);
		} else if (action.equals("deleteEgg")) {
			deleteEgg(request, response);
		} else {
			goLoginPage(request, response);
		}

	}

	private void goLoginPage(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		RequestDispatcher dispatcher = getServletContext().getRequestDispatcher("/jsp/login.jsp");
		dispatcher.forward(request, response);

	}

	private void goDashboard(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		request.setAttribute("status", getLatestStatus());
		request.setAttribute("lastCommands", lastCommands);
		
		RequestDispatcher dispatcher = getServletContext().getRequestDispatcher("/jsp/dashboard.jsp");
		dispatcher.forward(request, response);

	}

	private void runCommand(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String cmd = request.getParameter("command");
		String parm1 = request.getParameter("parm1");
		String parm2 = request.getParameter("parm2");
		runCommand(new CommandBean(cmd, parm1, parm2));
		
		goDashboard(request, response);
	}

	private void goEggTracker(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		RequestDispatcher dispatcher = getServletContext().getRequestDispatcher("/jsp/eggTracker.jsp");
		dispatcher.forward(request, response);

	}

	private void addEggs(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String eggDateString = request.getParameter("eggDate");
		
		Date eggDate = null;
		if (eggDateString.equals("Today")) {
			eggDate = new Date();
		} else {
			try {
				eggDate = sdf.parse(eggDateString);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		System.out.println("Date: " + eggDate.toString());
		for (ChickenBean chicken: getChickens()) {
			long id = chicken.getId();
			String checked = request.getParameter("chicken" + id);
			if (checked!=null) {
				chicken.addEgg(eggDate);
			}
		}
		
		try {
			saveEggFile();
		} catch (Exception e) {
			e.printStackTrace();
		}
		goEggTracker(request, response);
	}

	private void deleteEgg(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String eggDateString = request.getParameter("date");
		String chickenId = request.getParameter("chicken");
		Date eggDate = null;
		try {
			eggDate = sdf.parse(eggDateString);
		} catch (Exception e) {
			e.printStackTrace();
		}
		//System.out.println("Deleting " + chickenId + " on " + eggDate);
		ChickenBean chicken = getChicken(Long.parseLong(chickenId));
		if (chicken!=null) {
			chicken.deleteEgg(eggDate);
		}
		
		try {
			saveEggFile();
		} catch (Exception e) {
			e.printStackTrace();
		}
		goEggTracker(request, response);
	}

	private void readEggFile() throws Exception {
	    Storage storage = StorageOptions.newBuilder().setProjectId("wide-hold-175717").setCredentials(credentials).build().getService();
	    //Blob blob = storage.get("chickendash", "EggList.xls", Storage.BlobGetOption.generationMatch());
	    Blob blob = storage.get(BlobId.of("chickendash", "EggList.xls"), Storage.BlobGetOption.generationNotMatch(-1));
	    System.out.println("Read EggFile.xls with size: " + blob.getSize());
	    
	    Workbook wb = null;
		try {
			byte[] blobBytes = blob.getContent(Blob.BlobSourceOption.generationMatch());
			ByteArrayInputStream bais = new ByteArrayInputStream(blobBytes);
			wb = new HSSFWorkbook(bais);
		} catch (Exception ex) {
			System.out.println("Error loading eggfile:" + ex.getMessage());
			ex.printStackTrace();
			throw ex;
		}
		if (wb==null) {
			return;
		}
		for (int i=0; i<wb.getNumberOfSheets(); i++) {
			Sheet sheet = wb.getSheetAt(i);
			ChickenBean chicken = getChicken(Long.parseLong(sheet.getSheetName()));
			if (chicken!=null) {
				chicken.getEggList().clear();
				for (int r=0; r<=sheet.getLastRowNum(); r++) {
					Row row = sheet.getRow(r);
					if (row==null) break;
					Cell cell = row.getCell(0);
					if (cell==null) break;
					String dateString = cell.getStringCellValue();
					if (dateString!=null && dateString.length()>0) {
						Date d = sdf.parse(dateString);
						if (d!=null) {
							chicken.addEgg(d);
						}
					}
				}
			}
		}
		wb.close();
		System.out.println("Done reading egg lists");
	}
	
	private void saveEggFile() throws Exception {
		Workbook wb = new HSSFWorkbook();
		for (ChickenBean chicken: getChickens()) {
			Sheet sheet = wb.createSheet("" + chicken.getId());
			int row = 0;
			if (chicken.getEggList()!=null) {
				for (Date d: chicken.getEggList()) {
					Row r = sheet.createRow(row++);
					Cell cell = r.createCell(0);
					cell.setCellValue(sdf.format(d));
				}
			}
		}
		ByteArrayOutputStream bos = new ByteArrayOutputStream();
		wb.write(bos);

	    Storage storage = StorageOptions.newBuilder().setProjectId("wide-hold-175717").setCredentials(credentials).build().getService();
	    BlobInfo bi = BlobInfo.newBuilder("chickendash", "EggList.xls").build();
	    storage.create(bi, bos.toByteArray());
		wb.close();
	}

	private void goHistoryData(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		RequestDispatcher dispatcher = getServletContext().getRequestDispatcher("/jsp/historyData.jsp");
		dispatcher.forward(request, response);

	}


}
