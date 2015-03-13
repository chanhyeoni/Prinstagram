package Prinstagram;

import java.sql.*;
import javax.sql.rowset.serial.SerialBlob;
import java.util.Date;
import java.util.List;
import java.util.LinkedHashMap;
import java.util.ArrayList;

public class Database {
	static final String username = "root";
	static final String password = "root";
	static final String JDBC_DRIVER = "com.mysql.jdbc.Driver";
	static final String DB_URL = "jdbc:mysql://localhost:8889/prinstagram_web";
	Connection conn;
	
	public Database(){
		try{
			Class.forName(JDBC_DRIVER);
			System.out.println("Connecting to database...");
			conn = DriverManager.getConnection(DB_URL,username,password);
		}catch(Exception e){
			e.printStackTrace();
			System.out.println("The Exception in the Database() has been raised");
		}
	}
	
	public void closeConnection(){
		try{
			conn.close();
		}catch(SQLException e){
			System.out.println("Connection cannot be closed!");
		}
	}
	

	public boolean loginValidate(String id, String password){
		// validates whether the login information was included in the person table
		try{
			String query = "select username, password from person where username = ? and password = ?";
			if(conn!=null){
				PreparedStatement pstmt = conn.prepareStatement(query);
				pstmt.setString(1, id);
				pstmt.setString(2, password);
				ResultSet result = pstmt.executeQuery();
				if(result.first()){return true;}
			}else{
				System.out.println("connection is DEAD!");
			}
			System.out.println("CAN't find the account");
			return false;
		}catch(SQLException e){
			e.printStackTrace();
			System.out.println("The SQLException in the loginValidate has been raised");
			return false;
		}
	}
	
	public ResultSet getPhotoInfoQuery(String user) throws SQLException{
		// uses the id (username) to make the menu site where the user can view the photo he's allowed to view
		// in other words, select the photos that are visible to the user
		String query = "select distinct pid, poster, pdate, caption from photo where is_pub = ? or poster = ?"
				+ " or pid in (select pid from shared natural join inGroup where "
				+ " ownername = ? or username = ?) order by pdate desc";
		
		if(conn!=null){
			PreparedStatement pstmt = conn.prepareStatement(query);
			pstmt.setBoolean(1, true);
			pstmt.setString(2, user);
			pstmt.setString(3, user);
			pstmt.setString(4, user);
			ResultSet result = pstmt.executeQuery();
			return result;
		}
		return null;
	}
	
	public ResultSet showTaggeeQuery(int pid){
		// execute the query that retrieves the names of taggees give the pid number and
		// the status of the tag as true
		String query = "select fname, lname from person, tag where"
				+ " tag.taggee = person.username and pid = ? and tstatus = ?";
		try{
			if(conn!=null){
				PreparedStatement pstmt = conn.prepareStatement(query);
				pstmt.setInt(1, pid);
				pstmt.setBoolean(2, true);
				ResultSet result = pstmt.executeQuery();
				return result;
			}
		}catch(SQLException e){
			e.printStackTrace();
			System.out.println("the SQLException is raised in showTaggeeQuery");
			return null;
		}
		return null;	
	}
	
	
	public ResultSet showCommentQuery(int pid){
		// execute the query that retrieves the comments of the photo
		String query = "select ctime, ctext from comment natural join commentOn"
				+ " where pid = ?";
		try{
			if(conn!=null){
				PreparedStatement pstmt = conn.prepareStatement(query);
				pstmt.setInt(1, pid);
				ResultSet result = pstmt.executeQuery();
				return result;
			}
		}catch(SQLException e){
			System.out.println("the SQLException is raised in showCommentQuery");
			return null;
		}
		return null;
		
	}
	
	public LinkedHashMap<String, List<List<String>>> viewPhotoQuery(String user) throws SQLException{
		// uses the three functions defined above to retrieve the photos that can be viewed by 
		// the parameter user
		// this function will be used along with the getPhotoInfoQuery function to retrieve
		// the photos that are visible to the user
		// the additional thing this function does is to show the information about the tagees and comments
		// associated with each visible photo
		if(conn!=null){
			ResultSet result_photo = getPhotoInfoQuery(user);
			LinkedHashMap<String, List<List<String>>> results = new LinkedHashMap<String, List<List<String>>>();
			if(result_photo!=null){
				while(result_photo.next()){
					int pid = result_photo.getInt("pid");
					System.out.println(pid);
					ResultSet result_taggee = showTaggeeQuery(pid);
					ResultSet result_comment = showCommentQuery(pid);
					List<String> taggees = new ArrayList();
					if(result_taggee !=null){
						while(result_taggee.next()){
							String fname = result_taggee.getString("fname");
							String lname = result_taggee.getString("lname");
		
							String value = fname + ", " + lname;
							taggees.add(value);
						}
					}
					List<String> comments = new ArrayList();
					if(result_comment !=null){
						while(result_comment.next()){
							String ctime = result_comment.getTimestamp("ctime").toString();
							String ctext = result_comment.getString("ctext");
							String value = "("+ ctime + ") : " + ctext;
							comments.add(value);
						}
					}
	
					String pid_str = Integer.toString(pid);
					String poster = result_photo.getString("poster");
					String pdate = result_photo.getTimestamp("pdate").toString();
					String caption = result_photo.getString("caption");
					
					List<List<String>> values = new ArrayList();
					values.add(taggees);
					values.add(comments);
					
					String key = pid + ", " + poster + ", " + pdate + ", " + caption;
					results.put(key, values);
				}
			}
			return results;
		}
		return null;
	}
	
	public ResultSet getAllProposedTags(String username){
		// returns all the tags the user is being tagged and the status is false
		String query = "select * from tag where taggee = ? and tstatus = ?";
		ResultSet result = null;
		try{
			if(conn!=null){
				PreparedStatement pstmt = conn.prepareStatement(query);
				pstmt.setString(1,  username);
				pstmt.setBoolean(2, false);
				result = pstmt.executeQuery();
			}else{
				System.out.println("Connection failed");
			}
		}catch(SQLException e){
			System.out.println("SQLException is raised in getAllTags");
		}
		return result;
	}
	
	public int manageTagQuery(String command, int pid, String username) throws SQLException{
		// update the tag status of the user as the tagee
		// depending on the command (update, delete, undecided)
		// choose the right version of the query and execute the command

		String query;
		if(command =="delete"){
			query ="delete from tag where where pid = ? and taggee = ?";
		}else if (command == "update"){
			query ="update tag set tstatus = 1 where pid = ? and taggee = ?";
		}else{
			query = "update tag set tstatus = 0 where pid = ?  and taggee = ?";
		}
		System.out.println(query);
		
		if(conn !=null){
			PreparedStatement pstmt = conn.prepareStatement(query);
			pstmt.setInt(1, pid);
			pstmt.setString(2, username);
			int a = pstmt.executeUpdate();
			// this part is where we actually have to implement such that our application
			// shows this message.
			return a;
			
		}else{
			System.out.println("connection failed");
		}
		return 0;
	}
	
	private int getMaxPid(){
		// get the maximum pid in order to create the next maximum pid when posting the photo.
		String query = "select max(pid) as max_pid from photo";
		try{
			if(conn!=null){
				Statement stmt = conn.createStatement();
				ResultSet result = stmt.executeQuery(query);
				int max_pid = -1;
				while(result.next()){
					max_pid = result.getInt(1);
				}

				return max_pid;
			}
		}catch(SQLException e){
			e.printStackTrace();
			System.out.println("The SQLException is raised in getMaxPid()");
		}
		return -1;
	}
	
	public int postPhotoQuery(String poster, String caption, String longitude, String latitude, 
			String addr, boolean is_public, byte[] image_byte) throws Exception{
		// insert the photo about the particular user
		// the poster will be the username
		String query = "insert into photo values (?, ?, ?, ?, ?, ?, ?, ?, ?)";
		// call the function that retrieves the max pid number
		int max_pid = getMaxPid();
		if(conn != null){
			PreparedStatement stmt = conn.prepareStatement(query);
			if(max_pid == -1) {
				System.out.println("the max number of pid is -1");
				return 0;
			}
			stmt.setInt(1, max_pid+1);
			stmt.setString(2, poster); // must be the username
			stmt.setString(3, caption); // from the user input
		
			Date today = new Date();
			Timestamp aTime = new Timestamp(today.getTime());
			stmt.setTimestamp(4, aTime);
			// longitude and latitude must be generated from address
			// we have to use the external library to automatically generate them
			
			stmt.setString(5, longitude);
			stmt.setString(6, latitude);
			stmt.setString(7, addr);
			// these can be set to null for now
			
			stmt.setBoolean(8,is_public); // from the user input
			Blob img = new SerialBlob(image_byte);
			stmt.setBlob(9, img);
			// this can be set to null too
		
			int a = stmt.executeUpdate();
			// this part is where we actually have to implement such that our application
			// shows this message.
			return a;
		}else{
			System.out.println("connection failed");
		}
		return 0;
		
	}
	

	public int tagPhotoQuery(int pid, String username, String taggee, boolean tstatus) {
		// the username will be the tagger
		String query = "insert into tag values(?, ?, ?, ?, ?)";
		try{
			if(conn!=null){
				// call the function getPhotoInfoQuery to retrieve all the photos visible to the user
				PreparedStatement pstmt = conn.prepareStatement(query);
				pstmt.setInt(1, pid);
				pstmt.setString(2, username);
				pstmt.setString(3, taggee);
				
				Date today = new Date();
				Timestamp aTime = new Timestamp(today.getTime());
				pstmt.setTimestamp(4, aTime); // get the current time to tag
				
				pstmt.setBoolean(5, tstatus);
				int success = pstmt.executeUpdate();
				return success;
			}
		}catch(SQLException e){
			e.printStackTrace();
			System.out.println("SQLException is raised in the tagPhotoQuery");
		}
		return 0;
	}
	

	public List<String> getUsernames(ResultSet people_found) throws SQLException {
		// users the ResultSet parameter to generate the list of usernames
		List<String> usernames = new ArrayList();
		while(people_found.next()){
			usernames.add(people_found.getString("username"));
		}
		return usernames;
	}
	
	public List<String> returnListOfFriends(String your_username, String groupname){
		// checks to see if the person whose username is as follows is inside the group
		// at first, retrieve the usernames in which your_username is associated with.
		List<String> friends_list = new ArrayList();
		try{
			String query_1 = "select distinct username from inGroup where ownername = ? and gname=?";
			if(conn != null){
				PreparedStatement pstmt_1 = conn.prepareStatement(query_1);
				pstmt_1.setString(1, your_username);
				pstmt_1.setString(2, groupname);
				ResultSet result = pstmt_1.executeQuery();
				while(result.next()){
					friends_list.add(result.getString("username"));
				}
			}
		}catch(SQLException e){
			System.out.println("SQLException is raised in returnListOfFriends function");
		}
		return friends_list;
	}
	

	public boolean checkWhetherInPersonTable(String fname, String lname){
		// returns true is the person with fname (first name) and lname (last name) is inside the person table
		// will be used in the case the person is not found when adding this guy as a friend
		String query = "select username from person where fname = ? and lname = ?";
		try{
			if(conn != null){
				PreparedStatement pstmt = conn.prepareStatement(query);
				pstmt.setString(1, fname);
				pstmt.setString(2, lname);
				ResultSet result = pstmt.executeQuery();
				return result.first();
			}
		}catch(SQLException e){
			System.out.println("SQLException raised in checkWhetherInPerson");
		}
		return false;
	}
	
	public int addFriendQuery(String ownername, String groupname, String friend_username) throws SQLException{
		// add a new friend to the user's friendGroup
		String query = "insert into inGroup values(?, ?, ?)";
		if(conn!=null){
			// selects the particular username you want to add
			PreparedStatement pstmt = conn.prepareStatement(query);
			pstmt.setString(1, ownername);
			pstmt.setString(2, groupname);
			pstmt.setString(3, friend_username);
			
			int a = pstmt.executeUpdate();
			if(a==1){
				System.out.println("successful");
			}else{
				System.out.println("not successful");
			}
			
			return a;
		}else{
			System.out.println("connection failed");
		}
		return 0;
	}
	
	
	public int defriendQuery(String ownername, String username_friend, String gname) throws SQLException{  
		// delete a friend from the group you are a part of
		// this function will work with returnListOfFriend and getGroupNameQuery
		// to retrieve the list of friends and lets the user select the person he wants to defriend
		
		// possible things to happen
		// comment that he posted on that group will be erased
		// 	1. retireve all the photos from that group (select pid from shared where gname = ?)
		// 	2. find the photo that this guy commented upon 
		// 		(select cid from commentOn 
		// 		where username = ? (the guy deleted) and pid in select pid from shared where gname = ?)
		//  3. delete from commentOn where cid = ?
		//  4. delete from comment where cid = ?
		// the tags of the photos he was in and from that group will be erased
		// 	1. retrieve the photo that this guy is in and from that group
		// 		select pid from shared natural join inGroup where username = ? and gname = ?
		//  2. delete the tags where tagee is the guy being defriended
		// 		delete * from tag where taggee = ? (the guy deleted ) and pid in 
		// 			select pid from shared natural join inGroup where username = ? and gname = ?
		
        String query = "delete from inGroup where ownername = ? and gname = ? and username = ?";
        if(conn!=null){
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setString(1, ownername);
            pstmt.setString(2, gname);
            pstmt.setString(3, username_friend);
            int a = pstmt.executeUpdate();
            if(a==1){
                System.out.println("successful");
            }else{
                System.out.println("not successful");
            }
            
            return a;
        }else{
            System.out.println("connection failed");
        }  
        return 0;
	}
	
	public int deleteTagQuery(String username_friend, String gname) throws SQLException{
		String query= "delete * from tag where taggee = ? and pid in "
				+ "(select pid from shared natural join inGroup where gname = ?)";
		if(conn!=null){
            PreparedStatement pstmt_tag = conn.prepareStatement(query);
            pstmt_tag.setString(1, username_friend);
            pstmt_tag.setString(2, gname);
            int a = pstmt_tag.executeUpdate();
            return a;
            
		}else{
            System.out.println("connection failed");
        }  
        return 0;
	}
	
	private String getCidsForDelete(String username_friend, String gname) throws SQLException{
		String query = "select cid from commentOn where "
				+ "username = ? and pid in (select pid from shared where gname = ?)";
		String cids = "";
		if(conn!=null){
            PreparedStatement pstmt_commentOn = conn.prepareStatement(query);
            pstmt_commentOn.setString(1, username_friend);
            pstmt_commentOn.setString(2, gname);
            ResultSet a = pstmt_commentOn.executeQuery();
            
            while(a.next()){
            	String cid = Integer.toString(a.getInt("cid"));
            	if(!a.isLast()){
            		cids += cid + ", ";
            	}else{
            		cids += cid;
            	}
           }
		}
        return cids;
	}
	
	public int deleteCommentQuery(String username_friend, String gname) throws SQLException{
		String cids = getCidsForDelete(username_friend, gname);
		if(!cids.equals("")){
			String query_2 = "delete from commentOn where cid in (" + cids + ")";
			String query_3 = "delete from comment where cid in (" + cids + ")";
			if(conn!=null){
	            PreparedStatement pstmt_commentOn = conn.prepareStatement(query_2);
	            int a = pstmt_commentOn.executeUpdate();
	            if(a==1){
	                PreparedStatement pstmt_comment = conn.prepareStatement(query_3);
	                int b = pstmt_comment.executeUpdate();
	                return b;
	            }else{
	            	return 0;
	            }
	            
			}else{
	            System.out.println("connection failed");
	        }  
		}
        return 0;
	}
	
	public String getFriendGroupQuery(String groupname, String ownername){
		// returns the name of the group and the owner's name
		// will be used to check the same group exists
		String query = "select gname, ownername from friendGroup where gname = ? and ownername = ?";
		String result = "";
		if(conn!=null){
			try{
				PreparedStatement pstmt = conn.prepareStatement(query);
				pstmt.setString(1, groupname);
				pstmt.setString(2, ownername);
				ResultSet rs = pstmt.executeQuery();
				while(rs.next()){
					String gname = rs.getString("gname");
					String owner = rs.getString("ownername");
					result = gname + "," + owner;
				}
			}catch(SQLException e){
				System.out.println("SQLException is raised in getFriendGroupQuery");
			}
		}
		return result;
	}
	
	public int createFriendGroup(String gname, String description, String ownername){
		// ownername should be the username 
		String query = "insert into friendGroup values(?, ?, ?)";
		if(conn!=null){
			try{
				PreparedStatement pstmt = conn.prepareStatement(query);
				pstmt.setString(1, gname);
				pstmt.setString(2, description);
				pstmt.setString(3, ownername);
				int a = pstmt.executeUpdate();
				return a;
			}catch(SQLException e){
				System.out.println("SQLException is raised in the createFriendGroup function");
			}
		}
		return 0;

	}
	
	public List<String> getGroupNameQuery(String username){
		// retrieve the list of groups the user is in
		// will be used in the selection of the group you want to add the friend to in AddFriend
		String query = "select distinct gname from InGroup where ownername = ? or username = ?"
				+ "union select distinct gname from friendGroup where ownername = ?";
		// in case there is a group that has no person (no data in the InGroup)
		// you also need to query such that that group is produced.
		List<String> listGroups = new ArrayList();
		if(conn!=null){
			try{
					PreparedStatement pstmt = conn.prepareStatement(query);
					pstmt.setString(1, username);
					pstmt.setString(2, username);
					pstmt.setString(3, username);
					ResultSet result = pstmt.executeQuery();
					while(result.next()){
						listGroups.add(result.getString("gname"));			
				}
			}catch(SQLException e){
				System.out.println("SQLException is raised in getGroupNameQuery");
			}
		}
		return listGroups;
	}
        
    public List<String> showFriends(String ownername, String groupname) throws SQLException{
    	// will display the list of friends whose owner is the user
    	// display by each group the user is the owner of
        String query = "select fname, lname from inGroup, person "
        		+ "where inGroup.username = person.username and ownername = ? and gname = ? "
        		+ "and inGroup.username != ?";
        List<String> listFriends = new ArrayList();
        if(conn!=null){
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setString(1, ownername);
            pstmt.setString(2, groupname);
            pstmt.setString(3, ownername);
            ResultSet result = pstmt.executeQuery();
            while(result.next()){
            	String first = result.getString("fname");
            	String last = result.getString("lname");
            	String name = first + " " + last;
            	listFriends.add(name);
	        }
	    }else{
	        System.out.println("connection failed");
	    }  
        return listFriends;
        
    }
    
    public List<Integer> countFriends(String username, String groupname) throws SQLException{
    	// counts the number of friends grouped by the group name
        String query = "select count(username) as num from inGroup where ownername = ?"
        		+ " and gname = ? and username != ?";
        List<Integer> counts = new ArrayList<Integer>();
        if(conn!=null){
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setString(1, username);
            pstmt.setString(2, groupname);
            pstmt.setString(3, username);
            ResultSet result = pstmt.executeQuery();
            while(result.next()){
            	counts.add(result.getInt("num"));
            }
	    }else{
	        System.out.println("connection failed");
	    }  
        return counts;
	}
    
}

