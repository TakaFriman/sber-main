import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

String formatNumberWithSpaces(double numberString) {
  // Разделяем число на дробную и целую части
  List<String> parts = numberString.toString().split('.');
  String integerPart = parts[0]; // Целая часть числа

  // Форматируем целую часть числа
  String formattedIntegerPart = formatIntNumberWithSpaces(int.parse(integerPart));

  if (parts.length > 1) {
    // Если есть дробная часть числа
    String decimalPart = parts[1];
    String formattedDecimalPart = formatIntNumberWithSpaces(int.parse(decimalPart));

    // Убираем незначащие нули справа от дробной части
    int endIndex = formattedDecimalPart.length - 1;
    while (endIndex >= 0 && formattedDecimalPart[endIndex] == '0') {
      endIndex--;
    }
    formattedDecimalPart = formattedDecimalPart.substring(0, endIndex + 1);

    // Собираем результат, если дробная часть не пустая
    if (formattedDecimalPart.isNotEmpty) {
      return '$formattedIntegerPart,$formattedDecimalPart';
    } else {
      // Если дробная часть пустая, возвращаем только целую часть
      return formattedIntegerPart;
    }
  } else {
    // Если нет дробной части, возвращаем только целую часть
    return formattedIntegerPart;
  }
}

String formatIntNumberWithSpaces(int number) {
  String formattedString = number.toString();
  String result = '';
  int count = 0;

  // Проходим по строке справа налево и добавляем пробел каждые 3 символа
  for (int i = formattedString.length - 1; i >= 0; i--) {
    result = formattedString[i] + result;
    count++;
    if (count % 3 == 0 && i > 0) {
      result = ' $result';
    }
  }
  result = result.replaceAll(' .', ',');
  return result;
}

String formatStringNumberWithSpaces(String formattedString) {
  String result = '';
  int count = 0;

  // Проходим по строке справа налево и добавляем пробел каждые 3 символа
  for (int i = formattedString.length - 1; i >= 0; i--) {
    result = formattedString[i] + result;
    count++;
    if (count % 3 == 0 && i > 0) {
      result = ' $result';
    }
  }
  result = result.replaceAll(' ,', '.');
  return result;
}

String formatDate(DateTime date) {
  final DateTime now = DateTime.now();
  final DateTime today = DateTime(now.year, now.month, now.day);
  final DateTime yesterday = DateTime(now.year, now.month, now.day - 1);

  if (date.isAtSameMomentAs(today)) {
    return 'Сегодня';
  } else if (date.isAtSameMomentAs(yesterday)) {
    return 'Вчера';
  } else {
    return DateFormat('d MMMM, E', 'ru').format(date);
  }
}

class DateChek extends StatelessWidget {
  final String date;
  final String cash;
  final String totalCash;

  const DateChek({
    super.key,
    required this.date,
    required this.cash,
    required this.totalCash,
  });

  @override
  Widget build(BuildContext context) {
    final formattedCash =
        formatIntNumberWithSpaces(int.parse((((double.parse(totalCash)).round()).toString()).replaceAll('.', '')));
    DateTime formatttedDate = DateTime.tryParse(date) ?? DateTime.now();
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20),
      child: Row(
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: formatDate(formatttedDate), // Получаем первые два символа
                  style: const TextStyle(
                    fontSize: 22, // Новый размер шрифта для первых двух символов
                    fontWeight: FontWeight.w500, // Жирный шрифт
                    color: Colors.white, // Цвет текста
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Text(
            '$formattedCash ₽',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Color(0xFF7d7d7d)),
          ),
        ],
      ),
    );
  }
}

class ChekHistory extends StatelessWidget {
  final String fio;
  final String type;
  final double cash;
  final String icon;
  const ChekHistory({
    super.key,
    required this.fio,
    required this.type,
    required this.cash,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final formattedCash = formatNumberWithSpaces(cash);
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    BanksIconIf(icon: icon, type: type),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0, top: 3),
                                    child: Text(
                                      fio,
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis, // добавлено для случая переполнения
                                      maxLines: 2,
                                      style: const TextStyle(
                                          fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white),
                                    ),
                                  ),
                                  (type == 'Входящий перевод')
                                      ? const Text(
                                          "Входящий перевод",
                                          style: TextStyle(
                                              fontSize: 14, fontWeight: FontWeight.w300, color: Color(0xFF7d7d7d)),
                                        )
                                      : (icon != 'Перевод по СПБ')
                                          ? Text(
                                              "Клиенту $icon",
                                              style: const TextStyle(
                                                  fontSize: 14, fontWeight: FontWeight.w300, color: Color(0xFF7d7d7d)),
                                            )
                                          : Text(
                                              icon,
                                              style: const TextStyle(
                                                  fontSize: 14, fontWeight: FontWeight.w300, color: Color(0xFF7d7d7d)),
                                            )
                                ]),
                              ),
                              if (type == 'Исходящий перевод') // Проверяем статус чека
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        '$formattedCash ₽',
                                        style: const TextStyle(
                                            fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),
                                      ),
                                      SvgPicture.asset(
                                        'assets/arrow.svg',
                                        width: 18,
                                      ),
                                    ],
                                  ),
                                ),
                              if (type == 'Входящий перевод') // Проверяем статус чека
                                Column(
                                  children: [
                                    Text(
                                      '+$formattedCash ₽',
                                      style: const TextStyle(
                                          fontSize: 18, fontWeight: FontWeight.w500, color: Color(0xFF2d8246)),
                                    ),
                                  ],
                                )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          (type == 'Исходящий перевод')
              ? const Padding(
                  padding: EdgeInsets.only(left: 50.0, right: 5, top: 0),
                  child: Divider(
                    thickness: 0.2,
                    color: Color(0xFF7d7d7d),
                  ),
                )
              : const Padding(
                  padding: EdgeInsets.only(left: 50.0, right: 5, top: 10),
                  child: Divider(
                    thickness: 0.2,
                    color: Color(0xFF7d7d7d),
                  ),
                )
        ],
      ),
    );
  }
}

class BanksIconIf extends StatelessWidget {
  final String icon;
  final String type;
  const BanksIconIf({super.key, required this.icon, required this.type});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Если входящий перевод из сберБанка
        if (type == 'Входящий перевод' && icon == 'Сбербанк') // Проверяем статус чека
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                'assets/Перевод.svg',
                width: 38,
              )
            ],
          ),
        // Если исходящий перевод из сберБанка
        if (type == 'Исходящий перевод') // Проверяем статус чека
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: SvgPicture.asset(
                  'assets/перевод_.svg',
                  width: 38,
                ),
              )
            ],
          ),

        // Если  перевод из OZON Банка
        if (type == 'Входящий перевод' && icon == 'OZON') // Проверяем статус чека
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20), // Установите радиус, чтобы получить круглую форму
                child: Image.asset(
                  'assets/banks/озон.png',
                  width: 38,
                ),
              )
            ],
          ),
        // Если  перевод из Альфа Банка
        if (type == 'Входящий перевод' && icon == 'Альфа Банк') // Проверяем статус чека
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20), // Установите радиус, чтобы получить круглую форму
                child: Image.asset(
                  'assets/banks/альфа.jpg',
                  width: 38,
                ),
              )
            ],
          ),
        // Если  перевод из вТБ Банка
        if (type == 'Входящий перевод' && icon == 'ВТБ') // Проверяем статус чека
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20), // Установите радиус, чтобы получить круглую форму
                child: Image.asset(
                  'assets/banks/втб.png',
                  width: 38,
                ),
              )
            ],
          ),
        // Если  перевод из Тинькоф
        if (type == 'Входящий перевод' && icon == 'Тинькоф') // Проверяем статус чека
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20), // Установите радиус, чтобы получить круглую форму
                child: Image.asset(
                  'assets/banks/тиньк.jpg',
                  width: 38,
                ),
              )
            ],
          ),
        // Если  перевод из Райфайзен Банк
        if (type == 'Входящий перевод' && icon == 'Райфайзен Банк') // Проверяем статус чека
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20), // Установите радиус, чтобы получить круглую форму
                child: Image.asset(
                  'assets/banks/райф.png',
                  width: 38,
                ),
              )
            ],
          ),
        // Если  перевод из Газпром Банк
        if (type == 'Входящий перевод' && icon == 'Газпром Банк') // Проверяем статус чека
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20), // Установите радиус, чтобы получить круглую форму
                child: Image.asset(
                  'assets/banks/газпром.jpg',
                  width: 38,
                ),
              )
            ],
          ),
        // Если  перевод из Зенит Банк
        if (type == 'Входящий перевод' && icon == 'Зенит Банк') // Проверяем статус чека
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20), // Установите радиус, чтобы получить круглую форму
                child: Image.asset(
                  'assets/banks/зенит.jpg',
                  width: 38,
                ),
              )
            ],
          ),
        // Если  перевод из Открытие Банк
        if (type == 'Входящий перевод' && icon == 'Открытие Банк') // Проверяем статус чека
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20), // Установите радиус, чтобы получить круглую форму
                child: Image.asset(
                  'assets/banks/открытие.webp',
                  width: 38,
                ),
              )
            ],
          ),
        // Если  перевод из Почта Банк
        if (type == 'Входящий перевод' && icon == 'Почта Банк') // Проверяем статус чека
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20), // Установите радиус, чтобы получить круглую форму
                child: Image.asset(
                  'assets/banks/почта.png',
                  width: 38,
                ),
              )
            ],
          ),
        // Если  перевод из рнкб
        if (type == 'Входящий перевод' && icon == 'РНКБ Банк') // Проверяем статус чека
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20), // Установите радиус, чтобы получить круглую форму
                child: Image.asset(
                  'assets/banks/рнкб.png',
                  width: 38,
                ),
              )
            ],
          ),
        // Если  перевод из росБанк
        if (type == 'Входящий перевод' && icon == 'Росбанк') // Проверяем статус чека
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20), // Установите радиус, чтобы получить круглую форму
                child: Image.asset(
                  'assets/banks/росбанк.png',
                  width: 38,
                ),
              )
            ],
          ),
        // Если  перевод из россельхоз
        if (type == 'Входящий перевод' && icon == 'Россельхоз Банк') // Проверяем статус чека
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20), // Установите радиус, чтобы получить круглую форму
                child: Image.asset(
                  'assets/banks/россельхоз.png',
                  width: 38,
                ),
              )
            ],
          ),
        // Если  перевод из россельхоз
        if (type == 'Входящий перевод' && icon == 'Совком Банк') // Проверяем статус чека
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20), // Установите радиус, чтобы получить круглую форму
                child: Image.asset(
                  'assets/banks/совком.png',
                  width: 38,
                ),
              )
            ],
          ),
        // Если  перевод из сургут
        if (type == 'Входящий перевод' && icon == 'Сургут Банк') // Проверяем статус чека
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20), // Установите радиус, чтобы получить круглую форму
                child: Image.asset(
                  'assets/banks/сургут.png',
                  width: 38,
                ),
              )
            ],
          ),
        // Если  перевод из убрил
        if (type == 'Входящий перевод' && icon == 'УБРиР Банк') // Проверяем статус чека
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20), // Установите радиус, чтобы получить круглую форму
                child: Image.asset(
                  'assets/banks/убрир.jpg',
                  width: 38,
                ),
              )
            ],
          ),
        // Если  перевод из Уралсиб
        if (type == 'Входящий перевод' && icon == 'Уралсиб Банк') // Проверяем статус чека
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20), // Установите радиус, чтобы получить круглую форму
                child: Image.asset(
                  'assets/banks/уралсиб.png',
                  width: 38,
                ),
              )
            ],
          ),
      ],
    );
  }
}
