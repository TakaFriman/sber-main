import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sber/models/profile.dart';
import 'package:sber/pages/history_page.dart';
import 'package:sber/pages/profile_page.dart';

class HistoryAppBar extends StatefulWidget {
  final CreditCard myCreditCard;
  final Function(String) onSearchAmountChanged; // Объявляем callback
  final VoidCallback resetCheck; // Объявляем callback

  const HistoryAppBar({
    Key? key,
    required this.onSearchAmountChanged,
    required this.resetCheck,
    required this.myCreditCard,
    // Передаем callback в конструкторе
  }) : super(key: key);

  @override
  State<HistoryAppBar> createState() => _HistoryAppBarState();
}

class _HistoryAppBarState extends State<HistoryAppBar> {
  bool isLoading = false;
  bool _showClearButton = false;
  Timer? _debounce;
  late TextEditingController searchAmount;

  @override
  void initState() {
    super.initState();
    searchAmount = TextEditingController();
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (value.isEmpty) {
        setState(() {
          _showClearButton = false;
          isLoading = true;

          widget.resetCheck();
          widget.onSearchAmountChanged(value);
          inserach = true;
        });
      } else {
        setState(() {
          widget.resetCheck();

          _showClearButton = true;
          widget.onSearchAmountChanged(value);
          inserach = false;
        });
      }
    });
  }

  void _clearText() {
    searchAmount.clear();
    setState(() {
      _showClearButton = false;
    });
    widget.resetCheck();
    inserach = true;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchAmount.dispose();
    inserach = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 48, bottom: 12),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF151515), Color(0xFF151515)],
          begin: Alignment.center,
          end: Alignment.center,
        ),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(
                    myCreditCard: widget.myCreditCard,
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
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              cursorColor: Colors.grey,
              style: const TextStyle(color: Color(0xFFB3BDC6), fontSize: 14),
              onChanged: _onSearchChanged,
              controller: searchAmount,
              decoration: InputDecoration(
                suffixIcon: _showClearButton
                    ? IconButton(
                        icon: const Icon(
                          Icons.clear,
                          color: Color(0xFFB3BDC6),
                          size: 16,
                        ),
                        onPressed: _clearText,
                      )
                    : const SizedBox(),
                hintText: 'Поиск',
                isDense: true,
                hintStyle: const TextStyle(color: Color(0xFFB3BDC6), fontSize: 14),
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.black87,
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}
