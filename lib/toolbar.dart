import 'package:flutter/material.dart';

import 'editor.dart';

enum Tools {
  none,
  text,
  brush,
  image,
  select,
}

//global variable selectedTool

// ignore: must_be_immutable
class ToolBar extends StatefulWidget {
  ToolBar({Key? key, this.selectedTool = Tools.none}) : super(key: key);

  var selectedTool = Tools.none;

  @override
  _ToolBarState createState() => _ToolBarState();
}

class _ToolBarState extends State<ToolBar> {
  final _isSelected = [false, false, false, false];
  final buttonLabels = [Tools.text, Tools.brush, Tools.image, Tools.select];
  Tools toggle = Tools.text;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Row(
        // center contents
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        // limit
        children: [
          //toggle button with icon
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.grey[300],
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[500]!,
                  spreadRadius: 1,
                  blurRadius: 15,
                  offset: Offset(1, 1), // changes position of shadow
                ),
                const BoxShadow(
                  color: Color.fromARGB(255, 75, 75, 75),
                  offset: Offset(-4, -4),
                  blurRadius: 15,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: ToggleButtons(
              highlightColor: Color.fromARGB(255, 168, 118, 115),
              borderColor: Colors.transparent,
              color: Colors.indigo,
              children: const <Widget>[
                Icon(
                  Icons.text_fields_outlined,
                  size: 30,
                ),
                Icon(
                  Icons.brush_outlined,
                  size: 30,
                ),
                Icon(
                  Icons.image_search_outlined,
                  size: 30,
                ),
                Icon(
                  Icons.mouse_outlined,
                  size: 30,
                )
              ],
              onPressed: (int index) {
                setState(() {
                  for (int buttonIndex = 0;
                      buttonIndex < _isSelected.length;
                      buttonIndex++) {
                    if (buttonIndex == index) {
                      _isSelected[buttonIndex] = true;
                      switch (buttonIndex) {
                        case 0:
                          toggle = Tools.text;
                          widget.selectedTool = toggle;

                          break;
                        case 1:
                          toggle = Tools.brush;
                          widget.selectedTool = Tools.brush;
                          break;
                        case 2:
                          toggle = Tools.image;
                          widget.selectedTool = Tools.image;
                          break;
                        case 3:
                          toggle = Tools.select;
                          widget.selectedTool = Tools.select;
                          break;
                      }
                    } else {
                      _isSelected[buttonIndex] = false;
                    }
                  }
                });
              },
              isSelected: _isSelected,
            ),
          ),
        ],
      ),
    );
  }
}
