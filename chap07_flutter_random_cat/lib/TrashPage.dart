import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'CatService.dart';

class TrashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CatService>(
      builder: (context, catService, child) {
        // 휴지통에 삭제된 사진을 모아서 보여줄 UI 작성
        return Scaffold(
          appBar: AppBar(
            title: Text(
              '삭제한 이미지 - 휴지통', // 앱바 제목 설정

              style: TextStyle(color: Colors.white), // 텍스트 스타일 설정
            ),

            backgroundColor: Colors.blueGrey, // 앱바 배경색 설정
            actions: [
              IconButton(
                onPressed: () {
                  // 아이콘 버튼 눌렀을 때 동작
                },
                icon: Icon(
                  Icons.delete_outline, // 휴지통 아이콘 설정
                  color: Colors.red, // 휴지통 아이콘 색상 설정
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
                List.generate(catService.deletedCatImages.length, (index) {
              String catImage =
                  catService.deletedCatImages[index]; // 좋아요한 고양이 이미지 URL
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
