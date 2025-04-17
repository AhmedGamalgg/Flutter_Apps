import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return (MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xFF2B475E),
        appBar: AppBar(
          backgroundColor: Colors.black,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
          title: Center(child: Text('Protofolio')),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 83,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                  radius: 80,
                  backgroundImage: AssetImage(
                      'D:/Flutter Projects/Business Card App/images/Profile-photo.jpeg')),
            ),
            Text(
              'Ahmed Gamal',
              style: TextStyle(
                  color: Colors.white, fontSize: 20, fontFamily: 'Pacifico'),
            ),
            Text('FLUTTER DEVELOPER', style: TextStyle(color: Colors.grey)),
            Divider(
              color: Colors.grey,
              thickness: 1,
              indent: 50,
              endIndent: 50,
            ),
            Card(
              color: Colors.white,
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
              child: ListTile(
                leading: Icon(Icons.phone_android),
                title: Text('+20 1008484956'),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              height: 55,
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
              child: Row(
                // spacing: 15,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 20),
                    child: Icon(
                      Icons.mail,
                      size: 25,
                      color: Color(0xFF2B475E),
                    ),
                  ),
                  Text(
                    'asallam634@gmail.com',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
