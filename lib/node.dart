import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'editor.dart';
import 'toolbar.dart';

// ignore: must_be_immutable
mixin showProperties {
  void showPopup(BuildContext context, Node widget) {}
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

  void dispose() {
    widget.tree.remove(widget.id);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned(
        left: widget.offset.dx,
        top: widget.offset.dy,
        child: GestureDetector(
          child: widget.child,
          onDoubleTap: () {
            // get mouse position
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
                  onTap: () {
                    setState(() {
                      widget.tree.remove(widget.id);
                    });
                  },
                ),
                const PopupMenuItem(
                  child: Text('Edit'),
                  value: 'edit',
                ),
              ],
            );
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
    ]);
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

class ResizableWidget extends StatefulWidget {
  ResizableWidget({required this.child});

  final Widget child;
  @override
  _ResizableWidgetState createState() => _ResizableWidgetState();
}

const ballDiameter = 30.0;

class _ResizableWidgetState extends State<ResizableWidget> {
  double height = 400;
  double width = 200;

  double top = 0;
  double left = 0;

  void onDrag(double dx, double dy) {
    var newHeight = height + dy;
    var newWidth = width + dx;

    setState(() {
      height = newHeight > 0 ? newHeight : 0;
      width = newWidth > 0 ? newWidth : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: top,
          left: left,
          child: Container(
            height: height,
            width: width,
            color: Colors.transparent,
            child: widget.child,
          ),
        ),
        // top left
        Positioned(
          top: top - ballDiameter / 2,
          left: left - ballDiameter / 2,
          child: ManipulatingBall(
            onDrag: (dx, dy) {
              var mid = (dx + dy) / 2;
              var newHeight = height - 2 * mid;
              var newWidth = width - 2 * mid;

              setState(() {
                height = newHeight > 0 ? newHeight : 0;
                width = newWidth > 0 ? newWidth : 0;
                top = top + mid;
                left = left + mid;
              });
            },
          ),
        ),
        // top middle
        Positioned(
          top: top - ballDiameter / 2,
          left: left + width / 2 - ballDiameter / 2,
          child: ManipulatingBall(
            onDrag: (dx, dy) {
              var newHeight = height - dy;

              setState(() {
                height = newHeight > 0 ? newHeight : 0;
                top = top + dy;
              });
            },
          ),
        ),
        // top right
        Positioned(
          top: top - ballDiameter / 2,
          left: left + width - ballDiameter / 2,
          child: ManipulatingBall(
            onDrag: (dx, dy) {
              var mid = (dx + (dy * -1)) / 2;

              var newHeight = height + 2 * mid;
              var newWidth = width + 2 * mid;

              setState(() {
                height = newHeight > 0 ? newHeight : 0;
                width = newWidth > 0 ? newWidth : 0;
                top = top - mid;
                left = left - mid;
              });
            },
          ),
        ),
        // center right
        Positioned(
          top: top + height / 2 - ballDiameter / 2,
          left: left + width - ballDiameter / 2,
          child: ManipulatingBall(
            onDrag: (dx, dy) {
              var newWidth = width + dx;

              setState(() {
                width = newWidth > 0 ? newWidth : 0;
              });
            },
          ),
        ),
        // bottom right
        Positioned(
          top: top + height - ballDiameter / 2,
          left: left + width - ballDiameter / 2,
          child: ManipulatingBall(
            onDrag: (dx, dy) {
              var mid = (dx + dy) / 2;

              var newHeight = height + 2 * mid;
              var newWidth = width + 2 * mid;

              setState(() {
                height = newHeight > 0 ? newHeight : 0;
                width = newWidth > 0 ? newWidth : 0;
                top = top - mid;
                left = left - mid;
              });
            },
          ),
        ),
        // bottom center
        Positioned(
          top: top + height - ballDiameter / 2,
          left: left + width / 2 - ballDiameter / 2,
          child: ManipulatingBall(
            onDrag: (dx, dy) {
              var newHeight = height + dy;

              setState(() {
                height = newHeight > 0 ? newHeight : 0;
              });
            },
          ),
        ),
        // bottom left
        Positioned(
          top: top + height - ballDiameter / 2,
          left: left - ballDiameter / 2,
          child: ManipulatingBall(
            onDrag: (dx, dy) {
              var mid = ((dx * -1) + dy) / 2;

              var newHeight = height + 2 * mid;
              var newWidth = width + 2 * mid;

              setState(() {
                height = newHeight > 0 ? newHeight : 0;
                width = newWidth > 0 ? newWidth : 0;
                top = top - mid;
                left = left - mid;
              });
            },
          ),
        ),
        //left center
        Positioned(
          top: top + height / 2 - ballDiameter / 2,
          left: left - ballDiameter / 2,
          child: ManipulatingBall(
            onDrag: (dx, dy) {
              var newWidth = width - dx;

              setState(() {
                width = newWidth > 0 ? newWidth : 0;
                left = left + dx;
              });
            },
          ),
        ),
        // center center
        Positioned(
          top: top + height / 2 - ballDiameter / 2,
          left: left + width / 2 - ballDiameter / 2,
          child: ManipulatingBall(
            onDrag: (dx, dy) {
              setState(() {
                top = top + dy;
                left = left + dx;
              });
            },
          ),
        ),
      ],
    );
  }
}

class ManipulatingBall extends StatefulWidget {
  const ManipulatingBall({Key? key, required this.onDrag});

  final Function onDrag;

  @override
  _ManipulatingBallState createState() => _ManipulatingBallState();
}

class _ManipulatingBallState extends State<ManipulatingBall> {
  late double initX;
  late double initY;

  _handleDrag(details) {
    setState(() {
      initX = details.globalPosition.dx;
      initY = details.globalPosition.dy;
    });
  }

  _handleUpdate(details) {
    var dx = details.globalPosition.dx - initX;
    var dy = details.globalPosition.dy - initY;
    initX = details.globalPosition.dx;
    initY = details.globalPosition.dy;
    widget.onDrag(dx, dy);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _handleDrag,
      onPanUpdate: _handleUpdate,
      child: Container(
        width: ballDiameter,
        height: ballDiameter,
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('initX', initX));
  }
}
