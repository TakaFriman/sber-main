import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sber/models/check.dart';

class AnalysMoneyPage extends StatefulWidget {
  const AnalysMoneyPage({super.key, required this.incoming, required this.outgoing, required this.checks});
  final String incoming;
  final String outgoing;
  final List<Chek> checks;

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
  bool _isLoading = false;
  Map<String, List<Chek>> incomingChecks = {};
  Map<String, List<Chek>> outgoingChecks = {};
  Map<String, List<Chek>> cardPurchases = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _organizeChecksByStatusAndDate();
  }

  int getMonthNumber(String dateStr) {
    // Парсим строку в объект DateTime
    DateTime date = DateFormat('yyyy-MM-dd').parse(dateStr);

    // Возвращаем номер месяца
    return date.month;
  }

  void _organizeChecksByStatusAndDate() {
    for (var check in widget.checks) {
      String monthKey = '${getMonthNumber(check.date)}';
      print(incomingChecks.values);
      if (check.status == 'Входящий перевод') {
        incomingChecks[monthKey] = (incomingChecks[monthKey] ?? [])..add(check);
      } else if (check.status == 'Исходящий перевод') {
        outgoingChecks[monthKey] = (outgoingChecks[monthKey] ?? [])..add(check);
      } else if (check.status == 'Покупка по карте') {
        cardPurchases[monthKey] = (cardPurchases[monthKey] ?? [])..add(check);
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _previousMonth() {
    setState(() {
      _isLoading = true; // Начинаем загрузку
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _selectedMonthIndex = (_selectedMonthIndex - 1);
        if (_selectedMonthIndex < 0) {
          _selectedMonthIndex += 12;
        }
        _isLoading = false; // Завершаем загрузку
      });
    });
  }

  void _nextMonth() {
    setState(() {
      _isLoading = true; // Начинаем загрузку
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        if (_selectedMonthIndex < _currentMonthIndex) {
          _selectedMonthIndex = (_selectedMonthIndex + 1);
        }
        _isLoading = false; // Завершаем загрузку
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String selectedMonthKey = '${_selectedMonthIndex + 1}';

    List<Chek> currentIncomingChecks = incomingChecks[selectedMonthKey] ?? [];
    List<Chek> currentOutgoingChecks = outgoingChecks[selectedMonthKey] ?? [];
    List<Chek> currentCardPurchases = cardPurchases[selectedMonthKey] ?? [];

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
      body: Stack(
        children: [
          _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.green,
                  ),
                )
              : TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  children: [
                    ExpensesTab(
                      outgoingChecks: currentOutgoingChecks,
                      cardPurchases: currentCardPurchases,
                      month: _months[_selectedMonthIndex],
                      onPreviousMonth: _previousMonth,
                      onNextMonth: _nextMonth,
                      canMoveNext: _selectedMonthIndex < _currentMonthIndex,
                      isLoading: _isLoading, // добавлено
                    ),
                    IncomesTab(
                      incomingChecks: currentIncomingChecks,
                      month: _months[_selectedMonthIndex],
                      onPreviousMonth: _previousMonth,
                      onNextMonth: _nextMonth,
                      canMoveNext: _selectedMonthIndex < _currentMonthIndex,
                      isLoading: _isLoading, // добавлено
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}

class ExpensesTab extends StatelessWidget {
  const ExpensesTab({
    super.key,
    required this.outgoingChecks,
    required this.cardPurchases,
    required this.month,
    required this.onPreviousMonth,
    required this.onNextMonth,
    required this.canMoveNext,
    required this.isLoading,
  });
  final bool isLoading;
  final List<Chek> outgoingChecks;
  final List<Chek> cardPurchases;
  final String month;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;
  final bool canMoveNext;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.green,
        ),
      );
    }
    double outgoingSum = outgoingChecks.fold(0, (sum, item) => sum + item.cash);
    double cardPurchaseSum = cardPurchases.fold(0, (sum, item) => sum + item.cash);
    double totalSum = outgoingSum + cardPurchaseSum;

    final formattedSum = formatIntNumberWithSpaces(int.parse(totalSum.round().toString()));

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$formattedSum ₽',
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
                CircularPercentIndicator(
                  radius: 90.0,
                  lineWidth: 13.0,
                  animation: true,
                  animationDuration: 1200,
                  percent: totalSum == 0.0
                      ? 0
                      : cardPurchaseSum > outgoingSum
                          ? cardPurchaseSum / totalSum
                          : outgoingSum / totalSum,
                  center: Text(
                    month,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Color(0xff696969),
                    ),
                  ),
                  circularStrokeCap: CircularStrokeCap.round,
                  backgroundColor: totalSum == 0.0
                      ? const Color(0xff696969)
                      : outgoingSum > cardPurchaseSum
                          ? const Color.fromARGB(255, 19, 186, 220)
                          : const Color.fromARGB(255, 21, 210, 27),
                  progressColor: cardPurchaseSum > outgoingSum
                      ? const Color.fromARGB(255, 19, 186, 220)
                      : const Color.fromARGB(255, 21, 210, 27),
                ),
                canMoveNext
                    ? InkWell(
                        onTap: onNextMonth,
                        child: const Icon(Icons.arrow_forward_ios, color: Color.fromARGB(255, 129, 126, 126), size: 35),
                      )
                    : const SizedBox(width: 35),
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
            outgoingSum != 0.0
                ? Column(
                    children: [
                      CategoryItem(
                        iconText: 'assets/Переводы.svg',
                        category: 'Переводы людям',
                        amount: '${formatIntNumberWithSpaces(int.parse(outgoingSum.round().toString()))} ₽',
                        transactions: outgoingSum == 0.0
                            ? '0 операций'
                            : outgoingChecks.length == 1
                                ? '${outgoingChecks.length} операция'
                                : outgoingChecks.length == 2 || outgoingChecks.length == 3 || outgoingChecks.length == 4
                                    ? '${outgoingChecks.length} операции'
                                    : '${outgoingChecks.length} операций',
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 55, right: 15),
                        child: Divider(
                          color: Color(0xff696969),
                          height: 25,
                        ),
                      ),
                    ],
                  )
                : const SizedBox(),
            cardPurchaseSum != 0.0
                ? Column(
                    children: [
                      CategoryItem(
                        color: const Color.fromARGB(255, 19, 186, 220),
                        iconText: 'assets/chart.svg',
                        category: 'Покупки товаров и услуг',
                        amount: '${formatIntNumberWithSpaces(int.parse(cardPurchaseSum.round().toString()))} ₽',
                        transactions: cardPurchaseSum == 0.0
                            ? '0 операций'
                            : cardPurchases.length == 1
                                ? '${cardPurchases.length} операция'
                                : cardPurchases.length == 2 || cardPurchases.length == 3 || cardPurchases.length == 4
                                    ? '${cardPurchases.length} операции'
                                    : '${cardPurchases.length} операций',
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
                      const SizedBox(height: 64),
                    ],
                  )
                : const CategoryItem(
                    iconText: 'assets/Plus.svg',
                    category: 'Добавить расход',
                    transactions: 'Например, если платили наличными',
                  ),
            const SizedBox(height: 64),
          ],
        ),
      ),
    );
  }
}

class IncomesTab extends StatelessWidget {
  const IncomesTab({
    super.key,
    required this.incomingChecks,
    required this.month,
    required this.onPreviousMonth,
    required this.onNextMonth,
    required this.canMoveNext,
    required this.isLoading,
  });

  final List<Chek> incomingChecks;
  final String month;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;
  final bool canMoveNext;
  final bool isLoading;
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.green,
        ),
      );
    }
    double incomingSum = incomingChecks.fold(0, (sum, item) => sum + item.cash);

    final formattedSum = formatIntNumberWithSpaces(int.parse(incomingSum.round().toString()));

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$formattedSum ₽',
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
                CircularPercentIndicator(
                  radius: 90.0,
                  lineWidth: 13.0,
                  animation: true,
                  animationDuration: 1200,
                  percent: incomingSum == 0.0 ? 0 : 1,
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
                canMoveNext
                    ? InkWell(
                        onTap: onNextMonth,
                        child: const Icon(Icons.arrow_forward_ios, color: Color.fromARGB(255, 129, 126, 126), size: 35),
                      )
                    : const SizedBox(width: 35),
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
            incomingSum != 0.0
                ? Column(
                    children: [
                      CategoryItem(
                        iconText: 'assets/Переводы.svg',
                        category: 'Переводы от людей',
                        amount: '${formatIntNumberWithSpaces(int.parse(incomingSum.round().toString()))} ₽',
                        transactions: incomingSum == 0.0
                            ? '0 операций'
                            : incomingChecks.length == 1
                                ? '${incomingChecks.length} операция'
                                : incomingChecks.length == 2 || incomingChecks.length == 3 || incomingChecks.length == 4
                                    ? '${incomingChecks.length} операции'
                                    : '${incomingChecks.length} операций',
                      ),
                      const Padding(
                          padding: EdgeInsets.only(left: 55, right: 15),
                          child: Divider(
                            color: Color(0xff696969),
                            height: 10,
                          )),
                    ],
                  )
                : const SizedBox(),
            const CategoryItem(
              iconText: 'assets/Plus.svg',
              category: 'Добавить зачисление',
              transactions: 'Например, если вам дали наличные',
            ),
            const SizedBox(height: 64),
          ],
        ),
      ),
    );
  }
}

String formatIntNumberWithSpaces(int number) {
  return number.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(?:\d{3})+(?!\d))'), (Match m) => '${m[1]} ');
}

class CategoryItem extends StatelessWidget {
  final String iconText;
  final String category;
  final String? amount;
  final String transactions;
  final Color? color;

  const CategoryItem({
    super.key,
    required this.iconText,
    required this.category,
    this.amount,
    required this.transactions,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
        contentPadding: const EdgeInsets.only(right: 15),
        onTap: () {},
        titleAlignment: ListTileTitleAlignment.titleHeight,
        leading: SvgPicture.asset(
          iconText, width: 40, color: color, //const Color.fromARGB(255, 12, 214, 73),
        ),
        title: Text(
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
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
