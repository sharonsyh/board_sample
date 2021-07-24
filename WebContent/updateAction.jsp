<%@page import="dao.BbsDao"%>
<%@page import="dto.BbsDto"%>
<%@page import="java.io.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>JSP 게시판 웹 사이트</title>
</head>
<body>
	
	<%
		request.setCharacterEncoding("UTF-8");
	
		String id = null;
		PrintWriter writer = response.getWriter();
		
		String bTitle = request.getParameter("bTitle");
		String bContent = request.getParameter("bContent");
		
		if (session.getAttribute("id") != null)
			id = (String) session.getAttribute("id");
	
		if (id == null) {
			writer.println("<script>");
			writer.println("alert('로그인을 하세요.')");
			writer.println("location.href='login.jsp'");
			writer.println("</script>");
		} 
		
		int bId = 0;
		if (request.getParameter("bId") != null)
			bId = Integer.parseInt(request.getParameter("bId"));
		
		if (bId == 0) {
			writer.println("<script>");
			writer.println("alert('유효하지 않은 글입니다.')");
			writer.println("location.href='bbs.jsp'");
			writer.println("</script>");
		}
		
		BbsDto dto = new BbsDao().getContent(bId, false);
		if (!id.equals(dto.getuserId())) {
			writer.println("<script>");
			writer.println("alert('권한이 없습니다.')");
			writer.println("location.href='bbs.jsp'");
			writer.println("</script>");
		} else {
			if (bTitle == null || bContent == null) {
				writer.println("<script>");
				writer.println("alert('입력이 안 된 항목이 있습니다.')");
				writer.println("history.back()");
				writer.println("</script>");
			} else {
				BbsDao dao = new BbsDao();
				int result = dao.update(bId, bTitle, bContent);
				
				if (result == -1) {
					writer.println("<script>");
					writer.println("alert('글 수정에 실패했습니다.')");
					writer.println("history.back()");
					writer.println("</script>");
				}
				else {
					writer.println("<script>");
					writer.println("location.href='bbs.jsp'");
					writer.println("</script>");
				}
			}	
		}
	%>
	
</body>
</html>