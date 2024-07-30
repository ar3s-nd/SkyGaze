import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Textfield extends StatelessWidget {
  TextEditingController controller = TextEditingController();
  Textfield({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Type here...',
        ),
      ),
    );
  }
}