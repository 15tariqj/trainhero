import 'package:flutter/material.dart';

class OutlineButton extends StatelessWidget {
  final String text;

  const OutlineButton({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xfb40284a),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Color(0xfb40284a),
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
