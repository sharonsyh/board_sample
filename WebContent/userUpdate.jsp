<%@page import="dao.BbsDao"%>
<%@page import="dto.UserDto"%>
<%@page import="java.io.PrintWriter"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width initial-scale=1">
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">

<title>JSP 게시판 웹 사이트</title>
</head>
<body>
	<%
		String id = null;
	
		if(session.getAttribute("id") != null)
			id = (String) session.getAttribute("id");
		
		if (id == null) {
			PrintWriter writer = response.getWriter();
			writer.println("<script>");
			writer.println("alert('로그인을 하세요.')");
			writer.println("location.href='login.jsp'");
			writer.println("</script>");
		}
		
		UserDto dto = new BbsDao().getUser(id);
	%>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
	
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
				<li><a href="bbs.jsp">게시판</a></li>
			</ul>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
					<a class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false" href="#">회원관리<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li class="active"><a href="userUpdate.jsp">회원정보 수정</a></li>
						<li><a href="login.jsp">로그아웃</a></li>
					</ul>
				</li>
			</ul>
		</div>
	</nav>
	
	<div class="container">
		<div class="col-lg-4"></div>
		<div class="col-lg-4">
			<div class="jumbotron" style="padding-top: 20px;">
				<form action="userUpdateAction.jsp" method="post">
					<h3 style="text-align: center;">회원정보 수정</h3>
					<div class="form-group">
						<input type="text" class="form-control" placeholder="아이디" name="id"  maxlength="20" value="<%= dto.getId() %>" readonly>
					</div>
					<div class="form-group">
						<input type="password" class="form-control" placeholder="비밀번호" name="pw"  maxlength="20">
					</div>
					<div class="form-group">
						<input type="text" class="form-control" placeholder="이름" name="name"  maxlength="20" value="<%= dto.getName() %>">
					</div>
					<div class="form-group" style="text-align: center">
						<div class="btn-group" data-toggle="buttons">
							<%
								if (dto.getGender().equals("남자")) {
							%>
							<label class="btn btn-primary active">
								<input type="radio" name="gender" autocomplete="off" value="남자" checked>남자
							</label>
							<label class="btn btn-primary">
								<input type="radio" name="gender" autocomplete="off" value="여자">여자
							</label>
							<%
								} else {
							%>
							<label class="btn btn-primary">
								<input type="radio" name="gender" autocomplete="off" value="남자">남자
							</label>
							<label class="btn btn-primary active">
								<input type="radio" name="gender" autocomplete="off" value="여자" checked>여자
							</label>
							<%
								}
							%>
						</div>
					</div>
					<div class="form-group">
						<input type="email" class="form-control" placeholder="이메일" name="email"  maxlength="50" value="<%= dto.getEmail() %>">
					</div>
					<input type="submit" class="btn btn-primary form-control" value="수정">
				</form>
			</div>
		</div>
		<div class="col-lg-4"></div>
	</div>
</body>
</html>