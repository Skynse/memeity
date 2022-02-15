import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'editor.dart';
import 'toolbar.dart';

// ignore: must_be_immutable
mixin showProperties {
  void showPopup(BuildContext context, Widget widget) {}
  // create a map of all the properties of the widget
}

class Draggable extends StatefulWidget {
  final TapUpDetails pos;
  final Widget child;
  final int id;
  final ToolBar toolbar;
  final Editor editor;
  List<Widget> tree;
  Offset offset;
  bool selected;
  VoidCallback onTap;

  Draggable({
    Key? key,
    required this.pos,
    required this.child,
    required this.id,
    required this.tree,
    required this.editor,
    required this.toolbar,
    required this.onTap,
    this.selected = false,
    this.offset = Offset.zero,
  }) : super(key: key);

  @override
  _DraggableState createState() => _DraggableState();
}

class _DraggableState extends State<Draggable> with showProperties {
  @override
  void initState() {
    super.initState();
    //init ontap function
  }

  @override
  void dispose() {
    widget.tree.removeAt(widget.id);
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
            widget.onTap();
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
      });
    }
  }
}

class CustomText extends StatefulWidget {
  String text;
  TapUpDetails pos;
  Editor editor;
  ToolBar toolbar;
  int id;
  List<Widget> tree;

  CustomText({
    Key? key,
    required this.id,
    this.text = "TEXT GOES HERE",
    required this.pos,
    required this.editor,
    required this.tree,
    required this.toolbar,
  }) : super(key: key);
  @override
  _CustomTextState createState() => _CustomTextState();
}

class _CustomTextState extends State<CustomText> {
  final controller = TextEditingController();
  late String text_;
  @override
  void initState() {
    text_ = widget.text;
    super.initState();
  }

  @override
  void dispose() {
    widget.tree.removeAt(widget.id);
    controller.dispose();
    super.dispose();
  }

  void updateTexts() {
    text_ = controller.text;
  }

  void onTap() {
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
              print(widget.tree);
            });
          },
        ),
        PopupMenuItem(
          child: TextField(
            controller: controller,
            onChanged: (tex) {
              setState(() {
                text_ = controller.text;
              });
            },
            onSubmitted: (value) {
              print("sub");
              setState(() {
                text_ = value;
              });
            },
          ),
          value: 'edit',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Draggable(
      pos: widget.pos,
      onTap: onTap,
      child: TextButton(
        onPressed: () {},
        child: Text(
          text_,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: Color.fromARGB(255, 184, 184, 184),
          ),
        ),
      ),
      id: widget.id,
      tree: widget.tree,
      editor: widget.editor,
      toolbar: widget.toolbar,
    );
  }
}

class CustomImage extends StatefulWidget {
  TapUpDetails pos;
  ToolBar toolbar;
  Editor editor;
  int id;
  String path;
  List<Widget> tree;
  Offset offset;
  bool selected;
  double scale;

  CustomImage({
    Key? key,
    required this.pos,
    required this.id,
    required this.tree,
    required this.editor,
    required this.toolbar,
    required this.path,
    this.scale = 1.0,
    this.selected = false,
    this.offset = Offset.zero,
  }) : super(key: key);
  @override
  _CustomImageState createState() => _CustomImageState();
}

class _CustomImageState extends State<CustomImage> {
  late String path_;
  late double scale_;

  void initState() {
    path_ = widget.path;
    scale_ = widget.scale;
    super.initState();
  }

  void onTap() {
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
              //delete widget
            });
          },
        ),
        const PopupMenuItem(
          child: Text('Edit'),
          value: 'edit',
        ),
        PopupMenuItem(
          child: Slider(
            value: scale_,
            min: 0.0,
            max: 1.0,
            onChanged: (value) {
              setState(() {
                scale_ = value;
              });
            },
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Draggable(
      pos: widget.pos,
      onTap: onTap,
      id: widget.id,
      child: Image.file(
        File(path_),
        width: 100,
        height: 100,
      ),
      tree: widget.tree,
      editor: widget.editor,
      toolbar: widget.toolbar,
    );
  }
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
