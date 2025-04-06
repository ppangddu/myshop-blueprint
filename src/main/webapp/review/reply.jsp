<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="pack.review.ReviewManager" %>
<%@ page import="pack.review.ReviewDto" %>
<%@ page import="pack.cookie.CookieManager" %>
<%@ page import="jakarta.servlet.http.Cookie" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
    request.setCharacterEncoding("UTF-8");

    String numStr = request.getParameter("num");
    String movieIdStr = request.getParameter("movieId");
    String bpage = request.getParameter("page");

    boolean isReplyToComment = (numStr != null);
    String contCookieName = isReplyToComment ? "cont_reply" : "cont_review";
    String ratingCookieName = isReplyToComment ? "rating_reply" : "rating_review";

    ReviewDto review = new ReviewDto();
    ReviewManager reviewManager = new ReviewManager();

    if (isReplyToComment) {
        int parentNum = Integer.parseInt(numStr);
        ReviewDto parent = reviewManager.getReplyData(parentNum);

        review.setMovieId(parent.getMovieId());
        review.setOnum(parent.getOnum()); // 원댓글 그룹 유지

        int newNested = parent.getNested() >= 2 ? 2 : parent.getNested() + 1;
        review.setNested(newNested);
    } else if (movieIdStr != null) {
        int movieId = Integer.parseInt(movieIdStr);
        review.setMovieId(movieId);
        review.setOnum(0); // 저장 후 onum 갱신
        review.setNested(1); // 원댓글
    } else {
        response.sendRedirect("movielist.jsp");
        return;
    }

    request.setAttribute("review", review);
    request.setAttribute("bpage", bpage);

    if (session.getAttribute("user_id") == null) {
        session.setAttribute("user_id", "testuser");
        session.setAttribute("nickname", "빠른강아지59");
    }

    CookieManager cm = CookieManager.getInstance();
    Cookie[] cookies = request.getCookies();
    String ckCont = "", ckRating = "";

    if (cookies != null) {
        for (Cookie c : cookies) {
            try {
                if (c.getName().equals(contCookieName)) {
                    ckCont = cm.readDecryptCookie(c);  // 🔐 복호화로 변경
                }
                if (c.getName().equals(ratingCookieName)) {
                    ckRating = cm.readDecryptCookie(c);  // 🔐 복호화로 변경
                }
            } catch (Exception ignored) {}
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" type="text/css" href="../css/board.css">
    <title>댓글 쓰기</title>
    <style>
        .star { font-size: 24px; cursor: pointer; color: lightgray; transition: color 0.2s; }
        .star.selected { color: gold; }
        .star:hover { color: orange; }
    </style>
    <script>
        function check() {
            const frm = document.forms["frm"];
            if (frm.cont.value.trim() === "") {
                alert("내용을 입력하세요");
                frm.cont.focus();
                return;
            }
            if (frm.rating && frm.rating.value === "0") {
                alert("별점을 입력하세요.");
                return;
            }
            frm.submit();
        }

        function saveToCookie(name, value) {
            const isReply = <%= isReplyToComment %>;
            const cookieName = name + (isReply ? "_reply" : "_review");
            fetch("../review/cookie_save.jsp?name=" + encodeURIComponent(cookieName) + "&value=" + encodeURIComponent(value));
        }

        document.addEventListener("DOMContentLoaded", function () {
            const stars = document.querySelectorAll("#star-rating .star");
            const ratingInput = document.getElementById("rating");

            stars.forEach((star, idx) => {
                star.addEventListener("click", () => {
                    const rating = idx + 1;
                    ratingInput.value = rating;
                    stars.forEach((s, i) => {
                        s.classList.toggle("selected", i < rating);
                        s.textContent = i < rating ? "★" : "☆";
                    });
                    saveToCookie("rating", rating);
                });
            });

            const initialRating = parseInt("<%= ckRating %>");
            if (!isNaN(initialRating) && initialRating > 0) {
                ratingInput.value = initialRating;
                stars.forEach((star, i) => {
                    star.classList.toggle("selected", i < initialRating);
                    star.textContent = i < initialRating ? "★" : "☆";
                });
            }

            const contEl = document.forms["frm"]["cont"];
            if (contEl) {
                contEl.addEventListener("input", () => saveToCookie("cont", contEl.value));
            }
        });
    </script>
</head>
<body>
<form name="frm" method="post" action="replysave.jsp">
    <c:if test="${not empty param.num}">
        <input type="hidden" name="num" value="${param.num}">
    </c:if>
    <input type="hidden" name="page" value="${bpage}">
    <input type="hidden" name="onum" value="${review.onum}">
    <input type="hidden" name="nested" value="${review.nested}">
    <input type="hidden" name="user_id" value="${sessionScope.user_id}">
    <input type="hidden" name="movieId" value="${review.movieId}">

    <table border="1">
        <tr><td colspan="2"><h2>*** 댓글 쓰기 ***</h2></td></tr>
        <tr>
            <td align="center">작성자</td>
            <td>${sessionScope.nickname}</td>
        </tr>
        <tr>
            <td align="center">내 용</td>
            <td><textarea name="cont" rows="10" style="width:100%"><%= ckCont %></textarea></td>
        </tr>

        <c:if test="${review.nested == 1}">
            <tr>
                <td align="center">별점</td>
                <td>
                    <div id="star-rating">
                        <input type="hidden" name="rating" id="rating" value="0">
                        <c:forEach begin="1" end="5" var="i">
                            <span class="star" data-value="${i}">☆</span>
                        </c:forEach>
                    </div>
                </td>
            </tr>
        </c:if>

        <tr>
            <td colspan="2" align="center" height="30">
                <input type="button" value="작  성" onClick="check()">&nbsp;
                <input type="button" value="작성 취소" onClick="history.back()">
            </td>
        </tr>
    </table>
</form>
</body>
</html>
