import 'package:flutter/material.dart';

class FilterResult {
  final String? examType;
  final String? region;
  final String? targetScore;

  const FilterResult({this.examType, this.region, this.targetScore});
}

class FilterDialog extends StatefulWidget {
  final String? initialExamType;
  final String? initialRegion;
  final String? initialTargetScore;

  const FilterDialog({
    super.key,
    this.initialExamType,
    this.initialRegion,
    this.initialTargetScore,
  });

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  String? examType;
  String? region;
  String? targetScore;

  final examTypes = const <String>["TOEIC", "TOEFL"];
  final regions = const <String>["대전 서구", "대전 둔산", "대전/온라인"];
  final scores = const <String>["800+", "850+", "900+", "100+"];

  @override
  void initState() {
    super.initState();
    examType = widget.initialExamType;
    region = widget.initialRegion;
    targetScore = widget.initialTargetScore;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("필터 설정"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _dropdown(
              label: "시험종류",
              value: examType,
              items: examTypes,
              onChanged: (v) => setState(() => examType = v),
            ),
            const SizedBox(height: 12),
            _dropdown(
              label: "지역",
              value: region,
              items: regions,
              onChanged: (v) => setState(() => region = v),
            ),
            const SizedBox(height: 12),
            _dropdown(
              label: "목표 점수",
              value: targetScore,
              items: scores,
              onChanged: (v) => setState(() => targetScore = v),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => setState(() {
                examType = null;
                region = null;
                targetScore = null;
              }),
              child: const Text("필터 초기화"),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("취소"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(
              context,
              FilterResult(
                examType: examType,
                region: region,
                targetScore: targetScore,
              ),
            );
          },
          child: const Text("적용"),
        ),
      ],
    );
  }

  Widget _dropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      value: value,
      items: [
        const DropdownMenuItem(value: null, child: Text("전체")),
        ...items.map((e) => DropdownMenuItem(value: e, child: Text(e))),
      ],
      onChanged: onChanged,
    );
  }
}
