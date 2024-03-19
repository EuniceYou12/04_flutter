import 'package:flutter/material.dart';
import 'package:intro_screen_onboarding_flutter/introduction.dart';
import 'package:intro_screen_onboarding_flutter/introscreenonboarding.dart';
import 'package:shared_preferences/shared_preferences.dart';

// SharedPreferences 인스턴스를 어디서든 접근 가능하도록 전역 변수로 선언
// late : 나중에 꼭 값을 할당해준다는 의미.
late SharedPreferences prefs;

void main() async {
  // main()함수에서 async를 쓰려면 필요
  WidgetsFlutterBinding.ensureInitialized();

  //Shared_preferences 인스턴스 생성
  prefs = await SharedPreferences.getInstance();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // SharedPreferences 에서 온보딩 완료 여부 조회
    // isOnboarded에 해당하는 값에서 null을 반환하는 경우 false를 기본값으로 지정.
    bool isOnboarded = prefs.getBool('isOnboarded') ?? false;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Pretendard",
      ),
      title: 'Who Am I',
      // isOnboarded 값에 따라 Homepage로 열지 TestScreen으로 열지 결정됨.
      home: isOnboarded ? HomePage() : TestScreen(),
    );
  }
}

class TestScreen extends StatelessWidget {
  final List<Introduction> list = [
    Introduction(
      title: '현재의 나',
      titleTextStyle: TextStyle(
          color: Colors.purple,
          fontSize: 35,
          fontFamily: "Pretendard",
          fontWeight: FontWeight.w800),
      subTitle: 'ENFJ 저는 오지잪이 넓은 사람입니다. \n 제 문제는 몰라도 여러분에겐 \n 든든한 강사가 되겠습니다.',
      subTitleTextStyle: TextStyle(
        fontSize: 25,
        fontFamily: "WagleWagle",
      ),
      imageUrl: 'assets/images/before.png',
    ),
    Introduction(
      title: '수료 후의 나',
      titleTextStyle: TextStyle(color: Colors.purple, fontSize: 35),
      subTitle: '여러분은 취업 할 수 있어요!',
      imageUrl: 'assets/images/after.png',
    ),
    Introduction(
      title: '10년 후의 나',
      titleTextStyle: TextStyle(color: Colors.purple, fontSize: 35),
      subTitle: '경치 좋은 캠핑장 텐트 안에서\n 개발중..ing',
      imageUrl: 'assets/images/ten_years_ago.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return IntroScreenOnboarding(
      introductionList: list,
      onTapSkipButton: () {
        // 마지막 페이지가 나오거나 skip을 해서 Homepage로 가기전에 isOnboarded를 true로 바꿔준다.
        prefs.setBool('isOnboarded', true);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ), //MaterialPageRoute
        );
      },
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home Page'), centerTitle: true, actions: [
        IconButton(
          onPressed: () {
            prefs.clear();
          },
          icon: Icon(Icons.delete),
        )
      ]),
      body: Center(
        child: Text(
          'Welcome to Home Page! \n 가나다라마바사',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
