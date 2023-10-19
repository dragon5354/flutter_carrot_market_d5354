import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  // Appbar 위젯
  // 요즘에는 PreferredSizeWiget(높이가 있는 위젯)으로 받아둬야 오류가 발생하지 않음
  PreferredSizeWidget _appbarWidget() {
    return AppBar(
        title: GestureDetector(
          onTap: () {
            print('click');
          },
          child: Row(
            children: [
              Text("아라동"),
              Icon(Icons.arrow_drop_down)
            ],
          ),
        ),
        elevation: 1,
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.search)), // 검색 아이콘
          IconButton(onPressed: (){}, icon: Icon(Icons.tune)), // tune 아이콘
          IconButton(onPressed: (){}, icon: SvgPicture.asset("assets/svg/bell.svg",width: 22,)), // 종 아이콘. 보통 이렇게 혼용해서 안 쓰긴 하는데 그냥 연습 겸해서 써봄
        ],
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbarWidget(),
      body: Container(),
      bottomNavigationBar: Container(),
    );
  }
}