<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ page import="pack.movie.MovieDto" %>
<%@ page import="pack.movie.MovieManager" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    int bpage = 1;
    try {
        bpage = Integer.parseInt(request.getParameter("page"));
    } catch(Exception e) {
        bpage = 1;
    }
    if(bpage <= 0) bpage = 1;

    String searchWord = request.getParameter("searchWord");

    MovieManager movieManager = new MovieManager();
    int totalRecord;
    if (searchWord != null && !searchWord.trim().isEmpty()) {
        totalRecord = movieManager.getSearchCount(searchWord);
    } else {
        movieManager.totalList();
        totalRecord = movieManager.getTotalRecordCount();
    }

    int pageList = 5;
    int pageSu = totalRecord / pageList + (totalRecord % pageList > 0 ? 1 : 0);

    List<MovieDto> list = movieManager.getDataAll(bpage, searchWord);

    request.setAttribute("list", list);
    request.setAttribute("bpage", bpage);
    request.setAttribute("pageSu", pageSu);
    request.setAttribute("totalRecord", totalRecord);
    request.setAttribute("searchWord", searchWord);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>과제 목록</title>
    <link rel="stylesheet" type="text/css" href="../css/board.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f9f9f9;
            margin: 0;
            padding: 20px;
        }
        .nav {
            margin-bottom: 20px;
            text-align: center;
        }
        .search-form {
            margin-bottom: 30px;
            text-align: center;
        }
        .movie-list-container {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 25px;
            margin-bottom: 40px;
        }
        .movie-card {
            width: 230px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            overflow: hidden;
            text-align: center;
            padding: 13px;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .movie-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.2);
        }
        .movie-card img {
            width: 100%;
            height: 330px;
            object-fit: cover;
            border-radius: 6px;
        }
        .movie-card .title {
            font-weight: bold;
            margin-top: 10px;
            font-size: 1.1em;
            color: #333;
        }
        .movie-card .meta {
            font-size: 0.9em;
            color: #666;
            margin-top: 4px;
        }
        .pagination {
            text-align: center;
            margin-top: 30px;
        }
        .pagination a, .pagination b {
            margin: 0 5px;
        }
        @media (max-width: 768px) {
            .movie-card {
                width: 180px;
            }
            .movie-card img {
                height: 260px;
            }
        }
        @media (max-width: 480px) {
            .movie-card {
                width: 150px;
            }
            .movie-card img {
                height: 220px;
            }
        }
    </style>
    <script>
        window.onload = () => {
            document.querySelector("#btnSearch").onclick = function () {
                const word = document.frm.searchWord.value.trim();
                if (word === "") {
                    document.frm.searchWord.placeholder = "검색어를 입력하세요.";
                    return;
                }
                document.frm.submit();
            }
        }
    </script>
</head>
<body>
<div class="nav">
    [ <a href="../index.html">메인으로</a> ]
    [ <a href="movielist.jsp?page=1">최근목록</a> ]
    [ <a href="moviewrite.jsp">새글작성</a> ]
    [ <a href="#" onclick="window.open('admin.jsp','','width=500,height=300,top=200,left=300')">관리자용</a> ]
</div>

<div class="search-form">
    <form action="movielist.jsp" name="frm" method="post">
        <input type="text" name="searchWord" placeholder="영화 제목 입력" value="${searchWord}">
        <input type="button" value="검색" id="btnSearch">
    </form>
</div>

<div class="movie-list-container">
    <c:forEach var="movie" items="${list}">
        <div class="movie-card">
            <a href='reviewcontent.jsp?movieId=${movie.id}&page=${bpage}'>
                <img src="${movie.imageUrl}" alt="영화 포스터">
                <div class="title">${movie.title}</div>
                <div class="meta">장르: ${movie.genre}</div>
                <div class="meta">출연: ${movie.actorName}</div>
                <div class="meta">개발일: ${movie.releaseDate}</div>
            </a>
        </div>
    </c:forEach>
</div>

<div class="pagination">
    <c:forEach begin="1" end="${pageSu}" var="i">
        <c:choose>
            <c:when test="${i == bpage}">
                <b style="color:black">[${i}]</b>
            </c:when>
            <c:otherwise>
                <a href="movielist.jsp?page=${i}&searchWord=${searchWord}">[${i}]</a>
            </c:otherwise>
        </c:choose>
    </c:forEach>
</div>
</body>
</html>
