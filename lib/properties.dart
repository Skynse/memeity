import 'package:flutter/material.dart';
import 'package:memeity/node.dart';
import 'editor.dart';

class PropertiesWindow extends StatefulWidget {
  String selectedWidget;
  PropertiesWindow({Key? key, this.selectedWidget = ""}) : super(key: key);

  @override
  _PropertiesWindowState createState() => _PropertiesWindowState();

  void setSelectedWidget(Widget widget) {}
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
    //sidebar
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                Container(
                  child: Text(
                    "Properties",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              children: <Widget>[
                Container(
                  child: Text(
                    "Widget",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              children: <Widget>[
                Container(
                  child: Text(
                    "Text",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              children: <Widget>[
                Container(
                  child: Text(
                    "Image",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              children: <Widget>[
                Container(
                  child: Text(
                    "Button",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              children: <Widget>[
                Container(
                  child: Text(
                    "Editor",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
