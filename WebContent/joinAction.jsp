<%@page import="java.io.PrintWriter"%>
<%@page import="user.UserDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="user" class="user.User" scope="page"/>
<jsp:setProperty name="user" property="*"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>JSP 게시판 웹 사이트</title>
</head>
<body>
	
	<%
		PrintWriter writer = response.getWriter();
		if (user.getId() == null || user.getPassword() == null || user.getName() == null ||
				user.getGender() == null || user.getEmail() == null) {
			writer.println("<script>");
			writer.println("alert('입력이 안 된 항목이 있습니다.')");
			writer.println("history.back()");
			writer.println("</script>");
		} else {
			UserDao dao = new UserDao();
			int result = dao.join(user);
			
			if (result == -1) {
				writer.println("<script>");
				writer.println("alert('이미 존재하는 아이디입니다.')");
				writer.println("history.back()");
				writer.println("</script>");
			}
			else {
				session.setAttribute("id", user.getId());
				writer.println("<script>");
				writer.println("location.href='main.jsp'");
				writer.println("</script>");
			}
		}
	%>
	
</body>
</html>