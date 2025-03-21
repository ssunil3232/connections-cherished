import 'package:connectionscherished/styles/styles.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

// ignore: must_be_immutable
class ArcGauge extends StatefulWidget {
  ArcGauge({super.key, required this.percentage});
  double percentage = 0.55;
  @override
  State<ArcGauge> createState() => _ArcGaugeState();
}

class _ArcGaugeState extends State<ArcGauge> {

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.2,
          child: CustomPaint(
            painter: ArcGaugePainter(percentage: widget.percentage),
          ),
        ),
      ],
    );
  }
}

class ArcGaugePainter extends CustomPainter {
  final double percentage; // expected 0.0..1.0

  ArcGaugePainter({required this.percentage});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = math.min(size.width / 2, 3*size.height/5);

    final startAngle = -math.pi;
    final sweepAngle = math.pi; // negative for clockwise from left to right

    final backgroundPaint = Paint()
      ..color = GlobalStyles.defaultTextBg
      ..style = PaintingStyle.stroke
      ..strokeWidth = GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing16)+2
      ..strokeCap = StrokeCap.round;
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      backgroundPaint,
    );

    Color activeColor;
    if (percentage < 0.33) {
      activeColor = const Color.fromARGB(255, 240, 125, 117);
    } else if (percentage < 0.66) {
      activeColor = const Color.fromARGB(255, 249, 194, 113);
    } else {
      activeColor = const Color(0xFFB5EEA2);
    }

    // Draw the active arc up to the current percentage.
    final activePaint = Paint()
      ..color = activeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing16)+2
      ..strokeCap = StrokeCap.round;

    final activeSweepAngle = sweepAngle * percentage;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      activeSweepAngle,
      false,
      activePaint,
    );

    _drawLabel(canvas, center, radius, fraction: 0.15, text:"Let's work\nharder");
    _drawLabel(canvas, center, radius, fraction: 0.5, text:"Good\neffort");
    _drawLabel(canvas, center, radius, fraction: 0.85, text:"Excellent\nwork");

    // Draw the pointer/knob for the current percentage
    // final currentAngle = startAngle + (sweepAngle * percentage);
    // final knobX = center.dx + radius * math.cos(currentAngle);
    // final knobY = center.dy + radius * math.sin(currentAngle);

    // final knobPaint = Paint()..color = Colors.blueAccent;
    // canvas.drawCircle(Offset(knobX, knobY), 10, knobPaint);
  }

  // Helper to place a text label at a fraction of the arc
  void _drawLabel(
    Canvas canvas,
    Offset center,
    double radius,{
    required double fraction,
    required String text,
  }) {
    final angle = -math.pi + (math.pi * fraction);

    final labelRadius = radius + 26;
    final dx = center.dx + labelRadius * math.cos(angle);
    final dy = center.dy + labelRadius * math.sin(angle);

    final textSpan = TextSpan(
      text: text,
      style: GlobalStyles.textStyles.textButtonTertiary,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    textPainter.layout();
    canvas.save();
    canvas.translate(dx, dy);
    canvas.rotate(angle + math.pi / 2);
    final textOffset = Offset(
      -textPainter.width / 2,
      -textPainter.height / 2 - (GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing16)),
    );
    textPainter.paint(canvas, textOffset);

    final double triangleWidth = GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing12, useWidth: true);
    final double triangleHeight = GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing12)-2;
    final double gap = GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing4);

    final textBottomY = textOffset.dy + textPainter.height;
    // The triangle's top is a few pixels below the text
    final topY = textBottomY + gap;
    final bottomY = topY + triangleHeight;

    // Create a path for the downward triangle
    final path = Path()
      ..moveTo(-triangleWidth / 2, topY) // top-left
      ..lineTo(triangleWidth / 2, topY)  // top-right
      ..lineTo(0, bottomY)   // bottom-center
      ..close();

    final trianglePaint = Paint()..color = Color(0xFF9FC3F2);
    canvas.drawPath(path, trianglePaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant ArcGaugePainter oldDelegate) {
    // Redraw if the percentage changes
    return oldDelegate.percentage != percentage;
  }
}