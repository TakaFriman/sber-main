import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sber/pages/profile_page.dart';

import '../models/profile.dart';

class CustomAppBar extends StatelessWidget {
  final CreditCard myCreditCard;
  const CustomAppBar({super.key, required this.myCreditCard});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 0),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(
                    myCreditCard: myCreditCard,
                  ),
                ),
              );
            },
            child: SizedBox(
              width: 38,
              height: 38,
              child: ClipOval(
                  child: Container(
                      padding: const EdgeInsets.only(top: 2),
                      color: const Color.fromARGB(255, 40, 39, 39),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                      ))),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              cursorColor: Colors.grey,
              decoration: InputDecoration(
                  suffixIcon: const SizedBox(),
                  hintText: 'Поиск',
                  isDense: true,
                  hintStyle: const TextStyle(color: Color(0xFFB3BDC6), fontSize: 14),
                  contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: const Color.fromRGBO(0, 0, 0, 0.4)),
            ),
          ),
          const SizedBox(width: 20),
          SvgPicture.asset(
            'assets/Flag.svg',
            width: 20,
            height: 20,
          ),
          const SizedBox(width: 15),
          SvgPicture.asset(
            'assets/Окно.svg',
            width: 20,
            height: 20,
          ),
        ],
      ),
    );
  }
}
