<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("utf-8"); %>
<jsp:useBean id="bean" class="pack.board.BoardBean" />
<jsp:setProperty name="bean" property="*" />
<jsp:useBean id="boardManager" class="pack.board.BoardManager" />

<%
    int num = boardManager.currentMaxNum() + 1;
    int gnum = Integer.parseInt(request.getParameter("gnum"));
    int onum = 1; // 댓글은 항상 1번부터 시작
    int nested = Integer.parseInt(request.getParameter("nested"));

    boardManager.updateOnum(gnum, onum);

    bean.setNum(num);
    bean.setGnum(gnum);
    bean.setOnum(onum);
    bean.setNested(nested);
    bean.setBip(request.getRemoteAddr());
    bean.setBdate();

    boardManager.saveReplyData(bean);

    // 응답은 단순 성공 메시지
    out.print("ok");
%>
