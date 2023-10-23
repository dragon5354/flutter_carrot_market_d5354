import 'package:flutter/material.dart';
import 'package:flutter_carrot_market_d5354/page/detail.dart';
import 'package:flutter_carrot_market_d5354/repository/contents_repository.dart';
import 'package:flutter_carrot_market_d5354/utils/data_utils.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyFavoriteContents extends StatefulWidget {
  const MyFavoriteContents({super.key});

  @override
  State<MyFavoriteContents> createState() => _MyFavoriteContentsState();
}

class _MyFavoriteContentsState extends State<MyFavoriteContents> {
  late ContentsRepository contentsRepository;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    contentsRepository = ContentsRepository();
  }

  PreferredSizeWidget _appbarWidget() {
    return AppBar(
      title: Text(
        '관심목록',
        style: TextStyle(fontSize: 15),
      ),
    );
  }

  _makeDataList(List<dynamic> datas) {
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
                            DataUtils.calcStringToWon(datas[index]["price"].toString()),
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
      itemCount: datas.length, // 개수
      // 분할선 부분
      separatorBuilder: (BuildContext _context, int index) {
        return Container(
          height: 1,
          color: Colors.black.withOpacity(0.4),
        );
      },
    );
  }

  Widget _bodyWidget() {
    return FutureBuilder<List<dynamic>?>(
        future: _loadMyFavoriteContentList(),
        builder: (BuildContext context,
            AsyncSnapshot<List<dynamic>?> snapshot) {
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

  Future<List<dynamic>?> _loadMyFavoriteContentList() async {
    return await contentsRepository.loadFavoriteContents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbarWidget(),
      body: _bodyWidget(),
    );
  }
}
