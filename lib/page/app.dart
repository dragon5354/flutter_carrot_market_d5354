/* 
  #1 ~ #4에서 시작 화면을 담당했던 home을, #5부터 app은 bottomNavigation 담당, home은 그 안의 home이라는 페이지를 담당하는 것으로 바꿈
*/
import 'package:flutter/material.dart';
import 'package:flutter_carrot_market_d5354/page/favorite.dart';
import 'package:flutter_carrot_market_d5354/page/home.dart';
import 'package:flutter_svg/flutter_svg.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  // 아래 바텀네비게이션쪽 선언
  late int _currentPageIndex;

  @override
  void initState() {
    super.initState();
    // 바텀네비게이션 초기화
    _currentPageIndex = 0;
  }

  // body 위젯
  Widget _bodyWidget() {
    switch (_currentPageIndex) {
      case 0:
        return Home();
      case 1:
        return Container();
      case 2:
        return Container();
      case 3:
        return Container();
      case 4:
        return MyFavoriteContents();
      default: // 디폴트값을 넣어줘야 null 오류에 안걸림
        return Container();
    }
  }

  // bottomNavigation에서 사용할 것
  // bottomNavigation 내부 구조가 다 같아서 하나로 빼줌
  BottomNavigationBarItem _bottomNavigationBarItem(
      String iconName, String label) {
    return BottomNavigationBarItem(
        icon: Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: SvgPicture.asset("assets/svg/${iconName}_off.svg", width: 22),
        ),
        // 눌렀을때 아이콘 바뀌게
        activeIcon: Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: SvgPicture.asset("assets/svg/${iconName}_on.svg", width: 22),
        ),
        label: label);
  }

  // bottomNavigationBar 위젯
  Widget _bottomNavigationBarWidget() {
    return BottomNavigationBar(
        // 눌렀을때 애니메이션 효과 설정
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          print(index);
          setState(() {
            // 누르면 해당 페이지 번호로 가게 해줌
            _currentPageIndex = index;
          });
        },
        currentIndex: _currentPageIndex,
        selectedItemColor: Colors.black, // 눌렀을때 색깔
        selectedLabelStyle: TextStyle(color: Colors.black), // 눌렀을때 색깔
        selectedFontSize: 12, // 눌렀을때 폰트크기
        items: [
          _bottomNavigationBarItem("home", "홈"),
          _bottomNavigationBarItem("notes", "동네생활"),
          _bottomNavigationBarItem("location", "내 근처"),
          _bottomNavigationBarItem("chat", "채팅"),
          _bottomNavigationBarItem("user", "나의 당근")
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyWidget(),
      bottomNavigationBar: _bottomNavigationBarWidget(),
    );
  }
}
