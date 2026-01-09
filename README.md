🗺️ Exam Map & Study App (Flutter)

고사장(학교) 지도 기반 리뷰 서비스 + 스터디 모집 기능을 제공하는 Flutter 앱입니다.
네이버 지도 SDK를 사용하여 위치를 시각화하고, 스터디 검색/필터링과 리뷰 작성 기능을 제공합니다.

✅ 주요 기능
📌 스터디 모집

스터디 모집글 리스트 조회

검색 (제목 / 지역)

필터링 (시험종류 / 지역 / 목표점수)

스터디 모집글 작성

📌 고사장 지도 & 리뷰

네이버 지도 표시

학교 마커 표시

마커 클릭 시 하단 리뷰 바텀시트 표시 (1/3 높이)

리뷰 목록 조회

리뷰 작성 (학교 선택, 별점, 태그, 내용)

📌 마이페이지

사용자 정보 영역 (확장 예정)

🧱 프로젝트 구조
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

🚀 실행 방법
1. 패키지 설치
   flutter pub get

2. 환경변수 설정

프로젝트 루트에 .env 파일 생성:

NAVER_MAP_CLIENT_ID=네이버지도_클라이언트_ID


pubspec.yaml에 assets 등록:

flutter:
assets:
- .env

3. 앱 실행
   flutter run

🧠 아키텍처 개요
🔹 상태 관리

AppState (ChangeNotifier)

AppScope (InheritedNotifier)

전역 데이터와 로직을 한 곳에서 관리하며,
notifyListeners() 호출 시 UI가 자동 갱신됩니다.

UI → AppScope.of(context) → AppState → notifyListeners() → UI 갱신

🔹 데이터 흐름
스터디 모집
WriteStudyPage
↓ addStudyPost()
AppState.studyPosts
↓ filteredStudyPosts
StudyListPage 리스트 갱신

리뷰 작성
WriteReviewPage
↓ addReview()
AppState.reviewsByCenterId
↓ reviewsFor(centerId)
MapPage 바텀시트 자동 갱신

📦 주요 파일 설명
main.dart

Flutter 앱 진입점

dotenv 로드

네이버 지도 SDK 초기화

AppScope(AppState)로 앱 감싸기

app.dart

MaterialApp 설정

홈 화면(MainPage) 지정

state/app_state.dart

앱 전체 데이터와 비즈니스 로직 관리

포함 내용:

검색어 및 필터 상태

스터디 모집 데이터

고사장 데이터

리뷰 데이터

필터링된 스터디 계산 로직

리뷰 추가 / 모집글 추가 함수

state/app_scope.dart

AppState를 위젯 트리 전체에 전달하는 Provider 역할

사용 예:

final app = AppScope.of(context);

models/*

데이터 구조 정의

StudyPost: 스터디 모집 글

ExamCenter: 고사장(학교)

Review: 리뷰

pages/main_page.dart

하단 탭 네비게이션 관리

스터디 / 지도 / 마이페이지 전환

pages/study_list_page.dart

검색창

필터 버튼

스터디 리스트

모집글 작성 버튼

pages/write_study_page.dart

스터디 모집글 입력 폼

등록 시 AppState에 데이터 추가

widgets/filter_dialog.dart

시험종류 / 지역 / 목표점수 필터 선택 UI

pages/map_page.dart

네이버 지도 표시

학교 마커 생성

마커 클릭 → 리뷰 바텀시트 표시

리뷰 목록 실시간 반영

pages/write_review_page.dart

리뷰 작성 화면

별점 슬라이더

태그 입력

내용 입력

pages/my_page.dart

마이페이지 (확장 예정)