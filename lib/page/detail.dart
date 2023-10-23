/*
* 홈 내부의 리스트를 눌렀을 때 세부 정보 페이지
*/
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carrot_market_d5354/components/manor_temperature_widget.dart';
import 'package:flutter_carrot_market_d5354/repository/contents_repository.dart';
import 'package:flutter_carrot_market_d5354/utils/data_utils.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DetailContentView extends StatefulWidget {
  Map<String, String> data;
  DetailContentView({Key? key, required this.data}) : super(key: key);

  @override
  State<DetailContentView> createState() => _DetailContentViewState();
}

// 애니메이션 기능을 사용할 것이라 상속받음
class _DetailContentViewState extends State<DetailContentView>
    with SingleTickerProviderStateMixin {
  // 휴대폰 기종에 맞춘 크기 받아오기
  Size? size;

  // 이미지를 리스트로 만들어서 받아오는 용도
  late List<String> imgList;

  int? _current;

  // 스크롤 컨트롤러
  ScrollController _controller = ScrollController();
  // 스크롤 위치 받아올 초기값
  double scrollpositionToAlpha = 0;

  // 애니메이션 컨트롤러와 값
  late AnimationController _animationController;
  late Animation _colorTween;

  // 관심상품용 값 => 기본적으로 false 상태로 둘 것
  late bool isMyFavoriteContent;

  // 리포지토리
  late ContentsRepository contentsRepository;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isMyFavoriteContent = false;
    _animationController = AnimationController(vsync: this);
    contentsRepository = ContentsRepository();
    _colorTween = ColorTween(begin: Colors.white, end: Colors.black)
        .animate(_animationController);
    _loadMyFavoriteContentState();
    _controller.addListener(() {
      // 스크롤 위치가 변하면 값을 변화시킴
      setState(() {
        if (_controller.offset > 255) {
          scrollpositionToAlpha = 255;
        } else {
          scrollpositionToAlpha = _controller.offset;
        }
        _animationController.value = scrollpositionToAlpha / 255;
      });
    });
    // 좋아요 버튼 로드하기
  }

  _loadMyFavoriteContentState() async {
    // 좋아요 누른 컨텐츠인지를 리포지토리에서 불러오기
    bool ck = await contentsRepository.isMyFavoriteContents(widget.data["cid"].toString());
    setState(() {
      isMyFavoriteContent = ck;
    });
    // print(ck);
  }

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

  // 색 바꾸는 애니메이션 부분을 위젯으로 처리
  Widget _makeIcon(IconData icon) {
    return AnimatedBuilder(
        animation: _colorTween,
        builder: (context, child) => Icon(
              icon,
              color: _colorTween.value,
            ));
  }

  PreferredSizeWidget _appbarWidget() {
    return AppBar(
      backgroundColor: Colors.white
          .withAlpha(scrollpositionToAlpha.toInt()), // 스크롤바 위치값을 받아와서 색상 변경
      elevation: 0,
      // 뒤로가기 임시 비활성화.
      leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: _makeIcon(Icons.arrow_back)),
      actions: [
        IconButton(onPressed: () {}, icon: _makeIcon(Icons.share)),
        IconButton(onPressed: () {}, icon: _makeIcon(Icons.more_vert)),
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

  // 경계선을 위젯으로 만들어줌
  Widget _line() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      height: 1,
      color: Colors.grey.withOpacity(0.3),
    );
  }

  // 원래는 api를 통해 받아올 내용
  // 그냥 영역만 잡고 일단 패스
  Widget _contentDetail() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 20),
          Text(
            widget.data["title"].toString(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "디지털/가전 ∙ 22시간 전",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 15),
          Text(
            "선물받은 새상품이고\n상품 꺼내보기만 했습니다\n거래는 직거래만 합니다.",
            style: TextStyle(fontSize: 15, height: 1.5),
          ),
          SizedBox(height: 15),
          Text(
            "채팅 3 ∙ 관심 17 ∙ 조회 295",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 15),
        ],
      ),
    );
  }

  Widget _otherCellContents() {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "판매자님의 판매 상품",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "모두보기",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bodyWidget() {
    // 리스트를 처리하기 위해선 singlechildscrollview 대신 custom을 써야 함
    return CustomScrollView(controller: _controller, slivers: [
      SliverList(
          delegate: SliverChildListDelegate([
        _makeSliderImage(),
        _sellerSimpleInfo(),
        _line(),
        _contentDetail(),
        _line(),
        _otherCellContents(),
      ])),
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        sliver: SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10),
          delegate: SliverChildListDelegate(List.generate(20, (index) {
            return Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      color: Colors.grey.withOpacity(0.3),
                      height: 120,
                    ),
                  ),
                  Text(
                    "상품 제목",
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    "금액",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          }).toList()),
        ),
      ),
    ]);
  }

  Widget _bottomBarWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      width: size!.width,
      height: 55,
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              contentsRepository.addMyFavoriteContent(widget.data);
              setState(() {
                isMyFavoriteContent = !isMyFavoriteContent; // 토글 방식
                // 이 부분에서 로컬 스토리지에 값을 저장할 것
                // 실제로는 api 통신 등으로 서버에 값을 넘기겠지만, 서버를 사용하지 않을 거라 로컬 스토리지 방식으로 구현
              });
              // 스낵바 사용이 키 대신 ScaffoldMessenger 쓰는 식으로 바뀜(기존 방식은 안 됨)
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                duration: Duration(milliseconds: 1000),
                content: Text(
                    isMyFavoriteContent ? "관심목록에 추가됐어요." : "관심목록에서 제거됐어요."),
              ));
            },
            child: SvgPicture.asset(
              isMyFavoriteContent
                  ? "assets/svg/heart_on.svg"
                  : "assets/svg/heart_off.svg",
              width: 25,
              height: 25,
              color: Color(0xfff08f4f),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 15, right: 10),
            width: 1,
            height: 40,
            color: Colors.black.withOpacity(0.3),
          ),
          Column(
            children: [
              Text(
                DataUtils.calcStringToWon(widget.data["price"].toString()),
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              Text(
                "가격제안불가",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              )
            ],
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Color(0xfff08f4f),
                  ),
                  child: Text(
                    "채팅으로 거래하기",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
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
