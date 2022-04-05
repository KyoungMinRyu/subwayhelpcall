import 'dart:core';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:subwayhelpcall/Firebase/firebase_auth.dart';
import 'package:subwayhelpcall/Login/login_page.dart';
import 'package:subwayhelpcall/Firebase/firebase_database.dart';
import 'package:subwayhelpcall/Pages/subway_model.dart';
import 'package:subwayhelpcall/Pages/subway_view.dart';

class SubwayPage extends StatefulWidget {
  SubwayPage({Key key, this.uid}) : super(key: key);
  final String uid;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<SubwayPage> {
  FirebaseATHelper _firebaseATHelper = new FirebaseATHelper();
  FirebaseDBHelper _firebaseDBHelper = new FirebaseDBHelper();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Subway> SubwayList;
  bool reset = true;

  @override
  void initState() {
    super.initState();
    _firebaseDBHelper.GetFirstList(widget.uid);
    re();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '지하철 헬프콜',
            style: TextStyle(),
            textAlign: TextAlign.center,
          ),
          // backgroundColor: Colors.blue,
        ),
        body: Padding(
          padding: EdgeInsets.all(30),
          child: FutureBuilder(
              future: GetList(widget.uid),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData || snapshot.data.toString() == '[]') {
                  return Center(
                    child: Column(children: [
                      Container(
                        margin: EdgeInsets.only(top: 10, bottom: 250),
                        child: Text(
                          '아직 도움을 요청한 사용자가 없습니다.',
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        child: CircularProgressIndicator(),
                      ),
                    ]),
                  );
                } else {
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          margin: EdgeInsets.only(bottom: 15),
                          child: ListTile(
                              leading: Icon(Icons.person),
                              title: Text(
                                  '${snapshot.data[index].name}님이 도움을 요청하셨습니다.'),
                              onTap: () {
                                MovePage(snapshot.data[index].name,
                                    snapshot.data[index].key);
                              }),
                        );
                      });
                }
              }),
        ),
        drawer: Drawer(
          child: ListView(
            // padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('img/subway.png'),
                  ),
                ),
              ),
              Card(
                margin:
                    EdgeInsets.only(bottom: 15, top: 15, right: 10, left: 10),
                child: ListTile(
                  leading: Icon(Icons.arrow_back),
                  title: Text('이전'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Card(
                margin:
                    EdgeInsets.only(bottom: 15, top: 0, right: 10, left: 10),
                child: ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('로그아웃'),
                  onTap: () {
                    _firebaseATHelper.signOut();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<Subway>> GetList(String uid) async {
    SubwayList = await _firebaseDBHelper.GetList(uid);
    if (SubwayList.toString() == '[]') {
    } else {
      return SubwayList;
    }
  }

  void re() async {
    while (reset) {
      print('reset');
      await Future.delayed(Duration(milliseconds: 5000), () {});
      setState(() {});
    }
  }

  void checkdata(String deviceNum, String name) async {
    await _firebaseDBHelper.db
        .child('Device' + deviceNum)
        .child(widget.uid)
        .once()
        .then((DataSnapshot dataSnapshot) {
      if (dataSnapshot == null || dataSnapshot == '[]') {
        SubwayList.clear();
        _firebaseDBHelper.SubwayList.clear();
        setState(() {});
        _firebaseDBHelper.GetFirstList(widget.uid);
        print('이미 도움을 받고있거나 완료된 사람이다');
      } else {
        _firebaseDBHelper.SubwayList.clear();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SubwayView(
                      name: name,
                      device: deviceNum.toString(),
                      uid: widget.uid,
                    )));
      }
    });
  }

  void MovePage(String name, int id) async {
    print(name);
    print(id);
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              '${name}님이 도움을 요청하셨습니다.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            content: Container(
              margin: EdgeInsets.only(top: 20),
              width: MediaQuery.of(context).size.width,
              height: 25,
              child: Column(
                children: [
                  Text(
                    '정보창으로 이동됩니다.',
                    style: TextStyle(),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(context, null);
                },
                child: Text('취소'),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context, null);
                  checkdata(id.toString(), name);
                },
                child: Text('확인'),
              ),
            ],
          );
        });
  }
}
