import 'package:flutter/material.dart';
import 'package:tic_tac_toe_app/main_game.dart';

class Selection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Select level"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 200,
                child: TextButton(
                    onPressed: () => Navigator.pushNamed(context, "/main_game",
                        arguments: 0),
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.green.shade100),
                    child: Text("Beginner",
                    style: TextStyle(fontSize: 20),
                    )),
              ),
              Container(
                  width: 200,
                  child: TextButton(
                      onPressed: () => Navigator.pushNamed(
                          context, "/main_game", arguments: 1),
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.green.shade100),
                      child: Text(
                        "Advanced",
                        style: TextStyle(fontSize: 20),
                      ))),
            ],
          ),
        ));
  }
}
