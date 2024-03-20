import 'package:dio/dio.dart'; // dio 패키지 를 가져옴 HTTP 요청을 만들고 처리 하기 위해 사용
import 'package:flutter/cupertino.dart'; // Flutter 에서 Cupertino 디자인 을 사용 하기 위해 가져옴
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// cat service
class CatService extends ChangeNotifier {
  late SharedPreferences prefs; // SharedPreferences 필드 추가

  List<String> catImages = []; // 고양이 이미지 URL을 저장 하는 리스트
  // 좋아요 한 고양이 사진을 담는 배열
  List<String> favoriteCatImages = []; // 좋아 하는 고양이 이미지 URL을 저장하는 리스트
  // SharedPreferences 인스턴스 선언
  List<String> deletedCatImages = []; // 삭제한 이미지 URL을 저장하는 리스트

  // CatService 생성자
  CatService(this.prefs) {
    catImages = [];
    deletedCatImages = [];
    getFavoriteCatImages(); // 좋아 하는 고양이 이미지를 가져 오는 메서드를 호출
    getRandomCatImages(); // 랜덤한 고양이 이미지를 가져 오는 메서드를 호출
    getDeletedCatImages();
  }

  // 좋아 하는 고양이 이미지를 가져 오는 메서드
  void getFavoriteCatImages() async {
    // SharedPreferences에서 좋아하는 고양이 이미지 리스트를 가져와 favoriteCatImages에 저장
    favoriteCatImages = await prefs.getStringList('favoriteCatImages') ?? [];
  }

  // 삭제한 고양이 이미지를 가져 오는 메서드
  void getDeletedCatImages() async {
    // SharedPreferences에서 좋아하는 고양이 이미지 리스트를 가져와 favoriteCatImages에 저장
    deletedCatImages = await prefs.getStringList('deletedCatImages') ?? [];
  }

  // 랜덤한 고양이 이미지를 가져오는 메서드.
  void getRandomCatImages() async {
    String path =
        "https://api.thecatapi.com/v1/images/search?limit=10&mime_types=gif"; // API 에서 랜덤한 고양이 이미지 를 가져 오는 경로
    var result = await Dio().get(path); // Dio를 사용하여 HTTP GET 요청을 보냄
    print(result.data); // 결과를 출력
    for (int i = 0; i < result.data.length; i++) {
      // 결과에서 각 이미지의 URL을 가져와 catImages 리스트에 추가
      var map = result.data[i];
      print(map['url']);
      catImages.add(map['url']);
    }

    notifyListeners(); // 리스너에게 상태 변경을 알림
  }

  // 좋아요 기능을 토글하는 메서드 고양이 이미지를 좋아요 리스트에 추가 또는 제거
  void toggleFavoriteImage(String catImage) {
    if (favoriteCatImages.contains(catImage)) {
      // 이미 좋아요한 이미지인 경우
      favoriteCatImages.remove(catImage); // 좋아요 리스트에서 제거
    } else {
      // 좋아요하지 않은 이미지인 경우
      favoriteCatImages.add(catImage); // 좋아요 리스트에 추가
    }

    // 좋아요한 이미지 목록을 SharedPreferences에 저장
    prefs.setStringList('favoriteCatImages', favoriteCatImages);

    notifyListeners(); // 리스너에게 상태 변경을 알림

    // 좋아요가 해제된 경우 해당 이미지를 deletedCatImages에 추가
    if (!favoriteCatImages.contains(catImage)) {
      deletedCatImages.add(catImage);
    } else {
      // 좋아요가 해제되었으므로 deletedCatImages에서 해당 이미지를 제거
      deletedCatImages.remove(catImage);
    }
    // 좋아요 해제한 이미지 목록을 SharedPreferences에 저장
    prefs.setStringList('deletedCatImages', deletedCatImages);
  }
}
