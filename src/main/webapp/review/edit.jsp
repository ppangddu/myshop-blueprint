<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ page import="pack.movie.MovieDto" %>
<%@ page import="pack.movie.MovieManager" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
  request.setCharacterEncoding("UTF-8");

  int id = Integer.parseInt(request.getParameter("id"));
  String bpage = request.getParameter("page");


  MovieManager movieManager = new MovieManager();
  MovieDto movie = movieManager.getMovie(id); // 이 줄 추가

  request.setAttribute("bpage", bpage);
  request.setAttribute("movie", movie);
  request.setAttribute("id", id);
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
      } else if (frm.genre.value === "") {
        frm.genre.focus();
        alert("장르를 입력하세요.");
      } else if (frm.actorName.value === "") {
        frm.actorName.focus();
        alert("출연란을 입력하세요.");
      } else if (frm.description.value === "") {
        frm.description.focus();
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
  <input type="hidden" name="id" value="${movie.id}">
  <input type="hidden" name="page" value="${bpage}">
  <table border="1">
    <tr>
      <td>영화제목</td>
      <td>
        <input type="text" name="title" style="width: 98%" value="${movie.title}">
      </td>
    </tr>
    <tr>
      <td>장르</td>
      <td>
        <input type="text" name="genre" style="width: 98%" value="${movie.genre}">
      </td>
    </tr>
    <tr>
      <td>출연</td>
      <td>
        <input type="text" name="actorName" style="width: 98%" value="${movie.actorName}">
      </td>
    </tr><tr>
    <td>개봉일</td>
    <td>
      <input type="text" name="releaseDate" style="width: 98%" value="${movie.releaseDate}">
    </td>
  </tr>
      <td>내용</td>
      <td>
        <textarea rows="10" name="description" style="width: 98%">${movie.description}</textarea>
      </td>
    </tr>
    <tr>
      <td>이미지url</td>
      <td>
        <input type="text" name="imageUrl" style="width: 98%" value="${movie.imageUrl}">
      </td>
    </tr>
    <tr>
      <td colspan="2" style="text-align: center; height: 50">
        <input type="button" value="수정완료" onclick="check()">&nbsp;
        <input type="button" value="목록보기" onclick="location.href='movielist.jsp?page=${bpage}'">&nbsp;
      </td>
    </tr>
  </table>
</form>
</body>
</html>