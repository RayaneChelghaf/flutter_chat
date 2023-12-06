import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart' hide Image;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_chat/draw/drawing_canvas/drawing_canvas.dart';
import 'package:flutter_chat/draw/drawing_canvas/models/drawing_mode.dart';
import 'package:flutter_chat/draw/drawing_canvas/models/random_word.dart';
import 'package:flutter_chat/draw/drawing_canvas/models/sketch.dart';
import 'package:flutter_chat/draw/drawing_canvas/widgets/canvas_side_bar.dart';

const Color backgroundColor = Color.fromARGB(255, 241, 243, 248);

class DrawingPage extends HookWidget {
  const DrawingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedColor = useState(Colors.black);
    final strokeSize = useState<double>(10);
    final eraserSize = useState<double>(30);
    final drawingMode = useState(DrawingMode.pencil);
    final canvasGlobalKey = GlobalKey();
    final randomWord = useState<String>('');
    final timerValueNotifier = useState<int>(5);
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 120),
      initialValue: 1,
    );

    final currentSketch = useState<Sketch?>(null);
    final allSketches = useState<List<Sketch>>([]);

    Future<void> getRandomWord() async {
      final random = Random();
      final index = random.nextInt(RandomWords.randomWordsList.length);
      final word = RandomWords.randomWordsList[index];
      randomWord.value = word;
      timerValueNotifier.value = 5;
    }

    final timerStream = Stream.periodic(const Duration(seconds: 1), (count) {
    });
    useEffect(() {
        getRandomWord();
      final subscription = timerStream.listen((event) {
        if (timerValueNotifier.value > 0) {
          timerValueNotifier.value--;
        } else {
          getRandomWord();
        }
      });

      return () {
        subscription.cancel();
      };
    }, const []);

    const titre = "Dessin";

    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: backgroundColor,
            width: double.maxFinite,
            height: double.maxFinite,
            child: DrawingCanvas(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              drawingMode: drawingMode,
              selectedColor: selectedColor,
              strokeSize: strokeSize,
              eraserSize: eraserSize,
              sideBarController: animationController,
              currentSketch: currentSketch,
              allSketches: allSketches,
              canvasGlobalKey: canvasGlobalKey,
            ),
          ),
          Positioned(
            top: kToolbarHeight + 10,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(-1, 0),
                end: Offset.zero,
              ).animate(animationController),
              child: CanvasSideBar(
                drawingMode: drawingMode,
                selectedColor: selectedColor,
                strokeSize: strokeSize,
                eraserSize: eraserSize,
                currentSketch: currentSketch,
                allSketches: allSketches,
                canvasGlobalKey: canvasGlobalKey,
              ),
            ),
          ),
          _CustomAppBar(animationController: animationController, titre: titre, randomWord: randomWord.value, timerValue: timerValueNotifier.value),
        ],
      ),
    );
  }
}

class _CustomAppBar extends StatelessWidget {
  final AnimationController animationController;
  final String randomWord;
  final String titre;
  final int timerValue;

  const _CustomAppBar({Key? key, required this.animationController, required this.titre, required this.randomWord, required this.timerValue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kToolbarHeight + 8,
      width: double.maxFinite,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 10,
          bottom: 10,
          left: 10,
          right: 10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                animationController.value == 0 ? animationController.forward() : animationController.reverse();
              },
              icon: const Icon(Icons.menu),
            ),
            Text(
              titre,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 19,
              ),
            ),
            Container(
              child: Column(
                children: [
                  Text(
                    randomWord,
                    style: const TextStyle(fontSize: 17, color: Colors.red),
                  ),
                  Text(
                    'Timer: $timerValue',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
