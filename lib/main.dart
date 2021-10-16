import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:simple_pomodoro/counter.dart';
import 'package:simple_pomodoro/custom_slider.dart';
import 'package:simple_pomodoro/pomodoro.dart';
import 'package:wakelock/wakelock.dart';

void main() => {runApp(const MyApp())};

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PomoSimple',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  bool playButton = true;
  bool forward = true;

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
    controller = AnimationController(vsync: this)
      ..addListener(() {
        setState(() {});
      });

    controller.duration = const Duration(minutes: 25);
    controller.reverseDuration = const Duration(minutes: 5);
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        pomodoroCounter++;
        player.play(startSound);
      } else if (status == AnimationStatus.dismissed && pomodoroCounter > 0) {
        player.play(startSound);
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  double size = 200;
  int pomodoroCounter = 0;

  double pomodoro = 25;
  double shortBreak = 5;
  double longBreak = 20;

  void _resetDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Warning!'),
          content:
              const Text('Do you really want to reset your current session?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                pomodoroCounter = 0;
                controller.reset();
                controller.stop();
                setState(() {
                  playButton = true;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  static AudioCache player = AudioCache();
  final startSound = "start.wav";
  double duration = 25;

  void _runTimer() {
    forward ? controller.forward() : controller.reverse();
    controller.addStatusListener(
      (status) {
        if (status == AnimationStatus.completed && pomodoroCounter == 4) {
          duration = longBreak;
          forward = false;
          controller.reverseDuration = Duration(minutes: longBreak.toInt());
          controller.reverse();
          return;
        } else if (status == AnimationStatus.completed &&
            pomodoroCounter != 4) {
          duration = shortBreak;
          forward = false;
          controller.reverseDuration = Duration(minutes: shortBreak.toInt());
          controller.reverse();
          return;
        } else if (status == AnimationStatus.dismissed) {
          duration = pomodoro;
          forward = true;
          controller.forward();
          return;
        } else if (pomodoroCounter >= 8) {
          controller.stop();
          forward = true;
          return;
        }
      },
    );
  }

  void _showSnackBar() {
    const settingsSnackBar =
        SnackBar(content: Text('Pause the timer before opening settings!'));
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(settingsSnackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('PomoSimple'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Counter(1, pomodoroCounter),
                    Counter(2, pomodoroCounter),
                    Counter(3, pomodoroCounter),
                    Counter(4, pomodoroCounter),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Counter(5, pomodoroCounter),
                    Counter(6, pomodoroCounter),
                    Counter(7, pomodoroCounter),
                    Counter(8, pomodoroCounter),
                  ],
                ),
              ),
            ],
          ),
          Pomodoro(
            duration: duration,
            controller: controller,
            forward: forward,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Ink(
                decoration: const ShapeDecoration(
                  color: Colors.blue,
                  shape: CircleBorder(),
                ),
                child: IconButton(
                  icon: const Icon(Icons.replay_sharp),
                  color: Colors.white,
                  onPressed: () {
                    _resetDialog();
                  },
                ),
              ),
              Ink(
                decoration: const ShapeDecoration(
                  color: Colors.blue,
                  shape: CircleBorder(),
                ),
                child: IconButton(
                  icon: Icon(
                      playButton ? Icons.play_arrow_sharp : Icons.pause_sharp),
                  color: Colors.white,
                  onPressed: () {
                    playButton ? _runTimer() : controller.stop();
                    setState(() {
                      playButton = !playButton;
                    });
                  },
                ),
              ),
              Ink(
                decoration: ShapeDecoration(
                  color: playButton ? Colors.blue : Colors.grey,
                  shape: const CircleBorder(),
                ),
                child: IconButton(
                  icon: const Icon(Icons.settings_sharp),
                  color: Colors.white,
                  onPressed: () {
                    !playButton
                        ? _showSnackBar()
                        : showModalBottomSheet(
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            )),
                            context: context,
                            builder: (context) {
                              return SizedBox(
                                height: 280,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    CustomSlider(
                                      title: 'Pomodoro Duration',
                                      maxValue: 60,
                                      minValue: 15,
                                      sliderValue: pomodoro,
                                      onChanged: (value) {
                                        setState(() {
                                          if (pomodoroCounter == 0) {
                                            duration = value;
                                          }
                                          pomodoro = value;
                                          controller.duration = Duration(
                                              minutes: pomodoro.toInt());
                                        });
                                      },
                                    ),
                                    CustomSlider(
                                      title: 'Short Break',
                                      maxValue: 20,
                                      minValue: 5,
                                      sliderValue: shortBreak,
                                      onChanged: (value) {
                                        setState(() {
                                          shortBreak = value;
                                          controller.reverseDuration = Duration(
                                              minutes: shortBreak.toInt());
                                        });
                                      },
                                    ),
                                    CustomSlider(
                                      title: 'Long Break',
                                      maxValue: 45,
                                      minValue: 10,
                                      sliderValue: longBreak,
                                      onChanged: (value) {
                                        setState(() {
                                          longBreak = value;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
