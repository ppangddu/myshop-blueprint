<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("utf-8"); %>
<%@page import="pack.review.ReviewManager" %>
<%@page import="pack.review.ReviewBean" %>

<%
    String bpage = request.getParameter("page");

    // Bean 객체 생성 및 값 세팅
    ReviewBean bean = new ReviewBean();
    bean.setNum(Integer.parseInt(request.getParameter("num")));
    bean.setName(request.getParameter("name"));
    bean.setPass(request.getParameter("pass"));
    bean.setMail(request.getParameter("mail"));
    bean.setTitle(request.getParameter("title"));
    bean.setCont(request.getParameter("cont"));

    ReviewManager reviewManager = new ReviewManager();
    // 비밀번호 비교 후 수정 여부 결정
    boolean b = reviewManager.checkPassword(bean.getNum(), bean.getPass()); // 비번 비교

    if (b) {
        reviewManager.saveEdit(bean);
        response.sendRedirect("reviewlist.jsp?page=" + bpage); // 자료 수정 후 목록보기
    } else {
%>
<script>
    alert("비밀번호 불일치");
    history.back(); // 이전 페이지로 돌아간다.
</script>
<%
    }

%>