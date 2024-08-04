import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sber/models/check.dart';

const List<String> listBanks = <String>[
  'Сбербанк',
  'Тинькоф',
  'ВТБ',
  'OZON',
  'Альфа Банк',
  'Почта Банк',
  'Зенит Банк',
  'Райфайзен Банк',
  'Открытие Банк',
  'Россельхоз Банк',
  'УБРиР Банк',
  'Совком Банк',
  'Росбанк',
  'РНКБ Банк',
  'Сургут Банк',
  'Газпром Банк',
  'Уралсиб Банк',
];
const List<String> listStatus = <String>[
  'Входящий перевод',
  'Исходящий перевод',
];

class ChekAdd extends StatefulWidget {
  const ChekAdd({Key? key}) : super(key: key);

  @override
  State<ChekAdd> createState() => _ChekAddState();
}

class _ChekAddState extends State<ChekAdd> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _fioController = TextEditingController();
  final TextEditingController _cashController = TextEditingController();
  final TextEditingController _timeController = TextEditingController(); // Новое поле для времени
  final TextEditingController _balanceController = TextEditingController(); // Новое поле для баланса
  String _selectedStatus = listStatus.first;
  String _selectedBank = listBanks.first;
  String _successMessage = '';
  File? _pickedImage;
  @override
  void dispose() {
    _dateController.dispose();
    _fioController.dispose();
    _cashController.dispose();
    _timeController.dispose(); // Освобождение контроллера времени
    _balanceController.dispose(); // Освобождение контроллера баланса
    // TODO: implement dispose
    super.dispose();
  }

  onTapFunction({required BuildContext context}) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      lastDate: DateTime.now(),
      firstDate: DateTime(2015),
      initialDate: DateTime.now(),
    );
    if (pickedDate == null) return;
    _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: IntrinsicHeight(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(
                children: [
                  AddChekTextField(
                    keyBoardType: TextInputType.text,
                    text: 'Дата',
                    controller: _dateController,
                    onTap: () {
                      onTapFunction(context: context);
                    },
                  ),
                  AddChekTextField(
                    keyBoardType: TextInputType.name,
                    text: 'ФИО',
                    controller: _fioController,
                  ),
                  AddChekTextField(
                    keyBoardType: TextInputType.number,
                    text: 'Сумма',
                    controller: _cashController,
                  ),
                  AddChekTextField(
                    keyBoardType: TextInputType.datetime,
                    text: 'Время',
                    controller: _timeController,
                  ),
                  AddChekTextField(
                    keyBoardType: TextInputType.number,
                    text: 'Баланс',
                    controller: _balanceController,
                  ),
                  DropdownButtonExample(
                    dropdown: listStatus,
                    initialValue: _selectedStatus,
                    onChanged: (value) {
                      setState(() {
                        _selectedStatus = value ?? listBanks.first;
                      });
                    },
                  ),
                  DropdownButtonExample(
                    dropdown: listBanks,
                    initialValue: _selectedBank,
                    onChanged: (value) {
                      setState(() {
                        _selectedBank = value ?? listStatus.first;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                        const Color(0xFF2d8246),
                      )),
                      onPressed: () async {
                        final pickedFile = await ImagePicker().pickImage(
                          source: ImageSource.gallery,
                        );
                        if (pickedFile != null) {
                          setState(() {
                            _pickedImage = File(pickedFile.path);
                          });
                        }
                      },
                      child: const Text(
                        'Выбрать изображение',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),

              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                  const Color(0xFF2d8246),
                )),
                onPressed: () {
                  // Если изображение выбрано
                  final newCheck = Chek(
                    date: _dateController.text,
                    fio: _fioController.text,
                    cash: double.parse(_cashController.text),
                    status: _selectedStatus,
                    icon: _selectedBank, // Путь к иконке (не изображению)
                    image: _pickedImage?.path ?? '', // Путь к изображению
                    time: _timeController.text, // Присваиваем значение времени из текстового поля
                    balance: _balanceController.text,
                  );

                  // Сохраняем новый чек
                  CheckRepository.saveCheck(newCheck);
                  setState(() {
                    _successMessage = 'Чек успешно добавлен!';
                    _pickedImage = null; // Сбрасываем выбранное изображение после сохранения
                  });

                  // Очищаем поля ввода после успешного добавления
                  _dateController.clear();
                  _fioController.clear();
                  _cashController.clear();
                  _timeController.clear(); // Очищаем текстовое поле времени
                  _balanceController.clear(); // Очищаем текстовое поле баланса

                  // Задержка перед скрытием сообщения
                  Future.delayed(const Duration(seconds: 2), () {
                    setState(() {
                      _successMessage = '';
                    });
                  });
                },
                child: const Text(
                  'Добавить чек',
                  style: TextStyle(color: Colors.white),
                ),
              ),

              // Отображаем сообщение об успешном добавлении
              if (_successMessage.isNotEmpty)
                Text(
                  _successMessage,
                  style: const TextStyle(
                    color: Color(0xFF08A652),
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddChekTextField extends StatelessWidget {
  final String text;
  final TextEditingController controller;
  final TextInputType keyBoardType;
  final List<TextInputFormatter>? inputFormat;
  final int? maxLength;
  final VoidCallback? onTap;
  const AddChekTextField({
    Key? key,
    required this.text,
    required this.controller,
    required this.keyBoardType,
    this.inputFormat,
    this.maxLength,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        onTap: onTap,
        maxLength: maxLength,
        inputFormatters: inputFormat,
        style: const TextStyle(color: Colors.white),
        controller: controller,
        keyboardType: keyBoardType,
        cursorColor: const Color(0xFF2d8246),
        decoration: InputDecoration(
          counterText: "",
          focusColor: const Color(0xFFB3BDC6),
          hintText: text,
          hintStyle: const TextStyle(color: Color.fromARGB(255, 93, 95, 98), fontSize: 14),
          contentPadding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: const Color.fromARGB(102, 75, 76, 75),
        ),
      ),
    );
  }
}

class DropdownButtonExample extends StatelessWidget {
  final List<String> dropdown;
  final String initialValue;
  final void Function(String?)? onChanged;

  const DropdownButtonExample({
    Key? key,
    required this.dropdown,
    required this.initialValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: DropdownButton<String>(
        isExpanded: true,
        dropdownColor: const Color.fromARGB(255, 75, 76, 75),
        value: initialValue,
        onChanged: onChanged,
        items: dropdown.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: const TextStyle(color: Color.fromARGB(211, 27, 234, 9)),
            ),
          );
        }).toList(),
      ),
    );
  }
}
