import 'package:flutter/material.dart';

import '../models/exam_center.dart';
import '../state/app_scope.dart';

class WriteReviewPage extends StatefulWidget {
  final List<ExamCenter> centers;
  final String? preselectCenterId;

  const WriteReviewPage({
    super.key,
    required this.centers,
    this.preselectCenterId,
  });

  @override
  State<WriteReviewPage> createState() => _WriteReviewPageState();
}

class _WriteReviewPageState extends State<WriteReviewPage> {
  String? centerId;
  double rating = 4.0;

  final authorCtrl = TextEditingController();
  final tagsCtrl = TextEditingController(text: "조용함/책상/난방");
  final contentCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    centerId = widget.preselectCenterId ?? widget.centers.first.id;
  }

  @override
  void dispose() {
    authorCtrl.dispose();
    tagsCtrl.dispose();
    contentCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final app = AppScope.of(context);

    final cid = centerId;
    if (cid == null) return;

    if (contentCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("리뷰 내용을 입력해줘")),
      );
      return;
    }

    app.addReview(
      centerId: cid,
      author: authorCtrl.text,
      rating: rating,
      tags: tagsCtrl.text,
      content: contentCtrl.text,
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final centers = widget.centers;

    return Scaffold(
      appBar: AppBar(
        title: const Text("리뷰 쓰기"),
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
          DropdownButtonFormField<String>(
            value: centerId,
            decoration: const InputDecoration(
              labelText: "고사장(학교)",
              border: OutlineInputBorder(),
            ),
            items: centers
                .map((c) => DropdownMenuItem(value: c.id, child: Text(c.name)))
                .toList(),
            onChanged: (v) => setState(() => centerId = v),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: authorCtrl,
            decoration: const InputDecoration(
              labelText: "작성자(선택)",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            "평점: ${rating.toStringAsFixed(1)}",
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Slider(
            value: rating,
            min: 1.0,
            max: 5.0,
            divisions: 8,
            label: rating.toStringAsFixed(1),
            onChanged: (v) => setState(() => rating = v),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: tagsCtrl,
            decoration: const InputDecoration(
              labelText: "태그(예: 조용함/화장실/난방)",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: contentCtrl,
            minLines: 4,
            maxLines: 8,
            decoration: const InputDecoration(
              labelText: "리뷰 내용",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 18),
          ElevatedButton.icon(
            onPressed: _submit,
            icon: const Icon(Icons.check),
            label: const Text("리뷰 등록"),
          ),
        ],
      ),
    );
  }
}
