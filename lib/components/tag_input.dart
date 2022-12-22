import 'package:flutter/material.dart';

typedef OnTagChanged = Function(List<String> tags);

class TagInput extends StatefulWidget {
  final OnTagChanged onTagChanged;
  const TagInput(this.onTagChanged, {Key? key}) : super(key: key);

  @override
  State<TagInput> createState() => _TagInputState();
}

class _TagInputState extends State<TagInput> {

  void _handleConfirm(String input) {
    var tags = input.split(" ")
        .map((e) {
          var trim = e.trim();
          return trim;
        })
        .where((element) => element.isNotEmpty).toList();
    widget.onTagChanged(tags);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text("Tags: "),
        Expanded(child: TextField(onSubmitted: _handleConfirm,))
      ],
    );
  }
}
