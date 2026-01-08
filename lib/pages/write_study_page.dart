import 'package:flutter/material.dart';

import '../state/app_scope.dart';

class WriteStudyPage extends StatefulWidget {
  const WriteStudyPage({super.key});

  @override
  State<WriteStudyPage> createState() => _WriteStudyPageState();
}

class _WriteStudyPageState extends State<WriteStudyPage> {
  final titleCtrl = TextEditingController();
  String examType = "TOEIC";
  String region = "대전 서구";
  String targetScore = "850+";
  int capacity = 6;

  @override
  void dispose() {
    titleCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (titleCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("제목을 입력해줘")),
      );
      return;
    }

    AppScope.of(context).addStudyPost(
      title: titleCtrl.text,
      examType: examType,
      region: region,
      targetScore: targetScore,
      capacity: capacity,
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("모집글 쓰기"),
        actions: [
          TextButton(
            onPressed: _submit,
            child: const Text("등록", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: titleCtrl,
            decoration: const InputDecoration(
              labelText: "제목",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 14),
          DropdownButtonFormField<String>(
            value: examType,
            decoration: const InputDecoration(
              labelText: "시험종류",
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: "TOEIC", child: Text("TOEIC")),
              DropdownMenuItem(value: "TOEFL", child: Text("TOEFL")),
            ],
            onChanged: (v) => setState(() => examType = v ?? "TOEIC"),
          ),
          const SizedBox(height: 14),
          DropdownButtonFormField<String>(
            value: region,
            decoration: const InputDecoration(
              labelText: "지역",
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: "대전 서구", child: Text("대전 서구")),
              DropdownMenuItem(value: "대전 둔산", child: Text("대전 둔산")),
              DropdownMenuItem(value: "대전/온라인", child: Text("대전/온라인")),
            ],
            onChanged: (v) => setState(() => region = v ?? "대전 서구"),
          ),
          const SizedBox(height: 14),
          DropdownButtonFormField<String>(
            value: targetScore,
            decoration: const InputDecoration(
              labelText: "목표 점수",
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: "800+", child: Text("800+")),
              DropdownMenuItem(value: "850+", child: Text("850+")),
              DropdownMenuItem(value: "900+", child: Text("900+")),
              DropdownMenuItem(value: "100+", child: Text("100+")),
            ],
            onChanged: (v) => setState(() => targetScore = v ?? "850+"),
          ),
          const SizedBox(height: 14),
          DropdownButtonFormField<int>(
            value: capacity,
            decoration: const InputDecoration(
              labelText: "정원",
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 3, child: Text("3명")),
              DropdownMenuItem(value: 4, child: Text("4명")),
              DropdownMenuItem(value: 5, child: Text("5명")),
              DropdownMenuItem(value: 6, child: Text("6명")),
              DropdownMenuItem(value: 8, child: Text("8명")),
            ],
            onChanged: (v) => setState(() => capacity = v ?? 6),
          ),
          const SizedBox(height: 18),
          ElevatedButton.icon(
            onPressed: _submit,
            icon: const Icon(Icons.check),
            label: const Text("모집글 등록"),
          ),
        ],
      ),
    );
  }
}
