import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sber/components/date_and_history_chek.dart';

class AnalysMoneyPage extends StatefulWidget {
  const AnalysMoneyPage({super.key, required this.incoming, required this.outgoing});
  final String incoming;
  final String outgoing;
  @override
  _AnalysMoneyPageState createState() => _AnalysMoneyPageState();
}

class _AnalysMoneyPageState extends State<AnalysMoneyPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _months = [
    'Январь',
    'Февраль',
    'Март',
    'Апрель',
    'Май',
    'Июнь',
    'Июль',
    'Август',
    'Сентябрь',
    'Октябрь',
    'Ноябрь',
    'Декабрь'
  ];
  final int _currentMonthIndex = DateTime.now().month - 1;
  int _selectedMonthIndex = DateTime.now().month - 1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _previousMonth() {
    setState(() {
      _selectedMonthIndex = (_selectedMonthIndex - 1);
      if (_selectedMonthIndex < 0) {
        _selectedMonthIndex += 12;
      }
    });
  }

  void _nextMonth() {
    if (_selectedMonthIndex < _currentMonthIndex) {
      setState(() {
        _selectedMonthIndex = (_selectedMonthIndex + 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF151515),
        title: const Text(
          'Анализ финансов',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: const [
          Icon(
            Icons.more_horiz,
            color: Colors.white,
            size: 28,
          ),
          SizedBox(width: 15),
        ],
        bottom: TabBar(
          labelStyle: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          indicatorColor: const Color(0xFF2d8246),
          indicatorSize: TabBarIndicatorSize.tab,
          controller: _tabController,
          tabs: const [
            Tab(text: 'Расходы'),
            Tab(text: 'Зачисления'),
          ],
        ),
      ),
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: [
          ExpensesTab(
            outgoing: widget.outgoing,
            month: _months[_selectedMonthIndex],
            onPreviousMonth: _previousMonth,
            onNextMonth: _nextMonth,
            canMoveNext: _selectedMonthIndex < _currentMonthIndex,
          ),
          IncomesTab(
            incoming: widget.incoming,
            month: _months[_selectedMonthIndex],
            onPreviousMonth: _previousMonth,
            onNextMonth: _nextMonth,
            canMoveNext: _selectedMonthIndex < _currentMonthIndex,
          ),
        ],
      ),
    );
  }
}

class ExpensesTab extends StatelessWidget {
  const ExpensesTab({
    super.key,
    required this.outgoing,
    required this.month,
    required this.onPreviousMonth,
    required this.onNextMonth,
    required this.canMoveNext,
  });

  final String outgoing;
  final String month;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;
  final bool canMoveNext;

  @override
  Widget build(BuildContext context) {
    final sum = formatIntNumberWithSpaces(int.parse(((double.parse(outgoing)).round()).toString().replaceAll('.', '')));
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$sum ₽',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: onPreviousMonth,
                  child: const Icon(Icons.arrow_back_ios, color: Color.fromARGB(255, 129, 126, 126), size: 35),
                ),
                const Spacer(),
                CircularPercentIndicator(
                  radius: 100.0,
                  lineWidth: 15.0,
                  animation: true,
                  percent: outgoing == '0.0' ? 0 : 1,
                  center: Text(
                    month,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Color(0xff696969),
                    ),
                  ),
                  circularStrokeCap: CircularStrokeCap.round,
                  backgroundColor: Colors.grey[300]!,
                  progressColor: const Color.fromARGB(255, 29, 179, 34),
                ),
                const Spacer(),
                canMoveNext
                    ? InkWell(
                        onTap: onPreviousMonth,
                        child: const Icon(Icons.arrow_forward_ios, color: Color.fromARGB(255, 129, 126, 126), size: 35),
                      )
                    : const Spacer()
              ],
            ),
            const SizedBox(height: 40),
            const Text(
              'Категории',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 15),
            CategoryItem(
              iconText: 'assets/Переводы.svg',
              category: 'Переводы людям',
              amount: '$sum ₽',
              transactions: outgoing == '0.0' ? '0 операций' : '${Random().nextInt(10) + 3} операций',
            ),
            const Padding(
              padding: EdgeInsets.only(left: 55, right: 15),
              child: Divider(
                color: Color(0xff696969),
                height: 25,
              ),
            ),
            const CategoryItem(
              iconText: 'assets/Plus.svg',
              category: 'Добавить расход',
              transactions: 'Например, если платили наличными',
            ),
          ],
        ),
      ),
    );
  }
}

class IncomesTab extends StatelessWidget {
  const IncomesTab({
    super.key,
    required this.incoming,
    required this.month,
    required this.onPreviousMonth,
    required this.onNextMonth,
    required this.canMoveNext,
  });

  final String incoming;
  final String month;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;
  final bool canMoveNext;

  @override
  Widget build(BuildContext context) {
    final sum = formatIntNumberWithSpaces(int.parse(((double.parse(incoming)).round()).toString().replaceAll('.', '')));
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$sum ₽',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: onPreviousMonth,
                  child: const Icon(Icons.arrow_back_ios, color: Color.fromARGB(255, 129, 126, 126), size: 35),
                ),
                const Spacer(),
                CircularPercentIndicator(
                  radius: 100.0,
                  lineWidth: 15.0,
                  animation: true,
                  percent: incoming == '0.0' ? 0 : 1,
                  center: Text(
                    month,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Color(0xff696969),
                    ),
                  ),
                  circularStrokeCap: CircularStrokeCap.round,
                  backgroundColor: Colors.grey[300]!,
                  progressColor: const Color.fromARGB(255, 29, 179, 34),
                ),
                const Spacer(),
                canMoveNext
                    ? InkWell(
                        onTap: onPreviousMonth,
                        child: const Icon(Icons.arrow_forward_ios, color: Color.fromARGB(255, 129, 126, 126), size: 35),
                      )
                    : const Spacer()
              ],
            ),
            const SizedBox(height: 40),
            const Text(
              'Категории',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 15),
            CategoryItem(
              iconText: 'assets/Переводы.svg',
              category: 'Переводы от людей',
              amount: '$sum ₽',
              transactions: incoming == '0.0' ? '0 операций' : '${Random().nextInt(10) + 3} операций',
            ),
            const Padding(
                padding: EdgeInsets.only(left: 55, right: 15),
                child: Divider(
                  color: Color(0xff696969),
                  height: 10,
                )),
            const CategoryItem(
              iconText: 'assets/Plus.svg',
              category: 'Добавить зачисление',
              transactions: 'Например, если вам дали наличные',
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String iconText;
  final String category;
  final String? amount;
  final String transactions;

  const CategoryItem({
    super.key,
    required this.iconText,
    required this.category,
    this.amount,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
        contentPadding: const EdgeInsets.only(right: 15),
        onTap: () {},
        titleAlignment: ListTileTitleAlignment.titleHeight,
        leading: SvgPicture.asset(
          iconText,
          width: 40,
        ),
        title: Text(
          category,
          style: const TextStyle(
            color: Color(0xffeeeeee),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          transactions,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Color(0xff696969),
          ),
        ),
        trailing: Text(
          amount ?? '',
          style: const TextStyle(
            color: Color(0xffeeeeee),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ));
  }
}
