import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClearDataScreen extends StatelessWidget {
  const ClearDataScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF151515),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Очистка данных',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                const Color(0xFF2d8246),
              )),
              onPressed: () {
                _clearAllData(context);
              },
              child: const Text(
                'Очистить все чеки',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 4),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                const Color(0xFF2d8246),
              )),
              onPressed: () {
                _clearLastEntry(context);
              },
              child: const Text(
                'Очистить последний чек',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _clearAllData(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Устанавливаем пустой список для ключа 'checks', чтобы удалить все чеки
    await prefs.setStringList('checks', []);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Очищены все чеки'),
      ),
    );
  }

  Future<void> _clearLastEntry(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? checks = prefs.getStringList('checks');
    if (checks != null && checks.isNotEmpty) {
      checks.removeLast();
      await prefs.setStringList('checks', checks);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Очистить все данные'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No entries to clear.'),
        ),
      );
    }
  }
}
