import 'package:flutter/material.dart';
import 'package:intro_screen_onboarding_flutter/introduction.dart';
import 'package:intro_screen_onboarding_flutter/introscreenonboarding.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Who Am I',
      home: TestScreen(),
    );
  }
}

class TestScreen extends StatelessWidget {
  final List<Introduction> list = [
    Introduction(
      title: '현재의 나',
      titleTextStyle: TextStyle(color: Colors.purple, fontSize: 35),
      subTitle: 'ENFJ 저는 오지잪이 넓은 사람입니다. \n 제 문제는 몰라도 여러분에겐 \n 든든한 강사가 되겠습니다.',
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
      appBar: AppBar(
        title: Text('Home Page'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'Welcome to Home Page!',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
