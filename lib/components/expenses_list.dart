import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:sber/models/check.dart';

import 'Expenses_card.dart';

String? incoming;
String? outgoing;
List<Chek> _checks = [];
Future<double> sumCasch<Check>(List<Check> checks) async {
  double sum = 0;
  List<Chek> checks = await CheckRepository.loadChecks();
  for (int i = 0; i < checks.length; i++) {
    if (checks[i].status == 'Исходящий перевод') {
      sum += checks[i].cash;
    }
  }
  return sum;
}

class ExpensesList extends StatefulWidget {
  const ExpensesList({
    super.key,
  });

  @override
  State<ExpensesList> createState() => _ExpensesListState();
}

class _ExpensesListState extends State<ExpensesList> {
  @override
  void initState() {
    super.initState();
    initializeDateFormatting('ru', null).then((_) {
      _loadChecks();
    });

    _loadChecks();
  }

  // Метод для загрузки чеков из локального хранилища
  void _loadChecks() async {
    try {
      List<Chek> loadedChecks = await CheckRepository.loadChecks();

      setState(() {
        _checks = loadedChecks;
      });

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

  String calculateTotalCashForStatus(String status) {
    double totalCash = 0;

    // Проходим по всем чекам
    for (var check in _checks) {
      // Если статус чека совпадает с заданным статусом, добавляем его сумму к общей сумме
      if (check.status == status) {
        totalCash += check.cash;
      }
    }

    // Возвращаем строковое представление общей суммы
    return '$totalCash';
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String month = DateFormat.MMMM('ru').format(now);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Row(
            children: [
              Text(
                'Расходы в $monthе',
                style: const TextStyle(
                    letterSpacing: -0.5, fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
              ),
              const Spacer(),
              const Text(
                'Все',
                style:
                    TextStyle(letterSpacing: -0.5, fontSize: 17, fontWeight: FontWeight.w500, color: Color(0xFF08A652)),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 180,
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            children: [
              Row(
                children: [
                  const SizedBox(
                    width: 15,
                  ),

                  Expenses(
                    cash: Text(
                      _checks.where((e) => e.status == 'Исходящий перевод').isEmpty
                          ? '${0} ₽'
                          : '${_checks.where(
                                (e) => e.status == 'Исходящий перевод',
                              ).where(
                                (e) => (DateFormat('MMMM', 'ru')
                                        .format(DateTime.tryParse(e.date) ?? DateTime.timestamp()) ==
                                    DateFormat('MMMM', 'ru').format(DateTime.now())),
                              ).map(
                                (e) => e.cash.toInt(),
                              ).toList().reduce(
                                (a, b) => a + b,
                              ).toString()} ₽',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    cardNumber: Text(
                      'Все расходы',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[400],
                      ),
                    ),
                    widget: SvgPicture.asset(
                      'assets/Расходы.svg',
                      width: 40,
                    ),
                  ),

                  const SizedBox(
                    width: 10,
                  ),
                  //====================================
                  Expenses(
                    cash: Text(
                      'Переводы людям',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[400],
                      ),
                    ),
                    cardNumber: Text(
                      _checks.where((e) => e.status == 'Исходящий перевод').isEmpty
                          ? '${0} ₽'
                          : '${_checks.where(
                                (e) => e.status == 'Исходящий перевод',
                              ).where(
                                (e) => (DateFormat('MMMM', 'ru')
                                        .format(DateTime.tryParse(e.date) ?? DateTime.timestamp()) ==
                                    DateFormat('MMMM', 'ru').format(DateTime.now())),
                              ).map(
                                (e) => e.cash.toInt(),
                              ).toList().reduce(
                                (a, b) => a + b,
                              ).toString()} ₽',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    widget: SvgPicture.asset(
                      'assets/Переводы.svg',
                      width: 40,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),

                  //====================================
                  Expenses(
                    cash: Text(
                      'Рестораны и кафе',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[400],
                      ),
                    ),
                    cardNumber: const Text(
                      '0 ₽',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    widget: SvgPicture.asset(
                      'assets/Food.svg',
                      width: 40,
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
