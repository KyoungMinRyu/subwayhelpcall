import 'dart:convert';
import 'dart:typed_data';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:subwayhelpcall/Firebase/firebase_database.dart';
import 'package:subwayhelpcall/Pages/subway_page.dart';

class SubwayView extends StatefulWidget {
  SubwayView({Key key, this.name, this.device, this.uid}) : super(key: key);
  final String name, uid, device;
  @override
  _SubwayViewState createState() => _SubwayViewState();
}

class _SubwayViewState extends State<SubwayView> {
  FirebaseDBHelper _firebaseDBHelper = new FirebaseDBHelper();
  List<Uint8List> list = new List<Uint8List>();
  List<String> PictureList = new List<String>();
  String cut;
  int count = 0;
  Uint8List pic;
  int check = 0;
  @override
  void initState() {
    super.initState();
    print(widget.uid);
    print(widget.device);
    print(widget.name);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: StreamBuilder<Event>(
                  stream: _firebaseDBHelper.db
                      .child('Device' + widget.device)
                      .child(widget.uid)
                      .onValue,
                  builder:
                      (BuildContext context, AsyncSnapshot<Event> snapshot) {
                    if (snapshot.hasData == false ||
                        snapshot.data.snapshot.value == '[]') {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      cut = snapshot.data.snapshot.value['Camera']['Capture'];
                      var split = cut.split(',');
                      if (PictureList.length == 0) {
                        PictureList.add(split.last);
                        list.add(base64.decode(PictureList[0]));
                        pic = list[count];
                      } else {
                        for (int i = 0; i < PictureList.length; i++) {
                          if (PictureList[i].compareTo(split.last) == 0) {
                            check = 1;
                          }
                        }
                        if (check != 1) {
                          PictureList.add(split.last);
                          list.add(base64.decode(PictureList.last));
                        }
                      }
                      check = 0;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(bottom: 10, top: 15),
                            width: double.infinity,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: Colors.blue, width: 3),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: Center(
                                      child: Text(
                                        '${count + 1}/${list.length}',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: 10, bottom: 10, right: 10),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(right: 10),
                                            width: 50,
                                            child: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  if (count == 0) {
                                                    FirstToast();
                                                  } else {
                                                    setState(() {
                                                      count--;
                                                      pic = list[count];
                                                    });
                                                  }
                                                });
                                              },
                                              icon: Icon(
                                                Icons.keyboard_arrow_left,
                                                size: 50,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 240,
                                            child: Center(
                                              child: Image.memory(
                                                pic,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 50,
                                            child: IconButton(
                                              onPressed: () {
                                                if (list.length == count + 1) {
                                                  LastToast();
                                                } else {
                                                  setState(() {
                                                    count++;
                                                    print(list.length);
                                                    pic = list[count];
                                                  });
                                                }
                                              },
                                              icon: Icon(
                                                Icons.keyboard_arrow_right,
                                                size: 50,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            width: double.infinity,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.blue, width: 3),
                            ),
                            child: Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '',
                                    style: TextStyle(fontSize: 8),
                                  ),
                                  Text(
                                    '이름',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  Text(
                                    '',
                                    style: TextStyle(fontSize: 8),
                                  ),
                                  Text(
                                    '${snapshot.data.snapshot.value['User']['Name']}님',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Text(
                                    '',
                                    style: TextStyle(fontSize: 8),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      margin:
                                          EdgeInsets.only(bottom: 10, right: 5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: Colors.blue, width: 3),
                                      ),
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            left: 10, right: 120),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '',
                                              style: TextStyle(fontSize: 8),
                                            ),
                                            Text(
                                              '나이',
                                              style: TextStyle(fontSize: 15),
                                            ),
                                            Text(
                                              '',
                                              style: TextStyle(fontSize: 8),
                                            ),
                                            Text(
                                              '${snapshot.data.snapshot.value['User']['Age']}세',
                                              style: TextStyle(fontSize: 20),
                                            ),
                                            Text(
                                              '',
                                              style: TextStyle(fontSize: 8),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.only(bottom: 10, left: 5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: Colors.blue, width: 3),
                                      ),
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            left: 10, right: 120),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '',
                                              style: TextStyle(fontSize: 8),
                                            ),
                                            Text(
                                              '성별',
                                              style: TextStyle(fontSize: 15),
                                            ),
                                            Text(
                                              '',
                                              style: TextStyle(fontSize: 8),
                                            ),
                                            Text(
                                              '${snapshot.data.snapshot.value['User']['Sex']}',
                                              style: TextStyle(fontSize: 20),
                                            ),
                                            Text(
                                              '',
                                              style: TextStyle(fontSize: 8),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            width: double.infinity,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.blue, width: 3),
                            ),
                            child: Container(
                              margin: EdgeInsets.only(left: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '',
                                    style: TextStyle(fontSize: 8),
                                  ),
                                  Text(
                                    '전화번호',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  // Text(
                                  //   '',
                                  //   style: TextStyle(fontSize: 8),
                                  // ),
                                  TextButton(
                                      child: Text(
                                        '${snapshot.data.snapshot.value['User']['PhoneNumber']}',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      onPressed: () {
                                        Clipboard.setData(new ClipboardData(
                                            text: snapshot.data.snapshot
                                                .value['User']['PhoneNumber']));
                                        CopyToast();
                                      }
                                      ),
                                  // Text(
                                  //   '',
                                  //   style: TextStyle(fontSize: 8),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            width: double.infinity,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.blue, width: 3),
                            ),
                            child: Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '',
                                    style: TextStyle(fontSize: 8),
                                  ),
                                  Text(
                                    '보행장치',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  Text(
                                    '',
                                    style: TextStyle(fontSize: 8),
                                  ),
                                  Text(
                                    '${snapshot.data.snapshot.value['User']['Module']}',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Text(
                                    '',
                                    style: TextStyle(fontSize: 8),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            width: double.infinity,
                            height: 80,
                            child: Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 165,
                                    margin: EdgeInsets.only(left: 0, right: 15),
                                    child: RaisedButton.icon(
                                        color: Colors.blue[300],
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          side: BorderSide(
                                              color: Colors.blue[400],
                                              width: 2),
                                        ),
                                        label: Text(
                                          '재촬영',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        icon: Icon(
                                          Icons.refresh,
                                          size: 30,
                                        ),
                                        onPressed: () {
                                          _firebaseDBHelper.db
                                              .child('Device' + widget.device)
                                              .child(widget.uid)
                                              .child('Camera')
                                              .update({'Control_Number': 1});
                                        }),
                                  ),
                                  Container(
                                    width: 165,
                                    margin: EdgeInsets.only(right: 10),
                                    child: RaisedButton.icon(
                                      color: Colors.blue[300],
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        side: BorderSide(
                                            color: Colors.blue[400], width: 2),
                                      ),
                                      label: Text(
                                        '확인',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      icon: Icon(
                                        Icons.check,
                                        size: 30,
                                      ),
                                      onPressed: () => Checking(snapshot
                                          .data.snapshot.value['User']['Name']),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }

  void Checking(String name) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              '${name} 님의 도움을 완료하시겠습니까?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(context, null);
                },
                child: Text('취소'),
              ),
              FlatButton(
                onPressed: () async {
                  toast();
                  Navigator.pop(context, null);
                  _firebaseDBHelper.db
                      .child('Device' + widget.device)
                      .update({'SetReady': 0});
                  // await Future.delayed(Duration(seconds: 5000), () {});
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SubwayPage(
                                uid: widget.uid,
                              )));
                },
                child: Text('확인'),
              ),
            ],
          );
        });
  }

  Future<void> delay() async {
    await Future.delayed(Duration(milliseconds: 5000), () {});
  }

  void toast() async {
    Fluttertoast.showToast(
        textColor: Colors.white,
        backgroundColor: Colors.black87,
        toastLength: Toast.LENGTH_SHORT,
        msg: '홈화면으로 이동됩니다.',
        timeInSecForIosWeb: 3,
        gravity: ToastGravity.BOTTOM);
  }

  void CopyToast() async {
    Fluttertoast.showToast(
        msg: '전화번호가 복사되었습니다.',
        textColor: Colors.white,
        backgroundColor: Colors.black87,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 3,
        gravity: ToastGravity.TOP);
  }


  void FirstToast() async {
    Fluttertoast.showToast(
        msg: '첫번쨰 사진입니다.',
        textColor: Colors.white,
        backgroundColor: Colors.black87,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 3,
        gravity: ToastGravity.TOP);
  }

  void LastToast() async {
    Fluttertoast.showToast(
        msg: '마지막 사진입니다.',
        textColor: Colors.white,
        backgroundColor: Colors.black87,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 3,
        gravity: ToastGravity.TOP);
  }
}
