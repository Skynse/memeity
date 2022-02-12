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
    Editor editor = Editor(toolbar: toolbar);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Memeity',
      theme: ThemeData(
        // dark theme
        brightness: Brightness.dark,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        primarySwatch: Colors.grey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Column(children: <Widget>[
        const TitleBar(),
        toolbar, //make it possible to interact between toolbar and editor
        editor,
      ]),
    );
  }
}

class TitleBar extends StatelessWidget {
  const TitleBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(),
    );
  }
}
