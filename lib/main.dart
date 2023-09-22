import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:photofolio/color_schemes.g.dart';
import 'package:photofolio/pages/Home.dart';

void main()  async{
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDefault();
  runApp(const MyApp());
}

Future<void> initializeDefault() async {
    FirebaseApp app = await Firebase.initializeApp();
    print('Initialized default app $app');
  }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: darkColorScheme,
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        // useMaterial3: true,
      ),
      home: const MyHomePage(title: '',),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late PersistentTabController _controller;

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
      const HomeScreen(),
      Container(
        child: const Center(
          child: Text('home'),
        ),
      ),
      Container(
        child: const Center(
          child: Text('home'),
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
}
