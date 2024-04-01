import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class InputWithIcon extends HookWidget {
  final IconData icon;
  final String hint;
  final TextEditingController controller;
  final bool isPasswordField;

  const InputWithIcon({
    super.key,
    required this.icon,
    required this.hint,
    required this.controller,
    this.isPasswordField = false,
  });

  @override
  Widget build(BuildContext context) {
    final inFocus = useState(false);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutCubic,
      decoration: BoxDecoration(
          color: const Color(0xffEAEAEA),
          border: Border.all(
            color: inFocus.value ? const Color(0xFFD9D9E2) : const Color(0xffEAEAEA),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: <Widget>[
          Expanded(
            child: FocusScope(
              child: Focus(
                onFocusChange: (focus) {
                  inFocus.value = !inFocus.value;
                },
                child: TextField(
                  obscureText: isPasswordField,
                  controller: controller,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    border: InputBorder.none,
                    hintText: hint,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
