<%@ page import="pack.review.ReviewDto" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="pack.review.ReviewManager" %>
<%@ page import="pack.movie.MovieDto" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
  response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
  response.setHeader("Pragma", "no-cache");
  response.setDateHeader("Expires", 0);

  int movieId = Integer.parseInt(request.getParameter("movieId"));
  String bpage = request.getParameter("page");

  ReviewManager reviewManager = new ReviewManager();

  MovieDto movie = reviewManager.getMovieById(movieId);
  ArrayList<ReviewDto> comments = reviewManager.getCommentsByMovieId(movieId);
  double avgRating = reviewManager.getAverageRating(movieId);

  request.setAttribute("movie", movie);
  request.setAttribute("comments", comments);
  request.setAttribute("avgRating", avgRating);
  request.setAttribute("bpage", bpage);
%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>${movie.title} - 상세 보기</title>
  <link rel="stylesheet" type="text/css" href="../css/board.css">
  <style>
    body {
      font-family: 'Arial', sans-serif;
      background: #f8f9fa;
      margin: 0;
      padding: 20px;
    }

    .movie-detail-container {
      max-width: 800px;
      margin: 0 auto;
      background: #fff;
      border-radius: 12px;
      padding: 20px;
      box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    }

    .movie-header {
      text-align: right;
      margin-bottom: 10px;
    }

    .movie-header a {
      margin-left: 10px;
    }

    .movie-title {
      background-color: #e0f7fa;
      padding: 10px;
      font-weight: bold;
      font-size: 1.3em;
      border-radius: 6px;
      margin-bottom: 15px;
    }

    .movie-info-wrapper {
      display: flex;
      justify-content: space-between;
      align-items: flex-start;
      gap: 30px;
      margin-bottom: 20px;
    }

    .movie-info {
      flex: 1;
      display: flex;
      flex-direction: column;
      gap: 10px;
    }

    .movie-image {
      flex-shrink: 0;
    }

    .movie-image img {
      width: 220px;
      height: auto;
      border-radius: 10px;
    }

    .movie-meta {
      color: #555;
      font-size: 1em;
    }

    .stars {
      color: gold;
      font-size: 1.1em;
      margin-left: 5px;
    }

    .movie-description {
      width: 100%;
      resize: none;
      border: none;
      background: transparent;
      padding: 0;
      font-size: 1em;
      font-family: inherit;
      line-height: 1.5;
    }

    .comment-box {
      margin-top: 30px;
    }

    .comment {
      border-bottom: 1px solid #ddd;
      padding: 10px;
      margin-left: 10px;
    }

    .comment .meta {
      font-size: 0.85em;
      color: gray;
      margin-top: 4px;
    }

    .comment .stars {
      color: gold;
      margin-bottom: 4px;
    }

    .likeBtn {
      padding: 3px 10px;
      font-size: 0.9em;
      background: #e0e0e0;
      border: none;
      border-radius: 4px;
      cursor: pointer;
    }

    .likeBtn:hover {
      background: #ccc;
    }
  </style>
</head>
<body>
<div class="movie-detail-container">
  <div class="movie-header">
    <a href="reply.jsp?movieId=${movie.id}&page=${bpage}">리뷰 쓰기</a>
    <a href="edit.jsp?id=${movie.id}&page=${bpage}">수정하기</a>
    <a href="delete.jsp?id=${movie.id}&page=${bpage}">삭제하기</a>
    <a href="movielist.jsp?page=${bpage}">목록 보기</a>
  </div>

  <div class="movie-title">제목 : ${movie.title}</div>

  <div class="movie-info-wrapper">
    <div class="movie-info">
      <div class="movie-meta">개봉일: ${movie.releaseDate}</div>
      <div class="movie-meta">장르: ${movie.genre}</div>
      <div class="movie-meta">출연: ${movie.actorName}</div>
      <div class="movie-meta">
        <strong>평균 별점:
          <fmt:formatNumber value="${avgRating}" pattern="0.0" /> / 5.0
        </strong>
        <span class="stars">★</span>
      </div>
    </div>

    <div class="movie-image">
      <img src="${movie.imageUrl}" alt="영화 포스터">
    </div>
  </div>

  <textarea class="movie-description" rows="10" readonly>${movie.description}</textarea>

  <div class="comment-box">
    <h3>댓글 목록</h3>
    <c:forEach var="comment" items="${comments}">
      <c:set var="indent" value="${comment.nested * 20}" />
      <div class="comment" style="margin-left:${indent}px;">
        <c:if test="${comment.nested == 1 && comment.rating > 0}">
          <div class="stars">
            <c:forEach var="i" begin="1" end="5">
              <c:choose>
                <c:when test="${i <= comment.rating}">★</c:when>
                <c:otherwise>☆</c:otherwise>
              </c:choose>
            </c:forEach>
          </div>
        </c:if>

        <div><b>${comment.nickname}</b> : ${comment.cont}</div>
        <div class="meta">
          (${comment.cdate})
          <button class="likeBtn" data-num="${comment.num}">
            좋아요 (<span id="like-${comment.num}">${comment.likeCount}</span>)
          </button>
          <a href="reply.jsp?num=${comment.num}&page=${bpage}">답글</a>
        </div>
      </div>
    </c:forEach>
  </div>
</div>

<script>
  const contextPath = "<%=request.getContextPath()%>";

  document.addEventListener("DOMContentLoaded", function() {
    const likeButtons = document.querySelectorAll(".likeBtn");

    likeButtons.forEach(button => {
      button.addEventListener("click", function() {
        const num = this.getAttribute("data-num");
        const url = contextPath + "/review/ajax/like.jsp?num=" + num;

        fetch(url)
                .then(response => response.text())
                .then(result => {
                  const countSpan = document.getElementById("like-" + num);
                  const newCount = parseInt(result.trim());
                  if (!isNaN(newCount)) {
                    countSpan.textContent = newCount;
                  }
                });
      });
    });
  });
</script>
</body>
</html>
