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
  ArrayList<ReviewDto> reviews = reviewManager.getReviewsByMovieId(movieId);
  double avgRating = reviewManager.getAverageRating(movieId);

  if (session.getAttribute("user_id") == null) {
    session.setAttribute("user_id", "testuser");
    session.setAttribute("nickname", "haruka");
  }

  request.setAttribute("movie", movie);
  request.setAttribute("reviews", reviews);
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
      display: inline-flex;
      align-items: center;
      gap: 6px;
      padding: 6px 14px;
      font-size: 1em;
      background-color: #fff0f0;
      color: #d6336c;
      border: 1px solid #f5c2c7;
      border-radius: 20px;
      cursor: pointer;
      transition: background-color 0.2s ease, transform 0.1s ease;
    }

    .likeBtn:hover {
      background-color: #ffe3e3;
      transform: scale(1.05);
    }

    .likeBtn:active {
      transform: scale(0.95);
    }


  </style>
</head>
<body>
<div class="movie-detail-container">
  <div class="movie-header">
    <a href="reply.jsp?movieId=${movie.id}&page=${bpage}"
       class="login-check" data-url="reply.jsp?movieId=${movie.id}&page=${bpage}">
      리뷰 쓰기
    </a>
<c:if test="${not empty sessionScope.admin}">
<a href="edit.jsp?id=${movie.id}&page=${bpage}">수정하기</a>
    <a href="delete.jsp?id=${movie.id}&page=${bpage}">삭제하기</a>
</c:if>
    <a href="movielist.jsp?page=${bpage}">목록 보기</a>
  </div>

  <div class="movie-title">${movie.title}</div>

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
    <c:forEach var="review" items="${reviews}">
      <c:set var="indent" value="${review.nested * 20}" />
      <div class="comment" style="margin-left:${indent}px;">
        <c:if test="${review.nested == 1 && review.rating > 0}">
          <div class="stars">
            <c:forEach var="i" begin="1" end="5">
              <c:choose>
                <c:when test="${i <= review.rating}">★</c:when>
                <c:otherwise>☆</c:otherwise>
              </c:choose>
            </c:forEach>
          </div>
        </c:if>

        <div><b>${review.nickname}</b> : ${review.cont}</div>
        <div class="meta">
          (<fmt:formatDate value="${review.cdate}" pattern="yyyy-MM-dd HH:mm" />)
          <button class="likeBtn" data-num="${review.num}">
            ❤️ <span id="like-${review.num}">${review.likeCount}</span>
          </button>
          <c:if test="${review.nested == 1}">
            <a href="reply.jsp?num=${review.num}&page=${bpage}"
               class="login-check"
               data-url="reply.jsp?num=${review.num}&page=${bpage}">
              답글
            </a>
          </c:if>
          <c:if test="${sessionScope.user_id == review.userId}">
            <a href="reviewdelete.jsp?num=${review.num}&movieId=${movie.id}&page=${bpage}">삭제</a>
          </c:if>
        </div>
      </div>
    </c:forEach>
  </div>
</div>


<script>
  const contextPath = "<%= request.getContextPath() %>";
  const isLoggedIn = <%= session.getAttribute("user_id") != null %>;

  document.addEventListener("DOMContentLoaded", function () {
    // 좋아요 토글
    document.querySelectorAll(".likeBtn").forEach(button => {
      button.addEventListener("click", function () {
        const num = this.getAttribute("data-num");
        const url = contextPath + "/review/ajax/like.jsp?num=" + num;
        const countSpan = document.getElementById("like-" + num);
        const btn = this;

        fetch(url)
                .then(response => response.text())
                .then(result => {
                  const trimmed = result.trim();

                  if (trimmed === "unauthorized") {
                    alert("로그인 후 이용 가능합니다.");
                    return;
                  }

                  if (trimmed.startsWith("liked:")) {
                    const count = trimmed.split(":")[1];
                    countSpan.textContent = count;
                    btn.classList.add("liked");
                    btn.title = "좋아요 취소";
                    return;
                  }

                  if (trimmed.startsWith("unliked:")) {
                    const count = trimmed.split(":")[1];
                    countSpan.textContent = count;
                    btn.classList.remove("liked");
                    btn.title = "좋아요";
                    return;
                  }
                });
      });
    });

    // 리뷰쓰기/답글 링크 클릭 시 로그인 확인
    document.querySelectorAll(".login-check").forEach(link => {
      link.addEventListener("click", function (e) {
        if (!isLoggedIn) {
          e.preventDefault();
          alert("로그인 후 이용 가능합니다.");
        } else {
          location.href = this.getAttribute("data-url");
        }
      });
    });
  });
</script>


</body>
</html>
