import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:subwayhelpcall/Firebase/firebase_auth.dart';
import 'package:subwayhelpcall/Pages/office_page.dart';
import 'package:subwayhelpcall/Pages/subway_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FirebaseATHelper _firebaseATHelper = new FirebaseATHelper();
  String _email, _password;
  String sub = 'station.com';
  String off = 'office.com';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                Container(
                  margin: EdgeInsets.only(top: 100),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 40),
                              width: double.infinity,
                              child: Image.asset(
                                'img/subway.png',
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.8),
                                    spreadRadius: 8,
                                    blurRadius: 25,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 15),
                              child: TextFormField(
                                maxLines: 1,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return '아이디 또는 이메일을 입력해주세요.';
                                  }
                                  return null;
                                },
                                onSaved: (input) => _email = input,
                                keyboardType: TextInputType.emailAddress,
                                autocorrect: false,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.email),
                                  hintText: '아이디 또는 이메일',
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 30),
                              child: TextFormField(
                                maxLines: 1,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return '비밀번호를 입력해주세요';
                                  }
                                  return null;
                                },
                                onSaved: (input) => _password = input,
                                keyboardType: TextInputType.visiblePassword,
                                autocorrect: false,
                                obscureText: true,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.lock),
                                  hintText: '비밀번호',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Container(
                          margin:
                              EdgeInsets.only(bottom: 20, left: 10, right: 10),
                          width: double.infinity,
                          height: 45,
                          // decoration: BoxDecoration(
                          //   borderRadius: BorderRadius.circular(10),
                          //   color: Colors.tealAccent,
                          // ),
                          child: RaisedButton(
                            color: Colors.blue[300],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              side:
                                  BorderSide(color: Colors.blue[400], width: 2),
                            ),
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
                                signin();
                              }
                            },
                            child: Text(
                              '로그인',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void ShowErrorToast() async {
    Fluttertoast.showToast(
        msg: '아이디와 비밀번호를 다시 확인해주세요.',
        backgroundColor: Colors.black,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 3,
        gravity: ToastGravity.BOTTOM);
  }

  void ShowToast() async {
    Fluttertoast.showToast(
        msg: '로그인되었습니다.',
        backgroundColor: Colors.black,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 3,
        gravity: ToastGravity.BOTTOM);
    await new Future.delayed(const Duration(seconds: 3));
  }

  Future<void> signin() async {
    var formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      if (await _firebaseATHelper.signIn(_email, _password) == true) {
        var arr = _email.split('@');
        if (arr[1].compareTo(off) == 0) {
          ShowToast();
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => OfficePage()));
        }
        if (arr[1].compareTo(sub) == 0) {
          ShowToast();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SubwayPage(
                        uid: _firebaseATHelper.setUser,
                      )));
        }
      } else {
        ShowErrorToast();
      }
    }
  }
}
