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
        // fontFamily: 'NotoSansSC',
      ),
      home: Scaffold(
        body: TKHomePage(),
      ),
    );
  }
}


/*
部署
1.拷贝.ttf .otf到 build/web/canvaskit/
2.修改index.html   <base href="/res/web/">
3.修改main.dart.js
- m="http://10.0.6.191/res/web/"+j
- canvaskit/KFOmCnqEu92Fr1Me5WZLCzYlKw.ttf
- canvaskit/k3kXo84MPvpLmixcA63oeALhL4iJ-Q7m8w.otf
 */
