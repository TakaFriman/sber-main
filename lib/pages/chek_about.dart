import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sber/components/date_and_history_chek.dart';
import 'package:sber/models/check.dart';
import 'package:sber/models/profile.dart';
import 'package:sber/pages/image_check.dart';
import 'package:sber/theme/colors.dart';

import '../animation/circular_animation.dart'; // Импортируем модель чека

class CheckDetailsScreen extends StatefulWidget {
  final Chek check; // Принимаем выбранный чек
  final CreditCard myCreditCart;
  const CheckDetailsScreen(
      {Key? key, required this.check, required this.myCreditCart})
      : super(key: key);

  @override
  _CheckDetailsScreenState createState() => _CheckDetailsScreenState();
}

class _CheckDetailsScreenState extends State<CheckDetailsScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Имитация загрузки на 2 секунды
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false; // После 2 секунд скрываем индикатор загрузки
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final formattedCash = formatIntNumberWithSpaces(int.parse(
        (((widget.check.cash).round()).toString()).replaceAll('.', '')));
    return Scaffold(
      backgroundColor: BODY_BLACK,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Color(0xfff4f4f4)),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.close), // Иконка крестика
          onPressed: () {
            Navigator.pop(context); // Закрытие экрана по нажатию на крестик
          },
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: GREEN_MEDIUM,
              ), // Отображаем индикатор загрузки
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      (widget.check.icon != 'Сбербанк')
                          ? Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xFF101113), // Night
                                    Color.fromARGB(
                                        255, 28, 29, 32), // Eerie Black
                                    Color.fromARGB(
                                        255, 38, 43, 44), // Eerie Black 2
                                    Color.fromARGB(
                                        255, 42, 46, 52), // Raisin Black
                                    Color.fromARGB(255, 61, 72, 76), // Gunmetal
                                  ],
                                ),
                              ),
                              height: 360,
                              width: double.infinity,
                              child: Column(
                                children: [
                                  (widget.check.status == 'Исходящий перевод')
                                      ? Column(
                                          children: [
                                            const SizedBox(
                                              height: 60,
                                            ),
                                            const SizedBox(
                                                height: 150,
                                                width: 150,
                                                child: CircleAnimation()),
                                            const Text(
                                              'Перевод отправлен',
                                              style: TextStyle(
                                                  letterSpacing: -0.5,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              '$formattedCash ₽',
                                              style: const TextStyle(
                                                  letterSpacing: -0.5,
                                                  fontSize: 23,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            (widget.check.icon !=
                                                    'Перевод по СПБ')
                                                ? Text(
                                                    'В ${widget.check.icon} через СПБ',
                                                    style: const TextStyle(
                                                        letterSpacing: -0.5,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        color: Colors.white),
                                                  )
                                                : Text(
                                                    widget.check.icon,
                                                    style: const TextStyle(
                                                        letterSpacing: -0.5,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        color: Colors.white),
                                                  ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              widget.check.fio,
                                              style: const TextStyle(
                                                  letterSpacing: -0.5,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.white),
                                            ),
                                          ],
                                        )
                                      : Column(
                                          children: [
                                            const SizedBox(
                                              height: 60,
                                            ),
                                            const SizedBox(
                                                height: 150,
                                                width: 150,
                                                child: CircleAnimation()),
                                            const Text(
                                              'Перевод принят',
                                              style: TextStyle(
                                                  letterSpacing: -0.5,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              '$formattedCash ₽',
                                              style: const TextStyle(
                                                  letterSpacing: -0.5,
                                                  fontSize: 23,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            (widget.check.icon !=
                                                    'Перевод по СПБ')
                                                ? Text(
                                                    'В ${widget.check.icon} через СПБ',
                                                    style: const TextStyle(
                                                        letterSpacing: -0.5,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        color: Colors.white),
                                                  )
                                                : Text(
                                                    widget.check.icon,
                                                    style: const TextStyle(
                                                        letterSpacing: -0.5,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        color: Colors.white),
                                                  ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              widget.check.fio,
                                              style: const TextStyle(
                                                  letterSpacing: -0.5,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.white),
                                            ),
                                          ],
                                        )
                                ],
                              ),
                            )
                          : Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    GREEN_HIGHT,
                                    GREEN_MEDIUM,
                                    GREEN_LITE
                                  ],
                                ),
                              ),
                              // height: 380,
                              width: double.infinity,
                              child: Column(
                                children: [
                                  (widget.check.status == 'Исходящий перевод')
                                      ? Column(
                                          children: [
                                            const SizedBox(
                                              height: 60,
                                            ),
                                            const SizedBox(
                                                height: 150,
                                                width: 150,
                                                child: CircleAnimationWhite()),
                                            const Text(
                                              'Перевод доставлен',
                                              style: TextStyle(
                                                  letterSpacing: -0.5,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              '$formattedCash ₽',
                                              style: const TextStyle(
                                                  letterSpacing: -0.5,
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            // Text(
                                            //   'В ${widget.check.icon} через СПБ',
                                            //   style: const TextStyle(
                                            //       letterSpacing: -0.5,
                                            //       fontSize: 16,
                                            //       fontWeight: FontWeight.w500,
                                            //       color: Colors.white),
                                            // ),
                                            // const SizedBox(
                                            //   height: 5,
                                            // ),
                                            Text(
                                              widget.check.fio,
                                              style: const TextStyle(
                                                  letterSpacing: -0.5,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.white),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                          ],
                                        )
                                      : Column(
                                          children: [
                                            const SizedBox(
                                              height: 60,
                                            ),
                                            const SizedBox(
                                                height: 150,
                                                width: 150,
                                                child: CircleAnimationWhite()),
                                            const Text(
                                              'Перевод принят',
                                              style: TextStyle(
                                                  letterSpacing: -0.5,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              '$formattedCash ₽',
                                              style: const TextStyle(
                                                  letterSpacing: -0.5,
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            (widget.check.icon !=
                                                    'Перевод по СПБ')
                                                ? Text(
                                                    'В ${widget.check.icon} через СПБ',
                                                    style: const TextStyle(
                                                        letterSpacing: -0.5,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        color: Colors.white),
                                                  )
                                                : Text(
                                                    widget.check.icon,
                                                    style: const TextStyle(
                                                        letterSpacing: -0.5,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        color: Colors.white),
                                                  ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              widget.check.fio,
                                              style: const TextStyle(
                                                  letterSpacing: -0.5,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.white),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            )
                                          ],
                                        )
                                ],
                              ),
                            ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ((widget.check.status == 'Исходящий перевод') &&
                                  (widget.check.icon != 'Сбербанк'))
                              ? const Column(
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 20.0, top: 20),
                                      child: Row(
                                        children: [
                                          Text(
                                            'Статус перевода',
                                            style: TextStyle(
                                                letterSpacing: -1,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 20.0, top: 10),
                                      child: Row(
                                        children: [
                                          Text(
                                            'Узнать о зачислениях денежных средств на счет \nвы можете у получателя перевода',
                                            style: TextStyle(
                                                letterSpacing: -1,
                                                color: TEXT_GRAY,
                                                fontSize: 17,
                                                fontWeight: FontWeight.w400),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                          ((widget.check.status == 'Исходящий перевод') &&
                                  (widget.check.icon != 'Сбербанк'))
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: SvgPicture.asset(
                                          'assets/Icons/Чек.svg',
                                          width: 21,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => ImageCheck(
                                                    text:
                                                        'Сохранить или отправить чек',
                                                    chek: widget.check)),
                                          );
                                        },
                                        child: const Text(
                                          'Сохранить или отправить чек',
                                          style: TextStyle(
                                              letterSpacing: -0.5,
                                              color: Color(0xffffffff),
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Column(
                                  children: [
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: SvgPicture.asset(
                                              'assets/Icons/Чек.svg',
                                              width: 21,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ImageCheck(
                                                            text:
                                                                'Сохранить чек',
                                                            chek:
                                                                widget.check)),
                                              );
                                            },
                                            child: const Text(
                                              'Сохранить чек',
                                              style: TextStyle(
                                                  letterSpacing: -0.5,
                                                  color: Color(0xffffffff),
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(
                                          left: 60.0,
                                          right: 15,
                                          top: 5,
                                          bottom: 10),
                                      child: Divider(
                                        thickness: 0.1,
                                        color: Color(0xFF7d7d7d),
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.star_border,
                                            size: 35,
                                            color: GREEN_MEDIUM,
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text(
                                            'Создать шаблон',
                                            style: TextStyle(
                                                letterSpacing: -0.5,
                                                color: Color(0xffffffff),
                                                fontSize: 17,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                          const Padding(
                            padding: EdgeInsets.only(
                                left: 60.0, right: 15, top: 5, bottom: 10),
                            child: Divider(
                              thickness: 0.1,
                              color: Color(0xFF7d7d7d),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  size: 30,
                                  color: GREEN_MEDIUM,
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  'Подробности операции',
                                  style: TextStyle(
                                      letterSpacing: -0.5,
                                      color: Color(0xffffffff),
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500),
                                ),
                                Spacer(),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Icon(
                                        weight: 30,
                                        size: 26,
                                        Icons.keyboard_arrow_down_sharp,
                                        color: TEXT_GRAY,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: GREEN_MEDIUM,
                                borderRadius: BorderRadius.circular(15)),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12.0),
                              child: Center(
                                  child: Text(
                                ((widget.check.status == 'Исходящий перевод') &&
                                        (widget.check.icon != 'Сбербанк'))
                                    ? 'Вернуться назад'
                                    : 'Повторить',
                                style: const TextStyle(
                                    letterSpacing: -0.5,
                                    color: Color(0xffffffff),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500),
                              )),
                            )),
                      ))
                ],
              ),
            ),
    );
  }
}
