import 'package:flutter/material.dart';

class DetailContentView extends StatefulWidget {
  Map<String, String> data;
  DetailContentView({Key? key, required this.data}) : super(key: key);

  @override
  State<DetailContentView> createState() => _DetailContentViewState();
}

class _DetailContentViewState extends State<DetailContentView> {
  // 휴대폰 기종에 맞춘 크기 받아오기
  Size? size;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    size = MediaQuery.of(context).size;
  }

  PreferredSizeWidget _appbarWidget() {
    return AppBar(
      backgroundColor: Colors.transparent, // 투명 앱바
      elevation: 0,
      actions: [
        IconButton(onPressed: () {}, icon: Icon(Icons.share)),
        IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
      ],
    );
  }

  Widget _bodyWidget() {
    return Container(
      child: Hero(
        tag: widget.data["cid"].toString(),
        child: Image.asset(
          widget.data["image"]!,
          fit: BoxFit.fill,
          width: size!.width,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // body 부분을 appbar 영역까지 쓰도록 허용
      appBar: _appbarWidget(),
      body: _bodyWidget(),
    );
  }
}
