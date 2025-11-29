<!--<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>-->
<!--<%@ page session="true" %>-->
<!--<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>-->
<!--<!DOCTYPE html>-->
<!--<html lang="ko">-->
<!--<head>-->
<!--<meta charset="UTF-8">-->
<!--<title>로그인 성공</title>-->
<!--<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">-->
<!--<style>-->
<!--body {-->
<!--    background-color: #eef2f3;-->
<!--}-->
<!--.container {-->
<!--    margin-top: 100px;-->
<!--    text-align: center;-->
<!--}-->
<!--</style>-->
<!--</head>-->
<!--<body>-->

<!--<div class="container">-->
<!--    <h2>로그인 성공 🎉</h2>-->
<!--    <p class="mt-3">-->
<!--        <strong>${sessionScope.name}</strong> 님 (${sessionScope.id}) 환영합니다!-->
<!--    </p>-->
<!--    <p>닉네임: <strong>${sessionScope.name}</strong></p>-->
<!--    <p>관리자 여부: -->
<!--        <c:choose>-->
<!--            <c:when test="${sessionScope.admin == 1}">-->
<!--                ✅ 관리자-->
<!--            </c:when>-->
<!--            <c:otherwise>-->
<!--                일반 회원-->
<!--            </c:otherwise>-->
<!--        </c:choose>-->
<!--    </p>-->

<!--     버튼 영역 -->
<!--    <div class="mt-3">-->
<!--        <a href="home" class="btn btn-primary me-2">홈으로 이동</a>-->
<!--        <a href="logout" class="btn btn-danger me-2">로그아웃</a>-->
<!--        <a href="list" class="btn btn-success">마이페이지</a>-->
<!--    </div>-->
<!--</div>-->

<!--</body>-->
<!--</html>-->
