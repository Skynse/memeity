import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:memeity/properties.dart';
import 'toolbar.dart';
import 'node.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';

class Editor extends StatefulWidget {
  const Editor({Key? key, required this.toolbar, required this.properties})
      : super(key: key);
  final ToolBar toolbar;
  final PropertiesWindow properties;

  void getToolbar() => toolbar;

  @override
  State<Editor> createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  final tree = <Widget>[];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 500,
        child: Stack(
          children: <Widget>[
                GridPaper(
                    color: Colors.grey,
                    interval: 200,
                    child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        child: Container(),
                        onTapUp: (pos) {
                          setState(() {
                            var tool = widget.toolbar.selectedTool;
                            addTool(tool, pos);
                          });
                        }))
              ] +
              tree,
        ),
      ),
    );
  }

  void addTool(Tools tool, pos) async {
    switch (tool) {
      case Tools.text:
        var field = TextButton(
          onPressed: () {},
          child: const Text("Text"),
        );
        var txt = CustomText(
          editor: this.widget,
          pos: pos,
          child: field,
          toolbar: widget.toolbar,
        );
        tree.add(txt);
        break;
      case Tools.none:
        // ignore: avoid_print
        print("None");
        break;
      case Tools.brush:
        break;
      case Tools.image:
        // open file picker
        FilePickerResult? result = await FilePicker.platform.pickFiles();
        if (result != null) {
          var image = Image.file(File(result.files.first.path.toString()));
          var img = CustomImage(
            editor: this.widget,
            pos: pos,
            child: image,
            toolbar: widget.toolbar,
          );
          tree.add(img);
        }
        break;
      case Tools.select:
        break;
    }
  }
}
