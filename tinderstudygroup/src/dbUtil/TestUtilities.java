package dbUtil;
/**
 * This program is used to test the Utilities class
 * for TinderStudyGroup in CS367 Spring 2019.
 * Members: Michael Garcia, Adam Rhoades, Alex Schuster,
 * 			Wyatt Gleason, Ben Vo.
 */
 
// You need to import the java.sql package to use JDBC
import java.sql.*;
import java.util.Formattable;
import java.util.Formatter;
import java.util.Scanner;


public class TestUtilities {

	// Global variables
	static Utilities testObj = new Utilities(); 		// Utilities object for testing
	static Scanner keyboard = new Scanner(System.in); 	// standard input

	public static void main(String[] args) throws SQLException {

		// variables needed for menu
		int choice;
		boolean done = false;

		while (!done) {
			System.out.println();
			displaymenu();
			choice = getChoice();
			switch (choice) {
				case 1: {
					openDefault();
					break;
				}
				case 2:{
					callAddFreeTimeSlot();
					break;
				}
				case 3:{
					callAddFreeTimeSlotEndTime();
					break;
				}
				case 4:{
					callCreateClient();
					break;
				}
				case 5:{
					callGetStudentsByCourseAndAvailability();
					break;
				}
				case 6: {
					callCreateStudySession();
					break;
				}
				case 7: {
					callAcceptInvite();
					break;
				}
				case 8:{
					callRemoveFrSession();
					break;
				}
				case 9:{
					callInSession();
					break;
				}
				case 10: {
					callUpdateFreeTimeSlot();
					break;
				}
				case 11: {
					testObj.closeDB();
					break;
				}
				case 12: {
					done = true;
					System.out.println("Good bye");
					break;
				}
			// switch
		
			}
		}
	}// main

	static void displaymenu() {
		System.out.println("1)  open default DB");
		System.out.println("2) Add a Free Time Slot using length");
		System.out.println("3) Add a Free Time Slot using End Time");
		System.out.println("4) Create a Client.");
		System.out.println("5) Students by Course and Availability");
		System.out.println("6) Create Study Session");
		System.out.println("7) Accept Client Invite to Session");
		System.out.println("8) Remove Client from Study_Session");
		System.out.println("9) Students by Study Session");
		System.out.println("10) Update Free_Time_Slot");
		System.out.println("11) Close the DB");
		System.out.println("12) Quit");
	}

	static int getChoice() {
		String input;
		int i = 0;
		while (i < 1 || i > 12) {
			try {
				System.out.print("Please enter an integer between 1-12: ");
				input = keyboard.nextLine();
				i = Integer.parseInt(input);
				System.out.println();
			} catch (NumberFormatException e) {
				System.out.println("That is not a integer, try again pal.");
			}
		}
		return i;
	}

	// open the default database;
	static void openDefault() {
		testObj.openDB();
	}
	
	static void callRemoveFrSession() throws SQLException {
		System.out.println("Enter an ID number: ");
		String ID_Num = keyboard.nextLine();
		System.out.println("Enter Session ID number:  ");
		String session = keyboard.nextLine();
		int rs;
		rs = testObj.removeFromSession(ID_Num, session);
		if(rs==0) {
			System.out.print("Could not delete from session");
		}
		else{
			
			System.out.print("Deleted from session");
		}
		
	}
	
	static void callInSession() throws SQLException{
		System.out.println("Please enter a session_ID: ");
		String session = keyboard.nextLine();
		ResultSet rs;
		rs = testObj.inSession(session);
		System.out.println("Name                  Email                  Major");
		
		while (rs.next()) {
			System.out.printf("%-16s     %-16s     %s\n", 
					rs.getString(1), rs.getString(2), rs.getString(3));
		}
	}
		
	static void callAddFreeTimeSlot(){
		System.out.println("Add a Free time slot using length");
		System.out.print("Enter the Student's ID Number: ");
		int idNumber = Integer.parseInt(keyboard.nextLine());
		System.out.print("Enter the starting date & time for the free time slot 24hour format (YYYY-MM-DD HH:MM) : ");
		Timestamp sDateTime = Timestamp.valueOf(keyboard.nextLine() + ":00");
		System.out.print("Enter the length as an integer divisible by 15 e.g. (15, 30, 45, 90): ");
		int length = Integer.parseInt(keyboard.nextLine());

		boolean tutor;
		System.out.print("Are you a tutor? (Y/N): ");
		char ch = keyboard.nextLine().charAt(0);
		tutor = ch == 'Y' || ch == 'y';
		int result = testObj.addFreeTimeSlot(idNumber, sDateTime, length, tutor);
		if(result == 0) {
			System.out.println("The tuple was not inserted successfully.");
		} else {
			System.out.println("Tuple was insert successfully.");
		}
	}

	static void callAddFreeTimeSlotEndTime(){
		System.out.println("Add a Free time slot using length");
		System.out.print("Enter the Student's ID Number: ");
		int idNumber = Integer.parseInt(keyboard.nextLine());
		System.out.print("Enter the starting date & time for the free time slot 24hour format (YYYY-MM-DD HH:MM) : ");
		Timestamp time = Timestamp.valueOf(keyboard.nextLine() + ":00");
		System.out.print("Enter the End Time ending in :00, :15, :30, :45 : ");
		Timestamp eTime = Timestamp.valueOf(keyboard.nextLine());
		boolean tutor;
		System.out.print("Are you a tutor? (Y/N): ");
		char ch = keyboard.nextLine().charAt(0);
		tutor = ch == 'Y' || ch == 'y';
		int result = testObj.addFreeTimeSlot(idNumber, time, eTime, tutor);
		if(result == 0) {
			System.out.println("The tuple was not inserted successfully.");
		} else {
			System.out.println("Tuple was insert successfully.");
		}
	}
	

	static void callAcceptInvite() {
		System.out.print("Enter the Student's ID Number: ");
		int idNum = keyboard.nextInt();
		System.out.println("Enter the Study Session ID Number: ");
		int sessionID = keyboard.nextInt();
		
		// Consuming new line character
		keyboard.nextLine();
		
		boolean tutor;
		System.out.print("Are you a tutor? (Y/N): ");
		char ch = keyboard.nextLine().charAt(0);
		tutor = ch == 'Y' || ch == 'y';
		
		int result = testObj.addClientToSession(idNum, sessionID, tutor);
		
		if(result == 0) {
			System.out.println("The tuple was not inserted successfully.");
		} else {
			System.out.println("Tuple was insert successfully.");
		}
	}

	static void callGetStudentsByCourseAndAvailability() throws SQLException{

		ResultSet rs;
		//(String courseNum, Timestamp startMeeting, Timestamp endMeeting){
		System.out.println("Enter the Course Number to find study partners: ");
		String cno = keyboard.nextLine();

		System.out.println("Enter the day you would you like to meet on(yyyy-mm-dd): ");
		Date meetingDate = Date.valueOf(keyboard.nextLine());

		System.out.println("Enter the potential start time for the meeting (hh:mm:00): ");
		String startTime = keyboard.nextLine();
		Timestamp startMeeting = Timestamp.valueOf(meetingDate + " " + startTime);


		System.out.println("Enter the potential end time for the meeting (hh:mm:00): ");
		String endTime = keyboard.nextLine();
		Timestamp endMeeting = Timestamp.valueOf(meetingDate + " " + endTime);

		System.out.println("\nStudents that are available to study: " + cno + " from " + startTime + " to " + endTime + " on " + meetingDate);
		System.out.println("***********************************************************************");
		//name, email, major
		System.out.printf("     %-22s     %-22s     %s\n", "Name","email","major");
		rs = testObj.getStudentsByCourseAndAvailability(cno,startMeeting,endMeeting);
		while (rs.next()) {
			System.out.printf(" %-26s %-26s %s\n", rs.getString(1),
					rs.getString(2), rs.getString(3));
		}

	}

	static void callCreateStudySession() throws SQLException{
		int rows = 0;
		System.out.println("Enter the name for the study session: ");
		String name = keyboard.nextLine();

		System.out.println("Enter the date this study session will take place on(yyyy-mm-dd): ");
		Date meetingDate = Date.valueOf(keyboard.nextLine());


		System.out.println("Enter the start time for the study session (hh:mm:00): ");
		String startTime = keyboard.nextLine();
		Timestamp startMeeting = Timestamp.valueOf(meetingDate + " " + startTime);


		System.out.println("Enter the length of the meeting (hh:mm:00): ");
		Time length = Time.valueOf(keyboard.nextLine());

		System.out.println("\nCreating Study_Session at " + startTime + " on " + meetingDate );
		System.out.println("***********************************************************************");
		//(String name, Date meetingDate, Time startTime, Time duration){
		rows = testObj.createStudySession(name, startMeeting, length);
		System.out.println("A total of " + rows + " meeting(s) were added to the Study_Session table.");
	}

	//test insertNewDepartmentLocation() method
	//("Dr Pepper", 12340015, "dpep@plu.edu", "mrpibb", false, true, "Chemistry, Culinary Arts")
	static void callCreateClient() throws SQLException {
		int newClients;
		boolean isTutor = false;
		boolean isStudent = false;
		System.out.println("Add a new Client to the System.");

		//Get Name from user
		System.out.print("Enter your first and last name: ");
		String name = keyboard.nextLine();

		//Get ID_Number from user
		System.out.print("Enter your Student ID Number: ");
		int idNum = Integer.parseInt(keyboard.nextLine());

		//Get email from user
		System.out.print("Enter your plu email: ");
		String email = keyboard.nextLine();

		//Get password from user
		System.out.print("Enter a password: ");
		String pass = keyboard.nextLine();

		//Get Student Status
		System.out.print("Are you a student? (T/F): ");
		char s = keyboard.nextLine().charAt(0);
		if (s == 'T' || s == 't') {
			isStudent = true;
		}

		//Get Tutor Status
		System.out.print("Are you a tutor? (T/F): ");
		char t = keyboard.nextLine().charAt(0);
		if (t == 'T' || t == 't') {
			isTutor = true;
		}

		//Get major(s) from user
		System.out.print("Enter your major(s): ");
		String major = keyboard.nextLine();

		System.out.println("\n Adding new client.");
		System.out.println("*******************************************");
		newClients = testObj.createClient(name,idNum, email, pass, isStudent, isTutor, major);
		System.out.println("Number of clients added:" + newClients);
		if(newClients == 0) {
			System.out.println("The insertion was not successful, you were not added to the system.");
		}
		else {
			System.out.println("The update was successful. " + name + " is now apart of the system." );
		}
	}

	//test updateFreeTimeSlot() method
	static void callUpdateFreeTimeSlot() throws SQLException {
		int updates;
		System.out.println("Update the time and length of one of your Free time slots.");

		//Get ID_Number from user
		System.out.print("Enter your Student ID Number: ");
		int idNum = Integer.parseInt(keyboard.nextLine());

		//Get old and new Start_Date_Time from the user
		System.out.print("Enter the current starting date & time of the free time slot 24hour format (YYYY-MM-DD HH:MM) : ");
		Timestamp oldSDateTime = Timestamp.valueOf(keyboard.nextLine() + ":00");
		System.out.print("Enter the new starting date & time of the free time slot 24hour format (YYYY-MM-DD HH:MM) : ");
		Timestamp newSDateTime = Timestamp.valueOf(keyboard.nextLine() + ":00");

		//Get new length from the user
		System.out.print("Enter the new length for the free time slot as a time in 15 minute increments in 24hour format (HH:MM) : ");
		Time newLength = Time.valueOf(keyboard.nextLine() + ":00");

		System.out.println("\n Updating your specified free time slot.");
		System.out.println("*******************************************");
		updates = testObj.updateFreeTimeSlot(idNum, oldSDateTime, newSDateTime, newLength);
		System.out.println("Number of updates made:" + updates);
			if(updates == 0) {
				System.out.println("The update was not successful, your free time slot will remain unchanged.");
			}
			else {
			System.out.println("The update was successful. Your free time slot is now at: " + newSDateTime + " and has a " + newLength +  " duration.");
			}
		}

}//MyUtilitiesTest	