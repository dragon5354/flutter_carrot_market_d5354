import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // 원래는 API에서 데이터를 받아오지만, view쪽 화면 구성이라 List로 대체함
  List<Map<String, String>> datas = [];

  // 아래 바텀네비게이션쪽 선언
  late int _currentPageIndex;

  // 시작시 값을 불러와야 하기에 initState 안에 List
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // 바텀네비게이션 초기화
    _currentPageIndex = 0;
    datas = [
      {
        "image": "assets/images/1.jpg",
        "title": "네메시스 축구화275",
        "location": "제주 제주시 아라동",
        "price": "30000",
        "likes": "2"
      },
      {
        "image": "assets/images/2.jpg",
        "title": "LA갈비 5kg팔아요~",
        "location": "제주 제주시 아라동",
        "price": "100000",
        "likes": "5"
      },
      {
        "image": "assets/images/3.jpg",
        "title": "치약팝니다",
        "location": "제주 제주시 아라동",
        "price": "5000",
        "likes": "0"
      },
      {
        "image": "assets/images/4.jpg",
        "title": "[풀박스]맥북프로16인치 터치바 스페이스그레이",
        "location": "제주 제주시 아라동",
        "price": "2500000",
        "likes": "6"
      },
      {
        "image": "assets/images/5.jpg",
        "title": "디월트존기임팩",
        "location": "제주 제주시 아라동",
        "price": "150000",
        "likes": "2"
      },
      {
        "image": "assets/images/6.jpg",
        "title": "갤럭시s10",
        "location": "제주 제주시 아라동",
        "price": "180000",
        "likes": "2"
      },
      {
        "image": "assets/images/7.jpg",
        "title": "선반",
        "location": "제주 제주시 아라동",
        "price": "15000",
        "likes": "2"
      },
      {
        "image": "assets/images/8.jpg",
        "title": "냉장 쇼케이스",
        "location": "제주 제주시 아라동",
        "price": "80000",
        "likes": "3"
      },
      {
        "image": "assets/images/9.jpg",
        "title": "대우 미니냉장고",
        "location": "제주 제주시 아라동",
        "price": "30000",
        "likes": "3"
      },
      {
        "image": "assets/images/10.jpg",
        "title": "멜킨스 풀업 턱걸이 판매합니다.",
        "location": "제주 제주시 아라동",
        "price": "50000",
        "likes": "7"
      },
    ];
  }

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

  // String to Won, 단위 변환용
  final oCcy = NumberFormat("#,###","Ko_KR");
  String calcStringToWon(String priceString) {
    return "${oCcy.format(int.parse(priceString))}원";
  }

  // body 위젯
  Widget _bodyWidget() {
    return ListView.separated( //Listview 중 분할선을 커스터마이징 가능
      padding: const EdgeInsets.symmetric(horizontal: 10),
      // 내용물 부분
      itemBuilder: (BuildContext _context, int index) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              // 이미지
              ClipRRect( // child를 특정한 모양으로 강제함
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: Image.asset(
                  datas[index]["image"].toString(),
                  width: 100,
                  height: 100,
                ),
              ),
              // 내용
              Expanded(
                child: Container(
                  height: 100,
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        datas[index]["title"].toString(),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 15),
                        ),
                      SizedBox(height: 5,),
                      Text(
                        datas[index]["location"].toString(),
                        style: TextStyle(fontSize: 12, color: Colors.black.withOpacity(0.3)),
                        ),
                      SizedBox(height: 5,),
                      Text(
                        calcStringToWon(datas[index]["price"].toString()),
                        style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SvgPicture.asset("assets/svg/heart_off.svg",width: 13, 
                            height: 13,
                            ),
                            SizedBox(width: 5,),
                            Text(datas[index]["likes"].toString()),
                          ],
                        ),
                      ),
              
                    ]
                  ),
                ),
              )
            ],
          ),
        );
      },
      itemCount: 10, // 개수
      // 분할선 부분
      separatorBuilder: (BuildContext _context, int index) {
        return Container(
          height: 1,
          color: Colors.black.withOpacity(0.4),
        );
      },
    );
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
      label: label
    );
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
        ]
      );
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbarWidget(),
      body: _bodyWidget(),
      bottomNavigationBar: _bottomNavigationBarWidget(),
    );
  }
}