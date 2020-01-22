import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart' hide TextStyle;

class MinutesHand extends StatelessWidget {
  final Color color;
  final double size;
  final double angleRadiansOfMinutes;
  final double angleRadiansOfSeconds;
  final String minutesText;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: CustomPaint(
        painter: _MinutesHandPainter(
            handSize: size,
            angleRadians: angleRadiansOfMinutes,
            color: color,
            angleRadiansSeconds: angleRadiansOfSeconds,
            minutesText: minutesText),
      ),
    );
  }

  MinutesHand(
      {this.color,
      this.size,
      this.angleRadiansOfMinutes,
      this.angleRadiansOfSeconds,
      this.minutesText});
}

class _MinutesHandPainter extends CustomPainter {
  _MinutesHandPainter({
    @required this.handSize,
    @required this.angleRadians,
    @required this.angleRadiansSeconds,
    @required this.color,
    @required this.minutesText,
  })  : assert(angleRadians != null),
        assert(color != null);

  double angleRadiansSeconds;

  String minutesText;

  double handSize;
  double angleRadians;
  Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = (Offset.zero & size).center;
    final angle = angleRadians - math.pi / 2.0;
    final position = center + Offset(math.cos(angle), math.sin(angle)) * 75;
    final linePaint = Paint()..color = color;
    canvas.drawCircle(position, handSize, linePaint);

    Paint newLinePaint = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.25;
    canvas.drawCircle(position, handSize, newLinePaint);

    final paragraphStyle =
        ParagraphStyle(textAlign: TextAlign.center, fontFamily: 'Montserrat');
    final textStyle = TextStyle(color: Colors.white, fontSize: 28);
    final paragraphBuilder = ParagraphBuilder(paragraphStyle)
      ..pushStyle(textStyle)
      ..addText(minutesText);
    final paragraph = paragraphBuilder.build()
      ..layout(ParagraphConstraints(width: 100));
    canvas.drawParagraph(paragraph,
        position - Offset(paragraph.width / 2, paragraph.height / 2));

    final angleSecond = angleRadiansSeconds + math.pi / 2;
    final positionSecond =
        position - Offset(math.cos(angleSecond), math.sin(angleSecond)) * 30;
    final linePaintSecond = Paint()..color = Colors.white;
    canvas.drawCircle(positionSecond, 5, linePaintSecond);
  }

  @override
  bool shouldRepaint(_MinutesHandPainter oldDelegate) {
    return oldDelegate.angleRadians != angleRadians ||
        oldDelegate.color != color ||
        oldDelegate.angleRadiansSeconds != angleRadiansSeconds;
  }
}
