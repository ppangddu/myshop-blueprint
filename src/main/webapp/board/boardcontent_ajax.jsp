<%@ page import="pack.board.BoardDto" %>
<%@ page import="java.util.ArrayList" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>
<jsp:useBean id="boardManager" class="pack.board.BoardManager" scope="page" />
<jsp:useBean id="dto" class="pack.board.BoardDto" />
<%
    String num = request.getParameter("num");
    String bpage = request.getParameter("page");
    boardManager.updateReadcnt(num);
    dto = boardManager.getData(num);
    String apass = "****";
    String adminOk = (String) session.getAttribute("adminOk");
    if (adminOk != null && adminOk.equals("admin")) apass = dto.getPass();
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
        <td><b>비밀번호 : <%=apass %></b></td>
        <td colspan="2" style="text-align: right">
            <a href="reply.jsp?num=<%=dto.getNum() %>&page=<%=bpage %>"><img src="../images/reply.gif"></a>
            <a href="edit.jsp?num=<%=dto.getNum() %>&page=<%=bpage %>"><img src="../images/edit.gif"></a>
            <a href="delete.jsp?num=<%=dto.getNum() %>&page=<%=bpage %>"><img src="../images/del.gif"></a>
            <a href="boardlist.jsp?num=<%=dto.getNum() %>&page=<%=bpage %>"><img src="../images/list.gif"></a>
        </td>
    </tr>
    <tr style="height: 30">
        <td>작성자: <a href="mailto:<%=dto.getMail() %>"><%=dto.getName() %></a>(ip : <%=dto.getBip() %>)</td>
        <td>작성일: <%=dto.getBdate() %></td>
        <td>조회수: <%=dto.getReadcnt() %></td>
    </tr>
    <tr>
        <td colspan="3" style="background-color: cyan">제목 : <%=dto.getTitle() %></td>
    </tr>
    <tr>
        <td colspan="3">
            <textarea rows="10" style="width: 99%" readonly="readonly"><%=dto.getCont() %></textarea>
        </td>
    </tr>
    <tr>
        <td colspan="3">
            <!-- 댓글 목록 -->
            <div id="commentList" style="margin-top: 20px;"></div>

            <!-- 댓글 입력 폼 -->
            <form id="replyForm">
                <input type="hidden" name="gnum" value="<%=dto.getNum()%>">
                <input type="hidden" name="onum" value="0">
                <input type="hidden" name="nested" value="1">
                <input type="text" name="name" placeholder="작성자" required><br>
                <input type="password" name="pass" placeholder="비밀번호" required><br>
                <input type="text" name="mail" placeholder="메일"><br>
                <input type="text" name="title" placeholder="제목"><br>
                <textarea name="cont" placeholder="댓글 내용" required></textarea><br>
                <button type="submit">댓글 등록</button>
            </form>
        </td>
    </tr>
</table>

<script>
    function loadComments() {
        fetch("get_comments.jsp?gnum=<%=dto.getNum()%>")
            .then(res => res.json())
            .then(data => {
                const container = document.getElementById("commentList");
                container.innerHTML = "<h3>댓글 목록</h3>";
                data.forEach(c => {
                    const indent = c.nested * 20;
                    container.innerHTML += `
          <div style="margin-left:${indent}px; border-bottom:1px solid #ddd;">
            <b>${c.name}</b> (${c.bdate}): ${c.cont}
          </div>`;
                });
            });
    }

    document.getElementById("replyForm").addEventListener("submit", function(e) {
        e.preventDefault();
        const formData = new FormData(this);
        fetch("replysave_ajax.jsp", {
            method: "POST",
            body: formData
        })
            .then(res => res.text())
            .then(() => {
                loadComments();
                this.reset();
            });
    });

    // 처음 로딩 시 댓글 불러오기
    loadComments();
</script>
</body>
</html>