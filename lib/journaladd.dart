import 'main.dart';
import 'journal.dart';
import 'package:flutter/material.dart';

class AddLogWidget extends StatefulWidget {
  const AddLogWidget({Key? key}) : super(key: key);

  @override
  _AddLogWidgetState createState() => _AddLogWidgetState();
}

class _AddLogWidgetState extends State<AddLogWidget> {
  // Show a form that consists of three pages:
  //the first has 9 cards in a grid from which the user can select one,
  //the second has a text field,
  //and the third has the option to add a photo or a voice recording
  int _addLogIndex = 0;
  final _addLogpageController = PageController();
  List<Widget> _addLogPages = [];

  @override
  void initState() {
    super.initState();
    _addLogPages = <Widget>[
      EmotionsPage(),
      TextPage(),
      //MediaPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/back.png"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.1),
              BlendMode.darken,
            ),
          ),
        ),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Add Log'),
          ),
          body: PageView(
            controller: _addLogpageController,
            children: _addLogPages,
            onPageChanged: (int index) {
              setState(() {
                _addLogIndex = index;
              });
            },
          ),
        ));
  }
}

class EmotionsPage extends StatefulWidget {
  const EmotionsPage({Key? key}) : super(key: key);

  @override
  _EmotionsPageState createState() => _EmotionsPageState();
}

class _EmotionsPageState extends State<EmotionsPage> {
  // User can select one of the cards to indicate their emotion
  int emotion_idx = -1;
  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.all(25),
          child: Text(
            'How are you feeling?',
            style: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontSize: 36,
            ),
          ),
        ),
      ),
      Container(
          padding: EdgeInsets.fromLTRB(10, 120, 10, 0),
          child: GridView.count(
            // set vertical spacing
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            crossAxisCount: 3,
            children: <Widget>[
              GestureDetector(
                child: Card(
                  color: emotion_idx == 0
                      ? Colors.purpleAccent.withOpacity(0.66)
                      : Color.fromARGB(169, 255, 255, 255),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/angry.png',
                        width: 80,
                        height: 80,
                      ),
                      Text('Angry'),
                    ],
                  ),
                ),
                onTap: () {
                  setState(() {
                    emotion_idx = 0;
                  });
                },
              ),
              GestureDetector(
                child: Card(
                  color: emotion_idx == 1
                      ? Colors.purpleAccent.withOpacity(0.66)
                      : Color.fromARGB(169, 255, 255, 255),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/annoyed.png',
                        width: 80,
                        height: 80,
                      ),
                      Text('Annoyed'),
                    ],
                  ),
                ),
                onTap: () {
                  setState(() {
                    emotion_idx = 1;
                  });
                },
              ),
              GestureDetector(
                child: Card(
                  color: emotion_idx == 2
                      ? Colors.purpleAccent.withOpacity(0.66)
                      : Color.fromARGB(169, 255, 255, 255),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/ashamed.png',
                        width: 80,
                        height: 80,
                      ),
                      Text('Ashamed'),
                    ],
                  ),
                ),
                onTap: () {
                  setState(() {
                    emotion_idx = 2;
                  });
                },
              ),
              GestureDetector(
                child: Card(
                  color: emotion_idx == 3
                      ? Colors.purpleAccent.withOpacity(0.66)
                      : Color.fromARGB(169, 255, 255, 255),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/bored.png',
                        width: 80,
                        height: 80,
                      ),
                      Text('Bored'),
                    ],
                  ),
                ),
                onTap: () {
                  setState(() {
                    emotion_idx = 3;
                  });
                },
              ),
              GestureDetector(
                child: Card(
                  color: emotion_idx == 4
                      ? Colors.purpleAccent.withOpacity(0.66)
                      : Color.fromARGB(169, 255, 255, 255),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/confused.png',
                        width: 80,
                        height: 80,
                      ),
                      Text('Confused'),
                    ],
                  ),
                ),
                onTap: () {
                  setState(() {
                    emotion_idx = 4;
                  });
                },
              ),
              GestureDetector(
                child: Card(
                  color: emotion_idx == 5
                      ? Colors.purpleAccent.withOpacity(0.66)
                      : Color.fromARGB(169, 255, 255, 255),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/content.png',
                        width: 80,
                        height: 80,
                      ),
                      Text('Content'),
                    ],
                  ),
                ),
                onTap: () {
                  setState(() {
                    emotion_idx = 5;
                  });
                },
              ),
              GestureDetector(
                child: Card(
                  color: emotion_idx == 6
                      ? Colors.purpleAccent.withOpacity(0.66)
                      : Color.fromARGB(169, 255, 255, 255),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/curious.png',
                        width: 80,
                        height: 80,
                      ),
                      Text('Curious'),
                    ],
                  ),
                ),
                onTap: () {
                  setState(() {
                    emotion_idx = 6;
                  });
                },
              ),
              GestureDetector(
                child: Card(
                  color: emotion_idx == 7
                      ? Colors.purpleAccent.withOpacity(0.66)
                      : Color.fromARGB(169, 255, 255, 255),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/unkempt.png',
                        width: 80,
                        height: 80,
                      ),
                      Text('Unkempt'),
                    ],
                  ),
                ),
                onTap: () {
                  setState(() {
                    emotion_idx = 7;
                  });
                },
              ),
              GestureDetector(
                child: Card(
                  color: emotion_idx == 8
                      ? Colors.purpleAccent.withOpacity(0.66)
                      : Color.fromARGB(169, 255, 255, 255),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/energetic.png',
                        width: 80,
                        height: 80,
                      ),
                      Text('Energetic'),
                    ],
                  ),
                ),
                onTap: () {
                  setState(() {
                    emotion_idx = 8;
                  });
                },
              ),
            ],
          )),
    ]);
  }
}

class TextPage extends StatefulWidget {
  @override
  _TextPageState createState() => _TextPageState();
}

class _TextPageState extends State<TextPage> {
  final _TextformKey = GlobalKey<FormState>();

  // Show a text field where the user can write their thoughts
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _TextformKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Write your thoughts here:',
            ),
            TextField(
              maxLines: 10,
              maxLength: 250,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Thoughts',
                filled: true,
                fillColor: Colors.white12,
                focusColor: Color.fromARGB(255, 92, 197, 31),
              ),
            ),
          ],
        ),
      ),
    );
  }
}