import 'package:flutter/material.dart';

class AnimatedTextWidget extends StatefulWidget {
  @override
  _AnimatedTextWidgetState createState() => _AnimatedTextWidgetState();
}

class _AnimatedTextWidgetState extends State<AnimatedTextWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    final curve = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _offsetAnimation = Tween<Offset>(begin: Offset.zero, end: Offset(-0.5, 0.0)).animate(curve);
    _colorAnimation = ColorTween(begin: Colors.black, end: Colors.red).animate(curve);

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          alignment: Alignment.center,
          child: RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
              children: [
                TextSpan(
                  text: 'S',
                  style: TextStyle(color: _colorAnimation.value),
                ),
                TextSpan(text: 'ystem '),
                TextSpan(
                  text: 'A',
                  style: TextStyle(color: _colorAnimation.value),
                ),
                TextSpan(text: 'utomation '),
                TextSpan(
                  text: 'I',
                  style: TextStyle(color: _colorAnimation.value),
                ),
                TextSpan(text: 'ntegration '),
                TextSpan(
                  text: 'F',
                  style: TextStyle(color: _colorAnimation.value),
                ),
                TextSpan(text: 'ramework'),
              ],
            ),
          ),
        );
      },
    );
  }
}
