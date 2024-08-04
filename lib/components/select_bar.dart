import 'package:flutter/material.dart';

class SelectBar extends StatelessWidget {
  final String text;
  const SelectBar({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF2e2e2e),
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
        child: Row(
          children: [
            Text(
              text,
              style: const TextStyle(color: Color(0xFFdedede)),
            ),
            const SizedBox(
              width: 10,
            ),
            Icon(
              size: 24,
              Icons.keyboard_arrow_down_outlined,
              color: Colors.grey.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }
}
