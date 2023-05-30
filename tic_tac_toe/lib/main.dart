import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';

String turnArr = '000000000';
int currNode = 0;
int winner = 3;

void main() => runApp(MainApp());

class MainApp extends StatelessWidget {
  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toc',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void updateState() {
    setState(() {
      turnArr = turnArr;

      winner = winner;
    });
  }

  playAgain() {
    setState(() {
      currNode = 0;
      turnArr = "000000000";
      winner = 3;
    });
    Navigator.pop(context);
  }

  exit() {
    SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> chanceList = [];

    for (int i = 0; i < 9; i++) {
      chanceList.add(CustomBtn(
        keyValue: i,
        onPressed: updateState,
      ));
    }
    String dialogContent = "";
    if (winner == 0) {
      dialogContent = "Tie, wanna play again?";
    } else if (winner == 1) {
      dialogContent = "You lose, wanna play again?";
    } else if (winner == 2) {
      dialogContent = "You won, wanna play again?";
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (winner != 3) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Game Over"),
              content: Text(dialogContent),
              actions: [
                TextButton(
                  onPressed: playAgain,
                  child: const Text("Play Again"),
                ),
                TextButton(
                  onPressed: exit,
                  child: const Text("Exit"),
                ),
              ],
            );
          },
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tic Tac Toe"),
      ),
      body: Center(
          child: Container(
              width: 200,
              height: 200,
              child: GridView.count(
                crossAxisCount: 3,
                childAspectRatio: 1,
                children: chanceList,
              ))),
    );
  }
}

class CustomBtn extends StatefulWidget {
  final int keyValue;
  final VoidCallback onPressed;

  CustomBtn({required this.keyValue, required this.onPressed})
      : super(key: ValueKey<int>(keyValue));

  @override
  _CustomBtnState createState() => _CustomBtnState();
}

class _CustomBtnState extends State<CustomBtn> {
  bool isClicked = false;
  String buttonText = "0";
  String dialogContent = "";

  void onPressed() async {
    setState(() {
      isClicked = true;

      List<String> chars = turnArr.split('');
      chars[widget.keyValue] = '2';
      turnArr = chars.join('');
    });

    widget.onPressed();

    String url =
        "https://tic-tac-toe-api-rgwe.onrender.com/api?array=$turnArr&curr_turn=${widget.keyValue}&curr_node=${currNode}";
    var output = jsonDecode(await fetchData(url));

    if (output.containsKey('winner')) {
      winner = output['winner'];
      if (winner == 1) {
        setState(() {
          currNode = output['curr_node'];
          turnArr = output['array_str'];
        });
      }

    } else {
      setState(() {
        currNode = output['curr_node'];
        turnArr = output['array_str'];
      });
    }
    widget.onPressed();
  }

  @override
  void didUpdateWidget(covariant CustomBtn oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (buttonText != turnArr[widget.keyValue] && !isClicked) {
      setState(() {
        isClicked = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (turnArr[widget.keyValue] == '0') {
      isClicked = false;
    }
    return ElevatedButton(
        onPressed: isClicked ? null : onPressed,
        child: Text(turnArr[widget.keyValue]));
  }
}

fetchData(String url) async {
  http.Response response = await http.get(Uri.parse(url));
  return response.body;
}
