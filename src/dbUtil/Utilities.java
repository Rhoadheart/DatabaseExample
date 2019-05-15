package dbUtil;
/**
 * This program is for TinderStudyGroup in CS367 Spring 2019.
 * Members: Michael Garcia, Adam Rhoades, Alex Schuster,
 * 			Wyatt Gleason, Ben Vo.
 */
import java.sql.*;
import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;

public class Utilities {

    Connection conn;
    
    // Locally saved variable of client that is currently logged in.
    private int currentStudentID;

    public void openDB() {

        // Connect to the database
        String url = "jdbc:mariadb://mal.cs.plu.edu:3306/tsg367_2019?user=tsg367&password=tsg367";
        
        // URL for off-campus tunneling connection:	
        //String url = "jdbc:mariadb://localhost:2000/tsg367_2019?user=tsg367&password=tsg367";
        
        try {
            conn = DriverManager.getConnection(url);
        } catch (SQLException e) {
            System.out.println("using url:" + url);
            System.out.println("problem connecting to MariaDB: "+ e.getMessage());
            //e.printStackTrace();
        }

    }// openDB

    
	/**
	 * Close the connection to the DB
	 */
	public void closeDB() {
		try {
			conn.close();
			conn = null;
		} catch (SQLException e) {
			System.err.println("Failed to close database connection: " + e);
		}
	}// closeDB
	
	/*
	 * Method called when a user logs in. This makes the ID Number of 
	 * the client reachable when a user wants to perform actions on
	 * the database that require the user's ID number.
	 */
	public void setID(int idNum) {
		currentStudentID = idNum;
	}
	
	/**
	 * Method that returns the ID number of current client logged in.
	 * @return ID Number of client that is logged in.
	 */
	public int getID() {
		return currentStudentID;
	}
	
	/**
	 * @return the conn
	 */
	public Connection getConn() {
		return conn;
	}
	
    /**
     * Add a FreeTimeSlot for the specified user. This is a time in which this user is AVAILABLE not a time in which
     * the user is busy.
     * @param id_Number The ID of the user to add this time slot to.
     * @param start_Date_Time The starting date & time of the Free_Time_Slot
     * @param length The length of this Free_Time_Slot, must be a multiple of 15 e.g. :00, :15, :30, :45, :60 etc.
     * @param isTutor Defines if this slot is for a tutor position or not.
     * @return tuple added to Free_Time_Slot
     */
    public int addFreeTimeSlot(int id_Number, Timestamp start_Date_Time, int length, boolean isTutor ){
        if(length % 15 != 0){
            System.err.println("Length is not a multiple of 15 minute increment: " + length);
            return 0;
        }

        try{
        	
    		int hours = length / 60; //since both are ints, you get an int
    		int minutes = length % 60;
    		String lengthToBeConverted = hours+":"+minutes+":00";
    		Time lengthCorrectForm = Time.valueOf(lengthToBeConverted);
    		
            String sql = "INSERT INTO Free_Time_Slot(ID_Number, Start_Date_Time, Length, isTutorSlot) "  +
                    "VALUES ('" + id_Number + "', '" + start_Date_Time + "', '" + lengthCorrectForm + "', " + isTutor + ")";

            PreparedStatement preparedStatement = conn.prepareStatement(sql);

            return preparedStatement.executeUpdate();

        } catch (SQLException e){
            e.printStackTrace();
            System.err.println("Free_Time_Slot addition failed: " + e.getMessage());
            return 0;
        }
    }// addFreeTimeSlot

    /**
     * Add a FreeTimeSlot for the specified user. This is a time in which this user is AVAILABLE not a time in which
     * the user is busy.
     * @param id_Number The ID of the user to add this time slot to.
     * @param start_Date_Time The starting date & time of the Free_Time_Slot
     * @param end_Time The ending time of the Free_Time_Slot
     * @param isTutor Defines if this slot is for a tutor position or not.
     * @return 1 if tuple was added to, 0 otherwise
     */
    public int addFreeTimeSlot(int id_Number, Timestamp start_Date_Time, Timestamp end_Time, boolean isTutor){

        Duration duration = Duration.between(start_Date_Time.toLocalDateTime(), end_Time.toLocalDateTime());
        int length = (int) duration.toMinutes();        
        return addFreeTimeSlot(id_Number, start_Date_Time, length, isTutor);
    }


    /**
     * Show all students that are taking a specified course at a given time.
     * @param courseNum The course number of which the user wants to find matching study partners.
     * @param startMeeting The start time of the meeting.
     * @param endMeeting The end time of the meeting.
     * @return a ResultSet of information containing students that have the matching attributes and are available for a meeting at that time.
     */
    public ResultSet getStudentsByCourseAndAvailability(String courseNum, Timestamp startMeeting, Timestamp endMeeting){

        ResultSet rset = null;
        String sql = null;

        try{
            sql = "SELECT distinct name, email, c.ID_Number, major " +
                    "FROM (Free_Time_Slot f join Client c on f.ID_Number = c.ID_Number) join Enrolled_In e on f.ID_Number = e.ID_Number " +
                    "WHERE Start_Date_Time <= '" + startMeeting.toString() + "' " +
                    "and " +
                    "ADDTIME(Start_Date_Time, Length) >= '" + endMeeting.toString() + "' " +
                    "and " +
                    "isTutorSlot = false " +
                    "and " +
                    "Course_Number = '" + courseNum + "'";

            PreparedStatement pstmt = conn.prepareStatement(sql);

            rset = pstmt.executeQuery();


        }catch(Exception e){
            System.out.println("createStatement " + e.getMessage() + sql);
        }

        return rset;
    }

    /**
     * Method to remove a Client from a Study Session.
     * @param IDNum The ID Number of the Client.
     * @param session The Session ID of the Study Session the client
     * will be removed from.
     * @return 1 if Client successfully removed from Study Session, 0 if not.
     */
    public int removeFromSession(String IDNum, String session) {
    
    	String sql = null;
    
    	try{
    	
    		sql = "DELETE FROM Is_In WHERE ID_Number = " + IDNum + " and Session_ID = " + session;

    		PreparedStatement stmt = conn.prepareStatement(sql);

    		return stmt.executeUpdate();


    	}catch(Exception e){
    		System.out.println("createStatement " + e.getMessage() + sql);
    		}

    	return 0;
    }


    /**
     *	Method to create a study session.
     * @param name The name that will be displayed on invites to the study_session
     * @param startMeeting The date/time of the start of the meeting
     * @param length The duration of the meeting.
     * @return 1 if the study session was created successfully, 0 if not.
     */
    public ResultSet createStudySession(String name, Timestamp startMeeting, Time length){
    	ResultSet rset = null;
        String sql = null;

        try{
            sql = "Insert into Study_Session (Session_ID, Name, Start_Date_Time, Length)\n" +
                    "Values((Select s2.Session_ID from Study_Session s2 where s2.Session_ID >= ALL ( Select s.Session_ID  from Study_Session s)) + 1,'" + name +"','" + startMeeting +"','" + length +"');";

            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.executeUpdate();
            
            sql = "SELECT s2.Session_ID FROM Study_Session s2 WHERE s2.Session_ID >= ALL ( Select s.Session_ID  from Study_Session s)";
            pstmt = conn.prepareStatement(sql);
            rset = pstmt.executeQuery();

        }catch(Exception e){
            System.out.println("SQL ERROR " + sql);
        }
        return rset;

    }
    
    /**
     * Method to list all students in a given Study Session.
     * @param session Study Session ID Number.
     * @return Result set containing the 
     */
    public ResultSet inSession(String session) {
    	ResultSet rset = null;
        String sql = null;

        try{
            sql = "SELECT Name, Email, Major " + 
            		"FROM Is_In as i, Client as c " + 
            		"WHERE Session_ID=" + session +
            		" AND c.ID_Number = i.ID_Number";

            PreparedStatement pstmt = conn.prepareStatement(sql);

            rset = pstmt.executeQuery();
        }catch(Exception e){
            System.out.println("createStatement " + e.getMessage() + sql);
        }
        return rset;
    }
    
    /**
	 * Method called when a user accepts their invitation. The 
	 * client will be added to the Is_In table.
	 * @param idNum is the ID number of the user invited.
	 * @param sessionID is the Session ID number of the Study Session the user was invited to.
	 * @param asTutor is a boolean telling whether the Client invited is a tutor. 
	 * @return number of tuples successfully entered into Is_In table.
	 */
	public int addClientToSession(int idNum, int sessionID, boolean asTutor) {
		int numOfTuplesInserted = -1;
		String sql = null;

//		Timestamp sessionStart = null;
//		int sessionLength = 0;
//		
//        try{
//        	ResultSet rset=null;
//            sql = "SELECT Session_ID, Start_Date_Time " + 
//            		"FROM Study_Session " + 
//            		"WHERE Session_ID=" + sessionID ;
//
//            PreparedStatement pstmt = conn.prepareStatement(sql);
//
//            rset = pstmt.executeQuery();
//            
//            rset.next();
//            
//            sessionStart = rset.getTimestamp(1);
//            Time sessionTimeLength = rset.getTime(2);
//            
//            sessionLength = sessionTimeLength.getMinutes() + ( sessionTimeLength.getHours() * 60 );
//            
//            
//        }catch(Exception e){
//            System.out.println("createStatement " + e.getMessage() + sql);
//        }
//		
//		try {
//			if(!validateStudySessionJoin(sessionStart, sessionLength, asTutor, idNum)) {
//				return 0;
//			}
//		} catch (SQLException e1) {
//			e1.printStackTrace();
//		}
		try {
			//create a statement and an SQL string
			sql = "INSERT INTO Is_In(ID_Number, Session_ID, asTutor) " +
					"VALUES (?, ?, ?)";
			PreparedStatement pstmt = conn.prepareStatement(sql);
			
			pstmt.clearParameters();
			pstmt.setInt(1, idNum); // set the 1 parameter
			pstmt.setInt(2, sessionID); // set the 2 parameter
			if( asTutor )
				pstmt.setBoolean(3,  true);
			else
				pstmt.setBoolean(3, false);
			
			numOfTuplesInserted = pstmt.executeUpdate();
		} catch (SQLException e) {
			System.out.println("createStatement " + e.getMessage() + sql);
		}
		
		return numOfTuplesInserted;
	}

    /**
     * Creates a new client based of off client input.
     * @param Name First and Last name of the client
     * @param idNum ID_Number of the client
     * @param email plu email of the client
     * @param isStudent is a boolean telling if the client is a student
     * @param isTutor is a boolean telling if the client is a tutor
     * @param Major string contianing the clients major(s)
     * @return int value 0 is failed to add, and 1 or more is a success with the number being the amount of clients
     * added, should never be above 1.
     */
	public int createClient(String Name, int idNum, String email, String pass, boolean isStudent, boolean isTutor, String Major){
	    int newClients = 0;
        String sql = null;

        try {
            // create a Statement and a SQL string for the statement
            Statement stmt = conn.createStatement();
            sql = "Insert Into Client Values ('"+Name+"',"+idNum+",'"+email+"', PASSWORD('"+pass+"'), "+isStudent+", "+isTutor+",'"+Major+"')";
            newClients = stmt.executeUpdate(sql);
           }
        catch (SQLException e) {
            e.printStackTrace();
           System.out.println("Create Client failed: " + e.getMessage());
            }
	    return newClients;
    }

    /**
     * Updates the Start_Date_Time of given free time slot for the client
     * @param id_Number clients ID_Number
     * @param oldStart_Date_Time current Start_Date_Time for the tuple to be updated in the system
     * @param newStart_Date_Time new Start_Date_Time value, Start_Date_Time will be updated to
     * @param newLength new Length value, that the current Length will be updated to
     * @return int of number updates made to the system, 0 indicates a failure, 1 or greater is a success
     */
    public int updateFreeTimeSlot(int id_Number, Timestamp oldStart_Date_Time, Timestamp newStart_Date_Time, int newLength ){
        int updates = 0;
        String sql = null;
      
        try{
    		int hours = newLength / 60; //since both are ints, you get an int
    		int minutes = newLength % 60;
    		String lengthToBeConverted = hours+":"+minutes+":00";
    		Time lengthCorrectForm = Time.valueOf(lengthToBeConverted);
    		
            // create a Statement and a SQL string for the statement
            Statement stmt = conn.createStatement();
            sql = "Update Free_Time_Slot "  + "Set Start_Date_Time = '" + newStart_Date_Time + "', Length = '" + lengthCorrectForm + "' "
                    + "Where ID_Number = " + id_Number + " and Start_Date_Time = '" + oldStart_Date_Time + "' ";

            updates = stmt.executeUpdate(sql);

        } catch (SQLException e){
            e.printStackTrace();
            System.err.println("Free_Time_Slot update failed: " + e.getMessage());
        }
        return updates;
    }
    
    /**
     * 
     * @param email
     * @param password
     * @return
     */
    public boolean attemptLogin(String email, String password) {
    	ResultSet rset = null;
    	String sql = null;
    	
    	try {
    		Statement stmt = conn.createStatement();
    		
    		sql = "SELECT *"
    				+ " FROM Client"
    				+ " WHERE Email = '" + email + "' and Password=password('" + password + "')";
    		rset = stmt.executeQuery(sql);
    		
        	if (rset.next()) {
        		
        		setID(rset.getInt(2));
        		return true;
        	}	else {

        		return false;
        	}
    		
    	} catch(SQLException e) {
    		e.printStackTrace();
    		return false;
    	}	
    }
    
    /**
     * Method that is called when a user attempts to delete
     * their account.
     * @param idNum IdNumber of client.
     * @param password Password of client
     * @return True if the client's password they entered is correct.
     */
    public boolean verifyPassword(int idNum, String password) {
    	ResultSet rset = null;
    	String sql = null;
    	
    	try {
    		Statement stmt = conn.createStatement();
    		
    		sql = "SELECT *"
    				+ " FROM Client"
    				+ " WHERE ID_Number = '" + idNum + "' and Password=password('" + password + "')";
    		rset = stmt.executeQuery(sql);
    		
        	if (rset.next()) {
        		return true;
        	}	else {
        		return false;
        	}    		
    	} catch(SQLException e) {
    		e.printStackTrace();
    		return false;
    	}
    }
    
    
    public boolean validateStudySessionJoin(Timestamp sessionStart, int sessionLength, boolean isTutor, int idNum) throws SQLException {
    	
    	// Get the client's free time slots.
    	ResultSet freeTimeSlots = viewFreeTimeSlots(idNum, isTutor);
    	int size = 0;
    	
    	// Checks if the user has any free time slots and saves how many free
    	// time slots they have.
    	if (freeTimeSlots != null) 
    	{
    	  freeTimeSlots.last();    // moves cursor to the last row
    	  size = freeTimeSlots.getRow(); // get row id 
    	} else {
    		return false;
    	}
    	
    	freeTimeSlots.first();
    	
    	LocalDateTime end = sessionStart.toLocalDateTime().plusMinutes(sessionLength);
    	Timestamp sessionEnd = Timestamp.valueOf(end);
    	
    	// First thing to check is if there are any free time slots
    	// on the day of the study session.
    	if(!clientHasFreeTimesOnStudySessionDate(idNum,sessionStart)) {
    		return false;
    	}
    	
    	return true;
    	// Second case to consider is when the study session is 
    	// outside of the free time slots
    	
    	// if the end of the study session is before the free time slot start
    	// or if the start of the study session after free time slot end.
//    	for(int i = 0; i < size; i++) {
//    		Timestamp freeTimeSlotStart = freeTimeSlots.getTimestamp(1);
//    		Time ftsLengthTime = freeTimeSlots.getTime(2);
//    		int ftslength = ftsLengthTime.getMinutes() + ( ftsLengthTime.getHours() * 60 );
//    		
//    		
//        	LocalDateTime ftsend = freeTimeSlotStart.toLocalDateTime().plusMinutes(ftslength);
//        	Timestamp freeTimeSlotEnd = Timestamp.valueOf(ftsend);
//        	
//        	if( sessionEnd.before(freeTimeSlotStart) || sessionStart.after(freeTimeSlotEnd)) {
//        		return false;
//        	}
//        	freeTimeSlots.next();
//    	}
//    	
//    	freeTimeSlots.first();
    	// Third case to consider is when the study session start is at the
    	// free time slot start.
    	
    	// Now we are starting up update our free time slots based on the study session.
//    	for(int i = 0; i < size; i ++) {
//    		Timestamp freeTimeSlotStart = freeTimeSlots.getTimestamp(1);
//    		Time ftsLengthTime = freeTimeSlots.getTime(2);
//    		int newFtsLength = ftsLengthTime.getMinutes() + ( ftsLengthTime.getHours() * 60 );
//    		
//        	LocalDateTime ftsend = freeTimeSlotStart.toLocalDateTime().plusMinutes(newFtsLength);
//        	Timestamp freeTimeSlotEnd = Timestamp.valueOf(ftsend);
//    		
//    		if(freeTimeSlotStart.compareTo(sessionStart) == 0) {
//    			int newLength = newFtsLength - sessionLength;
//    			
//    			updateFreeTimeSlot(idNum, freeTimeSlotStart, sessionEnd, newLength);
//    			return true;
//    		}
//    
//    		freeTimeSlots.next();
//    	}
//    	
//    	freeTimeSlots.first(); 
    	
    	// Fourth case is when free time slot end = study session end
//    	for(int i = 0; i < size; i ++) {
//    		Timestamp freeTimeSlotStart = freeTimeSlots.getTimestamp(1);
//    		Time ftsLengthTime = freeTimeSlots.getTime(2);
//    		int newFtsLength = ftsLengthTime.getMinutes() + ( ftsLengthTime.getHours() * 60 );
//    		
//        	LocalDateTime ftsend = freeTimeSlotStart.toLocalDateTime().plusMinutes(newFtsLength);
//        	Timestamp freeTimeSlotEnd = Timestamp.valueOf(ftsend);
//    		
//    		if(sessionEnd.compareTo(freeTimeSlotEnd) == 0) {
//    			int newLength = newFtsLength - sessionLength;
//    			updateFreeTimeSlot(idNum, freeTimeSlotStart, freeTimeSlotStart, newLength);
//    			return true;
//    		}
//    
//    		freeTimeSlots.next();
//    	}
//    	
//    	freeTimeSlots.first();
    	
    	// Fifth case is when the study session is somewhere in the middle of the clients
    	// free time slot. You basically have to split the free time slot into two slots.
//    	for(int i = 0; i < size; i ++) {
//    		Timestamp freeTimeSlotStart = freeTimeSlots.getTimestamp(1);
//    		Time ftsLengthTime = freeTimeSlots.getTime(2);
//    		int newFtsLength = ftsLengthTime.getMinutes() + ( ftsLengthTime.getHours() * 60 );
//    		
//        	LocalDateTime ftsend = freeTimeSlotStart.toLocalDateTime().plusMinutes(newFtsLength);
//        	Timestamp freeTimeSlotEnd = Timestamp.valueOf(ftsend);
//    		
//    		if(sessionStart.before(freeTimeSlotEnd) && sessionStart.after(freeTimeSlotStart)
//    				&& sessionEnd.before(freeTimeSlotEnd)) {
//    			//First half of new time slot:
//    			double newLength1 = sessionStart.getTime() - freeTimeSlotStart.getTime();
//    			updateFreeTimeSlot(idNum, freeTimeSlotStart, freeTimeSlotStart, (int)newLength1);
//    			 
//    			double newLength2 = freeTimeSlotEnd.getTime() - sessionEnd.getTime();
//    			addFreeTimeSlot(idNum, sessionEnd, (int)newLength2, isClientTutor(idNum));
//    			return true;
//    		}
//    
//    		freeTimeSlots.next();
//    	}
    	// if the start time of the study session is before the end time of the fts, and
    	// if the start time of the study session after the fts starttime, and study session
    	// end time is before the end of the free time.
    }
   
    /**
     * Returns the number of free time slots that are on the date of the
     * study session.
     * @return
     */
    public boolean clientHasFreeTimesOnStudySessionDate(int idNum, Timestamp studySessionDate) {
    	ResultSet rset = null;
    	String sql = null;
    	
    	String dateAsString = studySessionDate.toString();
    	dateAsString = dateAsString.substring(0, dateAsString.indexOf("\\s"));
    	try {
    		Statement stmt = conn.createStatement();
    		
    		sql = "SELECT count(*)"
    				+ " FROM Free_Time_Slot"
    				+ " WHERE Start_Date_Time like '" + dateAsString + "%' and"
    				+ " ID_Number = '" + idNum+ "'";
    		rset = stmt.executeQuery(sql);
    		
        	if (rset.next()) {
        		int count = rset.getInt(1);
        		if (count > 0 ) {
        			return true;
        		} else {
        			return false;
        		}
        	}	else {
        		return false;
        	}    		
    	} catch(SQLException e) {
    		e.printStackTrace();
    		return false;
    	}
    }
    
    /**
     * Method called when a user attempts to add a user to a study session. In 
     * our UI when a user attempts to add a user to a study session, they give
     * us the email of the student they want to add. But our addClientToSession 
     * takes in IDNumber. So we need to get the IDNum associated with the requested
     * students email.
     * @return
     */
    public int getIDNumberFromEmail(String email) {
    	ResultSet rset = null;
    	String sql = null;
    	
    	try {
    		Statement stmt = conn.createStatement();
    		
    		sql = "SELECT ID_Number"
    				+ " FROM Client"
    				+ " WHERE Email = '" + email + "'";
    		rset = stmt.executeQuery(sql);
    		
        	if (rset.next()) {
        		return (rset.getInt(1));
        	}else {
        		return -1;
        	}
    	} catch(SQLException e) {
    		e.printStackTrace();
    	}
    	return -1;
    }
    
    /**
     * Method to return all classes a student is enrolled in.
     * @return ResultSet of all classes enrolled in.
     */
    public ResultSet coursesEnrolledIn(int studentID) {
    	ResultSet rset = null;
        String sql = null;

        try{
            sql = "SELECT Course_Number " + 
            		"FROM Enrolled_In " + 
            		"WHERE ID_Number=" + studentID;

            PreparedStatement pstmt = conn.prepareStatement(sql);

            rset = pstmt.executeQuery();
        }catch(Exception e){
            System.out.println("createStatement " + e.getMessage() + sql);
        }
        return rset;
    }
    
    /**
     * Method to return the free time slots of the requested user.
     * This method will be called from the student and tutor menu,
     * and in each menu it will only show free time slots for the user
     * if they are a student or tutor.
     * @param clientID ID of client.
     * @param isTutor boolean that tells if client is a tutor.
     * @return
     */
    public ResultSet viewFreeTimeSlots(int clientID, boolean isTutor) {
    	ResultSet rset = null;
        String sql = null;

        try{
            sql = "SELECT Start_Date_Time, Length " + 
            		"FROM Free_Time_Slot "+ 
            		"WHERE ID_Number=" + clientID +
            		" and isTutorSlot = " + isTutor + "";

            PreparedStatement pstmt = conn.prepareStatement(sql);

            rset = pstmt.executeQuery();
        }catch(Exception e){
            System.out.println("createStatement " + e.getMessage() + sql);
        }
        return rset;
    }
    
    /**
     * Method to return all classes a tutor is proficient in.
     * @return ResultSet of all classes proficient in.
     */
    public ResultSet coursesProficientIn(int tutorID) {
    	ResultSet rset = null;
        String sql = null;

        try{
            sql = "SELECT Course_Number " + 
            		"FROM Proficient_In " + 
            		"WHERE ID_Number=" + tutorID;

            PreparedStatement pstmt = conn.prepareStatement(sql);

            rset = pstmt.executeQuery();
        }catch(Exception e){
            System.out.println("createStatement " + e.getMessage() + sql);
        }
        return rset;
    }
    
    /**
     * Method called from General Menu to update the current user's password.
     * @param idNum ID Number of client logged in.
     * @param newPassword New password of client.
     * @return 1 if the password was updated, 0 if not not updated.
     */
    public int updatePassword(int idNum, String newPassword) {
        int updates = 0;
        String sql = null;
      
        try{
            // create a Statement and a SQL string for the statement
            Statement stmt = conn.createStatement();
            sql = "Update Client "  + 
            		"Set Password = password('" +newPassword+ "') " +  
            		"Where ID_Number = " + idNum ;

            updates = stmt.executeUpdate(sql);

        } catch (SQLException e){
            e.printStackTrace();
            System.err.println("Password update failed: " + e.getMessage());
        }
        return updates;
    }
    
    /**
     * Method called from General Menu that deletes the client's account.
     * @param idNum ID number of the client.
     * @return 1 if the client was deleted, 0 if not.
     */
    public int deleteClient(int idNum) {
        
    	String sql = null;
    
    	try{
    	
    		sql = "DELETE FROM Client WHERE ID_Number = " + idNum;

    		PreparedStatement stmt = conn.prepareStatement(sql);

    		return stmt.executeUpdate();


    	}catch(Exception e){
    		System.out.println("createStatement " + e.getMessage() + sql);
    		}

    	return 0;
    }
    
    /**
     * Method to delete free_time_slots of a client.
     * @param idNum ID Number of the client.
     * @param startDateTimes Dates of the Free_Time_Slots to be deleted.
     * @return Number of free_time_slots deleted.
     */
    public int deleteFreeTimeSlots(int idNum, String[] startDateTimes) {
        
    	String sql = null;
    	int count = 0;
    	
    	for (int i = 0; i < startDateTimes.length; i++) {
        	try{
            	
        		sql = "DELETE FROM Free_Time_Slot " + 
        				"WHERE ID_Number = " + idNum + " and Start_Date_Time = '" +
        				startDateTimes[i] + "'";

        		PreparedStatement stmt = conn.prepareStatement(sql);

        		count += stmt.executeUpdate();


        	}catch(Exception e){
        		System.out.println("createStatement " + e.getMessage() + sql);
        		}
    	}


    	return count;
    }
    
    /**
     * Method to delete a student's requested enrolled in courses.
     * @param idNum ID number of client.
     * @param courses Enrolled in courses of client to be removed.
     * @return Number of enrolled in courses deleted.
     */
    public int deleteEnrolledInCourses(int idNum, String[] courses) {
        
    	String sql = null;
    	int count = 0;
    	
    	for (int i = 0; i < courses.length; i++) {
        	try{
            	
        		sql = "DELETE FROM Enrolled_In " + 
        				"WHERE ID_Number = " + idNum + " and Course_Number = '" +
        				courses[i] + "'";

        		PreparedStatement stmt = conn.prepareStatement(sql);

        		count += stmt.executeUpdate();


        	}catch(Exception e){
        		System.out.println("createStatement " + e.getMessage() + sql);
        		}
    	}


    	return count;
    }
    
    /**
     * Method to delete a tutor's proficient courses.
     * @param idNum ID number of tutor.
     * @param courses Courses to be removed from user's list of
     * 					proficient_in courses.
     * @return Number of courses deleted.
     */
    public int deleteProficientInCourses(int idNum, String[] courses) {
    	String sql = null;
    	int count = 0;
    	
    	for (int i = 0; i < courses.length; i++) {
        	try{
            	
        		sql = "DELETE FROM Proficient_In " + 
        				"WHERE ID_Number = " + idNum + " and Course_Number = '" +
        				courses[i] + "'";

        		PreparedStatement stmt = conn.prepareStatement(sql);

        		count += stmt.executeUpdate();


        	}catch(Exception e){
        		System.out.println("createStatement " + e.getMessage() + sql);
        		}
    	}


    	return count;
    }
    
    /**
     * Method to add courses to a student's list of enrolled_in courses.
     * @param idNum ID number of client.
     * @param courses Courses to be added to a student's list of enrolled in courses.
     * @return Number of courses added.
     */
    public int addClassesEnrolledIn(int idNum, String[] courses) {
    	String sql = null;
    	int count = 0;
    	
    	for (int i = 0; i < courses.length; i++) {
        	try{
            	
        		sql = "INSERT INTO Enrolled_In " + 
        				"VALUES ('" + idNum + "', '" +
        				courses[i] + "')";

        		PreparedStatement stmt = conn.prepareStatement(sql);

        		count += stmt.executeUpdate();


        	}catch(Exception e){
        		System.out.println("createStatement " + e.getMessage() + sql);
        		}
    	}


    	return count;
    }
    
    /**
     * Method that gets a list of all courses in the database.
     * @return ResultSet of all courses.
     */
    public ResultSet getListOfAllCourses() {
    	ResultSet rset = null;
        String sql = null;

        try{
            sql = "SELECT Course_Number, Name " + 
            		"FROM Course";

            PreparedStatement pstmt = conn.prepareStatement(sql);

            rset = pstmt.executeQuery();
        }catch(Exception e){
            System.out.println("createStatement " + e.getMessage() + sql);
        }
        return rset;
    }

    /**
     * Method to add courses to a tutor's list of proficient in courses.
     * @param idNum ID number of client.
     * @param courses Courses to be added.
     * @return Number of courses successfully added.
     */
    public int addClassesProficientIn(int idNum, String[] courses) {
    	String sql = null;
    	int count = 0;
    	
    	for (int i = 0; i < courses.length; i++) {
        	try{
            	
        		sql = "INSERT INTO Proficient_In " + 
        				"VALUES ('" + idNum + "', '" +
        				courses[i] + "')";

        		PreparedStatement stmt = conn.prepareStatement(sql);

        		count += stmt.executeUpdate();


        	}catch(Exception e){
        		System.out.println("createStatement " + e.getMessage() + sql);
        		}
    	}


    	return count;
    }
    
    /**
     * Method that checks if the client is a tutor.
     * @param idNum ID number of client.
     * @return True if client is a tutor, false if not.
     */
    public boolean isClientTutor(int idNum) {
    	ResultSet rset = null;
        String sql = null;

        try{
            sql = "SELECT isTutor " + 
            		"FROM Client " + 
            		"Where ID_Number = " + idNum;

            PreparedStatement pstmt = conn.prepareStatement(sql);

            rset = pstmt.executeQuery();
            
            rset.next();
            
            boolean isTutor = rset.getBoolean(1);
            return isTutor;
            
        }catch(Exception e){
            System.out.println("createStatement " + e.getMessage() + sql);
        }
        return false;
    }
    
    /**
     * Method that checks if a client is a student.
     * @param idNum ID number of client.
     * @return True if student is a client, false if not.
     */
    public boolean isClientStudent(int idNum) {
    	ResultSet rset = null;
        String sql = null;

        try{
            sql = "SELECT isStudent " + 
            		"FROM Client " + 
            		"Where ID_Number = " + idNum;

            PreparedStatement pstmt = conn.prepareStatement(sql);

            rset = pstmt.executeQuery();
            
            rset.next();
            
            boolean isStudent = rset.getBoolean(1);
            return isStudent;
            
        }catch(Exception e){
            System.out.println("createStatement " + e.getMessage() + sql);
        }
        return false;
    }
}
