import 'dart:math' as math;

import 'package:flutter/material.dart';

class CircleWaveRoute extends StatefulWidget {
  final Widget child;
  const CircleWaveRoute({Key? key, required this.child}) : super(key: key);

  @override
  _CircleWaveRouteState createState() => _CircleWaveRouteState();
}

class _CircleWaveRouteState extends State<CircleWaveRoute>
    with SingleTickerProviderStateMixin {
  double waveRadius = 1.0;
  double waveGap = 5.0;
  late Animation<double> _animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(seconds: 4, milliseconds: 0), vsync: this)
      ..repeat();

    controller.forward();

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _animation = Tween(begin: 0.0, end: waveGap).animate(controller)
      ..addListener(() {
        setState(() {
          waveRadius = 10 * math.sin(_animation.value);
        });
      });
    ThemeData theme = Theme.of(context);
    return Stack(
      alignment: Alignment.center,
      children: [
        CustomPaint(
          size: const Size(400, 400),
          painter: CircleWavePainter(waveRadius, theme.primaryColor),
        ),
        Align(
          alignment: Alignment.center,
          child: widget.child,
        ),
      ],
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class CircleWavePainter extends CustomPainter {
  final double waveRadius;
  late Paint wavePaint;
  CircleWavePainter(this.waveRadius, Color color) {
    wavePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..isAntiAlias = true;
  }
  @override
  void paint(Canvas canvas, Size size) {
    double centerX = size.width / 2.0;
    double centerY = size.height / 2.0;
    double maxRadius = 150; //hypot(centerX, centerY);

    var currentRadius = waveRadius;
    while (currentRadius < maxRadius) {
      canvas.drawCircle(Offset(centerX, centerY), currentRadius, wavePaint);
      currentRadius += 20.0;
    }
  }

  @override
  bool shouldRepaint(CircleWavePainter oldDelegate) {
    return oldDelegate.waveRadius != waveRadius;
  }

  double hypot(double x, double y) {
    return math.sqrt(x * x + y * y);
  }
}
