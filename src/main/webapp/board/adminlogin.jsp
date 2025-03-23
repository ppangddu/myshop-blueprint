<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Insert title here</title>
</head>
<body>
<%
    String id = request.getParameter("id");
    String pwd = request.getParameter("pwd");


    if(id.equals("admin") && pwd.equals("123")) {
        session.setAttribute("adminOk", id); // 세션 생성
        out.println("로그인 성공<br>");
    } else {
        out.println("로그인 실패<br>");
    }
%>

<a href="javascript:window.close()">창 닫기</a>
</body>
</html>