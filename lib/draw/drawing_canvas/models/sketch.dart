import 'package:flutter/material.dart';
import 'package:flutter_chat/draw/drawing_canvas/models/drawing_mode.dart';


class Sketch {
  final List<Offset> points;
  final Color color;
  final double size;
  final SketchType type;

  Sketch({
    required this.points,
    this.color = Colors.black,
    this.type = SketchType.scribble,
    this.size = 10,
  });

  factory Sketch.fromDrawingMode(Sketch sketch, DrawingMode drawingMode) {
    return Sketch(
      points: sketch.points,
      color: sketch.color,
      size: sketch.size,
      type: () {
        switch (drawingMode) {
          case DrawingMode.eraser:
          case DrawingMode.pencil:
            return SketchType.scribble;
          case DrawingMode.line:
            return SketchType.line;
          case DrawingMode.square:
            return SketchType.square;
          case DrawingMode.circle:
            return SketchType.circle;
          default:
            return SketchType.scribble;
        }
      }(),
    );
  }

  factory Sketch.fromJson(Map<String, dynamic> json) {
    List<Offset> points = (json['points'] as List).map((e) => Offset(e['dx'], e['dy'])).toList();
    return Sketch(
      points: points,
      size: json['size'],
    );
  }
}

enum SketchType {
  scribble,
  line,
  square,
  circle,
}