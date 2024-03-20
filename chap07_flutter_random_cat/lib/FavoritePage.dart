import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'CatService.dart';
import 'TrashPage.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TrashPage()),
                  );
                },
                icon: Icon(
                  Icons.delete_outline, // 하트 아이콘 설정
                  color: Colors.redAccent, // 아이콘 색상 설정
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
                          color: catService.favoriteCatImages.contains(catImage)
                              ? Colors.pinkAccent // 좋아요한 사진이면 핑크색 하트 표시
                              : Colors.transparent, // 해제하면 투명한 색으로 표시
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
