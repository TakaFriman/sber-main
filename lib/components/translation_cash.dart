import 'package:flutter/material.dart';
import 'package:sber/models/check.dart';

import 'profile_cards.dart';

class TranslationCash extends StatefulWidget {
  const TranslationCash({
    super.key,
  });

  @override
  State<TranslationCash> createState() => _TranslationCashState();
}

class _TranslationCashState extends State<TranslationCash> {
  List<Chek> _checks = [];
  final List<Chek> _newChecks = [];

  @override
  void initState() {
    super.initState();
    _loadChecks();
  }

  void _loadChecks() async {
    try {
      List<Chek> loadedChecks = await CheckRepository.loadChecks();
      // Удаление дубликатов по имени (fio)
      List<Chek> uniqueChecks = _removeDuplicatesByName(loadedChecks);

      setState(() {
        _checks = uniqueChecks;
      });
    } catch (e) {
      print('Ошибка при загрузке чеков: $e');
    }
  }

  List<Chek> _removeDuplicatesByName(List<Chek> checks) {
    final seenNames = <String>{};
    return checks.where((check) => seenNames.add(check.fio)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          SizedBox(
            child: Container(
                width: double.infinity,
                color: Colors.black87,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          Text(
                            'Переводы на Сбер',
                            style: TextStyle(
                                letterSpacing: -0.5, fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
                          ),
                          Spacer(),
                          Text(
                            'Все',
                            style: TextStyle(
                                letterSpacing: -0.5,
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF08A652)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                      child: SizedBox(
                        height: 125,
                        child: Column(
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              height: 115,
                              child: _checks.isNotEmpty
                                  ? ListView.separated(
                                      separatorBuilder: (context, index) => const SizedBox(width: 15),
                                      itemCount: _checks.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return index == 0
                                            ? Row(
                                                children: [
                                                  const NewTransferWidget(),
                                                  const SizedBox(width: 15),
                                                  ProfileCards(name: _checks[index].fio),
                                                ],
                                              )
                                            : ProfileCards(name: _checks[index].fio);
                                      })
                                  : const NewTransferWidget(),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )),
          ),
        ],
      ),
    );
  }
}

class NewTransferWidget extends StatelessWidget {
  const NewTransferWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 60,
          width: 60,
          child: ClipOval(
              child: Container(
                  color: const Color(0xFF168e2a),
                  child: const Icon(
                    Icons.arrow_forward,
                    color: Color(0xFFf7ffff),
                    size: 25,
                  ))),
        ),
        const SizedBox(
          height: 5,
        ),
        const Text(
          'Новый',
          softWrap: true,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Color.fromARGB(255, 67, 140, 84),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Text(
          'Перевод',
          softWrap: true,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Color.fromARGB(255, 67, 140, 84), fontWeight: FontWeight.w500, fontSize: 12),
        )
      ],
    );
  }
}
