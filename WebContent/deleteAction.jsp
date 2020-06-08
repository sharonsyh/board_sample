<%@page import="bbs.Bbs"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="bbs.BbsDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>JSP 게시판 웹 사이트</title>
</head>
<body>
	
	<%
		String id = null;
		PrintWriter writer = response.getWriter();
		
		if (session.getAttribute("id") != null)
			id = (String) session.getAttribute("id");
	
		if (id == null) {
			writer.println("<script>");
			writer.println("alert('로그인을 하세요.')");
			writer.println("location.href='login.jsp'");
			writer.println("</script>");
		} 
		
		int bbsId = 0;
		if (request.getParameter("bbsId") != null)
			bbsId = Integer.parseInt(request.getParameter("bbsId"));
		
		if (bbsId == 0) {
			writer.println("<script>");
			writer.println("alert('유효하지 않은 글입니다.')");
			writer.println("location.href='bbs.jsp'");
			writer.println("</script>");
		}
		
		Bbs bbs = new BbsDao().getBbs(bbsId);
		if (!id.equals(bbs.getUserId())) {
			writer.println("<script>");
			writer.println("alert('권한이 없습니다.')");
			writer.println("location.href='bbs.jsp'");
			writer.println("</script>");
		}
		
		else {
			BbsDao dao = new BbsDao();
			int result = dao.delete(bbsId);
			
			if (result == -1) {
				writer.println("<script>");
				writer.println("alert('글 삭제에 실패했습니다.')");
				writer.println("history.back()");
				writer.println("</script>");
			}
			else {
				writer.println("<script>");
				writer.println("location.href='bbs.jsp'");
				writer.println("</script>");
			}
		}	
	%>
	
</body>
</html>