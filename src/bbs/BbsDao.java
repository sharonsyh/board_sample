package bbs;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

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
	
	public ArrayList<Bbs> getList(int pageNumber) {
		
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<Bbs> list = new ArrayList<Bbs>();
		
		try {
			con = dataSource.getConnection();
			String query = "select * from (select * from bbs where bbsId < ? and bbsAvailable = 1 order by bbsId desc) where rownum <= 10";
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, getNextBbsId() - (pageNumber - 1) * 10);
			rs = pstmt.executeQuery();
			
			while (rs.next()) {
				Bbs bbs = new Bbs();
				bbs.setBbsId(rs.getInt(1));
				bbs.setBbsTitle(rs.getString(2));
				bbs.setUserId(rs.getString(3));
				bbs.setBbsDate(rs.getTimestamp(4));
				bbs.setBbsContent(rs.getString(5));
				bbs.setBbsAvailable(rs.getInt(6));
				
				list.add(bbs);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (rs != null) rs.close();
				if (pstmt != null) pstmt.close();
				if (con != null) con.close();
			} catch (Exception e2) {
				e2.printStackTrace();
			}
		}
		
		return list;
	}
	
	public boolean nextPage(int pageNumber) {
		
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			con = dataSource.getConnection();
			String query = "select * from bbs where bbsId < ? and bbsAvailable = 1";
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, getNextBbsId() - (pageNumber - 1) * 10);
			rs = pstmt.executeQuery();
			
			if (rs.next())
				return true;
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (rs != null) rs.close();
				if (pstmt != null) pstmt.close();
				if (con != null) con.close();
			} catch (Exception e2) {
				e2.printStackTrace();
			}
		}
		
		return false;
	}
	
	public int getNextBbsId() {
		
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			con = dataSource.getConnection();
			String query = "select bbsId from bbs order by bbsId desc";
			pstmt = con.prepareStatement(query);
			rs = pstmt.executeQuery();
			
			if (rs.next())
				return rs.getInt(1) + 1;
			
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
