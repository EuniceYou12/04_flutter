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
      subTitle: '아직 초보 개발자 이지만\n 아기 오리처럼 열심히 노력해서 \n배우고 나아가고 싶습니다',
      subTitleTextStyle: TextStyle(
        fontSize: 25,
        fontFamily: "WagleWagle",
      ),
      imageUrl: 'assets/images/a.jpg',
    ),
    Introduction(
      title: '수료 후의 나',
      titleTextStyle: TextStyle(color: Colors.purple, fontSize: 35),
      subTitle:
          '멋진 백조의 모습처럼\n우아하고여유로운 모습을 하고\n수면아래 백조 다리처럼\n열심히 일을 하고 있을것 같습니다',
      imageUrl: 'assets/images/b.jpg',
    ),
    Introduction(
      title: '10년 후의 나',
      titleTextStyle: TextStyle(color: Colors.purple, fontSize: 35),
      subTitle: '별이 보이는 집을 지어서\n가족과 함께 생활 하며\n여유로운 개발을 하고 싶습니다',
      imageUrl: 'assets/images/c.jpg',
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
