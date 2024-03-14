import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('AppBar'),
          backgroundColor: Colors.blue,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          color: Colors.cyanAccent,
                          child: Text('컨테이너'),
                          alignment: Alignment.center,
                          margin: EdgeInsets.all(20),
                          padding: EdgeInsets.only(bottom: 20),
                        ),
                        Text(
                          'hello',
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w300,
                              color: Colors.orange),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.favorite,
                      color: Colors.yellow,
                      size: 100,
                    ),
                  ],
                ),
                Image.asset(
                  'assets/images/cat.jpg',
                ),
                Image.network(
                    'https://img.freepik.com/free-photo/cute-puppy-sitting-in-grass-enjoying-nature-playful-beauty-generated-by-artificial-intelligence_188544-84973.jpg?w=1380&t=st=1710384346~exp=1710384946~hmac=beddb2399998fd6f3de8815a42ca101ea67b3ef7b9777d82d86fe450f9ee8cfc'),
                Image.network(
                    'https://gratisography.com/wp-content/uploads/2023/05/gratisography-colorful-cat-free-stock-photo-800x525.jpg'),
                TextField(
                  decoration: InputDecoration(labelText: 'Input'),

                  //입력폼(text)에 값이 변경될 경우 작동한다.
                  onChanged: (text) {
                    print(text);
                  },

                  //엔터를 눌렀을 경우 작동한다.
                  onSubmitted: (text) {
                    print("enter를 눌렀습니다 입력값 : $text");
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
