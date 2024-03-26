import 'package:chap08_flutter_firebase/auth_service.dart';
import 'package:chap08_flutter_firebase/to_do_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // firevase app 시작
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => ToDoService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthService>().currentUser();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: user == null ? LoginPage() : HomePage(),
    );
  }
}

//로그인 페이지

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(builder: (context, authService, child) {
      User? user = authService.currentUser();
      return Scaffold(
        appBar: AppBar(
          title: Text('로그인'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Text(
                  user == null ? '로그인 해주세요' : '${user.email}님 안녕하세요',
                  style: TextStyle(fontSize: 25),
                ),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(hintText: '이메일'),
              ),
              TextField(
                controller: passwordController,
                //비밀번호 숨기기
                obscureText: true,
                decoration: InputDecoration(hintText: '비밀번호'),
              ),
              ElevatedButton(
                onPressed: () {
                  //로그인
                  authService.signIn(
                    email: emailController.text,
                    password: passwordController.text,
                    onSuccess: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('로그인 성공'),
                        ),
                      );
                      //로그인 성공시 홈페이지로 이동
                      // pushReplacement 새로운 페이지로 이동해서 뒤로버튼 X
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => HomePage()),
                      );
                    },
                    onError: (err) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(err),
                        ),
                      );
                    },
                  );
                },
                child: Text(
                  "로그인",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  authService.signUp(
                    email: emailController.text,
                    password: passwordController.text,
                    onSuccess: () {
                      //회원가입 성공
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('회원가입 성공'),
                        ),
                      );
                      // print('회원가입 성공');
                    },
                    onError: (err) {
                      //에러발생
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(err),
                        ),
                      );
                      // print('회원가입 실패 : $err');
                    },
                  );
                },
                child: Text(
                  '회원가입',
                  style: TextStyle(fontSize: 20),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}

// 홈페이지

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController jobController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<ToDoService>(
      builder: (context, toDoService, child) {
        // 로그인한 회원정보룰 가져오기 위해 AuthService를 context를 통해 위젯트리 최상단에서 가져옴.
        final AuthService authService = context.read<AuthService>();

        // 로그인 시에만 HomePage에 접근이 가능하기 때문에 User는 null이 될 수 없다.
        // 따라서, !로 nullable 을 지워준다.
        User user = authService.currentUser()!;
        print(user.uid);

        return Scaffold(
          appBar: AppBar(
            title: Text("ToDoList"),
            actions: [
              TextButton(
                onPressed: () {
                  //로그 버튼을 눌렀을 때 로그인 페이지로 이동
                  context.read<AuthService>().signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => LoginPage()),
                  );
                },
                child: Text(
                  '로그아웃',
                  style: TextStyle(color: Colors.black),
                ),
              )
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    // 입력창
                    Expanded(
                      child: TextField(
                        controller: jobController,
                        decoration: InputDecoration(
                          hintText: "job을 입력해주세요",
                        ),
                      ),
                    ),
                    // 추가버튼
                    ElevatedButton(
                      onPressed: () {
                        // add 버튼을 눌렀을때 job 추가
                        if (jobController.text.isNotEmpty) {
                          toDoService.create(jobController.text, user.uid);
                          // 입력창 초기화
                        }
                      },
                      child: Icon(Icons.add),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 1,
              ),
              // 투두 리스트
              Expanded(
                /**
                 * FutureBuilder
                 * ToDoService read 기능은 반환하는 값이 시간이 걸리는 Future에서 바로 화면에 보여줄 수 없다.
                 * FutureBuild는 데이터를 요청할 때 builder가 동작하고, 데이터를 받아왔을 때, 다시 builder 가 동작하여
                 * 데이터를 받아 온 뒤에 화면이 다시 그려지면서 데이터를 출력해 줄 수 있다.
                 */
                child: FutureBuilder<QuerySnapshot>(
                    future: toDoService.read(user.uid),
                    builder: (context, snapshot) {
                      /**
                     * snapshot.data는 값을 가지고 오는데 시간이 걸린다.
                     * docs의 경우 데이터가 있는 경우에만 호출이 가능하기 때문에 data 뒤에 ? nullable을 지정해준다.
                     */

                      //반환되는 값
                      final documents = snapshot.data?.docs ?? [];
                      return ListView.builder(
                        itemCount: documents.length,
                        itemBuilder: (context, index) {
                          final doc = documents[index];
                          String job = doc.get('job');
                          bool isDone = doc.get('isDone');
                          return ListTile(
                            title: Text(
                              job,
                              style: TextStyle(
                                  fontSize: 24,
                                  color: isDone ? Colors.grey : Colors.black,
                                  decoration: isDone
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none),
                            ),
                            trailing: IconButton(
                              icon: Icon(CupertinoIcons.delete),
                              onPressed: () {
                                // 삭제버튼 클릭시
                                toDoService.delete(doc.id);
                              },
                            ),
                            onTap: () {
                              // 아이템 클릭하여 isDone 상태 변경
                              toDoService.update(doc.id, !isDone);
                            },
                          );
                        },
                      );
                    }),
              ),
            ],
          ),
        );
      },
    );
  }
}
