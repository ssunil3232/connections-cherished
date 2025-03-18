import 'package:connectionscherished/styles/styles.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

// ignore: must_be_immutable
class ToggleButtonWidget extends StatefulWidget {
  ToggleButtonWidget({super.key, required this.onToggle});
  Function(int) onToggle;

  @override
  State<ToggleButtonWidget> createState() => _ToggleButtonWidgetState();
}

class _ToggleButtonWidgetState extends State<ToggleButtonWidget> {
  int selectedIndex = 0;
  final List<String> segments = ["Week", "Month", "Years"];

  // The left offset (in pixels) of the white pill
  double currentOffset = 0.0;

  // We can define the total width & height for demonstration
  static const double totalWidth = 300.0;
  static const double totalHeight = 48.0;

  // The width of each segment (equal slices)
  double get segmentWidth => totalWidth / segments.length;

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: totalWidth,
      height: totalHeight,
      child: GestureDetector(
        // 1) DRAG LOGIC
        onPanUpdate: (details) {
          setState(() {
            // Update the offset by the drag distance
            currentOffset += details.delta.dx;
            // Clamp the offset so it doesn’t go beyond left/right bounds
            currentOffset = math.max(0, math.min(currentOffset, totalWidth - segmentWidth));
          });
        },
        onPanEnd: (details) {
          // Snap to the nearest segment
          final nearestIndex = (currentOffset / segmentWidth).round();
          _animateToSegment(nearestIndex);
        },
        child: Stack(
          children: [
            // 1) The background pill
            Container(
              width: totalWidth,
              height: totalHeight,
              decoration: BoxDecoration(
                color: GlobalStyles.btnBgPrimary,
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            // 2) The white pill for the selected segment
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              left: currentOffset,
              child: Container(
                width: segmentWidth,
                height: totalHeight,
                decoration: BoxDecoration(
                  color: GlobalStyles.defaultTextBg,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            // 3) The row of text on top
            Row(
              children: List.generate(segments.length, (index) {
                return SizedBox(
                  width: segmentWidth,
                  height: totalHeight,
                  child: Center(
                    child: GestureDetector(
                      onTap: () => _animateToSegment(index),
                      child: Text(
                    segments[index],
                    style: GlobalStyles.textStyles.textBody
                  ),
                )));
              }),
            ),
          ],
        ),
      )
    );
  }

  void _animateToSegment(int index) {
    setState(() {
      selectedIndex = index;
      currentOffset = index * segmentWidth;
      widget.onToggle(index);
    });
  }
}
