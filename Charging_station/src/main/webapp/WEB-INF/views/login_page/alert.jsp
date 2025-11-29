<%
	request.setCharacterEncoding("UTF-8");
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<script>
    // [수정] 큰따옴표(") 대신 작은따옴표(')로 감싸서
    // 컨트롤러에서 보낸 '\n' 문자를 alert()가 인식할 수 있게 합니다.
    var msg = '${msg}';
    var url = '${url}';
    
    alert(msg);
    location.href = url;
</script>