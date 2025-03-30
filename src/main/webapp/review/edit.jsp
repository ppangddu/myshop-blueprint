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
  <title>영화 등록 수정</title>
  <link rel="stylesheet" type="text/css" href="../css/board.css">
  <script type="text/javascript">

    function check() {
      const frm = document.forms["frm"];
      if (frm.title.value === "") {
        frm.title.focus();
        alert("영화 제목을 입력하세요.");
      } else if (frm.directorName.value === "") {
        frm.directorName.focus();
        alert("감독 이름을 입력하세요.");
      } else if (frm.cont.value === "") {
        frm.cont.focus();
        alert("내용을 입력하세요.");
      } else if (frm.imageUrl.value === "") {
        frm.imageUrl.focus();
        alert("이미지 url을 입력하세요.");
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
      <td>영화제목</td>
      <td>
        <input type="text" name="title" style="width: 98%" value="${dto.title}">
      </td>
    </tr>
    <tr>
      <td>감독</td>
      <td>
        <input type="text" name="directorName" style="width: 98%" value="${dto.directorName}">
      </td>
    </tr>
      <td>내용</td>
      <td>
        <textarea rows="10" name="cont" style="width: 98%">${dto.cont}</textarea>
      </td>
    </tr>
    <tr>
      <td>이미지url</td>
      <td>
        <input type="text" name="imageUrl" style="width: 98%" value="${dto.imageUrl}">
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