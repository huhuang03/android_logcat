import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'device.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> texts = [];
  Device device = Device();
  final ScrollController _scrollController = ScrollController();
  double fontSize = 20;
  late FocusNode _node;
  late FocusAttachment _nodeAttachment;

  _MyHomePageState() {
    device.setLogListener((log) {
      _addLog(log);
    });
  }

  @override
  void initState() {
    super.initState();
    _node = FocusNode(debugLabel: 'Log List');
    _node.addListener(_handleFocusChanged);
    _nodeAttachment = _node.attach(context, onKey: _handleKeyPress);
    _node.requestFocus();
  }

  @override
  void dispose() {
    _node.removeListener(_handleFocusChanged);
    _node.dispose();
    super.dispose();
  }

  void _handleFocusChanged() {
    debugPrint("hasFocus: ${_node.hasFocus}");
  }

  KeyEventResult _handleKeyPress(FocusNode node, RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.enter) {
        _addLog("\n");
      }
    }
    return KeyEventResult.ignored;
  }


  void _addLog(String log) {
    // print("append log: $log");
    setState(() {
      texts.add(log);
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  void toggleStartAndStop() {
    setState(() {
      if (device.hasStarted()) {
        device.stop();
      } else {
        device.start();
      }
    });
  }

  void _incrementFontSize() {
    setState(() {
      fontSize += 1;
    });
  }

  void _decrementFontSize() {
    setState(() {
      fontSize -= 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    _nodeAttachment.reparent();
    return Scaffold(
        body: Column(
      children: [
        Row(
          children: [
            IconButton(
                onPressed: () {
                  toggleStartAndStop();
                },
                icon:
                    Icon(device.hasStarted() ? Icons.stop : Icons.play_arrow)),
            IconButton(
                onPressed: () {
                  setState(() {
                    device.pause();
                  });
                },
                icon: const Icon(Icons.pause)),
            IconButton(
                onPressed: _incrementFontSize, icon: const Icon(Icons.add)),
            IconButton(
                onPressed: _decrementFontSize, icon: const Icon(Icons.remove))
          ],
        ),
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            itemBuilder: (BuildContext context, int index) {
              return Text(
                texts[index],
                style: TextStyle(fontSize: fontSize),
              );
            },
            itemCount: texts.length,
          ),
        ),
      ],
    ));
  }
}
