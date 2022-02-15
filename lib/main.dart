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
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Memeity',
      theme: ThemeData(
        // dark theme
        brightness: Brightness.dark,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        primarySwatch: Colors.lightBlue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Row(children: [
        Expanded(
          child: Column(children: <Widget>[
            Padding(padding: const EdgeInsets.all(8), child: toolbar),
            editor,
          ]),
        ),
      ]),
    );
  }
}
