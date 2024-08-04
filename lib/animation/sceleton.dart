import 'package:flutter/material.dart';

class SkeletonContainer extends StatefulWidget {
  final String text;
  final TextStyle style;
  final double width;
  final double height;
  final BorderRadius borderRadius;
  final Color color;
  final Duration duration;

  const SkeletonContainer({
    Key? key,
    required this.width,
    required this.height,
    this.borderRadius = BorderRadius.zero,
    this.color = const Color(0xFF313131),
    this.duration = const Duration(milliseconds: 1200),
    required this.text,
    required this.style,
  }) : super(key: key);

  @override
  _SkeletonContainerState createState() => _SkeletonContainerState();
}

class _SkeletonContainerState extends State<SkeletonContainer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: true);
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: widget.borderRadius,
              color: widget.color,
            ),
            child: Text(
              widget.text,
              style: widget.style,
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class SkeletonIconContainer extends StatefulWidget {
  final String text;
  final TextStyle style;
  final double width;
  final double height;
  final BorderRadius borderRadius;
  final Color color;
  final Duration duration;

  const SkeletonIconContainer({
    Key? key,
    required this.width,
    required this.height,
    this.borderRadius = BorderRadius.zero,
    this.color = const Color(0xFF313131),
    this.duration = const Duration(milliseconds: 1000),
    required this.text,
    required this.style,
  }) : super(key: key);

  @override
  _SkeletonIconContainerState createState() => _SkeletonIconContainerState();
}

class _SkeletonIconContainerState extends State<SkeletonIconContainer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: true);
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              borderRadius: widget.borderRadius,
              color: widget.color,
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class SkeletonList extends StatelessWidget {
  const SkeletonList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 2, // Здесь задаем количество элементов в списке
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(right: 40.0, top: 5, left: 10),
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  SkeletonContainer(
                    borderRadius: BorderRadius.circular(20),
                    width: 70,
                    height: 20,
                    text: 'safafafasfasdfsfsfsfdsffd',
                    style: const TextStyle(color: Colors.transparent, fontSize: 10),
                  ),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              Row(
                children: [
                  SkeletonIconContainer(
                    height: 25,
                    width: 25,
                    borderRadius: BorderRadius.circular(40),
                    style: const TextStyle(),
                    text: '',
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  SkeletonContainer(
                    borderRadius: BorderRadius.circular(3),
                    width: 70,
                    height: 20,
                    text: 'safafafasfasdfsfsfsfdsffd',
                    style: const TextStyle(color: Colors.transparent, fontSize: 10),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
