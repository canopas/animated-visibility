import 'package:animated_visibility_widget/animated_visibility_widget.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isShow = true;

  void _incrementCounter() {
    setState(() {
      _isShow = !_isShow;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF404349),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return GridView.count(
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
            crossAxisCount: (constraints.maxWidth / 140).floor(),
            childAspectRatio: 1,
            padding: MediaQuery.of(context).padding +
                const EdgeInsets.only(top: 16, bottom: 100, left: 4, right: 4),
            children: [
              _body("Fade", _content(enter: fadeIn(), exit: fadeOut())),
              _body("Scale", _content(enter: scaleIn(), exit: scaleOut())),
              _body(
                  "Fade+Scale",
                  _content(
                      enter: fadeIn() + scaleIn(),
                      exit: fadeOut() + scaleOut())),
              _body("Slide", _content(enter: slideIn(), exit: slideOut())),
              _body(
                  "Slide Vertically",
                  _content(
                      enter: slideInVertically(),
                      exit: slideOutVertically(targetOffsetY: -1))),
              _body(
                  "Slide Vertically",
                  _content(
                      enter: slideInVertically(
                          initialOffsetY: -1,
                          curve: Curves.fastEaseInToSlowEaseOut),
                      exit: slideOutVertically(
                          curve: Curves.fastEaseInToSlowEaseOut))),
              _body(
                  "Slide Horizontally",
                  _content(
                      enter: slideInHorizontally(),
                      exit: slideOutHorizontally())),
              _body(
                  "Slide Horizontally",
                  _content(
                      enter: slideInHorizontally(initialOffsetX: -1),
                      exit: slideOutHorizontally(targetOffsetX: -1))),
              _body(
                  "Expand Center Vertically",
                  _content(
                      enter: expandVertically(alignment: 0),
                      exit: shrinkVertically(alignment: 0))),
              _body(
                  "Expand Center Horizontally",
                  _content(
                      enter: expandHorizontally(), exit: shrinkHorizontally())),
              _body(
                  "Expand from top",
                  _content(
                      enter: expandVertically(alignment: -1),
                      exit: shrinkVertically(alignment: -1))),
              _body(
                  "Expand from start",
                  _content(
                      enter: expandHorizontally(alignment: -1),
                      exit: shrinkHorizontally(alignment: -1))),
              _body(
                  "Fade+Scale+Slide",
                  _content(
                      enter: fadeIn() + scaleIn() + slideInHorizontally(),
                      exit: fadeOut() + scaleOut() + slideOutHorizontally())),
              _body(
                  "Expand+Fade",
                  _content(
                      enter: expandHorizontally(alignment: 1) +
                          fadeIn(initialAlpha: 0.5),
                      exit: shrinkHorizontally(alignment: 1) +
                          fadeOut(targetAlpha: 0.5))),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Text(_isShow ? "Hide" : "Show"),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _content({EnterTransition? enter, ExitTransition? exit}) =>
      AnimatedVisibility(
        visible: _isShow,
        enter: enter ?? EnterTransitionNone.instance,
        exit: exit ?? ExitTransitionNone.instance,
        child: const Center(
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/background.png'),
            radius: 60,
          ),
        ),
      );

  Widget _body(String label, Widget demo) => Container(
        margin: const EdgeInsets.all(4),
        color: Colors.black38,
        child: Column(
          children: [
            Flexible(
                child: Center(
              child: ClipRRect(
                child: demo,
              ),
            )),
            Container(
                color: Colors.black12,
                height: 38,
                alignment: Alignment.center,
                child: Text(label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white))),
          ],
        ),
      );
}
