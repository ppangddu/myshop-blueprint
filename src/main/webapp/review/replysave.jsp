<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<% request.setCharacterEncoding("utf-8"); %>
<%@page import="pack.review.ReviewBean" %>
<%@page import="pack.review.ReviewManager" %>
<%@page import="pack.review.ReviewDto" %>
<%@page import="jakarta.servlet.http.Cookie" %>
<%@page import="pack.cookie.CookieManager" %>

<%
  String bpage = request.getParameter("page");

  ReviewBean bean = new ReviewBean();
  ReviewManager reviewManager = new ReviewManager();

  int movieId = Integer.parseInt(request.getParameter("movieId"));
  boolean isReply = (request.getParameter("num") != null);
  int parentOnum = Integer.parseInt(request.getParameter("onum"));
  int parentNested = Integer.parseInt(request.getParameter("nested"));

  if (isReply) {
    // 대댓글: 부모 onum 유지, nested +1 → 최대 2까지만
    int newNested = parentNested >= 2 ? 2 : parentNested + 1;
    bean.setOnum(parentOnum);
    bean.setNested(newNested);
  } else {
    // 원댓글
    bean.setOnum(0);  // 저장 후 자기 num으로 update
    bean.setNested(1);
  }

  bean.setMovieId(movieId);
  bean.setCont(request.getParameter("cont"));
  bean.setUserId((String) session.getAttribute("user_id"));

  // 비속어 필터링
  String cont = bean.getCont();
  String[] badWords = {"ㅅㅂ", "tq"};
  for (String word : badWords) {
    if (cont != null && cont.contains(word)) {
      out.println("<script>alert('금지된 단어가 포함되어 있습니다.'); history.back();</script>");
      return;
    }
  }

  // 별점 (원댓글일 때만)
  int rating = 0;
  if (!isReply) {
    try {
      rating = Integer.parseInt(request.getParameter("rating"));
    } catch (Exception e) { rating = 0; }
  }
  bean.setRating(rating);

  // 저장 후 num 받아오기
  int insertedNum = reviewManager.saveReplyData(bean);

  // onum 갱신 (원댓글일 경우)
  if (!isReply) {
    reviewManager.updateReviewOnum(insertedNum, insertedNum);
  }

  // 쿠키 삭제
  CookieManager cm = CookieManager.getInstance();
  String contName = isReply ? "cont_reply" : "cont_review";
  String ratingName = isReply ? "rating_reply" : "rating_review";

  response.addCookie(cm.deleteCookie(contName));
  response.addCookie(cm.deleteCookie(ratingName));

  response.sendRedirect("reviewcontent.jsp?movieId=" + movieId + "&page=" + bpage);
%>
