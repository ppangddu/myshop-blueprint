<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>게시판</title>
  <link rel="stylesheet" type="text/css" href="../css/board.css">
  <script type="text/javascript">
    function check() {
      if (frm.id.value === "" || frm.pwd.value === "") {
        alert("자료를 입력하세요.");
        return;
      } frm.submit();
    }
  </script>
</head>
<body>
<form action="adminlogin.jsp" name="frm" method="post">
  <table>
    <tr>
      <td>
        <c:choose>
          <c:when test="${not empty sessionScope.admin}">
            이미 로그인된 상태입니다.
            <a href="adminlogin.jsp">로그아웃</a>
            <a href="javascript:window.close()">창 닫기</a>
          </c:when>
          <c:otherwise>
            <table>
              <tr>
                <td>아이디: <input type="text" name="id"> </td>
              </tr>
              <tr>
                <td>비밀번호: <input type="text" name="pwd"></td>
              </tr>
              <tr>
                <td>
                  <a href="#" onclick="check()">로그인</a>
                  <a href="javascript:window.close()">창 닫기</a>
                </td>
              </tr>
            </table>
          </c:otherwise>
        </c:choose>
      </td>
    </tr>
  </table>
</form>
</body>
</html>