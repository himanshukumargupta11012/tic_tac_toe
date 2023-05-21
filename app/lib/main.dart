// library my_app.globals;



// import "package:flutter/material.dart";
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// String turnArr = '000000000';
// int currNode = 0;

// void main() => runApp(MainApp());

// class MainApp extends StatelessWidget {
//   MainApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'char to int',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.blueGrey,
//       ),
//       home: Home(),
//     );
//   }
// }




// class Home extends StatefulWidget {
//   @override
//   _HomeState createState() => _HomeState();
// }

// class _HomeState extends State<Home> {

//   @override
//   Widget build(BuildContext context) {
//     List<Widget> chanceList = [];

//     for (int i = 0; i < 9; i++) {
//       chanceList.add(CustomBtn(
//         keyValue: i,
//         btnLabel: turnArr[i],
//       ));
//     }
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Tic Tac Toe"),
//       ),
//       body: Center(
//           child: Container(
//               width: 200,
//               height: 200,
//               child: GridView.count(
//                 crossAxisCount: 3,
//                 childAspectRatio: 1,
//                 children: chanceList,
//               ))),
//     );
//   }
// }

// class CustomBtn extends StatefulWidget {
//   final int keyValue;
//   String btnLabel;

//   CustomBtn({required this.keyValue, required this.btnLabel}) : super(key: ValueKey<int>(keyValue));

//   @override
//   _CustomBtnState createState() => _CustomBtnState();
// }

// class _CustomBtnState extends State<CustomBtn> {

//   void onPressed() async {

//     setState(() {
//       isClicked = true;
//       List<String> chars = turnArr.split('');
//       chars[widget.keyValue] = '2';
//       turnArr = chars.join('');
//     });
        
//     print(turnArr);
//     print(widget.keyValue);
//     print(currNode);
//     String url = "http://127.0.0.1:5000/api?array=${turnArr}&curr_turn=${widget.keyValue}&curr_node=${currNode}";
//     var output = jsonDecode(await fetchData(url));

    
//     setState(() {
//       currNode = output['curr_node'];
//       turnArr = output['array_str'];

//       print(turnArr);
//       print(currNode);
//     });
//   }

//   bool isClicked = false;
//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//         onPressed: isClicked ? null : onPressed, child: Text(widget.btnLabel));
//   }
// }

// fetchData(String url) async {
//   http.Response response = await http.get(Uri.parse(url));
//   return response.body;
// }




import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

String turnArr = '000000000';
int currNode = 0;

void main() => runApp(MainApp());

class MainApp extends StatelessWidget {
  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'char to int',
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
    });
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

  CustomBtn(
      {required this.keyValue, required this.onPressed})
      : super(key: ValueKey<int>(keyValue));

  @override
  _CustomBtnState createState() => _CustomBtnState();
}

class _CustomBtnState extends State<CustomBtn> {
  bool isClicked = false;
  String buttonText = "0";


  void onPressed() async {
    setState(() {
      isClicked = true;
      List<String> chars = turnArr.split('');
      chars[widget.keyValue] = '2';
      turnArr = chars.join('');
    });

    widget.onPressed();

    String url =
        "http://192.168.175.235:5000/api?array=${turnArr}&curr_turn=${widget.keyValue}&curr_node=${currNode}";
    var output = jsonDecode(await fetchData(url));

    setState(() {
      currNode = output['curr_node'];
      turnArr = output['array_str'];
    });
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
    return ElevatedButton(
        onPressed: isClicked ? null : onPressed, child: Text(turnArr[widget.keyValue]));
  }
}

fetchData(String url) async {
  http.Response response = await http.get(Uri.parse(url));
  return response.body;
}
