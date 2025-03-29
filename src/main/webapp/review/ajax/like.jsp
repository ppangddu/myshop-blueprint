<%@ page import="pack.review.ReviewManager" %>
<%@ page language="java" contentType="text/plain; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String numStr = request.getParameter("num");
    if (numStr != null) {
        int num = Integer.parseInt(numStr);
        ReviewManager manager = new ReviewManager();
        manager.increaseLikeCount(num);

        // DB에서 갱신된 값 다시 가져오기
        int updatedCount = manager.getLikeCount(num); // 새로 만들어줘야 해

        out.print(updatedCount);
    } else {
        out.print("error");
    }
%>
