<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
  String id = request.getParameter("id");
  String bpage = request.getParameter("page");

  request.setAttribute("id", id);
  request.setAttribute("bpage", bpage);
%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>글 삭제</title>
  <link rel="stylesheet" type="text/css" href="../css/board.css">
  <script>
    function confirmDelete() {
      if (confirm("정말 삭제하시겠습니까?")) {
        location.href = "deleteok.jsp?id=${id}&page=${bpage}";
      }
    }
  </script>
</head>
<body>
<h2>글 삭제</h2>

<p>정말 삭제하시겠습니까?</p>
<input type="button" value="삭제확인" onclick="confirmDelete()">
<input type="button" value="취소" onclick="history.back()">

</body>
</html>
