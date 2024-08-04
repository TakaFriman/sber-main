import 'package:flutter/material.dart';

class ProfileCards extends StatelessWidget {
  final String name;

  const ProfileCards({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 60,
          width: 60,
          child: ClipOval(
              child: Container(
                  color: const Color(0xFF383838),
                  child: Center(
                      child: Text(
                    getInitials(name),
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Color(0xFF959595)),
                  )))),
        ),
        const SizedBox(height: 5),
        SizedBox(
          width: 60,
          child: Text(
            name.split(' ').length == 2 ? '${name.split(' ').first}\n${name.split(' ')[1]} ' : name,
            softWrap: true,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Color(0xfff8f8f8), fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}

String getInitials(String fullName) {
  List<String> words = fullName.split(' ');
  if (words.length < 2) {
    return words[0][0].toUpperCase();
  }
  String initials = words[0][0] + words[1][0];
  return initials.toUpperCase();
}
