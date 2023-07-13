import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'dart:math';
import 'value.dart';
import 'selection.dart';
import 'main_game.dart';



void main() {
  runApp(MainApp());
}


class MainApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tic-Tac-Toe',
      initialRoute: '/',
      routes: {
        '/': (context) => Selection(),
        '/main_game': (context) {
          
              final int game_type =
              ModalRoute.of(context)!.settings.arguments as int;
              return MainGame(game_type: game_type);
        }
      },

      // onGenerateRoute: (settings) {
      //   if (settings.name == '/main_game') {
      //     int game_type = settings.arguments as int;
      //     return MaterialPageRoute(
      //       builder: (context) => MainGame(game_type: game_type),
      //     );
      //   }
      //   return null;
      // },
    );
  }
}

