import 'dart:ui';

import 'package:flutter/material.dart';
import 'toolbar.dart';
import 'tools.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';

class Editor extends StatefulWidget {
  const Editor({Key? key, required this.toolbar}) : super(key: key);
  final ToolBar toolbar;

  @override
  State<Editor> createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  final children = <Widget>[];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: GridPaper(
          color: Colors.grey,
          interval: 200,
          child: Stack(
            children: <Widget>[
                  GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      child: Container(),
                      onTapUp: (pos) {
                        setState(() {
                          var tool = widget.toolbar.selectedTool;
                          addTool(tool, pos);
                        });
                      })
                ] +
                children,
          ),
        ),
      ),
    );
  }

  void addTool(Tools tool, pos) async {
    switch (tool) {
      case Tools.text:
        var txt = CustomText(
          pos: pos,
        );
        children.add(txt);
        break;
      case Tools.none:
        print("None");
        break;
      case Tools.brush:
        // TODO: Handle this case.
        break;
      case Tools.image:
        // open file picker
        FilePickerResult? result = await FilePicker.platform.pickFiles();
        if (result != null) {
          var img = CustomImage(
            pos: pos,
            path: result.files.single.path.toString(),
          );
          children.add(img);
        }
        break;
      case Tools.select:
        // TODO: Handle this case.
        break;
    }
  }
}
