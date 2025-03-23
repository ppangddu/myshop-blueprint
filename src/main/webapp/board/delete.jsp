<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>

<%
  String num = request.getParameter("num");
  String bpage = request.getParameter("page");
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>게시판</title>
  <link rel="stylesheet" type="text/css" href="../css/board.css">
  <script type="text/javascript">
    function check() {
      if (frm.pass.val === "") {
        frm.pass.focus();
        alert("비밀번호 입력");
        return;
      }
      if(confirm("절말 삭제할까요?")) {
        frm.submit();
      }
    }
  </script>
</head>
<body>
<h2>글 삭제</h2>
<form action="deleteok.jsp" name="frm" method="get">

  <input type="hidden" name="num" value="<%=num %>">
  <input type="hidden" name="page" value="<%=bpage %>">

  비밀번호 : <input type="text" name="pass">
  <input type="button" onclick="check()" value="삭제확인">
  <input type="button" value="목록보기" onclick="location.href='boardlist.jsp?page=<%=bpage %>'">
</form>
</body>
</html>