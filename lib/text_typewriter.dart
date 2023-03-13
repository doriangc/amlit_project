import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class TextTypewriter extends StatefulWidget {
  final String contents;
  final double fontSize;

  final Function doneCallback;
  final bool show;

  const TextTypewriter(
    this.contents, {
    super.key,
    this.fontSize = 30.0,
    required this.doneCallback,
    this.show = false,
  });

  @override
  State<TextTypewriter> createState() => _TextTypewriterState();
}

class _TextTypewriterState extends State<TextTypewriter>
    with TickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    _ctrl = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: widget.contents.length * 20,
      ),
    );

    _ctrl.addStatusListener((status) {
      print("AA ${status}");
      if (status == AnimationStatus.completed) {
        widget.doneCallback();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.show && !_ctrl.isAnimating && _ctrl.value < 0.1) {
      print('Now ready!');
      _ctrl.forward();
    }

    return AnimatedBuilder(
      animation: _ctrl,
      builder: (contex, _widget) {
        return Text(
          widget.contents.substring(
            0,
            (widget.contents.length * _ctrl.value).toInt(),
          ),
          style: TextStyle(
            fontFamily: 'Typewriter',
            fontSize: widget.fontSize,
          ),
        );
      },
    );
  }
}
