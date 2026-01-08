import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

import '../models/study_post.dart';
import '../models/exam_center.dart';
import '../models/review.dart';

class AppState extends ChangeNotifier {
  String searchQuery = "";
  String? filterExamType;
  String? filterRegion;
  String? filterTargetScore;

  final List<StudyPost> studyPosts = [
    const StudyPost(
      id: "s1",
      title: "대전 서구 토익 850+ 스터디 (주 2회)",
      examType: "TOEIC",
      region: "대전 서구",
      targetScore: "850+",
      members: 3,
      capacity: 6,
    ),
    const StudyPost(
      id: "s2",
      title: "토플 Speaking 집중 스터디 (온라인+오프)",
      examType: "TOEFL",
      region: "대전/온라인",
      targetScore: "100+",
      members: 4,
      capacity: 5,
    ),
    const StudyPost(
      id: "s3",
      title: "토익 RC 단기(2주) 스터디",
      examType: "TOEIC",
      region: "대전 둔산",
      targetScore: "800+",
      members: 2,
      capacity: 4,
    ),
  ];

  final List<ExamCenter> examCenters = const [
    ExamCenter(
      id: "gapcheon",
      name: "갑천중",
      address: "대전광역시 서구 월평동로 80",
      pos: NLatLng(36.3614357, 127.3685946),
    ),
    ExamCenter(
      id: "namseon",
      name: "남선중",
      address: "대전광역시 서구 월평북로 41 (월평동, 남선중학교)",
      pos: NLatLng(36.3626867, 127.3716957),
    ),
    ExamCenter(
      id: "dunsan",
      name: "둔산중",
      address: "대전광역시 서구 갈마역로25번길 70",
      pos: NLatLng(36.3534361, 127.3717582),
    ),
    ExamCenter(
      id: "mannyeon",
      name: "만년중",
      address: "대전광역시 서구 만년남로 17",
      pos: NLatLng(36.3666061, 127.3754713),
    ),
    ExamCenter(
      id: "munjeong",
      name: "문정중",
      address: "대전광역시 서구 둔산북로 232-11 (둔산동, 문정중학교)",
      pos: NLatLng(36.3551293, 127.4005347),
    ),
  ];

  final Map<String, List<Review>> reviewsByCenterId = {
    "gapcheon": [
      Review(
        id: "r1",
        author: "익명",
        rating: 4.5,
        tags: "조용함/책상 무난",
        content: "교실이 비교적 조용했고 감독 진행도 매끄러웠어요.",
        createdAt: DateTime(2026, 1, 5),
      ),
    ],
  };

  List<StudyPost> get filteredStudyPosts {
    return studyPosts.where((p) {
      final q = searchQuery.trim().toLowerCase();
      final matchesQuery = q.isEmpty ||
          p.title.toLowerCase().contains(q) ||
          p.region.toLowerCase().contains(q);

      final matchesExam = filterExamType == null || p.examType == filterExamType;
      final matchesRegion = filterRegion == null || p.region == filterRegion;
      final matchesScore =
          filterTargetScore == null || p.targetScore == filterTargetScore;

      return matchesQuery && matchesExam && matchesRegion && matchesScore;
    }).toList();
  }

  List<Review> reviewsFor(String centerId) =>
      List.unmodifiable(reviewsByCenterId[centerId] ?? const []);

  void setSearchQuery(String q) {
    searchQuery = q;
    notifyListeners();
  }

  void setFilters({String? examType, String? region, String? targetScore}) {
    filterExamType = examType;
    filterRegion = region;
    filterTargetScore = targetScore;
    notifyListeners();
  }

  void addReview({
    required String centerId,
    required String author,
    required double rating,
    required String tags,
    required String content,
  }) {
    final list = reviewsByCenterId.putIfAbsent(centerId, () => []);
    list.insert(
      0,
      Review(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        author: author.trim().isEmpty ? "익명" : author.trim(),
        rating: rating,
        tags: tags.trim(),
        content: content.trim(),
        createdAt: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void addStudyPost({
    required String title,
    required String examType,
    required String region,
    required String targetScore,
    required int capacity,
  }) {
    studyPosts.insert(
      0,
      StudyPost(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: title.trim(),
        examType: examType,
        region: region.trim(),
        targetScore: targetScore,
        members: 1,
        capacity: capacity,
      ),
    );
    notifyListeners();
  }
}
