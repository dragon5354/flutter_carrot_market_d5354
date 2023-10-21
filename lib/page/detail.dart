/*
* 홈 내부의 리스트를 눌렀을 때 세부 정보 페이지
*/
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carrot_market_d5354/components/manor_temperature_widget.dart';

class DetailContentView extends StatefulWidget {
  Map<String, String> data;
  DetailContentView({Key? key, required this.data}) : super(key: key);

  @override
  State<DetailContentView> createState() => _DetailContentViewState();
}

class _DetailContentViewState extends State<DetailContentView> {
  // 휴대폰 기종에 맞춘 크기 받아오기
  Size? size;

  // 이미지를 리스트로 만들어서 받아오는 용도
  late List<String> imgList;

  int? _current;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    size = MediaQuery.of(context).size;
    _current = 0;
    imgList = [
      // 실제로는 다른 이미지겠지만 이번은 그냥 같은 걸로 쓰기...
      widget.data["image"].toString(),
      widget.data["image"].toString(),
      widget.data["image"].toString(),
      widget.data["image"].toString(),
      widget.data["image"].toString(),
    ];
  }

  PreferredSizeWidget _appbarWidget() {
    return AppBar(
      backgroundColor: Colors.transparent, // 투명 앱바
      elevation: 0,
      // 뒤로가기 임시 비활성화.
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back, color: Colors.white),
      ),
      actions: [
        IconButton(
            onPressed: () {}, icon: Icon(Icons.share, color: Colors.white)),
        IconButton(
            onPressed: () {}, icon: Icon(Icons.more_vert, color: Colors.white)),
      ],
    );
  }

  // 이미지 슬라이더를 위젯으로 분리
  Widget _makeSliderImage() {
    return Container(
      child: Stack(
        children: [
          Hero(
            tag: widget.data["cid"].toString(),
            // 슬라이더
            child: CarouselSlider(
              options: CarouselOptions(
                height: size!.width,
                initialPage: 0,
                enableInfiniteScroll: false,
                viewportFraction: 1,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                  print(index);
                },
              ),
              items: imgList.map((url) {
                return Image.asset(
                  url,
                  width: size!.width,
                  fit: BoxFit.fill,
                );
              }).toList(),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: imgList.asMap().entries.map((entry) {
                return GestureDetector(
                  // onTap: () => _controller.animateToPage(entry.key),
                  child: Container(
                    width: 12.0,
                    height: 12.0,
                    margin:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: (Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.white.withOpacity(0.4))
                            .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // 판매자 정보
  Widget _sellerSimpleInfo() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: Image.asset("assets/images/user.png").image,
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("dragon5354",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text("부천시 소사구")
            ],
          ),
          Expanded(child: ManorTemperature(manorTemp: 37.5))
        ],
      ),
    );
  }

  Widget _bodyWidget() {
    return Column(
      children: [
        _makeSliderImage(),
        _sellerSimpleInfo(),
      ],
    );
  }

  Widget _bottomBarWidget() {
    return Container(
      width: size!.width,
      height: 55,
      color: Colors.red,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // body 부분을 appbar 영역까지 쓰도록 허용
      appBar: _appbarWidget(),
      body: _bodyWidget(),
      bottomNavigationBar: _bottomBarWidget(),
    );
  }
}
