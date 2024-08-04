import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sber/models/check.dart';
import 'package:sber/theme/colors.dart';

class ImageCheck extends StatelessWidget {
  final Chek chek;
  final String text;
  const ImageCheck({
    super.key,
    required this.chek,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: GREEN_MEDIUM),
        backgroundColor: BODY_DARK_GRAY,
        title: Text(
          text,
          style: const TextStyle(color: Color(0xfff4f4f4), letterSpacing: -0.7),
        ),
      ),
      body: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                    child: SizedBox(
                        height: 2500,
                        child: ListView(
                          children: [
                            ChekImageDisplay(chek: chek),
                            const SizedBox(
                              height: 150,
                            )
                          ],
                        ))),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: Colors.black,
                  height: 100,
                  width: double.infinity,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0.0),
                        child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                color: GREEN_MEDIUM,
                                borderRadius: BorderRadius.circular(15)),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12.0),
                              child: Center(
                                  child: Text(
                                text.substring(0, text.length - 4),
                                style: const TextStyle(
                                    letterSpacing: -0.5,
                                    color: Color(0xffffffff),
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500),
                              )),
                            )),
                      )),
                ),
              )
            ],
          )),
    );
  }
}

class ChekImageDisplay extends StatelessWidget {
  final Chek chek;

  const ChekImageDisplay({
    Key? key,
    required this.chek,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File>(
      future: _loadImage(chek.image),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child:
                  CircularProgressIndicator()); // Показываем индикатор загрузки
        } else if (snapshot.hasError) {
          return const Text('Ошибка загрузки изображения');
        } else if (snapshot.hasData) {
          return ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: FittedBox(
                fit: BoxFit.fill,
                child: Image.file(
                  snapshot.data!,
                ),
              )); // Отображаем изображение
        } else {
          return const Text('Изображение не найдено');
        }
      },
    );
  }

  Future<File> _loadImage(String imagePath) async {
    final File imageFile = File(imagePath);
    return imageFile;
  }
}
