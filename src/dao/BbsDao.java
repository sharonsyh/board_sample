package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import dto.BbsDto;
import dto.UserDto;

public class BbsDao {

	private DataSource ds;
	
	public BbsDao() {
		try {
			Context context = new InitialContext();
			ds = (DataSource) context.lookup("java:comp/env/jdbc/Oracle11g");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	
	public int existId(String id) {
		
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			con = ds.getConnection();
			String query = "select id from bbs_user where id = ?";
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			
			if (rs.next())
				return 1;	// 아이디 존재
			else
				return 0;	// 아이디 부재
			
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
		
		return -1;	// db 오류
	}
	
	public int join(UserDto dto) {
		
		Connection con = null;
		PreparedStatement pstmt = null;
		
		try {
			con = ds.getConnection();
			String query = "insert into bbs_user values (?, ?, ?, ?, ?)";
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, dto.getId());
			pstmt.setString(2, dto.getPw());
			pstmt.setString(3, dto.getName());
			pstmt.setString(4, dto.getGender());
			pstmt.setString(5, dto.getEmail());
			
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
		
		return -1;	// db 오류
	}
	
	public int login(String id, String pw) {
		
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			con = ds.getConnection();
			String query = "select pw from bbs_user where id = ?";
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			
			if (rs.next()) {
				if (rs.getString(1).equals(pw))
					return 1;	// 성공
				else
					return 0;	// 비밀번호 틀림
			} else {
				return -1;		// 아이디가 존재하지 않음
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
		
		return -2;	// db 오류
	}
	
	public UserDto getUser(String id) {
		
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			con = ds.getConnection();
			String query = "select * from bbs_user where id = ?";
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			
			if (rs.next()) {
				UserDto dto = new UserDto();
				dto.setId(rs.getString(1));
				dto.setPw(rs.getString(2));
				dto.setName(rs.getString(3));
				dto.setGender(rs.getString(4));
				dto.setEmail(rs.getString(5));
				
				return dto;
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
		
		return null;
	}
	
	public int userUpdate(UserDto dto) {
		
		Connection con = null;
		PreparedStatement pstmt = null;
		
		try {
			con = ds.getConnection();
			String query = "update bbs_user set pw = ?, name = ?, gender = ?, email = ? where id = ?";
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, dto.getPw());
			pstmt.setString(2, dto.getName());
			pstmt.setString(3, dto.getGender());
			pstmt.setString(4, dto.getEmail());
			pstmt.setString(5, dto.getId());
						
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
		
		return -1;	// db 오류
	}
	
	public ArrayList<BbsDto> list(int pageNumber) {
		
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<BbsDto> dtos = new ArrayList<BbsDto>();
		
		try {
			con = ds.getConnection();
			String query = "select * from (select * from bbs where bId < ? order by bId desc) where rownum <= 10";
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, getNextBbsId() - (pageNumber - 1) * 10);
			rs = pstmt.executeQuery();
			
			while (rs.next()) {
				BbsDto dto = new BbsDto();
				dto.setbId(rs.getInt(1));
				dto.setbTitle(rs.getString(2));
				dto.setuserId(rs.getString(3));
				dto.setbContent(rs.getString(4));
				dto.setbDate(rs.getTimestamp(5));
				dto.setbHit(rs.getInt(6));
				
				dtos.add(dto);
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
		
		return dtos;
	}
	
	public boolean nextPage(int pageNumber) {
		
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			con = ds.getConnection();
			String query = "select * from bbs where bId < ?";
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
	
	public int write(String bTitle, String id, String bContent) {
		
		Connection con = null;
		PreparedStatement pstmt = null;
		
		try {
			con = ds.getConnection();
			String query = "insert into bbs (bId, bTitle, userId, bContent, bHit) values (?, ?, ?, ?, ?)";
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, getNextBbsId());
			pstmt.setString(2, bTitle);
			pstmt.setString(3, id);
			pstmt.setString(4, bContent);
			pstmt.setInt(5, 0);
						
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
		
		return -1;	// db 오류
	}
	
	public BbsDto getContent(int bId, boolean view) {
		
		if (view == true)	// 게시글 클릭 했을 경우
			upHit(bId);
		
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			con = ds.getConnection();
			String query = "select * from bbs where bId = ?";
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, bId);
			rs = pstmt.executeQuery();
			
			if (rs.next()) {
				BbsDto dto = new BbsDto();
				dto.setbId(rs.getInt(1));
				dto.setbTitle(rs.getString(2));
				dto.setuserId(rs.getString(3));
				dto.setbContent(rs.getString(4));
				dto.setbDate(rs.getTimestamp(5));
				dto.setbHit(rs.getInt(6));
				
				return dto;
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
		
		return null;
	}
	
	public int update(int bId, String bTitle, String bContent) {
		
		Connection con = null;
		PreparedStatement pstmt = null;
		
		try {
			con = ds.getConnection();
			String query = "update bbs set bTitle = ?, bContent = ? where bId = ?";
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, bTitle);
			pstmt.setString(2, bContent);
			pstmt.setInt(3, bId);
						
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
		
		return -1;	// db 오류
	}
	
	public int delete(int bId) {
		
		Connection con = null;
		PreparedStatement pstmt = null;
		
		try {
			con = ds.getConnection();
			String query = "delete from bbs where bId = ?";
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, bId);
						
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
		
		return -1;	// db 오류
	}
	
	public int getNextBbsId() {
		
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			con = ds.getConnection();
			String query = "select bId from bbs order by bId desc";
			pstmt = con.prepareStatement(query);	
			rs = pstmt.executeQuery();
			
			if (rs.next())
				return rs.getInt(1) + 1;
			else
				return 1;	// 첫 글일 경우
			
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
		
		return -1;	// db 오류
	}
	
	public void upHit(int bId) {
		
		Connection con = null;
		PreparedStatement pstmt = null;
		
		try {
			con = ds.getConnection();
			String query = "update bbs set bHit = bHit + 1 where bId = ?";
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, bId);
			pstmt.executeUpdate();
			
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
	}
}
