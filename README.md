# ⚡ EV Station — 전기차 충전소 정보 & 실시간 예약/고장신고 플랫폼

<p align="center">
  <img src="https://github.com/user-attachments/assets/3f5231f5-e368-4875-9b5e-bcb8ff08f52e" alt="EV Station Project Banner" />
</p>

## 📌 프로젝트 소개
**EV Station**은 실시간 전기차 충전소 정보, 예약, 결제, 고장 신고 등  
전기차 운전자에게 꼭 필요한 기능을 제공하는 **충전소 통합 정보 플랫폼**입니다.  
Spring, JSP, Oracle DB, MyBatis, Spring Security 등 최신 기술과 공공데이터 API 연동으로 실시간 데이터를 제공합니다.

---

## ✨ 주요 기능

- **회원 관리**: 회원가입, 로그인/로그아웃, 마이페이지, 회원 정보 수정, Spring Security 기반 비밀번호 암호화   
- **충전소 지도/API 연동**: 실시간 충전소 위치·상태·혼잡도(공공데이터 API), 주변 카페·편의점 등 부가 정보 표시  
- **고장 신고 & 처리**: 회원의 고장신고/관리자 처리, 처리 상태 확인
- **공지사항 및 자유게시판**: 커뮤니티 기능, 게시글/댓글 작성·수정·삭제
- **관리자 페이지**: 고장 처리, 회원 관리, 예약 내역 관리
- **예약/결제 기능**: 충전소 예약, 예약금 결제(토스 API)
- **혼잡도 예측**: 시간대별 실시간 충전소 이용 혼잡도 예측

---

## 📸 서비스 화면 예시

<!-- 1 -->
### 🔐 로그인 / 🧾 메인
<p align="center">
  <img src="https://github.com/user-attachments/assets/f7193ac1-6d4f-4f84-9dc9-e1f67d233842" width="47%" />
  <img src="https://github.com/user-attachments/assets/e28d85b0-2158-4f78-8869-3a88241671b7" width="47%" />
</p>

<!-- 2 -->
### ⚡ 충전소 지도 / 혼잡도 예측
<p align="center">
  <img src="https://github.com/user-attachments/assets/75b13823-3b4b-47cf-b6b5-bcd884ed7705" width="47%" />
  <img src="https://github.com/user-attachments/assets/a608aaad-3331-47f4-9e9e-d42bd2b11d65" width="47%" />
</p>

<!-- 3 -->
### 🛠 고장신고 / 관리자 고장처리
<p align="center">
  <img src="https://github.com/user-attachments/assets/52f4a590-475f-40e8-92b2-6d4a841f3f20" width="47%" />
  <img src="https://github.com/user-attachments/assets/1d43cb23-df41-4dda-a2f3-f7adbf9a04bc" width="47%" />
</p>

<!-- 4 -->
### 📢 공지사항 / 자유게시판
<p align="center">
  <img src="https://github.com/user-attachments/assets/b1603884-e6ef-4af8-9f92-0b7292793e69" width="47%" />
  <img src="https://github.com/user-attachments/assets/fdd8a51f-6b18-4134-8bc3-c04dd7ae5da1" width="47%" />
</p>

<!-- 5 -->
### 💳 예약 결제 / 결제 성공·실패 안내
<p align="center">
  <img src="https://github.com/user-attachments/assets/0535efa8-5177-4df5-b391-fcde6d0c22a4" width="47%" />
  <img src="https://github.com/user-attachments/assets/3ab112f6-6d08-4837-b0ca-eb1bca8f1fb2" width="47%" />
</p>

<!-- 6 -->
### 🏪 주변 편의시설 지도(Kakao Map 등)
<p align="center">
  <img src="https://github.com/user-attachments/assets/10347bda-a261-4207-ba53-e0e06a193df3" width="47%" />
  <img src="https://github.com/user-attachments/assets/90216f2f-c64f-4105-822e-0b46679117b3" width="47%" />
</p>

<!-- 7 -->
### 👤 마이페이지 / 관리자 회원관리
<p align="center">
  <img src="https://github.com/user-attachments/assets/16673cd2-7173-4dc2-ace4-789d2cc05088" width="47%" />
  <img src="https://github.com/user-attachments/assets/50fb4226-1330-4bbf-be35-2e121e33e345" width="47%" />
</p>

<!-- 8 -->
### 📊 예약현황 / 전체 관리페이지
<p align="center">
  <img src="https://github.com/user-attachments/assets/5a9bb62a-e41e-4022-9e26-2aed53107415" width="47%" />
  <img src="https://github.com/user-attachments/assets/8f9a8e66-f531-42d9-b3a7-a57229d65ec2" width="47%" />
</p>

---

## 🛠 기술 스택

### Backend
- Java 17
- Spring Framework / MVC / Security
- MyBatis
- Tomcat
- Oracle Database

### Frontend
- JSP
- HTML5, CSS3, JavaScript
- jQuery

### DevOps & Tools
- Git / GitHub
- Gradle
- Postman

<p align="center">
  <img src="https://skillicons.dev/icons?i=java,spring,mysql,html,css,js,git,github" />
</p>

---

## 📁 프로젝트 폴더 구조

```
Charging_station/
├─ src/main/java/com.boot/
│  ├─ Board/           # 게시판·커뮤니티
│  ├─ common.dto/      # 공통 DTO
│  ├─ fix/             # 고장신고 관리
│  ├─ login/           # 로그인·회원 관련
│  ├─ Main_Page/       # 메인 페이지
│  ├─ MY_Page/         # 마이페이지
│  ├─ Notice/          # 공지사항
│  ├─ Reservation/     # 예약·결제 관련
│  ├─ CacheConfig.java
│  └─ ChargingStationApplication.java
│
├─ src/main/resources/
│  ├─ ...
│
├─ src/main/webapp/
│  └─ WEB-INF/
│     └─ views/
│        ├─ board/
│        ├─ common/
│        ├─ fix/
│        ├─ login_page/
│        ├─ my_page/
│        └─ notice/
│        ├─ cancelPage.jsp
│        ├─ detail_panel.jsp
│        ├─ fail.jsp
│        ├─ home.jsp
│        ├─ indiv_payment.jsp
│        ├─ kakao_map.jsp
│        ├─ map.jsp
│        ├─ navigation_bar.jsp
│        ├─ payment.jsp
│        └─ success.jsp
│
├─ build.gradle
├─ gradlew
├─ gradlew.bat
├─ dummy_data.sql
└─ settings.gradle
```
---

## 👥 팀원 소개

<br>

<h3 align="center">EV Station Team</h3>

<br>

<div align="center">

<table>
  <tr>
    <!-- 팀원 1(팀장) -->
    <td align="center">
      <a href="https://github.com/sbg0629">
        <img src="https://github.com/sbg0629.png" width="130" height="130" style="border-radius: 10px;">
        <br><br>
        <b>손봉균 (팀장)</b>
      </a>
      <br>
      <sub>풀스택 - 로그인, 이메일-아이디&비번찾기, 관리자/고장처리, 공지사항, 고장신고, 혼잡도 예측, 페이징처리</sub>
    </td>
    <!-- 팀원 2 -->
    <td align="center">
       <a href="https://github.com/LeeHyunJin323">
      <img src="https://github.com/LeeHyunJin323.png" width="130" height="130" style="border-radius: 10px;">
      <br><br>
      <b>이현진</b>
          </a>
      <br>
      <sub>풀스택 - 회원가입, 마이페이지, 시큐리티, 소셜로그인, 게시판, 예약처리</sub>
    </td>
    <!-- 팀원 3 -->
    <td align="center">
       <a href="https://github.com/RollingSoap">
      <img src="https://github.com/RollingSoap.png" width="130" height="130" style="border-radius: 10px;">
      <br><br>
      <b>박동영</b>
          </a>
      <br>
      <sub>풀스택 - 토스 결제기능, 지도 클러스터처리, 지도 충전소 외 장소 찾기 </sub>
    </td>
    <!-- 팀원 4 -->
    <td align="center">
       <a href="https://github.com/Rootplant">
      <img src="https://github.com/Rootplant.png" width="130" height="130" style="border-radius: 10px;">
      <br><br>
      <b>정찬호</b>
          </a>
      <br>
      <sub>풀스택 - 공공데이터 api, 디비삽입, 각종 버그 수정, 지도 클러스터 처리</sub>
    </td>
  </tr>
</table>
</div>

<br>

---

## 🧩 기타 특장점

- **실시간 충전소 정보 & 공공데이터 API 연동**
- **Spring Security 기반 비밀번호 암호화/인증**
- **카카오·토스 API 연동(지도/결제)**
- **관리자 · 회원 역할 분리 UI**
- **예약/결제 혼잡도 예측 기능**

---
