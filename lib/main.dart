import 'dart:io';
import 'dart:math';

import 'package:amlit_project/story_chunk.dart';
import 'package:amlit_project/text_typewriter.dart';
import 'package:amlit_project/texts.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Choose Your Own Adventure',
      theme: ThemeData(
        primarySwatch: Colors.blue,

        // backgroundColor: Colors.brown,
      ),
      home: const BookPage(title: 'Flutter Demo Home Page'),
    );
  }
}

class Page {}

class BookPage extends StatefulWidget {
  const BookPage({super.key, required this.title});

  final String title;

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> with TickerProviderStateMixin {
  final Random random = Random();

  int _counter = 0;

  late AnimationController _ctrl;
  late Animation<double> _twn;

  List<StoryChunk> chunks = [];
  Map<String, StoryChunk?> chunkMap = {};

  // List<Widget> widgetsToDraw = [
  //   TextTypewriter('Hello World'),
  //   TextTypewriter('Hello World', fontSize: 40.0),
  // ];

  String currentName = "";
  int readyNow = 0;

  StoryChunk? _chunkRecurse(String name) {
    if (!texts.keys.contains(name)) return null;

    final tMap = texts[name]!;

    final Map<String, StoryChunk?> choices = {};

    if (tMap.containsKey("choices")) {
      for (final q in tMap["choices"] as List<List>) {
        choices[q[0]] = _chunkRecurse(q[1]);
      }
    }

    return DefaultStoryChunk(
      name: name,
      rotation: random.nextDouble() - 0.5,
      translationX: 0.0,
      translationY: 40.0 + random.nextDouble() * 20.0,
      body: Builder(builder: (context) {
        List<Widget> widgs = [];

        int i = 0;
        for (final paragraph in tMap["body"] as List) {
          widgs.add(Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: TextTypewriter(
              paragraph,
              fontSize: 20.0,
              doneCallback: () {
                setState(() {
                  readyNow++;
                });
              },
              show: readyNow == i,
            ),
          ));

          i++;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widgs,
        );
      }),
      choices: choices,
    );
  }

  @override
  void initState() {
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _twn = Tween(begin: -2000.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: Curves.easeOut,
      ),
    );

    chunks.add(_chunkRecurse("start")!);
    _ctrl.forward();

    super.initState();
  }

  void _addPage(StoryChunk chunk) {
    setState(() {
      currentName = chunk.getName();
      readyNow = 0;

      _ctrl.reset();
      _ctrl.forward();

      chunks.add(chunk);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
            image: AssetImage("assets/images/wood.jpg"),
            fit: BoxFit.cover,
            opacity: 0.3,
          ),
        ),
        alignment: Alignment.center,
        child: Stack(
          children: [
            for (int i = 0; i < chunks.length; i++)
              AnimatedBuilder(
                animation: _twn,
                builder: (context, child) {
                  return Transform(
                    transform:
                        Matrix4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1)
                          ..rotateZ(pi * 0.02 * chunks[i].getRotation())
                          ..scale(0.9)
                          ..translate(
                            chunks[i].getTranslationX() +
                                (i == chunks.length - 1 ? _twn.value : 0.0),
                            chunks[i].getTranslationY(),
                            0.0,
                          ),
                    child: _createPage(context, chunks[i]),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Container _createPage(BuildContext context, StoryChunk chunk) {
    final choices = chunk.getChoices();

    return Container(
      width: min(700.0, MediaQuery.of(context).size.width),
      height: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(255, 255, 255, 1.0),
            spreadRadius: 1.0,
            // offset: const Offset(5.0, 5.0),
            blurRadius: 5.0,
          ),
        ],
        image: DecorationImage(
          image: AssetImage("assets/images/white-texture.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          chunk.getBody(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextTypewriter("What does Sylvia do?", doneCallback: () => {}),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  for (final question in choices.keys)
                    TextButton(
                      onPressed: () {
                        if (choices[question] != null) {
                          _addPage(choices[question]!);
                        }
                      },
                      child: Text(question),
                    )
                ],
              ),
              SizedBox(height: 60.0),
            ],
          )
        ],
      ),
    );
  }
}
