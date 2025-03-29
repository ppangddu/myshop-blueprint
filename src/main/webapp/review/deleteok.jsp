<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="pack.review.ReviewManager" %>

<%
    String num = request.getParameter("num");
    String bpage = request.getParameter("page");
    String pass = request.getParameter("pass");

    ReviewManager reviewManager = new ReviewManager();

    String adminOk = (String) session.getAttribute("adminOk");
    boolean isAdmin = "admin".equals(adminOk);

    boolean isVaild = isAdmin || reviewManager.checkPassword(Integer.parseInt(num), pass);

    request.setAttribute("isValid", isVaild);
    request.setAttribute("num", num);
    request.setAttribute("bpage", bpage);
%>

<c:choose>
    <c:when test="${isValid}">
        <%
            reviewManager.delData(num);
            response.sendRedirect("reviewlist.jsp?page=" + bpage);
        %>
    </c:when>
    <c:otherwise>
        <script>
            alert("비밀번호 불일치");
            history.back();
        </script>
    </c:otherwise>
</c:choose>