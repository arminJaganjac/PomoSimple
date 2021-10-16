import 'package:flutter/material.dart';

class Counter extends StatefulWidget {
  const Counter(this.id, this.pomodoroCount, {Key? key}) : super(key: key);

  final int id;
  final int pomodoroCount;

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  Color? _whichColor() {
    if (widget.pomodoroCount >= widget.id) {
      return Colors.blue[300];
    } else {
      return Colors.grey[200];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 20.0,
                height: 20.0,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                width: 15.0,
                height: 15.0,
                decoration: BoxDecoration(
                  color: _whichColor(),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
