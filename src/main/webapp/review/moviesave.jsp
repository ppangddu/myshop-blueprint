<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ page import="pack.movie.MovieBean" %>
<%@ page import="pack.movie.MovieManager" %>

<% request.setCharacterEncoding("utf-8");

    MovieBean bean = new MovieBean();
    MovieManager movieManager = new MovieManager();

    bean.setTitle(request.getParameter("title"));
    bean.setGenre(request.getParameter("genre"));
    bean.setActorName(request.getParameter("actorName"));
    bean.setDescription(request.getParameter("description"));
    bean.setReleaseDate(request.getParameter("releaseDate"));
    bean.setImageUrl(request.getParameter("imageUrl"));

    // DB 저장
    movieManager.saveMovie(bean);

    // 영화 목록으로 이동
    response.sendRedirect("movielist.jsp?page=1");
%>

