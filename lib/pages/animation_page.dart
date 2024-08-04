import 'package:flutter/material.dart';
import 'package:sber/main.dart';
import 'package:sber/models/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NextScreen extends StatefulWidget {
  const NextScreen({
    super.key,
  });

  @override
  _NextScreenState createState() => _NextScreenState();
}

class _NextScreenState extends State<NextScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Image _backgroundImage;

  late Future<CreditCard> creditCardFuture;

  @override
  void initState() {
    creditCardFuture = initializeCreditCard();
    super.initState();

    _backgroundImage = Image.asset(
      'assets/Animation_page2.jpg',
      fit: BoxFit.fill,
      width: double.infinity,
    );

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: const Offset(0, 0.181),
    ).animate(_controller);

    _controller.forward();

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MyHomePage(title: 'Сбербанк'),
        ),
      );
    });
  }

  Future<CreditCard> initializeCreditCard() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return CreditCard.fromSharedPreferences(prefs);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(_backgroundImage.image, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FutureBuilder<CreditCard>(
          future: creditCardFuture,
          builder: (context, snapshot) {
            return Stack(
              children: [
                _backgroundImage,
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const Text(
                            'Добрый день,',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 31,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            snapshot.data?.name != null ? '${snapshot.data?.name}!' : 'Новый пользователь!',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
