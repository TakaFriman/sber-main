import 'package:flutter/material.dart';
import 'package:sber/theme/colors.dart';

class CircleAnimation extends StatefulWidget {
  const CircleAnimation({Key? key}) : super(key: key);

  @override
  _CircleAnimationState createState() => _CircleAnimationState();
}

class _CircleAnimationState extends State<CircleAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation1;
  late Animation<double> _animation2;
  late Animation<double> _animation3;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _animation1 = Tween<double>(begin: 0.0, end: 120.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeInOut),
      ),
    );
    _animation2 = Tween<double>(begin: 0.0, end: 90.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 1, curve: Curves.easeInOut),
      ),
    );
    _animation3 = Tween<double>(begin: 0.0, end: 60.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1, curve: Curves.easeInOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              _buildCircle(const Color(0xff464749).withOpacity(0.8),
                  _animation1.value, []),
              _buildCircle(const Color(0xff919193).withOpacity(0.8),
                  _animation2.value, []),
              _buildCircle(
                  const Color(0xffffffff).withOpacity(0.9), _animation3.value, [
                const Center(
                    child: Padding(
                  padding: EdgeInsets.only(left: 5.0, bottom: 5),
                  child: Text(
                    'L',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
                  ),
                ))
              ]),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCircle(Color color, double size, List<Widget> children) {
    return Center(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Stack(
          children: children,
        ),
      ),
    );
  }
}

class ClockHand extends StatelessWidget {
  final Color color;
  final double size;
  final double angleRadians;

  const ClockHand({
    Key? key,
    required this.color,
    required this.size,
    required this.angleRadians,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: size / 2,
      left: size / 2,
      child: Transform.rotate(
        angle: angleRadians,
        child: Container(
          width: 2.0,
          height: size / 2,
          color: color,
        ),
      ),
    );
  }
}

class CircleAnimationWhite extends StatefulWidget {
  const CircleAnimationWhite({Key? key}) : super(key: key);

  @override
  _CircleAnimationWhiteState createState() => _CircleAnimationWhiteState();
}

class _CircleAnimationWhiteState extends State<CircleAnimationWhite>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation1;
  late Animation<double> _animation2;
  late Animation<double> _animation3;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _animation1 = Tween<double>(begin: 0.0, end: 130.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeInOut),
      ),
    );
    _animation2 = Tween<double>(begin: 0.0, end: 100.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 1, curve: Curves.easeInOut),
      ),
    );
    _animation3 = Tween<double>(begin: 0.0, end: 70.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1, curve: Curves.easeInOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              _buildCircle(
                  const Color.fromARGB(255, 144, 146, 149).withOpacity(0.6),
                  _animation1.value, []),
              _buildCircle(
                  const Color.fromARGB(255, 174, 174, 174).withOpacity(0.6),
                  _animation2.value, []),
              _buildCircle(
                  const Color(0xffffffff).withOpacity(0.9), _animation3.value, [
                const Center(
                    child: Icon(
                  Icons.check,
                  size: 36,
                  color: GREEN_MEDIUM,
                ))
              ]),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCircle(Color color, double size, List<Widget> children) {
    return Center(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Stack(
          children: children,
        ),
      ),
    );
  }
}

class ClockHandWhite extends StatelessWidget {
  final Color color;
  final double size;
  final double angleRadians;

  const ClockHandWhite({
    Key? key,
    required this.color,
    required this.size,
    required this.angleRadians,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: size / 2,
      left: size / 2,
      child: Transform.rotate(
        angle: angleRadians,
        child: Container(
          width: 2.0,
          height: size / 2,
          color: color,
        ),
      ),
    );
  }
}
