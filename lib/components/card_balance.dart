import 'package:flutter/material.dart';
import 'package:sber/models/profile.dart';

class CardBalanceWidget extends StatelessWidget {
  final String balance;
  final CreditCard myCreditCard;
  const CardBalanceWidget({
    super.key,
    required this.myCreditCard,
    required this.balance,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Text(
                  'Кошелёк',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 5),
                Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Icon(
                    size: 18,
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.grey.withOpacity(0.7),
                  ),
                ),
              ],
            ),
            const Row(
              children: [
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
          ],
        ),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }
}
