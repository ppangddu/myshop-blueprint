<%@ page import="pack.review.ReviewDto" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="pack.review.ReviewManager" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
  response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
  response.setHeader("Pragma", "no-cache");
  response.setDateHeader("Expires", 0);
%>

<%
  String num = request.getParameter("num");
  String bpage = request.getParameter("page");

  ReviewManager reviewManager = new ReviewManager();
  reviewManager.updateReadcnt(num);
  ReviewDto dto = reviewManager.getData(num);

  request.setAttribute("dto", dto);
  request.setAttribute("bpage", bpage);
  request.setAttribute("comments", reviewManager.getComments(dto.getNum()));
  request.setAttribute("avgRating", reviewManager.getAverageRating(dto.getNum()));

  String adminOk = (String) session.getAttribute("adminOk");
  request.setAttribute("isAdmin", "admin".equals(adminOk));
%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>게시판</title>
  <link rel="stylesheet" type="text/css" href="../css/board.css">
</head>
<body>
<table>
  <tr>
    <td colspan="2" style="text-align: right">
      <a href="reply.jsp?num=${dto.num}&page=${bpage}">
        <img src="../images/reply.gif">
      </a>

      <a href="edit.jsp?num=${dto.num}&page=${bpage}">
        <img src="../images/edit.gif">
      </a>

      <c:if test="${isAdmin}">
        <a href="delete.jsp?num=${dto.num}&page=${bpage}">
          <img src="../images/del.gif">
        </a>
      </c:if>

      <a href="reviewlist.jsp?num=${dto.num}&page=${bpage}">
        <img src="../images/list.gif">
      </a>
    </td>
  </tr>
  <tr style="height: 30">
    <td>개봉일: ${dto.releaseDate}</td>
    <td>조회수: ${dto.readcnt}</td>
  </tr>
  <tr>
    <td colspan="3" style="background-color: cyan">제목 : ${dto.title}</td>
  </tr>
  <tr>
    <td colspan="3" style="text-align: left; padding-left: 10px;">
      <div style="margin: 10px 0;">
        <strong>평균 별점:
          <fmt:formatNumber value="${avgRating}" pattern="0.0" /> / 5.0
        </strong>
      </div>
    </td>
  </tr>
  <tr>
    <td colspan="3" style="text-align:center;">
      <img src="${dto.imageUrl}" alt="영화 포스터를 넣어주세요."
           style="max-width: 400px; height: auto; border-radius: 10px; margin: 10px 0;">

    </td>
  </tr>
  <tr>
    <td colspan="3">
      <textarea rows="10" style="width: 99%" readonly="readonly">${dto.cont}</textarea>
    </td>
  </tr>
  <tr>
    <td>
      <div style="margin-top: 20px;">
        <h3>댓글 목록</h3>
        <c:forEach var="comment" items="${comments}">
          <c:set var="indent" value="${comment.nested * 20}" />
          <div style="margin-left:${indent}px; border-bottom:1px solid #ddd; padding: 10px 0;">

            <c:if test="${comment.nested == 1 && comment.rating > 0}">
              <div style="margin-bottom: 5px;">
                <c:forEach var="i" begin="1" end="5">
                  <c:choose>
                    <c:when test="${i <= comment.rating}">
                      ★
                    </c:when>
                    <c:otherwise>
                      ☆
                    </c:otherwise>
                  </c:choose>
                </c:forEach>
              </div>
            </c:if>

            <div>
              <b>${comment.name}</b> : ${comment.cont}
            </div>

            <div style="font-size: 0.9em; color: gray; margin-top: 3px;">
              (${comment.bdate}) &nbsp;
              <button class="likeBtn" data-num="${comment.num}">
                좋아요 (<span id="like-${comment.num}">${comment.likeCount}</span>)
              </button>
              <a href="reply.jsp?num=${comment.num}&page=${bpage}">답글</a>
            </div>
          </div>
        </c:forEach>


      </div>
    </td>
  </tr>
</table>

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
