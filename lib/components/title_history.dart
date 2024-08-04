import 'package:flutter/material.dart';
import 'package:sber/animation/sceleton.dart';
import 'package:sber/components/date_and_history_chek.dart';
import 'package:sber/models/month.dart';
import 'package:sber/pages/analys_money_page.dart';
import 'package:sber/pages/home_page.dart';

class TitleHistory extends StatelessWidget {
  final String incoming;
  final String outgoing;
  const TitleHistory({
    super.key,
    required this.incoming,
    required this.outgoing,
  });

  @override
  Widget build(BuildContext context) {
    final currentDate = DateTime.now();
    final currentMonth = russianMonths[currentDate.month - 1];
    final incomingP =
        formatIntNumberWithSpaces(int.parse((((double.parse(outgoing)).round()).toString()).replaceAll('.', '')));
    final outgoingP =
        formatIntNumberWithSpaces(int.parse((((double.parse(incoming)).round()).toString()).replaceAll('.', '')));
    return Container(
      decoration: const BoxDecoration(
        // color: Colors.transparent,
        gradient: LinearGradient(
          colors: [Color(0xFF151515), Color(0xFF151515)],
          begin: Alignment.center,
          end: Alignment.center,
        ),
      ),
      child: Column(children: [
        const SizedBox(
          height: 70,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'История',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontFamily: 'SPB',
                        ),
                      ),
                      SizedBox(width: 12),
                    ],
                  ),
                ],
              ),
              Spacer(),
              Icon(
                Icons.visibility_off,
                color: Colors.white,
                size: 26,
              ),
              SizedBox(width: 15),
              Icon(
                Icons.more_horiz,
                color: Colors.white,
                size: 26,
              )
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 140,
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            children: [
              Row(
                children: [
                  const SizedBox(
                    width: 15,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AnalysMoneyPage(
                            incoming: incoming,
                            outgoing: outgoing,
                          ),
                        ),
                      );
                    },
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: 220,
                      child: AspectRatio(
                        aspectRatio: 1.8,
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: const Color(0xFF1E1E1E),
                          ),
                          child: enabled1
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SkeletonContainer(
                                          text: 'Расходы в $currentMonth',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF313131),
                                          ),
                                          width: 110,
                                          height: 20,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        const Spacer(),
                                        Icon(
                                          size: 16,
                                          Icons.arrow_forward_ios_rounded,
                                          color: Colors.grey.withOpacity(0.5),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    SkeletonContainer(
                                      text: '$incomingP ₽',
                                      style: const TextStyle(
                                          fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF313131)),
                                      width: 110,
                                      height: 27,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        SkeletonContainer(
                                          text: 'Расходы в $currentMonth',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Color(0xFF313131),
                                          ),
                                          width: 110,
                                          height: 20,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Расходы в $currentMonth',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[400],
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Icon(
                                              size: 16,
                                              Icons.arrow_forward_ios_rounded,
                                              color: Colors.grey.withOpacity(0.5),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          '${formatIntNumberWithSpaces(int.parse((((double.parse(outgoing)).round()).toString()).replaceAll('.', '')))} ₽',
                                          style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '+$outgoingP ₽',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF08A652),
                                          ),
                                        ),
                                        const Text(
                                          ' зачислений',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const CardHistory(
                    icon: Icon(
                      Icons.error_outline, // Иконка восклицательного знака без заливки
                      color: Colors.grey, // Цвет иконки
                      size: 32, // Размер иконки
                    ),
                    text: 'Укажите свой телефон',
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const CardHistory(
                    icon: Icon(
                      Icons.monetization_on, // Иконка восклицательного знака без заливки
                      color: Colors.grey, // Цвет иконки
                      size: 32, // Размер иконки
                    ),
                    text: 'Деньги за покупки',
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const CardHistory(
                    icon: Icon(
                      Icons.error_outline, // Иконка восклицательного знака без заливки
                      color: Colors.grey, // Цвет иконки
                      size: 32, // Размер иконки
                    ),
                    text: 'Выписки и справки',
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
      ]),
    );
  }
}

class CardHistory extends StatelessWidget {
  final String text;
  final Icon icon;
  const CardHistory({
    super.key,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: MediaQuery.of(context).size.height * 0.2,
      child: AspectRatio(
        aspectRatio: 1.1,
        child: Container(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: const Color(0xFF1E1E1E),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              icon,
              Text(
                text,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
