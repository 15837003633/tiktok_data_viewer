import 'package:flutter/material.dart';
import 'home_page.dart';
void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "抖音达人数据",
      theme: ThemeData(
        // textTheme: TextTheme(
        //     displayMedium:TextStyle(color: Colors.black)
        // ),
        fontFamily: 'NotoSansSC',
      ),
      home: Scaffold(
        body: TKHomePage(),
      ),
    );
  }
}
