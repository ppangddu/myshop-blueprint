<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("utf-8"); %>
<%@page import="pack.review.ReviewBean" %>
<%@page import="pack.review.ReviewManager" %>
<%@page import="jakarta.servlet.http.Cookie" %>
<%@page import="pack.cookie.CookieManager" %>

<%
  String bpage = request.getParameter("page"); // 페이지는 따로 받는다

  ReviewBean bean = new ReviewBean();
  ReviewManager reviewManager = new ReviewManager();

  // 기존 데이터 계산
  int gnum = Integer.parseInt(request.getParameter("gnum"));
  int onum = Integer.parseInt(request.getParameter("onum")) + 1;
  int nested = Integer.parseInt(request.getParameter("nested")) + 1;

  reviewManager.updateOnum(gnum, onum); // 같은 그룹에서 onum 밀기

  // 새 댓글 설정
  bean.setGnum(gnum);
  bean.setOnum(onum);
  bean.setNested(nested);
  bean.setBip(request.getRemoteAddr());
  bean.setBdate();
  bean.setNum(reviewManager.currentMaxNum() + 1);

  String name = request.getParameter("name");
  String pass = request.getParameter("pass");
  String mail = request.getParameter("mail");
  String title = request.getParameter("title");
  String cont = request.getParameter("cont");

  bean.setName(request.getParameter("name"));
  bean.setPass(request.getParameter("pass"));
  bean.setMail(request.getParameter("mail"));
  bean.setTitle(request.getParameter("title"));
  bean.setCont(request.getParameter("cont"));

  //비속어 필터링
  String[] badWords = {"프", "로", "젝", "트"};
  boolean hasBadWord = false;

  for(String word : badWords){
    if(cont != null && cont.contains(word)){
      hasBadWord = true;
      break;
    }
  }

  if(hasBadWord){
    out.println("<script>");
    out.println("alert('금지된 단어가 포함되어 있습니다.');");
    out.println("history.back();");
    out.println("</script>");
    return;
  }


  // 별점은 nested == 1일 때만 저장
  int rating = 0;
  if (nested == 1) {
    try {
      rating = Integer.parseInt(request.getParameter("rating"));
    } catch (Exception e) {
      rating = 0;
    }
  }
  bean.setRating(rating);

  // 저장
  reviewManager.saveReplyData(bean);

  //쿠키 삭제
  CookieManager cm = CookieManager.getInstance();
  String[] cookieNames = {"name", "pass", "mail", "title", "cont", "rating"};
  for (String cname : cookieNames) {
    Cookie delete = cm.deleteCookie(cname);
    response.addCookie(delete);
    System.out.println("쿠키 삭제됨: " + cname);
  }

  // 원글로 리다이렉트
  response.sendRedirect("reviewcontent.jsp?num=" + bean.getGnum() + "&page=" + bpage);
%>
