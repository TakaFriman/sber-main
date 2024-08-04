import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Chek {
  final String icon;
  final String fio;
  final String status;
  final double cash;
  final String date;
  final String image;
  final String? time; // Добавленное поле time

  final String? balance; // Добавленное поле time

  Chek({
    required this.date,
    required this.icon,
    required this.fio,
    required this.status,
    required this.cash,
    required this.image,
    this.time = '', // Инициализация поля time
    this.balance = '',
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'date': date,
      'icon': icon,
      'fio': fio,
      'status': status,
      'cash': cash,
      'image': image,
    };
    if (time != null) {
      json['time'] =
          time; // Добавляем поле 'time' в JSON только если оно не null
    }
    if (balance != null) {
      json['balance'] =
          balance; // Добавляем поле 'time' в JSON только если оно не null
    }
    return json;
  }

  factory Chek.fromJson(Map<String, dynamic> json) {
    return Chek(
      date: json['date'],
      icon: json['icon'],
      fio: json['fio'],
      status: json['status'],
      cash: json['cash'],
      image: json['image'],
      time: json['time'] ?? '21.04.2024 17:41',
      balance: json['balance'] ?? '67 586,48',
    );
  }
}

class CheckRepository {
  static const _key = 'checks';

  static Future<void> saveCheck(Chek check) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? checks = prefs.getStringList(_key);
    checks ??= [];
    checks.add(jsonEncode(check.toJson()));
    await prefs.setStringList(_key, checks);
  }

  static Future<List<Chek>> loadChecks() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStringList = prefs.getStringList(_key);
    if (jsonStringList != null) {
      final jsonList =
          jsonStringList.map((jsonString) => jsonDecode(jsonString)).toList();
      return jsonList.map((json) => Chek.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  // Метод для очистки данных в SharedPreferences
  Future<void> clearSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
