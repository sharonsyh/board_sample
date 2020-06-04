<%@page import="java.io.PrintWriter"%>
<%@page import="user.UserDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="user" class="user.User" scope="page"/>
<jsp:setProperty name="user" property="id"/>
<jsp:setProperty name="user" property="password"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>JSP 게시판 웹 사이트</title>
</head>
<body>
	
	<%
		UserDao dao = new UserDao();
		PrintWriter writer = response.getWriter();
		int result = dao.login(user.getId(), user.getPassword());
		
		if (result == 1) {
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