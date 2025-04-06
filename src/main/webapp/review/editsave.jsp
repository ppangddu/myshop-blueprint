<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("utf-8"); %>
<%@page import="pack.movie.MovieManager" %>
<%@page import="pack.movie.MovieDto" %>

<%
    String bpage = request.getParameter("page");
    int id = Integer.parseInt(request.getParameter("id"));

    MovieDto movie = new MovieDto();
    movie.setId(id);
    movie.setTitle(request.getParameter("title"));
    movie.setActorName(request.getParameter("actorName")); // actorName이 맞으면 유지, directorName이면 필드명 확인 필요
    movie.setReleaseDate(request.getParameter("releaseDate"));
    movie.setDescription(request.getParameter("description"));
    movie.setImageUrl(request.getParameter("imageUrl"));
    movie.setGenre(request.getParameter("genre"));

    MovieManager movieManager = new MovieManager();
    movieManager.saveEdit(movie);

    response.sendRedirect("movielist.jsp?page=" + bpage); // 수정 후 목록보기는 movielist로 가야 정확함!
%>
