<%@ page import="pack.review.ReviewManager" %>
<%@ page language="java" contentType="text/plain; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String numStr = request.getParameter("num");
    String userId = (String) session.getAttribute("user_id");

    if (userId == null) {
        out.print("unauthorized");
        return;
    }

    if (numStr != null) {
        int num = Integer.parseInt(numStr);
        String likeKey = "liked_" + num;

        ReviewManager manager = new ReviewManager();
        Boolean alreadyLiked = (Boolean) session.getAttribute(likeKey);
        int newCount = 0;

        if (alreadyLiked != null && alreadyLiked) {
            // 이미 눌렀으면 취소
            manager.decreaseLikeCount(num);
            session.removeAttribute(likeKey);
            newCount = manager.getLikeCount(num);
            out.print("unliked:" + newCount);
        } else {
            // 처음 누르면 증가
            manager.increaseLikeCount(num);
            session.setAttribute(likeKey, true);
            newCount = manager.getLikeCount(num);
            out.print("liked:" + newCount);
        }
    } else {
        out.print("error");
    }
%>
