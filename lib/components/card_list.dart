import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sber/components/card_block.dart';
import 'package:sber/components/card_icon.dart';
import 'package:sber/models/profile.dart';
import 'package:sber/pages/about_cards.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CardsList extends StatefulWidget {
  final String balance;
  const CardsList({super.key, required this.balance});

  @override
  State<CardsList> createState() => _CardsListState();
}

class _CardsListState extends State<CardsList> {
  CreditCard? myCreditCard;
  Future<void> initializeCreditCard() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    CreditCard loadedCreditCard = CreditCard.fromSharedPreferences(prefs);

    // Проверяем каждое поле на пустоту и заполняем его, если оно пустое
    if (loadedCreditCard.cardNumber.isEmpty) {
      loadedCreditCard.cardNumber = '0000 0000 0000 0000';
    }
    if (loadedCreditCard.provider.isEmpty) {
      loadedCreditCard.provider = '00000';
    }
    if (loadedCreditCard.name.isEmpty) {
      loadedCreditCard.name = 'no name';
    }
    if (loadedCreditCard.cvc.isEmpty) {
      loadedCreditCard.cvc = '000';
    }
    if (loadedCreditCard.expirationDate.isEmpty) {
      loadedCreditCard.expirationDate = '00000';
    }
    if (loadedCreditCard.phoneNumber.isEmpty) {
      loadedCreditCard.phoneNumber = '0000000000';
    }
    if (loadedCreditCard.email.isEmpty) {
      loadedCreditCard.email = '0@0.0';
    }

    setState(() {
      myCreditCard = loadedCreditCard;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeCreditCard();
  }

  @override
  Widget build(BuildContext context) {
    if (myCreditCard == null) {
      myCreditCard = CreditCard(
        // Присваиваем всем полям пустые строки
        cardNumber: '0000 0000 0000 0000',
        provider: '00000', name: 'no name',
        cvc: '000',
        expirationDate: '00000',
        phoneNumber: '0000000000',
        email: '0@0.0', passport: '00 00 000000',
        inn: '000000000000',
      );
      // Если myCreditCard еще не инициализирована, показываем индикатор загрузки
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Container(
      height: 150,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          const SizedBox(width: 15),
          const Column(
            children: [
              CardIconWidget(
                svg: 'assets/Component.svg',
                
              ),
              SizedBox(height: 8),
              CardIconWidget(
                svg: 'assets/Done.svg',
              ),
            ],
          ),
          const SizedBox(width: 8),
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AboutCards(myCreditCard: myCreditCard!, balance: widget.balance),
                ),
              );
            },
            child: CardBlock(
              widget: SvgPicture.asset(
                'assets/Card.svg',
                width: 30,
              ),
              cash: '${widget.balance} ₽',
              cardNumber:
                  '${(myCreditCard?.provider.length ?? 4) > 6 ? '${myCreditCard?.provider.substring(0, 6)}...' // обрезаем до 6 символов и добавляем многоточие
                      : myCreditCard?.provider} \u2022\u2022 ${myCreditCard?.cardNumber.substring((myCreditCard?.cardNumber.length ?? 3) - 4)}',
            ),
          ),
          const SizedBox(width: 8),
          const CardBlock(
            widget: Icon(
              Icons.published_with_changes_outlined,
              color: Colors.green,
              size: 30,
            ),
            cash: '0',
            cardNumber: 'СберСпасибо',
          ),
          const SizedBox(width: 8),
          const CardBlock(
            widget: Icon(
              Icons.add_circle_outline_outlined,
              color: Colors.white,
              size: 30,
            ),
            cash: 'Оформить',
            cardNumber: 'карту или счет',
          ),
        ],
      ),
    );
  }
}
