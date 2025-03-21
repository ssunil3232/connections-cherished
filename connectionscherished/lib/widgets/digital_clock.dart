import 'dart:async';
import 'package:connectionscherished/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:timezone/standalone.dart' as tz;

// ignore: must_be_immutable
class DigitalClock extends StatefulWidget {
  String timezone;
  DigitalClock({super.key, required this.timezone});

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  final StreamController<String> _timeStreamController = StreamController<String>.broadcast();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startClock();
  }

  void _startClock() {
    _timer?.cancel(); // Cancel existing timer if any
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      try {
        final location = tz.getLocation(widget.timezone);
        final now = tz.TZDateTime.now(location);
        _timeStreamController.add("${now.hour.toString().padLeft(2, '0')}:"
                                  "${now.minute.toString().padLeft(2, '0')}");
      } catch (e) {
        _timeStreamController.add("Invalid Timezone");
      }
    });
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.timezone != widget.timezone) {
      _startClock(); // Restart with new timezone
    }
    // setState(() {});
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timeStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: _timeStreamController.stream,
      builder: (context, snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing8), horizontal: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing40, useWidth: true)),
          decoration: BoxDecoration(
            color: GlobalStyles.btnBgTertiary,
            borderRadius: BorderRadius.circular(GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing16)),
          ),
          child: snapshot.data == null ?
            SizedBox(
              height: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing24),
              width: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing48, useWidth: true),
              child: LoadingIndicator(
                indicatorType: Indicator.ballPulse, 
                colors: [GlobalStyles.primaryText],
              )
            )
          : 
          Text(
            snapshot.data ?? "Loading...",
            style: snapshot.data == "Invalid Timezone" ? 
              GlobalStyles.textStyles.textCaption3.copyWith(
                color: GlobalStyles.textSubtle
              ) 
            : GlobalStyles.textStyles.textH1,
          ),
        );
      },
    );
  }
}
