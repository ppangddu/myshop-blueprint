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
    bean.setTitle(request.getParameter("title"));
    bean.setDirectorName(request.getParameter("directorName"));
    bean.setCont(request.getParameter("cont"));
    bean.setImageUrl(request.getParameter("imageUrl"));

    ReviewManager reviewManager = new ReviewManager();

    reviewManager.saveEdit(bean);
    response.sendRedirect("reviewlist.jsp?page=" + bpage); // 자료 수정 후 목록보기

%>
