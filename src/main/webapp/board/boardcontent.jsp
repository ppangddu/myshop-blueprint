<%@ page import="pack.board.BoardDto" %>
<%@ page import="java.util.ArrayList" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>

<%
  response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
  response.setHeader("Pragma", "no-cache");
  response.setDateHeader("Expires", 0);
%>


<jsp:useBean id="boardManager" class="pack.board.BoardManager" scope="page" />
<jsp:useBean id="dto" class="pack.board.BoardDto" />

<%
  String num = request.getParameter("num"); //넘어올게 하나라서 formBean 안 써도 됨
  String bpage = request.getParameter("page");
// out.print(num + " " + bpage);

  boardManager.updateReadcnt(num); //조회수 증가
  dto = boardManager.getData(num); //해당 자료 읽기

  String apass = "****"; // 일반 사용자는 비밀번호 보이지 않기
  String adminOk = (String) session.getAttribute("adminOk"); // 세션에서 adminOk라는 키의 값을 읽음
  if (adminOk != null) {
    if (adminOk.equals("admin")) apass = dto.getPass(); // 키 값이 admin인 경우 비밀번호를 치환
  }

// out.print(dto.getNum() + " " + dto.getName() + " " + dto.getTitle());
%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>게시판</title>
  <link rel="stylesheet" type="text/css" href="../css/board.css">
  <title>Insert title here</title>
</head>
<body>
<table>
  <tr>
    <td><b>비밀번호 : <%=apass %></b></td>
    <td colspan="2" style="text-align: right">
      <a href="reply.jsp?num=<%=dto.getNum() %>&page=<%=bpage %>">
        <img src="../images/reply.gif">
      </a>

      <a href="edit.jsp?num=<%=dto.getNum() %>&page=<%=bpage %>">
        <img src="../images/edit.gif">
      </a>

      <a href="delete.jsp?num=<%=dto.getNum() %>&page=<%=bpage %>">
        <img src="../images/del.gif">
      </a>

      <a href="boardlist.jsp?num=<%=dto.getNum() %>&page=<%=bpage %>">

        <img src="../images/list.gif">
      </a>
    </td>
  </tr>
  <tr style="height: 30">
    <td>
      작성자: <a href="mailto:<%=dto.getMail() %>"><%=dto.getName() %></a>(ip : <%=dto.getBip() %>)
    </td>
    <td>작성일: <%=dto.getBdate() %></td>
    <td>조회수: <%=dto.getReadcnt() %></td>
  </tr>
  <tr>
    <td colspan="3" style="background-color: cyan">제목 : <%=dto.getTitle() %></td>
  </tr>
  <tr>
    <td colspan="3">
      <textarea rows="10" style="width: 99%" readonly="readonly"><%=dto.getCont() %></textarea>
  </tr>
  <tr>
    <td>
      <!-- boardcontent.jsp 하단 -->
      <div style="margin-top: 20px;">
        <h3>댓글 목록</h3>
        <%
          ArrayList<BoardDto> comments = boardManager.getComments(dto.getNum());
          for(BoardDto comment : comments) {
            int indent = comment.getNested() * 20;
        %>
        <div style="margin-left:<%=indent%>px; border-bottom:1px solid #ddd;">
          <b><%=comment.getName()%></b> (<%=comment.getBdate()%>): <%=comment.getCont()%>
          <a href="reply.jsp?num=<%=comment.getNum()%>&page=<%=bpage%>">답글</a>
        </div>
        <%
          }
        %>
      </div>

    </td>
  </tr>
</table>
</body>
</html>