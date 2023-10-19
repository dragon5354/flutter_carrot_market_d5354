import 'package:flutter/material.dart';
import 'package:flutter_carrot_market_d5354/page/home.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.white, // 전체적인 테마가 흰색으로 설정됨.
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme( // 상단 앱바 테마
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(
            color: Colors.black,
          ),
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
        )
      ),
      home: Home(),
    );
  }
}
