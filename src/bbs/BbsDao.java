package bbs;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class BbsDao {

	private DataSource dataSource;
	
	public BbsDao() {
		try {
			Context context = new InitialContext();
			dataSource = (DataSource) context.lookup("java:comp/env/jdbc/Oracle11g");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public int write(String bbsTitle, String userId, String bbsContent) {
		
		Connection con = null;
		PreparedStatement pstmt = null;
		
		try {
			con = dataSource.getConnection();
			String query = "insert into bbs (bbsId, bbsTitle, userId, bbsContent, bbsAvailable) values (bbs_seq.nextval, ?, ?, ?, 1)";
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, bbsTitle);
			pstmt.setString(2, userId);
			pstmt.setString(3, bbsContent);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (pstmt != null) pstmt.close();
				if (con != null) con.close();
			} catch (Exception e2) {
				e2.printStackTrace();
			}
		}
		
		return -1;
	}
	
}
