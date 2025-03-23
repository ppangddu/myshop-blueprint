<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("utf-8"); %>

<jsp:useBean id="bean" class="pack.board.BoardBean" />
<jsp:setProperty property="*" name="bean" /> <!-- num도 같이 들어옴 -->
<jsp:useBean id="boardManager" class="pack.board.BoardManager" />

<%
    String bpage = request.getParameter("page");
// num은 FormBean을 타고 이미 저장됨

// 비밀번호 비교 후 수정 여부 결정
    boolean b = boardManager.checkPassword(bean.getNum(), bean.getPass()); // 비번 비교

    if (b) {
        boardManager.saveEdit(bean);
        response.sendRedirect("boardlist.jsp?page=" + bpage); // 자료 수정 후 목록보기
    } else {
%>
<script>
    alert("비밀번호 불일치");
    history.back(); // 이전 페이지로 돌아간다.
</script>
<%
    }

%>