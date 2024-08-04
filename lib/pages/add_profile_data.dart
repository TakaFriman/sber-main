import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sber/main.dart';
import 'package:sber/pages/add_chek_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddProfileData extends StatefulWidget {
  const AddProfileData({super.key});

  @override
  _AddProfileDataState createState() => _AddProfileDataState();
}

class _AddProfileDataState extends State<AddProfileData> {
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController cvcController = TextEditingController();
  TextEditingController balanceController = TextEditingController();
  TextEditingController expirationDateController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController providerController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passportController = TextEditingController();
  TextEditingController innController = TextEditingController();
  @override
  void dispose() {
    // Освобождение ресурсов контроллеров
    cardNumberController.dispose();
    cvcController.dispose();
    balanceController.dispose();
    expirationDateController.dispose();
    phoneNumberController.dispose();
    providerController.dispose();
    emailController.dispose();
    passportController.dispose();
    innController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF151515),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Форма кредитной карты',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              deleteCreditCardData();
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AddChekTextField(
                  text: 'Номер карты',
                  maxLength: 19,
                  controller: cardNumberController,
                  keyBoardType: TextInputType.number,
                  inputFormat: [
                    FilteringTextInputFormatter.digitsOnly,
                    CustomInputFormatter(),
                  ],
                ),
                AddChekTextField(
                  text: 'CVC',
                  maxLength: 3,
                  controller: cvcController,
                  keyBoardType: TextInputType.number,
                ),
                AddChekTextField(
                  text: 'Visa masterkard',
                  controller: providerController,
                  keyBoardType: TextInputType.text,
                ),
                AddChekTextField(
                  text: 'Имя',
                  controller: balanceController,
                  keyBoardType: TextInputType.name,
                ),
                AddChekTextField(
                  maxLength: 5,
                  text: 'До какого работает',
                  controller: expirationDateController,
                  keyBoardType: TextInputType.datetime,
                  inputFormat: [
                    FilteringTextInputFormatter.digitsOnly,
                    DateInputFormatter(),
                  ],
                ),
                AddChekTextField(
                  text: 'Паспорт',
                  maxLength: 13,
                  controller: passportController,
                  keyBoardType: TextInputType.number,
                  inputFormat: [
                    FilteringTextInputFormatter.digitsOnly,
                    PassportInputFormatter(),
                  ],
                ),
                AddChekTextField(
                  maxLength: 12,
                  text: 'ИНН',
                  controller: innController,
                  keyBoardType: TextInputType.number,
                ),
                AddChekTextField(
                  text: 'Номер телефона',
                  controller: phoneNumberController,
                  keyBoardType: TextInputType.text,
                ),
                AddChekTextField(
                  text: 'Электронная почта',
                  controller: emailController,
                  keyBoardType: TextInputType.emailAddress,
                ),
                // TextField(
                //   controller: cardNumberController,
                //   decoration: const InputDecoration(labelText: 'Номер карты'),
                // ),
                // TextField(
                //   controller: cvcController,
                //   decoration: const InputDecoration(labelText: 'CVC'),
                // ),
                // TextField(
                //   controller: providerController,
                //   decoration: const InputDecoration(labelText: 'visa masterkard'),
                // ),
                // TextField(
                //   controller: balanceController,
                //   decoration: const InputDecoration(labelText: 'Имя'),
                // ),
                // TextField(
                //   controller: expirationDateController,
                //   decoration: const InputDecoration(labelText: 'До какого работает'),
                // ),
                // TextField(
                //   controller: phoneNumberController,
                //   decoration: const InputDecoration(labelText: 'Номер телефона'),
                // ),
                // TextField(
                //   controller: emailController, // Привязка контроллера для email
                //   decoration: const InputDecoration(labelText: 'Электронная почта'), // Добавлено поле для ввода email
                // ),
                const SizedBox(height: 20.0),
                Center(
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                      const Color(0xFF2d8246),
                    )),
                    onPressed: () {
                      saveCreditCardData();
                      Future.delayed(Duration.zero, () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (BuildContext context) => const MyApp()),
                          (Route<dynamic> route) => false,
                        );
                      });
                    },
                    child: const Text(
                      'Сохранить',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> saveCreditCardData() async {
    final isMounted = mounted;
    print(emailController.text);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('cardNumber', cardNumberController.text);
    await prefs.setString('cvc', cvcController.text);
    await prefs.setString('balance', balanceController.text);
    await prefs.setString('expirationDate', expirationDateController.text);
    await prefs.setString('phoneNumber', phoneNumberController.text);
    await prefs.setString('provider', providerController.text);
    await prefs.setString('email', emailController.text);
    await prefs.setString('passport', passportController.text);
    await prefs.setString('inn', innController.text);
    if (isMounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Данные сохранены'),
      ));
      // Очистка значений в текстовых полях
      cardNumberController.clear();
      cvcController.clear();
      balanceController.clear();
      expirationDateController.clear();
      phoneNumberController.clear();
      providerController.clear();
      emailController.clear();
      passportController.clear();
      innController.clear();
    }
  }

  Future<void> deleteCreditCardData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('cardNumber');
    await prefs.remove('cvc');
    await prefs.remove('balance');
    await prefs.remove('expirationDate');
    await prefs.remove('phoneNumber');
    await prefs.remove('provider');
    await prefs.remove('email');
    await prefs.remove('passport');
    await prefs.remove('inn');
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Данные карты удалены'),
    ));
  }
}

class CustomInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write(' '); // Replace this with anything you want to put after each 4 numbers
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(text: string, selection: TextSelection.collapsed(offset: string.length));
  }
}

class PassportInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;

      // Add space after every 2 characters until the 5th character
      if (nonZeroIndex % 2 == 0 && nonZeroIndex <= 5 && nonZeroIndex != text.length) {
        buffer.write(' ');
      }

      // Add space after the 5th character
      if (nonZeroIndex == 4 && nonZeroIndex != text.length) {
        buffer.write(' ');
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    if (newValue.selection.baseOffset < oldValue.selection.baseOffset) {
      if (oldValue.text.length == 3 && oldValue.text[2] == '/') {
        text = text.substring(0, 2);
      }
    } else {
      if (newValue.selection.baseOffset == 0) {
        return newValue;
      }

      var buffer = StringBuffer();
      for (int i = 0; i < text.length; i++) {
        buffer.write(text[i]);
        if (i == 1 && !text.contains('/')) {
          buffer.write('/');
        }
      }

      var string = buffer.toString();
      text = string;
    }

    return newValue.copyWith(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
