<%@ page import="pack.cookie.CookieManager" %>
<%@ page import="jakarta.servlet.http.Cookie" %>
<%
  String name = request.getParameter("name");
  String value = request.getParameter("value");

  System.out.println("저장 시도: " + name + "=" + value);

  CookieManager cm = CookieManager.getInstance();
  Cookie cookie = cm.createCookie(name, cm.encrypt(value));

  response.addCookie(cookie);
  System.out.println("쿠키 생성 완료: " + cookie.getName() + "=" + cookie.getValue());
%>
