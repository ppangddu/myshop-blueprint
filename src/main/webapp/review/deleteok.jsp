<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ page import="pack.movie.MovieManager" %>

<%
    request.setCharacterEncoding("UTF-8");

    int id = Integer.parseInt(request.getParameter("id"));
    String bpage = request.getParameter("page");

    MovieManager movieManager = new MovieManager();
    movieManager.deleteMovie(id);

    response.sendRedirect("movielist.jsp?page=" + bpage);
%>
