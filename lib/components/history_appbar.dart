import 'package:flutter/material.dart';

import '../pages/history_page.dart';

TextEditingController? searchAmount;

class HistoryAppBar extends StatefulWidget {
  final Function(String) onSearchAmountChanged; // Объявляем callback
  final VoidCallback resetCheck; // Объявляем callback

  const HistoryAppBar({
    Key? key,
    required this.onSearchAmountChanged,
    required this.resetCheck, // Передаем callback в конструкторе
  }) : super(key: key);

  @override
  State<HistoryAppBar> createState() => _HistoryAppBarState();
}

class _HistoryAppBarState extends State<HistoryAppBar> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 32),
        decoration: const BoxDecoration(
          // color: Colors.transparent,
          gradient: LinearGradient(
            colors: [Color(0xFF151515), Color(0xFF151515)],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            children: [
              SizedBox(
                width: 35,
                height: 35,
                child: ClipOval(
                    child: Container(
                        color: const Color(0xFFEDEFEF),
                        child: const Icon(
                          Icons.person,
                          color: Color(0xFFc1c4c9),
                        ))),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  style: const TextStyle(color: Color(0xFFB3BDC6), fontSize: 14),
                  onChanged: (value) {
                    setState(() {
                      isLoading = true;
                      inserach = true;
                    });

                    if (value.isNotEmpty) {
                      setState(() {
                        inserach = false;
                      });

                      widget.onSearchAmountChanged(value);
                    } else {
                      setState(() {
                        inserach = true;
                      });
                      widget.resetCheck();
                    }
                  },
                  controller: searchAmount,
                  decoration: InputDecoration(
                      hintText: 'Поиск',
                      isDense: true,
                      hintStyle: const TextStyle(color: Color(0xFFB3BDC6), fontSize: 14),
                      contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.black87),
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
        ));
  }
}
