<%@page import="java.io.PrintWriter"%>
<%@page import="bbs.BbsDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="bbs" class="bbs.Bbs" scope="page"/>
<jsp:setProperty name="bbs" property="bbsTitle"/>
<jsp:setProperty name="bbs" property="bbsContent"/>
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
		} else {
			if (bbs.getBbsTitle() == null || bbs.getBbsContent() == null) {
				writer.println("<script>");
				writer.println("alert('입력이 안 된 항목이 있습니다.')");
				writer.println("history.back()");
				writer.println("</script>");
			} else {
				BbsDao dao = new BbsDao();
				int result = dao.write(bbs.getBbsTitle(), id, bbs.getBbsContent());
				
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