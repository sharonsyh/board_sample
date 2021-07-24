<%@page import="dao.BbsDao"%>
<%@page import="dto.BbsDto"%>
<%@page import="java.io.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width initial-scale=1">	<!-- 반응형 웹에 사용 -->
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">

<title>JSP 게시판 웹 사이트</title>
</head>
<body>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
	
	<%
		String id = null;
		if (session.getAttribute("id") != null)
			id = (String) session.getAttribute("id");
		
		PrintWriter writer = response.getWriter();
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
		}
	%>
	
	<nav class="navbar navbar-default">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
			</button>
			<a class="navbar-brand" href="main.jsp">JSP 게시판 웹 사이트</a>
		</div>
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li><a href="main.jsp">메인</a></li>
				<li class="active"><a href="bbs.jsp">게시판</a></li>
			</ul>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
					<a class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false" href="#">회원관리<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="userUpdate.jsp">회원정보 수정</a></li>
						<li><a href="logoutAction.jsp">로그아웃</a></li>
					</ul>
				</li>
			</ul>
		</div>
	</nav>
	
	<div class="container">
		<div class="row">
			<form action="updateAction.jsp?bId=<%= bId %>" method="post">
				<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
					<thead>
						<tr>
							<th colspan="2" style="background-color: #eeeeee; text-align: center;">게시판 글 수정 양식</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td><input type="text" class="form-control" placeholder="글 제목" name="bTitle" maxlength="50" value="<%= dto.getbTitle() %>"></td>
						</tr>
						<tr>
							<td><textarea class="form-control" placeholder="글 내용" name="bContent" maxlength="2048" style="height:350px;"><%= dto.getbContent() %></textarea></td>
						</tr>
					</tbody>
				</table>
				<a href="bbs.jsp" class="btn btn-primary">목록</a>
				<input type="submit" class="btn btn-primary pull-right" value="수정">
			</form>
		</div>
	</div>
</body>
</html>