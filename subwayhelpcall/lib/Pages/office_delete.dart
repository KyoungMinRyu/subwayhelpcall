import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:subwayhelpcall/Firebase/firebase_auth.dart';
import 'package:subwayhelpcall/Firebase/firebase_cloud.dart';
import 'package:subwayhelpcall/Login/login_page.dart';
import 'package:subwayhelpcall/Pages/office_add.dart';
import 'package:subwayhelpcall/Pages/office_page.dart';
import 'package:subwayhelpcall/Pages/office_update.dart';

class OfficeDeletePage extends StatefulWidget {
  @override
  _OfficeDeletePageState createState() => _OfficeDeletePageState();
}

class _OfficeDeletePageState extends State<OfficeDeletePage> {
  FirebaseATHelper _firebaseATHelper = new FirebaseATHelper();
  FirebaseCDHelper _firebaseCDHelper = new FirebaseCDHelper();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _PhoneNumber;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('사용자 삭제'),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: TextFormField(
                    maxLines: 1,
                    validator: (value) {
                      if (value.isEmpty) {
                        return '사용자의 전화번호를 입력해주세요.';
                      }
                      return null;
                    },
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    onSaved: (input) => _PhoneNumber = input,
                    keyboardType: TextInputType.phone,
                    autocorrect: false,
                    decoration: InputDecoration(
                      icon: Icon(Icons.person),
                      hintText: '사용자 전화번호 ( 숫자만 입력해주세요. )',
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 20),
                  child: RaisedButton(
                      color: Colors.blue[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: BorderSide(color: Colors.blue[400], width: 2),
                      ),
                      child: Text('사용자 삭제'),
                      onPressed: () {
                        var formState = _formKey.currentState;
                        formState.save();
                        FocusScope.of(context).requestFocus(new FocusNode());
                        DeleteCloud();
                      }),
                ),
              ],
            ),
          ),
        ),
        drawer: Drawer(
          child: ListView(
            // padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage('img/subway.png')),
                ),
              ),
              Card(
                margin: EdgeInsets.only(top: 15, right: 10, left: 10),
                child: ListTile(
                  leading: Icon(Icons.arrow_back),
                  title: Text('이전'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Card(
                margin: EdgeInsets.only(top: 15, right: 10, left: 10),
                child: ListTile(
                  leading: Icon(Icons.home),
                  title: Text('홈으로'),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => OfficePage()));
                  },
                ),
              ),
              Card(
                margin: EdgeInsets.only(top: 15, right: 10, left: 10),
                child: ListTile(
                  leading: Icon(Icons.person_add),
                  title: Text('사용자 추가'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OfficeAddPage()));
                  },
                ),
              ),
              Card(
                margin: EdgeInsets.only(top: 15, right: 10, left: 10),
                child: ListTile(
                  leading: Icon(Icons.update),
                  title: Text('사용자 수정'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OfficeUpDatePage()));
                  },
                ),
              ),
              Card(
                margin: EdgeInsets.only(top: 15, right: 10, left: 10),
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

  void CheckingAlert() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              '사용자를 정말 삭제하시겠습니까?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            content: Container(
              width: MediaQuery.of(context).size.width,
              height: 45,
              child: Column(
                children: [
                  Text(
                    '사용자 "${_firebaseCDHelper.UserNameData}"을 삭제하시겠습니까?',
                    style: TextStyle(),
                  ),
                  Text(
                    '삭제된 데이터는 복구하실 수 없습니다.',
                    style: TextStyle(color: Colors.red),
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
                  _firebaseCDHelper.DeleteData();
                  ShowToast();
                },
                child: Text('확인'),
              ),
            ],
          );
        });
  }

  void DeleteCloud() async {
    if (_PhoneNumber == '') {
      ShowNullErrorToast();
    } else {
      await _firebaseCDHelper.SearchData(_PhoneNumber);
      if (_firebaseCDHelper.CheckPhoneNum == 1) {
        await _firebaseCDHelper.GetData();
        CheckingAlert();
      } else {
        ShowErrorToast();
      }
    }
  }

  void ShowToast() async {
    Fluttertoast.showToast(
        msg: '사용자가 삭제되었습니다.',
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 3,
        gravity: ToastGravity.BOTTOM);
    await new Future.delayed(const Duration(seconds: 4));
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => OfficePage()));
  }

  void ShowErrorToast() async {
    Fluttertoast.showToast(
        msg: '사용자가 없습니다.',
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 3,
        gravity: ToastGravity.BOTTOM);
    await new Future.delayed(const Duration(seconds: 3));
  }

  void ShowNullErrorToast() async {
    Fluttertoast.showToast(
        msg: '전화번호를 입력해주세요.',
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 3,
        gravity: ToastGravity.BOTTOM);
    await new Future.delayed(const Duration(seconds: 3));
  }
}
