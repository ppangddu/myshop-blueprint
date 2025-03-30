<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@page import="pack.review.ReviewDto"%>
<%@page import="pack.review.ReviewManager" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    int bpage = 1; // page는 예약어이므로 bpage 선언
    try {
        bpage = Integer.parseInt(request.getParameter("page"));
    } catch(Exception e) {
        bpage = 1;
    }
    if(bpage <= 0) bpage = 1;

    String searchType = request.getParameter("searchType"); // 검색 처리용
    String searchWord = request.getParameter("searchWord");

    ReviewManager reviewManager = new ReviewManager();
    reviewManager.totalList();
    int pageSu = reviewManager.getPageSu();
    List<ReviewDto> list = reviewManager.getDataAll(bpage, searchType, searchWord);
    int totalRecord = reviewManager.getTotalRecordCount();

    request.setAttribute("list", list);
    request.setAttribute("bpage", bpage);
    request.setAttribute("pageSu", pageSu);
    request.setAttribute("totalRecord", totalRecord);

    String adminOk = (String)session.getAttribute("adminOk");
    request.setAttribute("adminOk", adminOk);
%>


<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시판</title>
    <link rel="stylesheet" type="text/css" href="../css/board.css">
    <script>
        window.onpageshow = function(event) {
            if (event.persisted || (window.performance && window.performance.navigation.type === 2)) {
                location.reload(true);
            }
        };
    </script>
    <script type="text/javascript">
        window.onload = () => {
            document.querySelector("#btnSearch").onclick = function() {
                if (frm.searchWord.value === "") {
                    frm.searchWord.placeholder = "검색어를 입력하세요.";
                    return;
                }
                frm.submit();
            }
        }
    </script>
</head>
<body>
<table>
    <tr>
        <td>
            [ <a href="../index.html">메인으로</a> ]&nbsp;
            [ <a href="reviewlist.jsp?page=1">최근목록</a> ]&nbsp;
            <c:if test="${adminOk == 'admin'}">
            [ <a href="reviewwrite.jsp">새글작성</a> ]&nbsp;
            </c:if>
            [ <a href="#" onclick="window.open('admin.jsp','','width=500,height=300,top=200,left=300')">관리자용</a> ]&nbsp;
            <br>
            <br>
            <table style="width: 100%">
                <tr style="background-color: cyan;">
                    <th>번호</th><th>영화</th><th>감독</th><th>개봉일</th><th>조회수</th>
                </tr>
                <c:forEach var="dto" items="${list}" varStatus="status">
                    <tr>
                        <td>${totalRecord - ((bpage - 1) * 10 + status.index)}</td>
                        <td>
                            <c:forEach begin="1" end="${dto.nested}">&nbsp;&nbsp;</c:forEach>
                            <a href="reviewcontent.jsp?num=${dto.num}&page=${bpage}">
                                <img src="${dto.imageUrl}" alt="영화 포스터"
                                     style="width:120px;height:180px;vertical-align:middle;margin-right:10px;border-radius:6px;">
                                ${dto.title}
                            </a>
                        </td>
                        <td>${dto.name}</td>
                        <td>${dto.releaseDate}</td>
                        <td>${dto.readcnt}</td>
                    </tr>
                </c:forEach>
            </table>
            <br>
            <table style="width: 100%">
                <tr>
                    <td style="text-align: center;">
                        <c:forEach begin="1" end="${pageSu}" var="i">
                            <c:choose>
                                <c:when test="${i == bpage}">
                                    <b style='font-size:12pt;color:blue'>[${i}]</b>
                                </c:when>
                                <c:otherwise>
                                    <a href='reviewlist.jsp?page=" + i + "'>[${i}]</a>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                        <br><br>
                        <form action="reviewlist.jsp" name="frm" method="post">
                            <select name="searchType">
                                <option value="title" selected="selected">영화제목</option>
                                <option value="name">감독</option>
                            </select>
                            <input type="text" name="searchWord">
                            <input type="button" value="검색" id="btnSearch">
                        </form>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</body>
</html>