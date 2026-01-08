import 'package:flutter_naver_map/flutter_naver_map.dart';

class ExamCenter {
  final String id;
  final String name;
  final String address;
  final NLatLng pos;

  const ExamCenter({
    required this.id,
    required this.name,
    required this.address,
    required this.pos,
  });
}
