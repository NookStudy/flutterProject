import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:photofolio/pages/Home.dart';
import 'package:photofolio/model/inifinityscroll.dart';
import 'package:photofolio/pages/listAlbum.dart';



class MainScreen extends StatefulWidget {
  const MainScreen({super.key});


  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  void getUserUID(){
    FirebaseAuth.instance.authStateChanges()
    .listen((User? user) {
      if (user != null) {
        print(user.uid);
      }
    });
  }

  late PersistentTabController _controller;

  String? downloadURL = '' ;

  void getImage() async{
    Reference _ref = FirebaseStorage.instance.ref().child('test/Main');
    String _url = await _ref.getDownloadURL();
    setState(() {
      downloadURL = _url;
    });
  }

  @override
  void initState(){
    super.initState();
    _controller = PersistentTabController(initialIndex : 0);
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context, 
      controller: _controller,    //컨트롤러
      screens: _buildScreens(),   //탭바를 눌렀을 때 변경될 페이지 설정
      items: _navBarsItems(),     //네비바 아이템 설정
      confineInSafeArea: false,   //휴대폰 바텀 네비게이션 바에 대한 안전장치
      backgroundColor: Colors.black,  //default : white
      handleAndroidBackButtonPress: true, //default : true
      resizeToAvoidBottomInset: true,  //뭐할려면 true
      stateManagement: true, //트루 디폴트. 각 화면 상태 유지
      //'크기조정'을 선택하는 것이 좋음. 하단을 피하려면 이 인수를 사용할 때 INSET이 true로 표현됨.
      hideNavigationBarWhenKeyboardShows: true, //recommend
      decoration: const NavBarDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties(
        duration: Duration(microseconds: 200),
        curve:  Curves.ease
      ),
      //화면전환시의 애니메이션 효과
      screenTransitionAnimation: const ScreenTransitionAnimation(
        animateTabTransition: false,  //false면 비활성화
        curve: Curves.ease,
        duration: Duration(microseconds: 500)
      ),
      navBarStyle: NavBarStyle.style6, //https://pub.dev/packages/persistent_bottom_nav_bar
    );
  }
  //탭바 클릭시 처리될 페이지 선언
  List<Widget> _buildScreens(){
    return[
      //page1
      const HomeScreen(),
      // Container(
      //   child: const Center(
      //     child: Text('home'),
      //   ),
      // ),

      //page2
      // infinityscroll
      FirebaseFirestoreScreen(),
      // ListAlbumScreen(albumName: 'listAlbum'),

      //page3
      Container(
        child: Center(
          child: Column(
            children: [
              Text('home'),
              ElevatedButton(
              onPressed: () =>  createFirestore(),
              child: Text('createData')),
              ElevatedButton(
              onPressed: () =>  uploadImage(),
              child: Text('uploadImage')),
              ElevatedButton(
                onPressed: () =>  getImage(),
                child: Text('getImage')
              ),
              ElevatedButton(
                onPressed: () =>  getList(),
                child: Text('getList')
              ),
              
              Container(
                child: Column(),
                decoration: (downloadURL == '') ? 
                BoxDecoration()
                : BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    // image:AssetImage('assets/images/Main.jpg')
                    image:NetworkImage('$downloadURL')
                  )
                ),
              ),
            ],
          ),
          
        ),
      ),
      // const PageB1(),
      // const PageC1(),
    ];
  }
  //탭메뉴의 버튼 생성 및 설정
  List<PersistentBottomNavBarItem> _navBarsItems(){
    return[
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.image,size: 30,), //아이콘 설정
        // title: 'Home',  //텍스트 설정
        activeColorPrimary: Colors.black,      //기본색
        activeColorSecondary: Colors.yellow,    //반전 
        inactiveColorPrimary: Colors.grey, //비활성
        inactiveColorSecondary: Colors.purple 
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.search,size: 37),
        // title: ("Search"),
        activeColorPrimary: Colors.black,
        activeColorSecondary: Colors.red,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.format_list_bulleted,size: 38),
        // title: ("Search"),
        activeColorPrimary: Colors.black,
        activeColorSecondary: Colors.white,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }

  void createFirestore() async{
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    for (int i = 0; i < 100; i++) {
      await _firestore.collection("infinity_scroll").doc().set(InfinityScrollModel(
          id: i, name: "Tyger $i", dateTime: Timestamp.now()).toJson());
      }
  }

  void uploadImage() async{

    //파이어 스토리지
    FirebaseStorage _storage = FirebaseStorage.instance;
    //스토리지 위치
    Reference _ref = _storage.ref("test/text.txt");
      _ref.putString("Hello World !!");

    //이미지피커 들어갈 부분
    String _image = "assets/images/Main.jpg";
    String _imageName = "Main";
    Directory systemTempDir = Directory.systemTemp;
    ByteData byteData = await rootBundle.load(_image);
    File file = File("${systemTempDir.path}/$_imageName.jpg");
    await file.writeAsBytes(byteData.buffer.asUint8List(
                        byteData.offsetInBytes, byteData.lengthInBytes));

    FirebaseStorage.instance.ref("test/$_imageName.jpg").putFile(file);
  }

  void getList() async{
    Logger logger = new Logger();

    ListResult  albumList = await FirebaseStorage.instance.ref("nightvision/").listAll();
    print(albumList);
      for (final e in albumList.items) {
        logger.d(await e.getDownloadURL());
      }
  }
}