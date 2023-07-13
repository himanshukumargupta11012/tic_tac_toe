import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'value.dart';

List<int> turnArr = List.filled(9, 0);
int winner = 3;
var game;

class MainGame extends StatelessWidget {
  // MainGame({super.key});
  final int game_type;

  MainGame({required this.game_type});

  @override
  Widget build(BuildContext context) {
    if (game_type == 0) {
      game = Game(input_value: level_1_value);
    } else {
      game = Game(input_value: level_2_value);
    }

    return Builder(
        builder: (context) => WillPopScope(
            onWillPop: () async {
              turnArr = List.filled(9, 0);
              winner = 3;
              return true;
            },
            child: MaterialApp(
              title: 'Tic Tac Toc',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primarySwatch: Colors.blueGrey,
              ),
              home: Home(),
            )));
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class Game {
  var value;
  final dict = {
    0: 1,
    1: 6,
    2: 5,
    3: 8,
    4: 4,
    5: 0,
    6: 3,
    7: 2,
    8: 7,
  };
  final dict2 = {
    1: 0,
    6: 1,
    5: 2,
    8: 3,
    4: 4,
    0: 5,
    3: 6,
    2: 7,
    7: 8,
  };

  Game({required List<num> input_value}) {
    value = input_value;
  }

  // finds index given board config
  int index(List<int> arr) {
    num curr_index = pow(3, 8) * arr[0] +
        pow(3, 7) * arr[1] +
        pow(3, 6) * arr[2] +
        pow(3, 5) * arr[3] +
        pow(3, 4) * arr[4] +
        pow(3, 3) * arr[5] +
        pow(3, 2) * arr[6] +
        3 * arr[7] +
        arr[8];
    return curr_index.toInt();
  }

  // checks if someone wons or not
  bool checkEnd(List<int> board, int turn, int index) {
    int first = dict[index] ?? 0;
    int left = 12 - first;
    for (int i = 0; i < min(9, left); i++) {
      for (int j = i + 1; j < min(9, left); j++) {
        if (i != first &&
            j != first &&
            i + j == left &&
            (board[dict2[i] ?? 0]) == turn &&
            board[dict2[j] ?? 0] == turn) {
          return true;
        }
      }
    }
    return false;
  }

  List<int> test(List<int> board) {
    num max = -1 * pow(10, 5);

    int max_index = 0;
    for (int k = 0; k < 9; k++) {
      if (board[k] == 0) {
        List<int> temp_board = List.from(board);
        temp_board[k] = 2;

        if (max < value[index(temp_board)]) {
          max = value[index(temp_board)];
          max_index = k;
        }
      }
    }

    if (checkEnd(board, 2, max_index)) {
      return [max_index, 1];
    }

    return [max_index, 3];
  }
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
      turnArr = List.filled(9, 0);
      winner = 3;
    });

    Navigator.of(
      context,
      rootNavigator: true,
    ).pop(
      context,
    );
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
            return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AlertDialog(
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
                  )
                ]);
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
      turnArr[widget.keyValue] = 1;
    });

    bool draw = true;
    for (int i = 0; i < 9; i++) {
      if (turnArr[i] == 0) {
        draw = false;
      }
    }

    if (draw) {
      print("draw");
      setState(() {
        winner = 0;
      });
    }

    if (game.checkEnd(turnArr, 1, widget.keyValue)) {
      print("you won");
      setState(() {
        winner = 2;
      });
    }

    widget.onPressed();

    if (winner == 3) {
      List<int> out_arr = game.test(turnArr);

      setState(() {
        turnArr[out_arr[0]] = 2;
      });

      winner = out_arr[1];

      widget.onPressed();
    }
  }

  @override
  void didUpdateWidget(covariant CustomBtn oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (int.parse(buttonText) != turnArr[widget.keyValue] && !isClicked) {
      setState(() {
        isClicked = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (turnArr[widget.keyValue] == 0) {
      isClicked = false;
    }
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
            side: BorderSide(
              color: Colors.black,
              width: 1,
            )
          ),
        ),
        onPressed: isClicked ? null : onPressed,
        child: turnArr[widget.keyValue] == 0
            ? SizedBox.shrink()
            : turnArr[widget.keyValue] == 1
                ? Center(
                    child: Icon(
                    Icons.close,
                    // size: 48.0,
                    color: Colors.red,
                  ))
                : Center(
                    child: Icon(
                    Icons.circle,
                    // size: 48.0,
                    color: Colors.blue,
                  ))

        // Text('${turnArr[widget.keyValue]}')
        );
  }
}
