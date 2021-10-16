import 'package:flutter/material.dart';

class Pomodoro extends StatefulWidget {
  const Pomodoro(
      {Key? key,
      required this.controller,
      required this.duration,
      required this.forward})
      : super(key: key);
  final AnimationController controller;
  final double duration;
  final bool forward;

  @override
  State<Pomodoro> createState() => _PomodoroState();
}

class _PomodoroState extends State<Pomodoro>
    with SingleTickerProviderStateMixin {
  double size = 250;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[300],
          ),
        ),
        SizedBox(
          height: size,
          width: size,
          child: CircularProgressIndicator(
            value: 1 - widget.controller.value,
            strokeWidth: 8,
          ),
        ),
        Column(
          children: [
            Text(
              widget.forward
                  ? (widget.duration * (1 - widget.controller.value))
                      .floor()
                      .toString()
                      .padLeft(2, '0')
                  : (widget.duration * (widget.controller.value))
                      .floor()
                      .toString()
                      .padLeft(2, '0'),
              style: const TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              widget.forward
                  ? ((60 * widget.duration * (1 - widget.controller.value)) -
                          (widget.duration * (1 - widget.controller.value))
                                  .floor() *
                              60)
                      .toInt()
                      .toString()
                      .padLeft(2, '0')
                  : ((60 * widget.duration * (widget.controller.value)) -
                          (widget.duration * (widget.controller.value))
                                  .floor() *
                              60)
                      .toInt()
                      .toString()
                      .padLeft(2, '0'),
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        )
      ],
    );
  }
}
