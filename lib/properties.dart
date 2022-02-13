import 'package:flutter/material.dart';
import 'package:memeity/node.dart';
import 'editor.dart';

class PropertiesWindow extends StatefulWidget {
  String selectedWidget;
  PropertiesWindow({Key? key, this.selectedWidget = ""}) : super(key: key);

  @override
  _PropertiesWindowState createState() => _PropertiesWindowState();

  void setSelectedWidget(Node widget) {}
}

class _PropertiesWindowState extends State<PropertiesWindow> {
  set selectedWidget(String selectedWidget) {}

  void setSelectedWidget(String widget) {
    setState(() {
      this.selectedWidget = widget;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Text(
            "Properties",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Text(
          "Selected widget: ${widget.selectedWidget}",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}
