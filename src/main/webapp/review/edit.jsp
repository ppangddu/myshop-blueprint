<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ page import="pack.review.ReviewManager" %>
<%@ page import="pack.review.ReviewDto" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
  request.setCharacterEncoding("UTF-8");

  String num = request.getParameter("num");
  String bpage = request.getParameter("page");

  ReviewManager reviewManager = new ReviewManager();
  ReviewDto dto = reviewManager.getData(num);

  request.setAttribute("dto", dto);
  request.setAttribute("bpage", bpage);
  request.setAttribute("num", num);
%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>게시판</title>
  <link rel="stylesheet" type="text/css" href="../css/board.css">
  <script type="text/javascript">

    function check() {
      if (frm.pass.value === "") {
        frm.pass.focus();
        alert("비밀번호를 입력하세요.");
        return;
      }

      if(confirm("정말 수정할까요?")) {
        frm.submit();
      }
    }

  </script>
</head>
<body>
<h2 style = "text-align: center;">글 수정</h2>
<form action="editsave.jsp" name="frm" method="post">
  <input type="hidden" name="num" value="${num}">	<!-- 두 개 들고 가야 함 -->
  <input type="hidden" name="page" value="${bpage}">
  <table border="1">
    <tr>
      <td>이름</td>
      <td>
        <input type="text" name="name" style="width: 98%" value="${dto.name}">
      </td>
    </tr>
    <tr>
      <td>비밀번호</td>
      <td>
        <input type="password" name="pass" style="width: 98%">
      </td>
    </tr>
    <tr>
      <td>이메일</td>
      <td>
        <input type="email" name="mail" style="width: 98%" value="${dto.mail}">
      </td>
    </tr>
    <tr>
      <td>글제목</td>
      <td>
        <input type="text" name="title" style="width: 98%" value="${dto.title}">
      </td>
    </tr>
    <tr>
      <td>글내용</td>
      <td>
        <textarea rows="10" name="cont" style="width: 98%">${dto.cont}}</textarea>

      </td>
    </tr>
    <tr>
      <td colspan="2" style="text-align: center; height: 50">
        <input type="button" value="수정완료" onclick="check()">&nbsp;
        <input type="button" value="목록보기" onclick="location.href='reviewlist.jsp?page=${bpage}'">&nbsp;
      </td>
    </tr>
  </table>
</form>
</body>
</html>