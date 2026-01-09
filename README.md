
Exam Map & Study App (Flutter) - Project Documentation

1. 프로젝트 개요
-----------------------------------------------------------
고사장(학교) 지도 기반 리뷰 서비스와 스터디 모집 기능을 제공하는 Flutter 앱입니다.
네이버 지도 SDK를 사용하여 위치를 시각화하고, 스터디 검색/필터링 및 리뷰 작성 기능을 제공합니다.


2. ✅ 주요 기능
-----------------------------------------------------------
📌 스터디 모집
- 스터디 모집글 리스트 조회
- 검색 (제목 / 지역)
- 필터링 (시험종류 / 지역 / 목표점수)
- 스터디 모집글 작성

📌 고사장 지도 & 리뷰
- 네이버 지도 표시
- 학교 마커 표시
- 마커 클릭 시 하단 리뷰 바텀시트 표시 (화면 높이의 1/3)
- 리뷰 목록 조회
- 리뷰 작성 (학교 선택, 별점, 태그, 내용 입력)

📌 마이페이지
- 사용자 정보 영역 (확장 예정)


3. 🚀 실행 방법
-----------------------------------------------------------
(1) 패키지 설치:
flutter pub get

(2) 환경변수 설정:
프로젝트 루트에 .env 파일 생성 후 아래 내용 작성:
NAVER_MAP_CLIENT_ID=네이버지도_클라이언트_ID

(3) 자산(Assets) 등록:
pubspec.yaml 파일 맨 아래에 assets 등록:
```
flutter:
  assets:
    - .env
```

4. 🧱 프로젝트 구조
-----------------------------------------------------------
```
lib/
├── main.dart                 # 앱 시작점, 환경변수 로드, 네이버지도 초기화
├── app.dart                  # MaterialApp 설정
│
├── state/
│    ├── app_state.dart       # 전역 상태 (데이터, 필터, 추가 로직)
│    └── app_scope.dart       # AppState를 위젯 트리에 전달
│
├── models/
│    ├── study_post.dart      # 스터디 모집 모델
│    ├── exam_center.dart     # 고사장(학교) 모델
│    └── review.dart          # 리뷰 모델
│
├── pages/
│    ├── main_page.dart       # 하단 탭 네비게이션
│    ├── study_list_page.dart # 스터디 리스트 + 검색/필터
│    ├── write_study_page.dart# 스터디 모집글 작성
│    ├── map_page.dart        # 지도 + 마커 + 리뷰 바텀시트
│    ├── write_review_page.dart # 리뷰 작성
│    └── my_page.dart         # 마이페이지
│
└── widgets/
└── filter_dialog.dart   # 필터 다이얼로그 UI
```

5. 🏗️ 아키텍처 개요
-----------------------------------------------------------
■ 상태 관리 구조
- AppState (ChangeNotifier)
- AppScope (InheritedNotifier)
- 흐름: UI -> AppScope.of(context) -> AppState -> notifyListeners() -> UI 갱신

■ 🔹 데이터 흐름
(1) 스터디 모집
WriteStudyPage
-> addStudyPost() 호출
-> AppState.studyPosts 업데이트
-> filteredStudyPosts를 통해 StudyListPage 리스트 자동 갱신

(2) 리뷰 작성
WriteReviewPage
-> addReview() 호출
-> AppState.reviewsByCenterId 업데이트
-> reviewsFor(centerId)를 통해 MapPage 바텀시트 자동 갱신


6. 📦 주요 파일 상세 설명
-----------------------------------------------------------
- main.dart:
  Flutter 앱 진입점. dotenv 로드 및 네이버 지도 SDK 초기화.
  AppScope(AppState)로 앱 전체를 감싸서 상태 공유.

- app.dart:
  MaterialApp 설정 및 기본 홈 화면(MainPage) 지정.

- state/app_state.dart:
  앱 전체 데이터와 비즈니스 로직 관리.
  (검색어/필터 상태, 스터디/고사장 데이터, 리뷰 데이터, 필터링 로직 등)

- state/app_scope.dart:
  AppState를 위젯 트리 전체에 전달하는 Provider 역할.
  사용 예: final app = AppScope.of(context);

- models/*:
  데이터 구조 정의 (StudyPost, ExamCenter, Review).

- pages/main_page.dart:
  하단 탭 네비게이션 관리 (스터디 / 지도 / 마이페이지 전환).

- pages/study_list_page.dart:
  검색창, 필터 버튼, 스터디 모집 리스트 UI 구성.

- pages/write_study_page.dart:
  스터디 모집글 입력 폼. 등록 시 AppState에 데이터 추가.

- widgets/filter_dialog.dart:
  시험종류 / 지역 / 목표점수 필터 선택을 위한 팝업 UI.

- pages/map_page.dart:
  네이버 지도 표시 및 학교 마커 생성.
  마커 클릭 시 리뷰 바텀시트 표시 및 데이터 실시간 반영.

- pages/write_review_page.dart:
  리뷰 작성 화면 (별점 슬라이더, 태그 입력, 내용 입력).

- pages/my_page.dart:
  마이페이지 (사용자 활동 및 설정 정보 확장 예정).
