import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:sber/components/date_and_history_chek.dart';
import 'package:sber/components/history_appbar.dart';
import 'package:sber/components/title_history.dart';
import 'package:sber/models/check.dart';
import 'package:sber/models/profile.dart';
import 'package:sber/pages/chek_about.dart';
import 'package:sber/pages/home_page.dart';
import 'package:sber/pages/incoming_page.dart';
import 'package:sber/theme/colors.dart';

import '../components/select_bar.dart';

bool inserach = true;
bool? isSearching;
String? incoming;
String? outgoing;

class HistoryPage extends StatefulWidget {
  final CreditCard myCreditCard;
  const HistoryPage({super.key, required this.myCreditCard});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String calculateTotalCashForStatus(String status) {
    double totalCash = 0;

    for (var check in _checks) {
      final currentMonth = DateFormat('MMMM', 'ru').format(DateTime.now());
      final month = DateFormat('MMMM', 'ru').format(DateTime.tryParse(check.date) ?? DateTime.timestamp());

      if (check.status == status && month == currentMonth) {
        totalCash += check.cash;
      }
    }

    return '$totalCash';
  }

  bool noResults = false;

  List<Chek> _checks = [];
  List<Chek> _newChecks = [];
  Future<void> _refresh() async {
    setState(() {
      enabled1 = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      enabled1 = false;
    });
  }

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _simulateLoading();
    _loadChecks();
  }

  void _loadChecks() async {
    try {
      List<Chek> loadedChecks = await CheckRepository.loadChecks();
      setState(() {
        _checks = loadedChecks;
        _newChecks = loadedChecks;
      });
      incoming = calculateTotalCashForStatus('Входящий перевод');
      outgoing = calculateTotalCashForStatus('Исходящий перевод');
    } catch (e) {
      print('Ошибка при загрузке чеков: $e');
    }
  }

  String calculateTotalCashForDate(String currentDate) {
    double totalCash = 0;

    for (var check in _checks) {
      if (check.date == currentDate) {
        totalCash += check.cash;
      }
    }

    return '$totalCash';
  }

  void filterChecks(String searchText) {
    setState(() {
      if (searchText.isEmpty) {
        _newChecks = _checks;
        noResults = false;
      } else {
        _newChecks = _checks.where((check) {
          String cashString = check.cash.toString().toLowerCase();
          String name = check.fio.toLowerCase();
          bool isNumericSearch = isNumeric(searchText[0]);

          if (isNumericSearch) {
            return cashString.startsWith(searchText.toLowerCase());
          } else {
            return name.startsWith(searchText.toLowerCase());
          }
        }).toList();

        noResults = _newChecks.isEmpty;
      }
    });
  }

  bool isNumeric(String str) {
    return double.tryParse(str) != null;
  }

  String outCalculateTotalCashForDate(String currentDate, String status) {
    double totalCash = 0;

    for (var check in _checks) {
      if (check.date == currentDate && check.status == status) {
        totalCash += check.cash;
      }
    }

    return '$totalCash';
  }

  void resetChecks() {
    setState(() {
      _newChecks = _checks;
      noResults = false;
    });
  }

  Future<void> _simulateLoading() async {
    final random = Random();
    final delaySeconds = random.nextInt(2) + 1;

    setState(() {
      enabled1 = true;
    });

    await Future.delayed(Duration(seconds: delaySeconds));

    setState(() {
      isLoading = false;
      enabled1 = false;
    });
  }

  static List<Chek> sortChecksByDate(List<Chek> checks) {
    checks.sort((a, b) => a.date.compareTo(b.date));
    return checks;
  }

  @override
  Widget build(BuildContext context) {
    _checks = sortChecksByDate(_checks);
    List<String> uniqueDates = _newChecks.map((check) => check.date).toSet().toList();
    uniqueDates = uniqueDates.reversed.toList();

    return Stack(
      children: [
        RefreshIndicator(
          backgroundColor: Colors.black,
          color: const Color(0xFF08A652),
          onRefresh: _refresh,
          displacement: 40,
          edgeOffset: 300.0,
          child: noResults
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ).copyWith(top: 148),
                  child: Column(
                    children: [
                      const Text(
                        'Ничего не нашлось',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Проверьте, что в запросе нет опечаток',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      const SizedBox(height: 30),
                      Container(
                        decoration: BoxDecoration(
                          color: BODY_DARK_GRAY,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              titleAlignment: ListTileTitleAlignment.titleHeight,
                              leading: SvgPicture.asset(
                                'assets/Виджет.svg',
                                width: 30,
                              ),
                              title: const Text('Все сервисы', style: TextStyle(color: Colors.white)),
                              subtitle: const Text('Продукты экосистемы Сбера и партнёров',
                                  style: TextStyle(color: Colors.grey)),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 62, right: 15),
                              child: Divider(
                                height: 10,
                                color: Color.fromARGB(255, 74, 74, 74),
                              ),
                            ),
                            ListTile(
                              titleAlignment: ListTileTitleAlignment.titleHeight,
                              leading: SvgPicture.asset(
                                'assets/Виджет.svg',
                                width: 30,
                              ),
                              title: const Text('Подсказки и обучение', style: TextStyle(color: Colors.white)),
                              subtitle: const Text('Всё о сервисах банка и возможностях приложения',
                                  style: TextStyle(color: Colors.grey)),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 62, right: 15),
                              child: Divider(
                                height: 10,
                                color: Color.fromARGB(255, 74, 74, 74),
                              ),
                            ),
                            ListTile(
                              titleAlignment: ListTileTitleAlignment.titleHeight,
                              leading: SvgPicture.asset(
                                'assets/Виджет.svg',
                                width: 30,
                              ),
                              title: const Text('Оплата по реквизитам', style: TextStyle(color: Colors.white)),
                              subtitle: const Text('Компаниям за услуги', style: TextStyle(color: Colors.grey)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: uniqueDates.length,
                  itemBuilder: (context, index) {
                    String currentDate = uniqueDates[index];
                    var outSum = outCalculateTotalCashForDate(currentDate, 'Исходящий перевод');
                    Widget dateChek = DateChek(
                      date: currentDate,
                      cash: calculateTotalCashForDate(currentDate),
                      totalCash: outSum,
                    );

                    List<Chek> filteredChecks = _newChecks.where((check) => check.date == currentDate).toList();
                    if (searchAmount != null) {
                      filteredChecks = filteredChecks.where((check) => check.cash == searchAmount).toList();
                    }
                    List<Widget> chekHistoryWidgets = filteredChecks
                        .map((check) => InkWell(
                              onTap: () {
                                check.status == "Исходящий перевод"
                                    ? Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CheckDetailsScreen(
                                            check: check,
                                            myCreditCart: widget.myCreditCard,
                                          ),
                                        ),
                                      )
                                    : Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => IncomingPage(
                                            chek: check,
                                            myCreditCard: widget.myCreditCard,
                                          ),
                                        ),
                                      );
                              },
                              splashColor: Colors.grey,
                              highlightColor: Colors.transparent,
                              child: ChekHistory(
                                fio: check.fio,
                                type: check.status,
                                cash: check.cash,
                                icon: check.icon,
                              ),
                            ))
                        .toList()
                        .reversed
                        .toList();

                    return Column(
                      children: [
                        if (index == 0 && !inserach)
                          const SizedBox(
                            height: 70,
                          ),
                        if (index == 0 && (inserach))
                          Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(23),
                                bottomRight: Radius.circular(23),
                              ),
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFF0e0e0e),
                                  Color(0xFF0f0f0f),
                                  Color(0xFF111110),
                                  Color(0xFF131312),
                                  Color(0xFF151514),
                                ],
                                begin: Alignment.center,
                                end: Alignment.center,
                              ),
                            ),
                            child: Column(
                              children: [
                                TitleHistory(
                                  incoming: incoming!,
                                  outgoing: outgoing!,
                                ),
                                const SelectBarList(),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        Center(
                            child: isLoading
                                ? Center(
                                    child: (index == 0)
                                        ? const Padding(
                                            padding: EdgeInsets.only(top: 68.0),
                                            child: CircularProgressIndicator(
                                              color: Color(0xFF08A652),
                                            ),
                                          )
                                        : const Text(''))
                                : Column(
                                    children: [
                                      dateChek,
                                      ...chekHistoryWidgets,
                                    ],
                                  )),
                      ],
                    );
                  },
                ),
        ),
        HistoryAppBar(
          onSearchAmountChanged: filterChecks,
          resetCheck: resetChecks,
        ),
      ],
    );
  }
}

class SelectBarList extends StatelessWidget {
  const SelectBarList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: SizedBox(
        height: 60,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: const [
            Row(
              children: [
                SelectBar(text: 'Тип операций'),
                SizedBox(
                  width: 10,
                ),
                SelectBar(text: 'Период'),
                SizedBox(
                  width: 10,
                ),
                SelectBar(text: 'Карта и счёт'),
                SizedBox(
                  width: 10,
                ),
                SelectBar(text: 'Сумма'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
