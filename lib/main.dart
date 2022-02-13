import 'package:flutter/material.dart';
import 'package:memeity/editor.dart';
import 'editor.dart';
import 'toolbar.dart';
import 'properties.dart';

void main() {
  runApp(const MainView());
}

class MainView extends StatelessWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ToolBar toolbar = ToolBar();
    PropertiesWindow properties = PropertiesWindow();
    Editor editor = Editor(
      toolbar: toolbar,
      properties: properties,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Memeity',
      theme: ThemeData(
        // dark theme
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 206, 11, 95),
        ),
        primarySwatch: Colors.grey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Row(children: [
        Expanded(
          child: Column(children: <Widget>[
            toolbar,
            editor,
          ]),
        ),
      ]),
    );
  }
}
