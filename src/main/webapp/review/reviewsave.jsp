<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("utf-8"); %>

<jsp:useBean id="bean" class="pack.review.ReviewBean" />
<jsp:setProperty property="*" name="bean" />
<jsp:useBean id="boardManager" class="pack.review.ReviewManager" />

<%
    String imageUrl = request.getParameter("imageUrl");

    // 자동으로 채워지는 거 생성
    int newNum = boardManager.currentMaxNum() + 1;
    bean.setNum(newNum);
    bean.setBip(request.getRemoteAddr()); // 글을 입력한 사람의 주소를 받을 수 있음
    bean.setBdate();
    bean.setGnum(newNum); // 원글인 경우 newNum을 setGnum에게 준다.
    bean.setImageUrl(imageUrl);

    boardManager.saveData(bean);

    response.sendRedirect("reviewlist.jsp?page=1"); // 최신글은 1페이지에 있다, 추가 후 목록보기 (forwarding X)
%>

