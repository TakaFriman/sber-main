import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sber/components/date_and_history_chek.dart';
import 'package:sber/components/history_appbar.dart';
import 'package:sber/components/title_history.dart';
import 'package:sber/models/check.dart';
import 'package:sber/models/profile.dart';
import 'package:sber/pages/chek_about.dart';
import 'package:sber/pages/home_page.dart';
import 'package:sber/pages/incoming_page.dart';

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
  // final bool _isFirstLoad = true;

  String calculateTotalCashForStatus(String status) {
    double totalCash = 0;

    // Проходим по всем чекам
    for (var check in _checks) {
      final currentMonth = DateFormat('MMMM', 'ru').format(DateTime.now());
      final month = DateFormat('MMMM', 'ru').format(DateTime.tryParse(check.date) ?? DateTime.timestamp());

      if (check.status == status && month == currentMonth) {
        totalCash += check.cash;
      }
    }

    // Возвращаем строковое представление общей суммы
    return '$totalCash';
  }

  List<Chek> _checks = [];
  List<Chek> _newChecks = [];
  Future<void> _refresh() async {
    setState(() {
      enabled1 = true;
    });
    //final random = Random();
    //final delaySeconds = random.nextInt(2);
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      enabled1 = false;
    });
  }

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Вызов функции, которая изменяет состояние isLoading после случайного времени
    _simulateLoading();
    _loadChecks();
  }

  // Метод для загрузки чеков из локального хранилища
  void _loadChecks() async {
    try {
      List<Chek> loadedChecks = await CheckRepository.loadChecks();
      // _checks = sortChecksByDate(loadedChecks);
      setState(() {
        _checks = loadedChecks;
      });
      incoming = calculateTotalCashForStatus('Входящий перевод');
      outgoing = calculateTotalCashForStatus('Исходящий перевод');
      // print('Загруженные чеки:');
      // print(_checks.length);
      // for (var check in _checks) {
      //   print('Дата: ${check.date}, ФИО: ${check.fio}, Сумма: ${check.cash}');
      // }
    } catch (e) {
      // Обработка ошибок, если загрузка не удалась
      // ignore: avoid_print
      print('Ошибка при загрузке чеков: $e');
    }
  }

  String calculateTotalCashForDate(String currentDate) {
    double totalCash = 0;

    // Проходим по всем чекам
    for (var check in _checks) {
      // Если дата чека совпадает с текущей датой, добавляем его сумму к общей сумме
      if (check.date == currentDate) {
        totalCash += check.cash;
      }
    }

    // Возвращаем строковое представление общей суммы
    return '$totalCash';
  }

  // void filterChecksByAmount(double amount) {
  //   setState(() {
  //     // Фильтруем чеки на основе введенной суммы
  //     _newChecks = _checks
  //         .where((check) => (check.cash - amount).abs() < 0.0001)
  //         .toList();
  //     _checks = _newChecks;
  //   });
  // }
  void filterChecks(String searchText) {
    setState(() {
      // Фильтруем чеки на основе введенного текста
      _newChecks = _checks.where((check) {
        // Получаем строковое представление суммы чека и имени
        String cashString = check.cash.toString().toLowerCase();
        String name = check.fio.toLowerCase();

        // Проверяем, начинается ли строка с цифры или буквы
        bool isNumericSearch = isNumeric(searchText[0]);

        if (isNumericSearch) {
          // Поиск по сумме чека (cash)
          return cashString.startsWith(searchText.toLowerCase());
        } else {
          // Поиск по имени (fio)
          return name.startsWith(searchText.toLowerCase());
        }
      }).toList();
      _checks = _newChecks;
    });
  }

  bool isNumeric(String str) {
    return double.tryParse(str) != null;
  }

  String outCalculateTotalCashForDate(String currentDate, String status) {
    double totalCash = 0;

    // Проходим по всем чекам
    for (var check in _checks) {
      // Если дата чека совпадает с текущей датой и статус чека равен указанному статусу,
      // добавляем его сумму к общей сумме
      if (check.date == currentDate && check.status == status) {
        totalCash += check.cash;
      }
    }

    // Возвращаем строковое представление общей суммы
    return '$totalCash';
  }

  void resetChecks() {
    setState(() {
      // Сбрасываем фильтр и показываем все чеки
      _loadChecks();
    });
  }

  // Функция, которая имитирует загрузку данных
  Future<void> _simulateLoading() async {
    // Генерация случайного времени от 1 до 2 секунд

    final random = Random();
    final delaySeconds = random.nextInt(2) + 1;

    setState(() {
      enabled1 = true;
    });
    // Задержка на случайное время
    await Future.delayed(Duration(seconds: delaySeconds));

    // После задержки обновляем состояние, чтобы скрыть индикатор загрузки

    setState(() {
      isLoading = false;
      enabled1 = false;
    });
  }

  // static int extractFirstNumberFromString(String input) {
  //   RegExp regex = RegExp(r'\d+');
  //   Match? match = regex.firstMatch(input);
  //   if (match != null) {
  //     return int.parse(match.group(0)!);
  //   } else {
  //     return 0; // Возвращаем 0, если не найдено ни одного числа
  //   }
  // }

  // Метод для сортировки списка экземпляров класса Chek по дате
  static List<Chek> sortChecksByDate(List<Chek> checks) {
    checks.sort((a, b) => a.date.compareTo(b.date));
    return checks;
  }

  @override
  Widget build(BuildContext context) {
    // Сортируем список чеков по дате
    _checks = sortChecksByDate(_checks);

    // Создаем список уникальных дат
    List<String> uniqueDates = _checks.map((check) => check.date).toSet().toList();
    // uniqueDates.sort((a, b) => b.compareTo(a));
    uniqueDates = uniqueDates.reversed.toList();
    return Stack(
      children: [
        RefreshIndicator(
          backgroundColor: Colors.black,
          color: const Color(0xFF08A652),
          onRefresh: _refresh,
          displacement: 40,
          edgeOffset: 300.0,
          child: ListView.builder(
            itemCount: uniqueDates.length,
            itemBuilder: (context, index) {
              // Получаем текущую дату
              String currentDate = uniqueDates[index];
              var outSum = outCalculateTotalCashForDate(currentDate, 'Исходящий перевод');
              // Создаем виджет DateChek для текущей даты
              Widget dateChek = DateChek(
                date: currentDate,
                cash: calculateTotalCashForDate(currentDate),
                totalCash: outSum,
              );

              // Фильтруем чеки по текущей дате
              List<Chek> filteredChecks = _checks.where((check) => check.date == currentDate).toList();
              if (searchAmount != null) {
                filteredChecks = filteredChecks
                    // ignore: unrelated_type_equality_checks
                    .where((check) => check.cash == searchAmount)
                    .toList();
              }
              // Создаем виджеты ChekHistory для отфильтрованных чеков
              List<Widget> chekHistoryWidgets = filteredChecks
                  .map((check) => InkWell(
                        onTap: () {
                          check.status == "Исходящий перевод"
                              ?
                              // При нажатии на чек открываем экран с подробной информацией о чеке
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CheckDetailsScreen(
                                      check: check,
                                      myCreditCart: widget.myCreditCard,
                                    ),
                                  ),
                                )
                              : // При нажатии на чек открываем экран с подробной информацией о чеке
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => IncomingPage(
                                      chek: check,
                                      myCreditCard: widget.myCreditCard,
                                    ),
                                  ),
                                );
                        },
                        splashColor: Colors.grey, // Цвет всплеска при нажатии
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

              // Возвращаем виджеты в списке
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
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      child: Column(
                        children: [
                          // Показываем HistoryAppBar только если не идет поиск
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
        // Показываем Container только при первой загрузке

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
                SelectBar(text: 'Карты и счета')
              ],
            ),
          ],
        ),
      ),
    );
  }
}
