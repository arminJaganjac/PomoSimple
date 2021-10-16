import 'package:flutter/material.dart';

// ignore: prefer_generic_function_type_aliases, avoid_types_as_parameter_names
typedef SliderCallback(double);

// ignore: must_be_immutable
class CustomSlider extends StatefulWidget {
  final String title;
  final double minValue;
  final double maxValue;
  double sliderValue;
  final SliderCallback onChanged;

  CustomSlider({
    Key? key,
    required this.title,
    required this.minValue,
    required this.maxValue,
    required this.sliderValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  _CustomSliderState createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          widget.title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Slider(
                min: widget.minValue,
                max: widget.maxValue,
                value: widget.sliderValue,
                onChanged: (newValue) {
                  setState(
                    () {
                      widget.sliderValue = newValue.roundToDouble();
                    },
                  );
                  widget.onChanged(widget.sliderValue);
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 20),
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Container(
                width: 30,
                alignment: Alignment.center,
                child: Text(
                  widget.sliderValue.round().toString(),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
