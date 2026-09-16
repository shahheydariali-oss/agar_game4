import 'dart:convert';

import 'package:flutter/material.dart';

import 'models/game_state.dart';
import 'models/stage.dart';
import 'engine/story_engine.dart';
import 'services/save_service.dart';

void main() {
  runApp(const AgarApp());
}

class AgarApp extends StatelessWidget {
  const AgarApp({super.key});

  @override
  Widget build(BuildContext c) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'اگر...',
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xffb58a5a),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xff090909),
        useMaterial3: true,
      ),
      home: const Loader(),
    );
  }
}

class Loader extends StatelessWidget {
  const Loader({super.key});

  Future<(StoryEngine, GameState)> load(BuildContext c) async {
    final raw = await DefaultAssetBundle.of(c)
        .loadString('assets/data/stages.json');

    final stages = (jsonDecode(raw) as List)
        .map(
          (e) => Stage.fromJson(
            Map<String, dynamic>.from(e),
          ),
        )
        .toList();

    final engine = StoryEngine(stages);

    final saved = await SaveService().load();

    final state = saved ??
        GameState(
          vars: {
            'Money': 0,
            'Energy': 100,
            'Stress': 10,
            'Satisfaction': 50,
            'Skill': 10,
            'Risk': 10,
            'Ambition': 20,
            'Caution': 20,
            'Empathy': 20,
            'Independence': 20,
            'Patience': 20,
            'Impulsiveness': 20,
            'Trust_Amir': 50,
            'Trust_Sara': 0,
            'Love_Sara': 0,
            'FamilyBond': 50,
            'CareerPath': 0,
            'BusinessPath': 0,
            'LovePath': 0,
          },
        );

    return (engine, state);
  }

  @override
  Widget build(BuildContext c) {
    return FutureBuilder<(StoryEngine, GameState)>(
      future: load(c),
      builder: (c, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final data = snapshot.data!;

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Game(
            engine: data.$1,
            state: data.$2,
          ),
        );
      },
    );
  }
}

class Game extends StatefulWidget {
  final StoryEngine engine;
  final GameState state;

  const Game({
    super.key,
    required this.engine,
    required this.state,
  });

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  late GameState s;
  late Stage st;

  final save = SaveService();

  @override
  void initState() {
    super.initState();

    s = widget.state;
    st = widget.engine.stage(s.currentStage);
  }

  Future<void> pick(StageChoice choice) async {
    setState(() {
      widget.engine.choose(s, st, choice);
      st = widget.engine.stage(s.currentStage);
    });

    await save.save(s);
  }

  @override
  Widget build(BuildContext c) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('اگر...'),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: c,
                builder: (_) => Status(s),
              );
            },
            icon: const Icon(Icons.insights),
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: c,
                builder: (_) => Notebook(s),
              );
            },
            icon: const Icon(Icons.menu_book),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'مرحله ${st.id}  •  سن ${s.age}',
                style: const TextStyle(
                  color: Colors.white54,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                st.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  st.story,
                  style: const TextStyle(
                    fontSize: 18,
                    height: 1.9,
                    color: Colors.white70,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ...st.choices.map(
                (choice) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: FilledButton(
                    onPressed: () => pick(choice),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.all(17),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17),
                      ),
                    ),
                    child: Text(
                      choice.text,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Status extends StatelessWidget {
  final GameState s;

  const Status(
    this.s, {
    super.key,
  });

  @override
  Widget build(BuildContext c) {
    return AlertDialog(
      title: const Text('وضعیت'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('پول: ${s.get('Money').round()}'),
          Text('استرس: ${s.get('Stress').round()}'),
          Text('رضایت: ${s.get('Satisfaction').round()}'),
          Text('اعتماد امیر: ${s.get('Trust_Amir').round()}'),
          Text('اعتماد سارا: ${s.get('Trust_Sara').round()}'),
        ],
      ),
    );
  }
}

class Notebook extends StatelessWidget {
  final GameState s;

  const Notebook(
    this.s, {
    super.key,
  });

  @override
  Widget build(BuildContext c) {
    return AlertDialog(
      title: const Text('دفتر من'),
      content: SizedBox(
        width: 300,
        height: 300,
        child: ListView(
          children: s.memories
              .reversed
              .take(40)
              .map(
                (x) => ListTile(
                  title: Text(x),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}