# newsqrab

newsqrab은 생성형 AI를 사용해 제작한 뉴스 숏폼을 제공하고, 사용자들끼리 스크랩을 통해 인사이트를 공유할 수 있는 플랫폼입니다.
<br><br>

# 개발환경

**Front-End:** Flutter <br>
**Back-End:** Nest.js <br>
**DB:** MongoDB <br>
**Server:** Naver Cloud Platform (Server, VPC, Object Storage) <br>
<br><br>

# 팀원

- 김서영 (성균관대학교 인공지능융합전공)
- 김예락 (고려대학교 컴퓨터학과)
- 박영민 (KAIST 뇌인지과학과)
- 이현정 (고려대학교 경영학과)
<br><br>

# 기능
## 1️⃣ 로그인 및 회원가입
<img src="https://github.com/user-attachments/assets/eb063df6-5a8f-4757-bcc5-aa66367a77fc">
<img src="https://github.com/user-attachments/assets/7f832415-7097-4fda-b363-635eff16f155">
<br>
- 자체 로그인 및 네이버 로그인 지원

## 2️⃣ 내가 팔로우한 유저들의 스크랩 확인
<img src="https://github.com/user-attachments/assets/794b79ad-2ca9-40fe-8bc1-d187cd78f314">
<img src="https://github.com/user-attachments/assets/f8e20540-b961-44c5-b7b9-441d2f5eb7fa">
<br>
- 유저가 스크랩한 부분, 유저가 남긴 반응 이모지, 원본 뉴스 링크를 확인하고, 원본 뉴스 링크로 이동할 수 있습니다.
- 이모지를 통해 스크랩에 반응을 남길 수 있습니다.

## 3️⃣ 인기 킹크랩, 화제의 스크랩 확인
<img src="https://github.com/user-attachments/assets/38886d34-6e28-441c-bd42-e64c6af78e12">
<img src="https://github.com/user-attachments/assets/04c7acbd-ea86-431c-af53-225211dd5897">
<br>

**인기 킹크랩**
<img src="https://github.com/user-attachments/assets/e1d1667a-e989-4275-97ce-20ae8684bd90">
<img src="https://github.com/user-attachments/assets/4edfe4f6-1e50-4c5e-bed7-247dfbf925d0">
<br>
- 팔로워가 많은 유저들 리스트를 확인할 수 있습니다.
- 유저에 대한 상세 정보 (프로필 사진, 이름, 팔로잉 수, 팔로워 수, 스크랩)를 확인할 수 있습니다.
- 유저를 바로 팔로우 및 언팔로우 할 수 있습니다.
<br>

**핫 스크랩** 
- 많은 이모지를 받은 스크랩을 확인할 수 있습니다.
- 스크랩에 대한 상세 정보 (스크랩한 유저의 이름, 사진, 스크랩한 기사 부분, 스크랩한 기사에 대한 반응, 스크랩한 기사 원문)를 확인할 수 있습니다.
- 이모지를 통해 스크랩에 반응을 남길 수 있습니다.

## 4️⃣ 카테고리별로 오늘의 뉴스 기사 확인
<img src="https://github.com/user-attachments/assets/bab1e5a6-c17a-4730-8cf9-23b385acb888">
<img src="https://github.com/user-attachments/assets/aa4cde31-baf9-46f5-b0d0-933307e161a4">
<img src="https://github.com/user-attachments/assets/d085a61c-ca49-4c9a-a2ed-e409f611b0ae">
<img src="https://github.com/user-attachments/assets/e64b1607-55c1-47c5-b8dc-81814fbcc594">
<br>
- 8개의 카테고리 (연예, 사회, 스포츠, 경영경제, 정치, 문화, 과학기술, 세계)에 대한 기사들을 확인할 수 있습니다.
- 각 카테고리별로 버튼을 클릭하면 해당 카테고리에 해당하는 기사들만 필터링하여 확인할 수 있습니다.
- 각 기사를 클릭하면 기사 원문을 확인하고, 스크랩을 할 수 있습니다.

## 5️⃣ 제작자별로 오늘의 뉴스 숏폼 확인
<video src="https://github.com/user-attachments/assets/c6a66bf6-7423-4a4c-9416-1ea593e4892a">
<br>
- 기본 제작자인 newsqrab과 언론사 (ex. YTN, 스포츠조선, 조선일보, 헤럴드경제) 등으로 구성된 숏폼 제작자들이 제작한 오늘의 뉴스 숏폼을 확인할 수 있습니다.
- 각 제작자 버튼을 클릭하면 해당 제작자가 제작한 숏폼들만 필터링하여 확인할 수 있습니다.
<br>

**예시 뉴스 숏폼**
<video src="https://github.com/user-attachments/assets/442adf6f-e0df-41fb-a830-a1c7373d5f36">
<video src="https://github.com/user-attachments/assets/31bece0e-fb0f-4c40-a71a-62787ccbe5a1">
<video src="https://github.com/user-attachments/assets/4cb90cf4-b124-4073-a2d0-9069809c21c0">
<br>

## 6️⃣ 마이페이지
<img src="https://github.com/user-attachments/assets/36f50cef-9b12-4714-a159-d72956c9d5d6">

- 내 프로필(사진, 한 줄 소개)을 확인하고 수정할 수 있습니다.
- 내 팔로잉과 팔로워 수, 그리고 팔로잉과 팔로워 목록을 확인할 수 있습니다.
- 내가 지금까지 진행한 스크랩을 확인할 수 있습니다.

