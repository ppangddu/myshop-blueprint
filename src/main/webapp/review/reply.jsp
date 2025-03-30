<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ page import="pack.review.ReviewManager" %>
<%@ page import="pack.review.ReviewDto" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<%
    String num = request.getParameter("num");
    String bpage = request.getParameter("page");

    ReviewManager reviewManager = new ReviewManager();
    ReviewDto dto = reviewManager.getReplyData(num); // 해당 댓글의 원글 정보 읽기

    request.setAttribute("dto", dto);
    request.setAttribute("num", num);
    request.setAttribute("bpage", bpage);

%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" type="text/css" href="../css/board.css">
    <title>댓글 쓰기</title>
    <style>
        .star {
            font-size: 24px;
            cursor: pointer;
            color: lightgray;
            transition: color 0.2s;
        }
        .star.selected {
            color: gold;
        }
        .star:hover {
            color: orange;
        }
    </style>
    <script>
        function check() {
            const frm = document.forms["frm"];
            if (frm.name.value === "") {
                alert("이름을 입력하세요");
                frm.name.focus();
            } else if (frm.pass.value === "") {
                alert("비밀번호를 입력하세요");
                frm.pass.focus();
            } else if (frm.mail.value === "") {
                alert("이메일을 입력하세요");
                frm.mail.focus();
            } else if (frm.title.value === "") {
                alert("제목을 입력하세요");
                frm.title.focus();
            } else if (frm.cont.value === "") {
                alert(" 내용을 입력하세요");
                frm.cont.focus();
            } else {
                frm.submit();
            }
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
                });
            });
        });
    </script>
</head>
<body>
<form name="frm" method="post" action="replysave.jsp">
    <input type="hidden" name="num" value="${num}">
    <input type="hidden" name="page" value="${bpage}">
    <input type="hidden" name="gnum" value="${dto.gnum}">
    <input type="hidden" name="onum" value="${dto.onum}">
    <input type="hidden" name="nested" value="${dto.nested}">
    <table border="1">
        <tr>
            <td colspan="2"><h2>*** 댓글 쓰기 ***</h2></td>
        </tr>
        <tr>
            <td align="center" width="100">이 름</td>
            <td width="430"><input name="name" size="15"></td>
        </tr>
        <tr>
            <td align="center">암 호</td>
            <td><input type="password" name="pass" size="15"></td>
        </tr>
        <tr>
            <td align="center">메 일</td>
            <td><input name="mail" style="width:100%"></td>
        </tr>
        <tr>
            <td align="center">제 목</td>
            <td><input name="title" style="width:100%"></td>
        </tr>
        <tr>
            <td align="center">내 용</td>
            <td><textarea name="cont" rows="10" style="width:100%"></textarea></td>
        </tr>
        <c:if test="${dto.nested == 0}">
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
                <input type="button" value="목  록"
                       onClick="location.href='reviewlist.jsp?page=<%=bpage%>'">
            </td>
        </tr>
    </table>
</form>
</body>
</html>