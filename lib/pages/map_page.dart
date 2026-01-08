import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

import '../models/exam_center.dart';
import '../state/app_scope.dart';
import 'write_review_page.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  static const initial = NLatLng(36.3600, 127.3780);

  void _openReviewSheet(ExamCenter center) {
    final app = AppScope.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        // AppState가 바뀌면(리뷰 등록) 자동 갱신
        return AnimatedBuilder(
          animation: app,
          builder: (_, __) {
            final reviews = app.reviewsFor(center.id);

            return DraggableScrollableSheet(
              initialChildSize: 0.33,
              minChildSize: 0.20,
              maxChildSize: 0.90,
              expand: false,
              builder: (context, scrollController) {
                return Column(
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      width: 42,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    const SizedBox(height: 12),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.school),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  center.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  center.address,
                                  style: const TextStyle(color: Colors.black54),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => WriteReviewPage(
                                    centers: app.examCenters,
                                    preselectCenterId: center.id,
                                  ),
                                ),
                              );
                            },
                            child: const Text("리뷰쓰기"),
                          )
                        ],
                      ),
                    ),
                    const Divider(height: 16),

                    Expanded(
                      child: reviews.isEmpty
                          ? const Center(child: Text("아직 리뷰가 없어요."))
                          : ListView.separated(
                        controller: scrollController,
                        itemCount: reviews.length,
                        separatorBuilder: (_, __) =>
                        const Divider(height: 1),
                        itemBuilder: (context, i) {
                          final r = reviews[i];
                          return ListTile(
                            title: Text(
                              "${r.rating.toStringAsFixed(1)} ⭐  ·  ${r.tags}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(r.content),
                            trailing: Text(
                              "${r.createdAt.month}/${r.createdAt.day}",
                              style:
                              const TextStyle(color: Colors.black45),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final safeAreaPadding = MediaQuery.paddingOf(context);

    return Scaffold(
      appBar: AppBar(title: const Text("고사장 지도")),
      body: NaverMap(
        options: NaverMapViewOptions(
          contentPadding: safeAreaPadding,
          initialCameraPosition:
          const NCameraPosition(target: initial, zoom: 13),
        ),
        onMapReady: (controller) async {
          for (final c in app.examCenters) {
            final marker = NMarker(
              id: c.id,
              position: c.pos,
              caption: NOverlayCaption(text: c.name),
            );
            marker.setOnTapListener((overlay) {
              _openReviewSheet(c);
              return true;
            });
            await controller.addOverlay(marker);
          }
        },
      ),
    );
  }
}
