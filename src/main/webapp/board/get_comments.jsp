<%@ page contentType="application/json; charset=UTF-8" %>
<%@ page import="pack.board.BoardDto, java.util.*, com.google.gson.Gson" %>
<jsp:useBean id="boardManager" class="pack.board.BoardManager" />

<%
  int gnum = Integer.parseInt(request.getParameter("gnum"));
  ArrayList<BoardDto> comments = boardManager.getComments(gnum);

  Gson gson = new Gson();
  String json = gson.toJson(comments);
  out.print(json);
%>
