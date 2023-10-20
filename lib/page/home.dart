/* 
  #1 ~ #4에서 시작 화면을 담당했던 home을, #5부터 app은 bottomNavigation 담당, home은 그 안의 home이라는 페이지를 담당하는 것으로 바꿈
*/
import 'package:flutter/material.dart';
import 'package:flutter_carrot_market_d5354/page/detail.dart';
import 'package:flutter_carrot_market_d5354/repository/contents_repository.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // 앱바 값 변환시킬 수 있게
  late String currentLocation;

  // 리포지토리 미리 선언
  late ContentsRepository contentsRepository;

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
  }

  // 리포지토리 값 불러오기
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    contentsRepository = ContentsRepository();
  }

  // String to Won, 단위 변환용
  final oCcy = NumberFormat("#,###", "Ko_KR");
  String calcStringToWon(String priceString) {
    if (priceString == "무료나눔") return priceString;
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
            children: [
              Text(locatioTypeToString[currentLocation].toString()),
              Icon(Icons.arrow_drop_down)
            ],
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

  _loadContents() {
    return contentsRepository.loadContentsFromLocation(currentLocation);
  }

  _makeDataList(List<Map<String, String>> datas) {
    // List<Map<String, String>> datas = snapshot.data ?? [];
    return ListView.separated(
      //Listview 중 분할선을 커스터마이징 가능
      padding: const EdgeInsets.symmetric(horizontal: 10),
      // 내용물 부분
      itemBuilder: (BuildContext _context, int index) {
        return GestureDetector(
          // 클릭시 이벤트 발생
          onTap: () {
            // 눌렀을때 해당 페이지로 보내주기
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) {
              return DetailContentView(data: datas[index]);
            }));
            print(datas[index]["title"]);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                // 이미지
                ClipRRect(
                  // child를 특정한 모양으로 강제함
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: Hero(
                    tag: datas[index]["cid"].toString(),
                    child: Image.asset(
                      datas[index]["image"].toString(),
                      width: 100,
                      height: 100,
                    ),
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

// body 위젯
  Widget _bodyWidget() {
    return FutureBuilder(
        future: _loadContents(),
        builder: (BuildContext context,
            AsyncSnapshot<List<Map<String, String>>?> snapshot) {
          // 데이터 불러오기 전 로딩바
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }
          // 오류가 있을 때
          if (snapshot.hasError) {
            return Center(child: Text("데이터 오류"));
          }
          if (snapshot.hasData) {
            return _makeDataList(snapshot.data ?? []);
          }

          return Center(
            child: Text("해당 지역에 데이터가 없습니다."),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbarWidget(),
      body: _bodyWidget(),
    );
  }
}
