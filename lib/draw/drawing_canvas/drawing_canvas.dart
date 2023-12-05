import 'package:flutter/material.dart' hide Image;
import 'package:flutter_chat/draw/drawing_canvas/models/drawing_mode.dart';
import 'package:flutter_chat/draw/drawing_canvas/models/sketch.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const Color backgroundColor = Color.fromARGB(255, 241, 243, 248);

class DrawingCanvas extends HookWidget {
  final double height;
  final double width;
  final ValueNotifier<Color> selectedColor;
  final ValueNotifier<double> strokeSize;
  final ValueNotifier<double> eraserSize;
  final ValueNotifier<DrawingMode> drawingMode;
  final AnimationController sideBarController;
  final ValueNotifier<Sketch?> currentSketch;
  final ValueNotifier<List<Sketch>> allSketches;
  final GlobalKey canvasGlobalKey;

  const DrawingCanvas({
    Key? key,
    required this.height,
    required this.width,
    required this.selectedColor,
    required this.strokeSize,
    required this.eraserSize,
    required this.drawingMode,
    required this.sideBarController,
    required this.currentSketch,
    required this.allSketches,
    required this.canvasGlobalKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.precise,
      child: Stack(
        children: [
          buildAllSketches(context),
          buildCurrentPath(context),
        ],
      ),
    );
  }

  void onPointerDown(PointerDownEvent details, BuildContext context) {
    final box = context.findRenderObject() as RenderBox;
    final offset = box.globalToLocal(details.position);
    currentSketch.value = Sketch.fromDrawingMode(
      Sketch(
        points: [
          offset
        ],
        size: drawingMode.value == DrawingMode.eraser ? eraserSize.value : strokeSize.value,
        color: drawingMode.value == DrawingMode.eraser ? backgroundColor : selectedColor.value,
      ),
      drawingMode.value,
    );
  }

  void onPointerMove(PointerMoveEvent details, BuildContext context) {
    final box = context.findRenderObject() as RenderBox;
    final offset = box.globalToLocal(details.position);
    final points = List<Offset>.from(currentSketch.value?.points ?? [])..add(offset);
    currentSketch.value = Sketch.fromDrawingMode(
      Sketch(
        points: points,
        size: drawingMode.value == DrawingMode.eraser ? eraserSize.value : strokeSize.value,
        color: drawingMode.value == DrawingMode.eraser ? backgroundColor : selectedColor.value,
      ),
      drawingMode.value,
    );
  }

  void onPointerUp(PointerUpEvent details) {
    allSketches.value = List<Sketch>.from(allSketches.value)..add(currentSketch.value!);
  }

  Widget buildAllSketches(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ValueListenableBuilder<List<Sketch>>(
        valueListenable: allSketches,
        builder: (context, sketches, _) {
          return RepaintBoundary(
            key: canvasGlobalKey,
            child: Container(
              height: height,
              width: width,
              color: backgroundColor,
              child: CustomPaint(
                painter: SketchPainter(
                  sketches: sketches,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildCurrentPath(BuildContext context) {
    return Listener(
      onPointerDown: (details) => onPointerDown(details, context),
      onPointerMove: (details) => onPointerMove(details, context),
      onPointerUp: onPointerUp,
      child: ValueListenableBuilder(
        valueListenable: currentSketch,
        builder: (context, sketch, child) {
          return RepaintBoundary(
            child: SizedBox(
              height: height,
              width: width,
              child: CustomPaint(
                painter: SketchPainter(
                  sketches: sketch == null
                      ? []
                      : [
                          sketch
                        ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class SketchPainter extends CustomPainter {
  final List<Sketch> sketches;

  const SketchPainter({
    Key? key,
    required this.sketches,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (Sketch sketch in sketches) {
      final points = sketch.points;
      if (points.isEmpty) continue;

      final path = Path();
      path.moveTo(points[0].dx, points[0].dy);

      for (int i = 1; i < points.length; ++i) {
        final p0 = points[i - 1];
        final p1 = points[i];
        path.quadraticBezierTo(
          p0.dx,
          p0.dy,
          (p0.dx + p1.dx) / 2,
          (p0.dy + p1.dy) / 2,
        );
      }

      Paint paint = Paint()
        ..color = sketch.color
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..strokeWidth = sketch.size;

      if (sketch.type == SketchType.scribble) {
        canvas.drawPath(path, paint);
      } else {
        Offset firstPoint = sketch.points.first;
        Offset lastPoint = sketch.points.last;
        Rect rect = Rect.fromPoints(firstPoint, lastPoint);

        if (sketch.type == SketchType.square) {
          canvas.drawRect(rect, paint);
        } else if (sketch.type == SketchType.line) {
          canvas.drawLine(firstPoint, lastPoint, paint);
        } else if (sketch.type == SketchType.circle) {
          canvas.drawOval(rect, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant SketchPainter oldDelegate) {
    return oldDelegate.sketches != sketches;
  }
}
