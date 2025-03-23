<%@page import="pack.board.BoardDto"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>

<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>


<jsp:useBean id="boardManager" class="pack.board.BoardManager"></jsp:useBean>
<jsp:useBean id="dto" class="pack.board.BoardDto"></jsp:useBean>
<%
    int pageSu, bpage = 1; // page는 예약어이므로 bpage 선언
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
            [ <a href="boardlist.jsp?page=1">최근목록</a> ]&nbsp;
            [ <a href="boardwrite.jsp">새글작성</a> ]&nbsp;
            [ <a href="#" onclick="window.open('admin.jsp','','width=500,height=300,top=200,left=300')">관리자용</a> ]&nbsp;
            <br>
            <br>
            <table style="width: 100%">
                <tr style="background-color: cyan;">
                    <th>번호</th><th>글 제 목</th><th>작성자</th><th>등록일</th><th>조회수</th>
                </tr>
                <%
                    request.setCharacterEncoding("utf-8");


                    try {
                        bpage = Integer.parseInt(request.getParameter("page"));
                    } catch(Exception e) {
                        bpage = 1;
                    }
                    if(bpage <= 0) {
                        bpage = 1;
                    }

                    String searchType = request.getParameter("searchType"); // 검색 처리용
                    String searchWord = request.getParameter("searchWord");

                    boardManager.totalList(); // 전체 페이지 수 얻기
                    pageSu = boardManager.getPageSu(); // 전체 레코드 수 구하기

                    // ArrayList<BoardDto> list = boardManager.getDataAll(bpage); // 검색 X
                    ArrayList<BoardDto> list = boardManager.getDataAll(bpage, searchType, searchWord); // 검색 O

                    for(int i = 0; i < list.size(); i++) {
                        dto = list.get(i); //list에는 boardDto타입만 있으니 캐스팅 안 해도 된다.

                        // 댓글 들여쓰기 준비
                        int nst = dto.getNested();
                        String tab = "";
                        for (int k = 0; k < nst; k++) {
                            tab += "&nbsp;&nbsp;";
                        }
                %>
                <tr>
                    <td><%= boardManager.getTotalRecordCount() - ((bpage - 1) * 10 + i) %></td>
                    <td>
                        <%=tab %><a href="boardcontent.jsp?num=<%=dto.getNum()%>&page=<%=bpage%>"><%= dto.getTitle() %></a>
                    </td>
                    <td><%= dto.getName() %></td>
                    <td><%= dto.getBdate() %></td>
                    <td><%= dto.getReadcnt() %></td>
                </tr>
                <%
                    }
                %>
            </table>
            <br>
            <table style="width: 100%">
                <tr>
                    <td style="text-align: center;">
                        <%
                            for (int i = 1; i <= pageSu; i++) { // 현재 페이지는 링크 걸 필요 x
                                if (i == bpage) {
                                    out.print("<b style='font-size:12pt;color:blue'>[" + i + "]</b>");
                                } else {
                                    out.print("<a href='boardlist.jsp?page=" + i + "'>[" + i + "]</a>");

                                }
                            }
                        %>
                        <br><br>
                        <form action="boardlist.jsp" name="frm" method="post">
                            <select name="searchType">
                                <option value="title" selected="selected">글제목</option>
                                <option value="name">작성자</option>
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