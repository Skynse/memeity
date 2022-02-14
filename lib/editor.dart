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
    required this.properties,
  }) : super(key: key);
  final ToolBar toolbar;
  final PropertiesWindow properties;

  void getToolbar() => toolbar;

  @override
  State<Editor> createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  // create a tree map to store the nodes with id as key
  Map<int, Node> tree = Map<int, Node>();

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
                          });
                        },
                      ),
                    ),
                  ),
                ] +
                tree.entries.map((e) => e.value).toList(),
          ),
        ),
      ),
    );
  }

  void addTool(Tools tool, pos) async {
    switch (tool) {
      case Tools.text:
        var field = TextButton(
            onPressed: () {},
            child: Text(
              "TEXT HERE",
              style: TextStyle(color: Color.fromARGB(255, 70, 70, 70)),
            ));
        var txt = CustomText(
          id: tree.length,
          editor: this.widget,
          pos: pos,
          child: field as Widget,
          tree: tree,
          toolbar: widget.toolbar,
        );
        tree.addEntries([MapEntry(txt.id, txt)]);
        print(tree);
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
          var image = Image.file(
            File(result.files.first.path.toString()),
          );
          var img = CustomImage(
            id: tree.length,
            editor: widget,
            pos: pos,
            child: image,
            tree: tree,
            toolbar: widget.toolbar,
          );
          tree.addEntries([MapEntry(img.id, img)]);
        }
        break;
      case Tools.select:
        break;
    }
  }
}
