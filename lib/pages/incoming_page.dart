import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sber/models/check.dart';
import 'package:sber/models/profile.dart';
import 'package:sber/pages/image_check.dart';

import '../components/date_and_history_chek.dart';

class IncomingPage extends StatelessWidget {
  final Chek chek;
  final CreditCard myCreditCard;

  const IncomingPage({Key? key, required this.chek, required this.myCreditCard}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          scrolledUnderElevation: 0,
          iconTheme: const IconThemeData(color: Color(0xff2c8441)),
          elevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: const Text(
            'Перевод выполнен',
            style: TextStyle(color: Color(0xfffefefe), fontWeight: FontWeight.w500),
          )),
      backgroundColor: const Color(0xff121212),
      body: Center(
        child: FutureBuilder(
          future: Future.delayed(const Duration(seconds: 2)), // Задержка в 2 секунды
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Показываем индикатор загрузки
              return const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green), // Зеленый цвет
              );
            } else {
              // Показываем вашу верстку после завершения задержки
              return YourContentWidget(
                myCreditCard: myCreditCard,
                chek: chek,
              ); // Замените YourContentWidget на вашу верстку
            }
          },
        ),
      ),
    );
  }
}

class YourContentWidget extends StatelessWidget {
  final Chek chek;
  final CreditCard myCreditCard;
  const YourContentWidget({super.key, required this.chek, required this.myCreditCard});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                // Внешний круг
                Container(
                  width: 170,
                  height: 170,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xff12912a).withOpacity(0.09),
                  ),
                ),
                // Средний круг
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xff12912a).withOpacity(0.1),
                  ),
                ),
                // Внутренний круг
                Container(
                  width: 90,
                  height: 90,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(255, 19, 125, 38),
                  ),
                  child: Transform.rotate(
                    angle: 180 * 3.1415926535 / 180,
                    child: const Icon(
                      Icons.forward,
                      color: Color(0xff0d160f),
                      size: 60,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Text('${formatNumberWithSpaces(chek.cash)} ₽',
                style: const TextStyle(color: Color(0xfffbfbfb), fontSize: 30, fontWeight: FontWeight.w500)),
            const SizedBox(
              height: 10,
            ),
            Text(chek.fio, style: const TextStyle(color: Color(0xffeeeeee), fontSize: 18, fontWeight: FontWeight.w300)),
            const SizedBox(
              height: 50,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 20,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ImageCheck(text: 'Сохранить справку', chek: chek)),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: const Color(0xff1e1e1e)),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/Icons/Чек.svg',
                            width: 28,
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          const Text('Сохранить \nсправку',
                              style: TextStyle(color: Color(0xffeeeeee), fontSize: 14, fontWeight: FontWeight.w300)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 350,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ImageCheck(text: 'Сохранить справку', chek: chek)),
                        );
                      },
                      child: Container(
                        width: 200,
                        height: 70,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.transparent),
                      ),
                    ),
                  ],
                ),
                Container(
                  decoration: const BoxDecoration(
                      color: Color(0xff1e1e1e),
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10), color: const Color(0xff666666)),
                              height: 3,
                              width: 30,
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Row(
                          children: [
                            Text('Подробности',
                                style: TextStyle(color: Color(0xffeeeeee), fontSize: 19, fontWeight: FontWeight.w500))
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        SeparateIncomingDate(
                          textHight: 'Баланс',
                          textLow: '${chek.balance} ₽',
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Карта зачисления',
                              style: TextStyle(
                                color: Color(0xff696969),
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Text(myCreditCard.provider,
                                    style: const TextStyle(
                                        color: Color(0xffeeeeee), fontSize: 17, fontWeight: FontWeight.w300)),
                                Text('  ** ${myCreditCard.cardNumber.substring((myCreditCard.cardNumber.length) - 4)}',
                                    style: const TextStyle(
                                        color: Color(0xff868686), fontSize: 14, fontWeight: FontWeight.w300))
                              ],
                            ),
                            Text(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              '............................................................................',
                              style: TextStyle(
                                color: const Color(0xff696969).withOpacity(0.5),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SeparateIncomingDate(textHight: 'Дата и время', textLow: "${chek.time}"),
                        const SizedBox(
                          height: 10,
                        ),
                        const SeparateIncomingDate(textHight: 'Тип операции', textLow: "Входящий перевод"),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'МСС-код торговой точки',
                                  style: TextStyle(
                                    color: Color(0xff696969),
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text("${Random().nextInt(9000) + 1000}",
                                    style: const TextStyle(
                                        color: Color(0xffeeeeee), fontSize: 17, fontWeight: FontWeight.w300)),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 270,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class SeparateIncomingDate extends StatelessWidget {
  final String textHight;
  final String textLow;
  const SeparateIncomingDate({
    super.key,
    required this.textHight,
    required this.textLow,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              textHight,
              style: const TextStyle(
                color: Color(0xff696969),
                fontSize: 15,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(textLow, style: const TextStyle(color: Color(0xffeeeeee), fontSize: 17, fontWeight: FontWeight.w300)),
            Text(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              '.......................................................................',
              style: TextStyle(
                color: const Color(0xff696969).withOpacity(0.5),
              ),
            )
          ],
        )
      ],
    );
  }
}
