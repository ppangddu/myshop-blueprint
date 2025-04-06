<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String id = request.getParameter("id");
    String pwd = request.getParameter("pwd");

    boolean loginSuccess = false;

    // JSTL에서는 sessionScope 접근은 가능하지만, setAttribute(세션 생성)는 꼭
    // 자바 코드로 해야 한다.

    if ("admin".equals(id) && "123".equals(pwd)) {
        session.setAttribute("admin", id); // 세션 저장
        loginSuccess = true;
    }
    request.setAttribute("loginSuccess", loginSuccess);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>로그인 결과</title>
</head>
<body>

<c:choose>
    <c:when test="${loginSuccess}"> <!-- test 속성은 "조건"을 의미함 -->
        로그인 성공<br>
    </c:when>
    <c:otherwise>
        로그인 실패<br>
    </c:otherwise>
</c:choose>

<a href="javascript:window.close()">창 닫기</a>
</body>
</html>