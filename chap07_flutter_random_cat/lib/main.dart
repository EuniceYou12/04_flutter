import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'CatService.dart';
import 'HomePage.dart';

void main() async {
  // main() 함수에서 async를 쓰려면 필요
  WidgetsFlutterBinding.ensureInitialized();

  // shared_preference 인스턴스 생성
  // late 키워드 제거하여 선언과 동시에 초기화
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // 좋아요한 리스트를 가져오기
  List<String> favoriteCatImages =
      prefs.getStringList("favoriteCatImages") ?? [];

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CatService(prefs)),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  //MyApp 클래스의 생성자를 정의
  //MyApp 클래스의 생성자는 key 매개변수를 부모 클래스의 생성자에 전달하는 역할
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
