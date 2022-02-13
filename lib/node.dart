import 'package:flutter/material.dart';
import 'editor.dart';
import 'toolbar.dart';

// ignore: must_be_immutable
class Node extends StatefulWidget {
  final TapUpDetails pos;
  final Widget child;
  final ToolBar toolbar;
  final Editor editor;
  Offset offset;
  bool selected;

  Node({
    Key? key,
    required this.pos,
    required this.child,
    required this.toolbar,
    required this.editor,
    this.selected = false,
    this.offset = Offset.zero,
  }) : super(key: key);

  @override
  _NodeState createState() => _NodeState();
}

class _NodeState extends State<Node> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: widget.offset.dx,
          top: widget.offset.dy,
          child: GestureDetector(
            child: widget.child,
            onDoubleTap: () {
              toggleSelect();
            },
            onPanUpdate: (details) {
              if (widget.toolbar.selectedTool == Tools.select) {
                setState(() {
                  widget.offset = Offset(widget.offset.dx + details.delta.dx,
                      widget.offset.dy + details.delta.dy);
                });
              }
            },
          ),
        ),
      ],
    );
  }

  toggleSelect() {
    if (widget.toolbar.selectedTool == Tools.select) {
      setState(() {
        widget.selected = !widget.selected;
        print("selected: ${widget.selected}");

        widget.editor.properties.setSelectedWidget(widget);
      });
    }
  }
}

class CustomText extends Node {
  var state = _CustomTextState();

  CustomText({
    Key? key,
    required TapUpDetails pos,
    required Widget child,
    required ToolBar toolbar,
    required Editor editor,
  }) : super(
          key: key,
          pos: pos,
          child: child,
          toolbar: toolbar,
          editor: editor,
        );
}

class _CustomTextState extends State<CustomText> {
  @override
  Widget build(BuildContext context) {
    return Node(
      pos: widget.pos,
      selected: false,
      toolbar: widget.toolbar,
      editor: widget.editor,
      child: Container(
        width: 100,
        height: 100,
        child: widget.child,
      ),
    );
  }
}

class CustomImage extends Node {
  var state = _CustomTextState();
  CustomImage({
    Key? key,
    required TapUpDetails pos,
    required Widget child,
    required ToolBar toolbar,
    required Editor editor,
  }) : super(
          key: key,
          pos: pos,
          child: child,
          toolbar: toolbar,
          editor: editor,
        );
}
