<%@page import="java.io.*"%>
<%@page import="dao.BbsDao"%>
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
		} else {
			if (bTitle == null || bTitle == null) {
				writer.println("<script>");
				writer.println("alert('입력이 안 된 항목이 있습니다.')");
				writer.println("history.back()");
				writer.println("</script>");
			} else {
				BbsDao dao = new BbsDao();
				int result = dao.write(bTitle, id, bContent);
				
				if (result == -1) {
					writer.println("<script>");
					writer.println("alert('글쓰기에 실패했습니다.')");
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