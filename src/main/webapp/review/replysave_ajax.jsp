<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("utf-8"); %>
<jsp:useBean id="bean" class="pack.review.ReviewBean" />
<jsp:setProperty name="bean" property="*" />
<jsp:useBean id="reviewManager" class="pack.review.ReviewManager" />

<%
    int num = reviewManager.currentMaxNum() + 1;
    int gnum = Integer.parseInt(request.getParameter("gnum"));
    int onum = 1; // 댓글은 항상 1번부터 시작
    int nested = Integer.parseInt(request.getParameter("nested"));

    reviewManager.updateOnum(gnum, onum);

    bean.setNum(num);
    bean.setGnum(gnum);
    bean.setOnum(onum);
    bean.setNested(nested);
    bean.setBip(request.getRemoteAddr());
    bean.setBdate();

    reviewManager.saveReplyData(bean);

    // 응답은 단순 성공 메시지
    out.print("ok");
%>
