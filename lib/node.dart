import 'package:flutter/material.dart';
import 'editor.dart';
import 'toolbar.dart';

// ignore: must_be_immutable
mixin showProperties {
  void showPopup(BuildContext context, Node widget) {
    showMenu(
      color: Color.fromARGB(255, 155, 155, 155),
      context: context,
      position: RelativeRect.fromLTRB(
        widget.pos.globalPosition.dx,
        widget.pos.globalPosition.dy,
        widget.pos.globalPosition.dx,
        widget.pos.globalPosition.dy,
      ),
      items: [
        PopupMenuItem(
          child: Text('Delete'),
          value: 'delete',
          onTap: () {},
        ),
        PopupMenuItem(
          child: Text('Edit'),
          value: 'edit',
        ),
      ],
    );
  }
  // create a map of all the properties of the widget
}

class Node extends StatefulWidget {
  final TapUpDetails pos;
  final Widget child;
  final ToolBar toolbar;
  final Editor editor;
  final int id;
  Map<int, Node> tree;
  Offset offset;
  bool selected;

  Node({
    Key? key,
    required this.pos,
    required this.child,
    required this.toolbar,
    required this.editor,
    required this.id,
    required this.tree,
    this.selected = false,
    this.offset = Offset.zero,
  }) : super(key: key);

  @override
  _NodeState createState() => _NodeState();
}

class _NodeState extends State<Node> with showProperties {
  @override
  void initState() {
    super.initState();
    widget.tree[widget.id] = this.widget;
  }

  void deleteSelf() {
    setState(() {
      widget.tree.remove(widget.id);
    });
  }

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
              // get mouse position
              showPopup(context, widget);
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
    if (widget.selected) {}
    if (widget.toolbar.selectedTool == Tools.select) {
      setState(() {
        widget.selected = !widget.selected;
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
    required Map<int, Node> tree,
    required int id,
  }) : super(
          key: key,
          pos: pos,
          child: child,
          toolbar: toolbar,
          editor: editor,
          tree: tree,
          id: id,
        );

  void onSelected() {}
}

class _CustomTextState extends State<CustomText> with showProperties {
  @override
  Widget build(BuildContext context) {
    return Node(
      pos: widget.pos,
      selected: false,
      toolbar: widget.toolbar,
      editor: widget.editor,
      tree: widget.tree,
      id: widget.id,
      child: Container(
        width: 100,
        height: 100,
        child: widget.child,
      ),
    );
  }
}

class CustomImage extends Node with showProperties {
  CustomImage({
    Key? key,
    required TapUpDetails pos,
    required Widget child,
    required ToolBar toolbar,
    required Editor editor,
    required Map<int, Node> tree,
    required int id,
  }) : super(
          key: key,
          pos: pos,
          child: child,
          toolbar: toolbar,
          editor: editor,
          tree: tree,
          id: id,
        );
}
