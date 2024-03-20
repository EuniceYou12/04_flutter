import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences prefs;

void main() async {
  // main() 함수에서 async를 쓰려면 필요
  WidgetsFlutterBinding.ensureInitialized();

  // shared_preference 인스턴스 생성
  prefs = await SharedPreferences.getInstance();

  // 좋아요한 리스트를 가져오기
  List<String> favoriteCatImages =
      prefs.getStringList("favoriteCatImages") ?? [];

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => CatService(favoriteCatImages)),
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

// cat service
class CatService extends ChangeNotifier {
  List<String> catImages = [];
  // 좋아요 한 고양이 사진을 담는 배열
  List<String> favoriteCatImages; // = [];
  // SharedPreferences 인스턴스 선언

  // CatService 생성자
  CatService(this.favoriteCatImages) {
    getFavoriteCatImages();
    getRandomCatImages();
  }

  void getFavoriteCatImages() async {
    favoriteCatImages = await prefs.getStringList('favoriteCatImages') ?? [];
  }

  // 고양이 이미지 10개 가져오는 메서드
  void getRandomCatImages() async {
    String path =
        "https://api.thecatapi.com/v1/images/search?limit=10&mime_types=gif";
    var result = await Dio().get(path);
    print(result.data);
    for (int i = 0; i < result.data.length; i++) {
      var map = result.data[i];
      print(map['url']);
      // carImage에 이미지 url 추가
      catImages.add(map['url']);
    }

    notifyListeners();
  }

  //좋아요 기능
  void toggleFavoriteImage(String catImage) {
    if (favoriteCatImages.contains(catImage)) {
      favoriteCatImages.remove(catImage);
    } else {
      favoriteCatImages.add(catImage);
    }

    // 좋아요 누를때 prefs 에 저장
    prefs.setStringList('favoriteCatImages', favoriteCatImages);

    notifyListeners();
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CatService>(
      builder: (context, catService, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              '랜덤고양이',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.indigo,
            actions: [
              IconButton(
                onPressed: () {
                  //아이콘 버튼 눌렀을 때  동작
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FavoritePage()),
                  );
                },
                icon: Icon(
                  Icons.favorite,
                  color: Colors.white,
                ),
              )
            ],
          ),
          //GridView count 생성자로, 그리드 내 아이템 수를 기반으로 레이아웃을 구성 할수 있다.
          body: GridView.count(
            // 크로스축으로 아이템이 2개씩 배치되도록 설정
            crossAxisCount: 2,
            // 그리드의 주축(세로) 사이의 아이템 공간 설정
            mainAxisSpacing: 8,
            // 그리드의 크로스축(가로) 사이의 아이템 공간 설정
            crossAxisSpacing: 8,
            // 그리드의 전체에 대한 패딩 설정
            padding: EdgeInsets.all(8),
            // 그리드에 표시될 위젯의 리스트, 10개의 위젯을 생성
            children: List.generate(catService.catImages.length, (index) {
              String catImage = catService.catImages[index];
              return GestureDetector(
                child: Stack(
                  children: [
                    /**
                     * Positioned
                     * Stack 내에서 자식 위쳇의 위치를 정밀하게 제어할 때 사용.
                     * top, right, bottom, left 네가지 속성으로 위치를 조정한다.
                     * Positioned.fill 4가지 속성이 모두 0으로 설정되며,
                     * Stack 모든 면을 채우도록 설정된다.
                     */
                    Positioned.fill(
                      child: Image.network(
                        catImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                        bottom: 8,
                        right: 8,
                        child: Icon(
                          Icons.favorite,
                          color: catService.favoriteCatImages.contains(catImage)
                              ? Colors.pinkAccent
                              //투명한 색
                              : Colors.transparent,
                        ))
                  ],
                ),
                onTap: () {
                  // 사진 클릭시 작동
                  catService.toggleFavoriteImage(catImage);
                },
              );
            }),
          ),
        );
      },
    );
  }
}

class FavoritePage extends StatelessWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CatService>(
      builder: (context, catService, child) {
        // 좋아요한 사진들을 모아서 보여줄 UI 작성
        return Scaffold(
          appBar: AppBar(
            title: Text(
              '좋아요 사진 모아 보기', // 앱바 제목 설정

              style: TextStyle(color: Colors.white), // 텍스트 스타일 설정
            ),

            backgroundColor: Colors.indigo, // 앱바 배경색 설정
            actions: [
              IconButton(
                onPressed: () {
                  // 아이콘 버튼 눌렀을 때 동작
                },
                icon: Icon(
                  Icons.favorite, // 하트 아이콘 설정
                  color: Colors.white, // 아이콘 색상 설정
                ),
              )
            ],
          ),
          body: GridView.count(
            crossAxisCount: 2,
            // 그리드뷰의 열 개수 설정
            mainAxisSpacing: 8,
            // 주축(세로) 간격 설정
            crossAxisSpacing: 8,
            // 교차축(가로) 간격 설정
            padding: EdgeInsets.all(8),
            // 그리드뷰의 전체 패딩 설정
            children:
                List.generate(catService.favoriteCatImages.length, (index) {
              String catImage =
                  catService.favoriteCatImages[index]; // 좋아요한 고양이 이미지 URL
              return GestureDetector(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.network(
                        catImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                        bottom: 8,
                        right: 8,
                        child: Icon(
                          Icons.favorite,
                          color: Colors.pinkAccent, // 항상 좋아요한 사진이므로 핑크색 하트 표시
                        ))
                  ],
                ),
                onTap: () {
                  // 이미 좋아요한 사진이므로 추가 동작 필요 없음
                },
              );
            }),
          ),
        );
      },
    );
  }
}
