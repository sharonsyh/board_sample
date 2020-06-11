<%@page import="java.io.PrintWriter"%>
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
	
		if (session.getAttribute("id") != null)
			id = (String) session.getAttribute("id");
		
		if (id != null) {
			writer.println("<script>");
			writer.println("location.href='main.jsp'");
			writer.println("</script>");
		}
		
		id = request.getParameter("id");
		String pw = request.getParameter("pw");
		
		BbsDao dao = new BbsDao();
		int result = dao.login(id, pw);
		
		if (result == 1) {
			session.setAttribute("id", id);
			writer.println("<script>");
			writer.println("location.href='main.jsp'");
			writer.println("</script>");
		}
		else if (result == 0) {
			writer.println("<script>");
			writer.println("alert('비밀번호가 틀립니다.')");
			writer.println("history.back()");
			writer.println("</script>");
		}
		else if (result == -1) {
			writer.println("<script>");
			writer.println("alert('존재하지 않는 아이디입니다.')");
			writer.println("history.back()");
			writer.println("</script>");
		}
		else if (result == -2) {
			writer.println("<script>");
			writer.println("alert('데이터베이스 오류가 발생했습니다.')");
			writer.println("history.back()");
			writer.println("</script>");
		}
	%>

</body>
</html>