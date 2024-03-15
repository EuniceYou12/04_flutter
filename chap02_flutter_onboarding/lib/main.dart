import 'package:flutter/material.dart';
import 'package:intro_screen_onboarding_flutter/intro_app.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.black26,
      ),
      home: TestScreen(),
    );
  }
}

class TestScreen extends StatelessWidget {
  final List<Introduction> introductionList = [
    Introduction(
      title: '현재의 나',
      subTitle: '아직 초보 개발자 이지만\n 아기 오리처럼 열심히 노력해서 \n배우고 나아가고 싶습니다',
      imageUrl: 'assets/images/b.jpg',
    ),
    Introduction(
      title: '수료 후의 나',
      subTitle:
          '멋진 백조의 모습처럼\n우아하고여유로운 모습을 하고\n수면아래 백조 다리처럼\n열심히 일을 하고 있을것 같습니다',
      imageUrl: 'assets/images/c.jpg',
    ),
    Introduction(
      title: '10년 후의 나',
      subTitle: '별이 보이는 집을 지어서\n가족과 함께 생활 하며\n여유로운 개발을 하고 싶습니다',
      imageUrl: 'assets/images/d.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return IntroScreenOnboarding(
      introductionList: introductionList,
      onTapSkipButton: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

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
            color: Colors.lightBlueAccent,
          ),
        ),
      ),
    );
  }
}
