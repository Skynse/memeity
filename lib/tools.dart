import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomText extends StatefulWidget {
  const CustomText({
    Key? key,
    this.text = "",
    this.size = 40,
    this.color = Colors.black,
    this.fontWeight = FontWeight.normal,
    this.fontStyle = FontStyle.normal,
    this.pos,
  }) : super(key: key);

  @override
  _CustomTextState createState() => _CustomTextState();

  final String text;
  final double size;
  final Color color;
  final FontWeight fontWeight;
  final FontStyle fontStyle;
  final dynamic pos;
}

class _CustomTextState extends State<CustomText> {
  Offset offset = Offset.zero;
  @override
  Widget build(BuildContext context) {
    var _top = offset.dy;
    var _left = offset.dx;
    return Stack(
      children: [
        Positioned(
          left: offset.dx,
          top: offset.dy,
          child: GestureDetector(
            child: TextButton(
                onPressed: () {},
                child: Text("Text",
                    style: TextStyle(
                        fontSize: widget.size,
                        color: widget.color,
                        fontWeight: widget.fontWeight,
                        fontStyle: widget.fontStyle))),
            onPanUpdate: (details) {
              setState(() {
                offset = Offset(
                    offset.dx + details.delta.dx, offset.dy + details.delta.dy);
              });
            },
          ),
        ),
      ],
    );
  }
}

class CustomImage extends StatefulWidget {
  CustomImage({
    Key? key,
    required this.path,
    required this.pos,
  }) : super(key: key);

  _CustomImageState createState() => _CustomImageState();

  final String path;
  final TapUpDetails pos;
}

class _CustomImageState extends State<CustomImage> {
  Offset offset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    //draggable image
    var _top = offset.dy;
    var _left = offset.dx;
    return Stack(
      children: [
        Positioned(
          left: offset.dx,
          top: offset.dy,
          child: GestureDetector(
            child: Image.file(File(widget.path)),
            onPanUpdate: (details) {
              print(details);
              setState(() {
                offset = Offset(
                    offset.dx + details.delta.dx, offset.dy + details.delta.dy);
              });
            },
          ),
        ),
      ],
    );
  }
}
