import 'package:flutter/material.dart';

class ColorPalette extends StatelessWidget {
  final ValueNotifier<Color> selectedColor;

  const ColorPalette({
    Key? key,
    required this.selectedColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = [
      Colors.black,
      Colors.white,
      ...Colors.primaries,
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 2,
          runSpacing: 2,
          children: colors
              .map((color) => MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => selectedColor.value = color,
                      child: Container(
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                          color: color,
                          border: Border.all(
                            color: selectedColor.value == color ? Colors.blue : Colors.grey,
                            width: 1.5,
                          ),
                          borderRadius: const BorderRadius.all(Radius.circular(5)),
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
