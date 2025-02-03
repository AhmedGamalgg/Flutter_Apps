import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int score_TeamA = 0;
  int score_TeamB = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: Text(
            'Points Counter',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(30),
              child: Row(
                children: [
                  Column(
                    children: [
                      Text(
                        'TeamA',
                        style: TextStyle(fontSize: 30),
                      ),
                      Text(
                        '$score_TeamA',
                        style: TextStyle(fontSize: 160),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            score_TeamA++;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            shape: RoundedRectangleBorder(),
                            minimumSize: Size(130, 40)),
                        child: Text(
                          'Add 1 Point',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            score_TeamA += 2;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            shape: RoundedRectangleBorder(),
                            minimumSize: Size(130, 40)),
                        child: Text(
                          'Add 2 Points',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            score_TeamA += 3;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            shape: RoundedRectangleBorder(),
                            minimumSize: Size(130, 40)),
                        child: Text(
                          'Add 3 Points',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 350,
                    child: VerticalDivider(
                      thickness: 1,
                      width: 40,
                      color: Colors.grey,
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        'TeamB',
                        style: TextStyle(fontSize: 30),
                      ),
                      Text(
                        '$score_TeamB',
                        style: TextStyle(fontSize: 160),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            score_TeamB += 1;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            shape: RoundedRectangleBorder(),
                            minimumSize: Size(130, 40)),
                        child: Text(
                          'Add 1 Point',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            score_TeamB += 2;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            shape: RoundedRectangleBorder(),
                            minimumSize: Size(130, 40)),
                        child: Text(
                          'Add 2 Points',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            score_TeamB += 3;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            shape: RoundedRectangleBorder(),
                            minimumSize: Size(130, 40)),
                        child: Text(
                          'Add 3 Points',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  score_TeamA = 0;
                  score_TeamB = 0;
                });
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(),
                  minimumSize: Size(130, 40)),
              child: Text(
                'Reset',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
