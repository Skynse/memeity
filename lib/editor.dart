import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:memeity/properties.dart';
import 'toolbar.dart';
import 'node.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';

class Editor extends StatefulWidget {
  const Editor({
    Key? key,
    required this.toolbar,
    this.projectname = "untitled",
  }) : super(key: key);
  final ToolBar toolbar;
  final String projectname;

  void getToolbar() => toolbar;

  @override
  State<Editor> createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  // create a tree map to store the nodes with id as key
  List<Widget> tree = [];

  @override
  void initState() {
    super.initState();
    // add the root nod
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        child: InteractiveViewer(
          minScale: 0.1,
          maxScale: 100,
          child: Stack(
            children: <Widget>[
                  Container(
                    //neumorphic effect,
                    color: Colors.grey[900],
                    child: GridPaper(
                      color: Colors.grey,
                      interval: 200,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        child: Container(),
                        onTapUp: (pos) {
                          setState(() {
                            var tool = widget.toolbar.selectedTool;
                            addTool(tool, pos);
                            print('adding tool');
                          });
                        },
                      ),
                    ),
                  ),
                ] +
                tree,
          ),
        ),
      ),
    );
  }

  void addTool(Tools tool, pos) async {
    switch (tool) {
      case Tools.text:
        var txt = CustomText(
          id: tree.length,
          editor: widget,
          pos: pos,
          tree: tree,
          toolbar: widget.toolbar,
        );
        tree.add(txt);
        print(tree);
        break;
      case Tools.none:
        // ignore: avoid_print
        break;
      case Tools.brush:
        break;
      case Tools.image:
        // open file picker
        FilePickerResult? result = await FilePicker.platform.pickFiles();
        if (result != null) {
          var img = CustomImage(
            id: tree.length,
            editor: widget,
            pos: pos,
            tree: tree,
            toolbar: widget.toolbar,
            path: result.files.first.path.toString(),
          );
          tree.add(img);
        }
        break;
      case Tools.select:
        break;
    }
  }
}
