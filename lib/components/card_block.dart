import 'package:flutter/material.dart';

class CardBlock extends StatelessWidget {
  final String? cash;
  final String? cardNumber;
  final Widget? widget;
  const CardBlock({
    super.key,
    required this.cash,
    required this.cardNumber,
    required this.widget,
  });

  @override
  Widget build(BuildContext context) {
    String formatCashBlock(String cash) {
      // Разделяем число на дробную и целую части
      List<String> parts = cash.split('.');

      // Форматируем целую часть, добавляя разделение разрядов пробелами
      String integerPart = parts[0].replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]} ');

      // Если есть дробная часть, добавляем ее к отформатированной целой части
      if (parts.length > 1) {
        return '$integerPart,${parts[1]}';
      } else {
        return integerPart;
      }
    }

    return AspectRatio(
      aspectRatio: 1.1,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 82, 86, 101),
                Color.fromARGB(255, 67, 72, 79),
                Color.fromRGBO(63, 68, 76, 1),
                Color.fromRGBO(62, 67, 73, 1),
                Color.fromRGBO(58, 61, 70, 1),
              ],
            )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
              child: widget,
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formatCashBlock(cash ?? '0'),
                  style: const TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                  ),
                ),
                Text(
                  cardNumber ?? '',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[400],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
