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
        // limit
        children: [
          //toggle button with icon
          ToggleButtons(
            borderColor: Colors.transparent,
            children: const <Widget>[
              Icon(
                Icons.text_fields,
                size: 30,
              ),
              Icon(
                Icons.brush,
                size: 30,
              ),
              Icon(
                Icons.image,
                size: 30,
              ),
              Icon(
                Icons.mouse,
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
        ],
      ),
    );
  }
}
