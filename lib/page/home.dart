/* 
  #1 ~ #4에서 시작 화면을 담당했던 home을, #5부터 app은 bottomNavigation 담당, home은 그 안의 home이라는 페이지를 담당하는 것으로 바꿈
*/
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

  // 앱바 값 변환시킬 수 있게
  late String currentLocation;

  final Map<String, String> locatioTypeToString = {
    "ara": "아라동",
    "ora": "오라동",
    "donam": "도남동",
  };

  // 시작시 값을 불러와야 하기에 initState 안에 List
  @override
  void initState() {
    super.initState();
    currentLocation = "ara"; // 초기값
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

  // String to Won, 단위 변환용
  final oCcy = NumberFormat("#,###", "Ko_KR");
  String calcStringToWon(String priceString) {
    return "${oCcy.format(int.parse(priceString))}원";
  }

// Appbar 위젯
// 요즘에는 PreferredSizeWiget(높이가 있는 위젯)으로 받아둬야 오류가 발생하지 않음
  PreferredSizeWidget _appbarWidget() {
    return AppBar(
      title: GestureDetector(
        onTap: () {
          print('click');
        },
        // 동 이름 눌렀을때 선택 가능하게
        child: PopupMenuButton<String>(
          offset: Offset(0, 25),
          shape: ShapeBorder.lerp(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              1),
          onSelected: (String where) {
            print(where);
            setState(() {
              currentLocation = where;
            });
          },
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(value: "ara", child: Text("아라동")),
              PopupMenuItem(value: "ora", child: Text("오라동")),
              PopupMenuItem(value: "donam", child: Text("도남동")),
            ];
          },
          child: Row(
            children: [Text(locatioTypeToString[currentLocation].toString()), Icon(Icons.arrow_drop_down)],
          ),
        ),
      ),
      elevation: 1,
      actions: [
        IconButton(onPressed: () {}, icon: Icon(Icons.search)), // 검색 아이콘
        IconButton(onPressed: () {}, icon: Icon(Icons.tune)), // tune 아이콘
        IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(
              "assets/svg/bell.svg",
              width: 22,
            )), // 종 아이콘. 보통 이렇게 혼용해서 안 쓰긴 하는데 그냥 연습 겸해서 써봄
      ],
    );
  }

// body 위젯
  Widget _bodyWidget() {
    return ListView.separated(
      //Listview 중 분할선을 커스터마이징 가능
      padding: const EdgeInsets.symmetric(horizontal: 10),
      // 내용물 부분
      itemBuilder: (BuildContext _context, int index) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              // 이미지
              ClipRRect(
                // child를 특정한 모양으로 강제함
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
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          datas[index]["location"].toString(),
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.black.withOpacity(0.3)),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          calcStringToWon(datas[index]["price"].toString()),
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SvgPicture.asset(
                                "assets/svg/heart_off.svg",
                                width: 13,
                                height: 13,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(datas[index]["likes"].toString()),
                            ],
                          ),
                        ),
                      ]),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbarWidget(),
      body: _bodyWidget(),
    );
  }
}
