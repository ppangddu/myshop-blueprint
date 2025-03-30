<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ page import="pack.review.ReviewBean" %>
<%@ page import="pack.review.ReviewManager" %>

<% request.setCharacterEncoding("utf-8");

    ReviewBean bean = new ReviewBean();
    ReviewManager reviewManager = new ReviewManager();

    // 자동으로 채워지는 거 생성
    String title = request.getParameter("title");
    String directorName = request.getParameter("directorName");
    String cont = request.getParameter("cont");
    String releaseDate = request.getParameter("releaseDate");
    String imageUrl = request.getParameter("imageUrl");

    int newNum = reviewManager.currentMaxNum() + 1;

    bean.setNum(newNum);
    bean.setTitle(title);
    bean.setCont(cont);
    bean.setBip(request.getRemoteAddr());
    bean.setBdate();
    bean.setReadcnt(0);
    bean.setGnum(newNum);
    bean.setOnum(0);
    bean.setNested(0);
    bean.setImageUrl(imageUrl);
    bean.setRating(0);
    bean.setLikeCount(0);
    bean.setReleaseDate(releaseDate);
    bean.setDirectorName(directorName);

    reviewManager.saveData(bean);

    response.sendRedirect("reviewlist.jsp?page=1"); // 최신글은 1페이지에 있다, 추가 후 목록보기 (forwarding X)
%>

