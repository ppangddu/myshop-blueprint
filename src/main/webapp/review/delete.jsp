<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
  String num = request.getParameter("num");
  String bpage = request.getParameter("page");
  String adminOk = (String) session.getAttribute("adminOk");
  boolean isAdmin = "admin".equals(adminOk);

  request.setAttribute("num", num);
  request.setAttribute("bpage", bpage);
  request.setAttribute("isAdmin", isAdmin);
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>글 삭제</title>
  <link rel="stylesheet" type="text/css" href="../css/board.css">
  <script type="text/javascript">
    function check() {
      const isAdmin = "${isAdmin}" === "true";
      if (!isAdmin) {
        const passField = document.frm.pass;
        if (passField.value.trim() === "") {
          alert("비밀번호를 입력하세요.");
          passField.focus();
          return;
        }
      }
      if (confirm("정말 삭제할까요?")) {
        document.frm.submit();
      }
    }
  </script>
</head>
<body>
<h2>글 삭제</h2>

<form action="deleteok.jsp" name="frm" method="get">
  <input type="hidden" name="num" value="${num}">
  <input type="hidden" name="page" value="${bpage}">

  <c:choose>
    <c:when test="${isAdmin}">
      <p style="color: red;">관리자 권한으로 삭제됩니다.</p>
      <input type="hidden" name="pass" value="adminpass" />
    </c:when>
    <c:otherwise>
      비밀번호 : <input type="text" name="pass">
    </c:otherwise>
  </c:choose>

  <br><br>
  <input type="button" onclick="check()" value="삭제확인">
  <input type="button" value="목록보기" onclick="location.href='reviewlist.jsp?page=<%=bpage %>'">
</form>
</body>
</html>
