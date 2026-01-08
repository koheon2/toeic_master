import 'package:flutter/material.dart';

import '../state/app_scope.dart';
import '../widgets/filter_dialog.dart';
import 'write_study_page.dart';

class StudyListPage extends StatefulWidget {
  const StudyListPage({super.key});

  @override
  State<StudyListPage> createState() => _StudyListPageState();
}

class _StudyListPageState extends State<StudyListPage> {
  late final TextEditingController _searchCtrl;

  @override
  void initState() {
    super.initState();
    _searchCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _openFilterDialog() async {
    final app = AppScope.of(context);

    final result = await showDialog<FilterResult>(
      context: context,
      builder: (_) => FilterDialog(
        initialExamType: app.filterExamType,
        initialRegion: app.filterRegion,
        initialTargetScore: app.filterTargetScore,
      ),
    );

    if (result == null) return;
    app.setFilters(
      examType: result.examType,
      region: result.region,
      targetScore: result.targetScore,
    );
  }

  Future<void> _openWriteStudy() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const WriteStudyPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final posts = app.filteredStudyPosts;

    return Scaffold(
      appBar: AppBar(title: const Text("스터디 모집")),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openWriteStudy,
        icon: const Icon(Icons.edit),
        label: const Text("모집글쓰기"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchCtrl,
                    onChanged: app.setSearchQuery,
                    decoration: const InputDecoration(
                      hintText: "검색(제목/지역)",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  tooltip: "필터",
                  onPressed: _openFilterDialog,
                  icon: const Icon(Icons.tune),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  Chip(label: Text("시험: ${app.filterExamType ?? '전체'}")),
                  Chip(label: Text("지역: ${app.filterRegion ?? '전체'}")),
                  Chip(label: Text("목표: ${app.filterTargetScore ?? '전체'}")),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Divider(height: 1),
          Expanded(
            child: posts.isEmpty
                ? const Center(child: Text("조건에 맞는 스터디가 없어요."))
                : ListView.separated(
              itemCount: posts.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final p = posts[i];
                return ListTile(
                  leading: const Icon(Icons.campaign),
                  title: Text(p.title),
                  subtitle: Text(
                    "${p.examType} · ${p.region} · ${p.targetScore} · ${p.members}/${p.capacity}명",
                  ),
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("여기에 스터디 상세/신청 연결")),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
