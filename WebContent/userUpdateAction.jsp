<%@page import="java.io.PrintWriter"%>
<%@page import="dao.BbsDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="dto" class="dto.UserDto"/>
<jsp:setProperty name="dto" property="*" />

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
			writer.println("location.href='main.jsp'");
			writer.println("</script>");
		}
		
		if (dto.getPw() == null || dto.getName() == null ||
				dto.getGender() == null || dto.getEmail() == null) {
			writer.println("<script>");
			writer.println("alert('입력이 안 된 항목이 있습니다.')");
			writer.println("history.back()");
			writer.println("</script>");
		} else {
			BbsDao dao = new BbsDao();
			int result = dao.userUpdate(dto);
			
			if (result == -1) {
				writer.println("<script>");
				writer.println("alert('데이터 베이스 오류가 발생했습니다.')");
				writer.println("history.back()");
				writer.println("</script>");
			} else {
				writer.println("<script>");
				writer.println("location.href='main.jsp'");
				writer.println("</script>");
			}
		}
	%>

</body>
</html>