import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:subwayhelpcall/Firebase/firebase_auth.dart';
import 'package:subwayhelpcall/Firebase/firebase_cloud.dart';
import 'package:subwayhelpcall/Firebase/firebase_database.dart';
import 'package:subwayhelpcall/Login/login_page.dart';
import 'package:subwayhelpcall/Pages/office_add.dart';
import 'package:subwayhelpcall/Pages/office_delete.dart';
import 'package:subwayhelpcall/Pages/office_page.dart';
import 'package:subwayhelpcall/Pages/office_update.dart';

enum Gender { MALE, FEMALE }
List<String> Device = ['지팡이', '휠체어', '보행기'];

class OfficeUpdateEditPage extends StatefulWidget {
  OfficeUpdateEditPage(
      {Key key,
      this.name,
      this.age,
      this.device,
      this.gender,
      this.phone,
      this.id,
      this.uid})
      : super(key: key);
  final String name, device, phone, gender, uid;
  final int id,age;
  @override
  _OfficeUpdateEditPageState createState() => _OfficeUpdateEditPageState();
}

class _OfficeUpdateEditPageState extends State<OfficeUpdateEditPage> {
  FirebaseCDHelper _firebaseCDHelper = new FirebaseCDHelper();
  FirebaseATHelper _firebaseATHelper = new FirebaseATHelper();
  FirebaseDBHelper _firebaseDBHelper = new FirebaseDBHelper();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Gender _genderValue = Gender.MALE;
  int _deviceValue, _CheckNumValue = 0, fgCkeckNum = 0;
  String _SaveName,
      _Id,
      _Age,
      _PhoneNumber,
      _Gender = 'MALE',
      _Message,
      _CheckNum = '확인 버튼을 눌러 전화번호를 확인해 주세요.';

  Color Blackrgb = const Color.fromARGB(255, 0, 0, 0);
  Color Bluergb = const Color.fromARGB(255, 0, 0, 255);
  Color Redrgb = const Color.fromARGB(255, 255, 0, 0);

  Color color = Color.fromARGB(255, 0, 0, 0);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firebaseCDHelper.Uid = widget.uid;
    _firebaseCDHelper.GetData();
    if (widget.gender.compareTo('남자') == 0) {
      setState(() {
        _genderValue = Gender.MALE;
        _Gender = 'MALE';
      });
    } else {
      setState(() {
        _genderValue = Gender.FEMALE;
        _Gender = 'FEMALE';
      });
    }
    if (widget.device.compareTo('지팡이') == 0) {
      setState(() {
        _Message = Device[0];
        _deviceValue = 0;
      });
    } else if (widget.device.compareTo('보행기') == 0) {
      setState(() {
        _Message = Device[2];
        _deviceValue = 2;
      });
    } else {
      _Message = Device[1];
      _deviceValue = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            '사용자 수정',
          ),
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
                        return '사용자의 장치 번호를 입력해주세요.';
                      }
                      return null;
                    },
                    onSaved: (input) => _Id = input,
                    keyboardType: TextInputType.number,
                    autocorrect: false,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                      icon: Icon(Icons.star),
                      hintText: widget.id.toString(),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 270,
                            child: FutureBuilder<String>(
                                future: FgState(),
                                builder:
                                    (context, AsyncSnapshot<String> snapshot) {
                                  if (snapshot.hasData == false) {
                                    return Text(
                                      '지문을 재등록하시려면\n재등록 버튼을 눌러주세요.',
                                      style: TextStyle(fontSize: 16),
                                      textAlign: TextAlign.center,
                                    );
                                  } else {
                                    return Text(
                                      snapshot.data.toString(),
                                      style: TextStyle(fontSize: 18),
                                      textAlign: TextAlign.center,
                                    );
                                  }
                                }),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 100,
                            child: RaisedButton(
                                color: Colors.blue[300],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  side: BorderSide(
                                      color: Colors.blue[400], width: 2),
                                ),
                                child: Text('재등록'),
                                onPressed: () {
                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());
                                  var formState2 = _formKey.currentState;
                                  formState2.save();
                                  FgCheck();
                                }),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: TextFormField(
                    maxLines: 1,
                    validator: (value) {
                      if (value.isEmpty) {
                        return '사용자의 이름을 입력해주세요.';
                      }
                      return null;
                    },
                    onSaved: (input) => _SaveName = input,
                    keyboardType: TextInputType.name,
                    autocorrect: false,
                    decoration: InputDecoration(
                      icon: Icon(Icons.person),
                      hintText: widget.name,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: TextFormField(
                    maxLines: 1,
                    validator: (value) {
                      if (value.isEmpty) {
                        return '사용자의 나이을 입력해주세요.';
                      }
                      return null;
                    },
                    onSaved: (input) => _Age = input,
                    keyboardType: TextInputType.number,
                    autocorrect: false,
                    decoration: InputDecoration(
                      icon: Icon(Icons.contacts),
                      hintText: widget.age.toString(),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(top: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 270,
                            child: TextFormField(
                              maxLines: 1,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return '사용자의 전화번호를 입력해주세요.';
                                }
                                return null;
                              },
                              onSaved: (input) => _PhoneNumber = input,
                              keyboardType: TextInputType.phone,
                              autocorrect: false,
                              inputFormatters: [
                                WhitelistingTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                icon: Icon(Icons.contacts),
                                hintText: widget.phone,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 100,
                            child: RaisedButton(
                                color: Colors.blue[300],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  side: BorderSide(
                                      color: Colors.blue[400], width: 2),
                                ),
                                child: Text('확인'),
                                onPressed: () {
                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());
                                  var formState = _formKey.currentState;
                                  formState.save();
                                  CheckPhoneNumber(_PhoneNumber);
                                }),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(top: 15, left: 25),
                  child: Text(
                    _CheckNum,
                    style: TextStyle(
                      fontSize: 15,
                      color: color,
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 270,
                            child: Text(
                              _Message,
                              style: TextStyle(fontSize: 18),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 100,
                            child: RaisedButton(
                                color: Colors.blue[300],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  side: BorderSide(
                                      color: Colors.blue[400], width: 2),
                                ),
                                child: Text('선택'),
                                onPressed: () {
                                  ChooseDevice();
                                }),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    margin: EdgeInsets.only(right: 70),
                    alignment: Alignment.centerLeft,
                    height: 1.0,
                    width: 230,
                    color: Colors.black45,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      FlatButton.icon(
                        label: const Text('남자'),
                        icon: Radio(
                          value: Gender.MALE,
                          groupValue: _genderValue,
                          onChanged: (Gender value) {
                            setState(() {
                              _genderValue = value;
                              _Gender = 'MALE';
                            });
                          },
                        ),
                        onPressed: () {
                          setState(() {
                            _genderValue = Gender.MALE;
                            _Gender = 'MALE';
                          });
                        },
                      ),
                      FlatButton.icon(
                        label: const Text('여자'),
                        icon: Radio(
                          value: Gender.FEMALE,
                          groupValue: _genderValue,
                          onChanged: (Gender value) {
                            setState(() {
                              _genderValue = value;
                              _Gender = 'FEMALE';
                            });
                          },
                        ),
                        onPressed: () {
                          setState(() {
                            _genderValue = Gender.FEMALE;
                            _Gender = 'FEMALE';
                          });
                        },
                      ),
                    ],
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
                      child: Text('사용자 수정'),
                      onPressed: () {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        var formState = _formKey.currentState;
                        formState.save();
                        CheckingAlert();
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
                  leading: Icon(Icons.delete),
                  title: Text('사용자 삭제'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OfficeDeletePage()));
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

  void CheckPhoneNumber(String PhoneNumber) async {
    print(PhoneNumber);
    if (PhoneNumber != '') {
      print(_firebaseCDHelper.CheckPhoneNum);
      await _firebaseCDHelper.SearchData(PhoneNumber);
      print(_firebaseCDHelper.CheckPhoneNum);
      if (_firebaseCDHelper.CheckPhoneNum != 0) {
        _CheckNumValue = 0;
        setState(() {
          _CheckNum = '사용 불가인 전화번호입니다.';
          color = Redrgb;
        });
      } else {
        _CheckNumValue = 1;
        setState(() {
          _CheckNum = '사용 가능한 전화번호입니다.';
          color = Bluergb;
        });
      }
    } else {
      _PhoneNumber = widget.phone;
      _CheckNumValue = 2;
      setState(() {
        _CheckNum = '같은 사용자입니다.';
        color = Bluergb;
      });
    }
  }

  void CheckingAlert() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('사용자를 수정하시겠습니까?'),
            content: Text('사용자를 정말 수정하시겠습니까?'),
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
                  UpdateCloud();
                },
                child: Text('확인'),
              ),
            ],
          );
        });
  }

  void UpdateCloud() {
    if (_Id == '') {
      _Id = widget.id.toString();
    }
    if (_PhoneNumber == '') {
      _PhoneNumber = widget.phone;
    }
    if (_SaveName == '') {
      _SaveName = widget.name;
    }
    if (_Age == '') {
      _Age = widget.age.toString();
    }
    if (_CheckNumValue == 1) {
      if (_Gender.compareTo('MALE') == 0) {
        _firebaseCDHelper.UpdataData(_SaveName, '남자', int.parse(_Age),
            Device[_deviceValue], _PhoneNumber, int.parse(_Id));
        ShowToast();
      } else {
        _firebaseCDHelper.UpdataData(_SaveName, '여자', int.parse(_Age),
            Device[_deviceValue], _PhoneNumber, int.parse(_Id));
        ShowToast();
      }
    } else if (_CheckNumValue == 2) {
      if (_Gender.compareTo('MALE') == 0) {
        _firebaseCDHelper.UpdataData(_SaveName, '남자', int.parse(_Age),
            Device[_deviceValue], _PhoneNumber, int.parse(_Id));
        ShowToast();
      } else {
        _firebaseCDHelper.UpdataData(_SaveName, '여자', int.parse(_Age),
            Device[_deviceValue], _PhoneNumber, int.parse(_Id));
        ShowToast();
      }
    } else {
      ErrorToast();
    }
  }

  void ErrorToast() async {
    setState(() {
      color = Redrgb;
    });
    Fluttertoast.showToast(
        msg: '사용자를 수정하지 못했습니다.',
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 3,
        gravity: ToastGravity.BOTTOM);
    await new Future.delayed(const Duration(seconds: 3));
  }

  void ShowToast() async {
    Fluttertoast.showToast(
        msg: '사용자가 수정되었습니다.',
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 3,
        gravity: ToastGravity.BOTTOM);
    await new Future.delayed(const Duration(seconds: 3));
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => OfficePage()));
  }

  Future<String> ChooseDevice() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState2) {
              return AlertDialog(
                title: Text('보행장치를 선택해주세요.'),
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
                      setState(() {
                        _Message = Device[_deviceValue];
                      });
                      print(_deviceValue);
                    },
                    child: Text('확인'),
                  ),
                ],
                content: Container(
                  width: double.maxFinite,
                  height: 300,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: Device.length,
                    itemBuilder: (BuildContext context, int index) {
                      return RadioListTile(
                        value: index,
                        groupValue: _deviceValue,
                        title: Text(Device[index]),
                        onChanged: (val) {
                          setState2(() {
                            _deviceValue = val;
                          });
                        },
                      );
                    },
                  ),
                ),
              );
            },
          );
        });
  }

  void FgErrorToast() async {
    Fluttertoast.showToast(
        msg: '장치번호(ID)를 입력해주세요.',
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 3,
        gravity: ToastGravity.BOTTOM);
    await new Future.delayed(const Duration(seconds: 3));
  }

  void FgCheck() {
    if (fgCkeckNum == 1) {
      AlreadyToast();
    } else {
      if (_Id != '') {
        _firebaseDBHelper.db
            .child('Device' + _Id)
            .child('FingerPrint')
            .child('Count_ID')
            .once()
            .then((DataSnapshot datasnapshot) {
          print(datasnapshot.value.toString());
          int count = datasnapshot.value + 1;
          if (count != null) {
            _firebaseDBHelper.db
                .child('Device' + _Id)
                .child('FingerPrint')
                .update({'ID_Number': count});
          }
          print(datasnapshot.value.toString());
        });
        print(_Id);
        _firebaseDBHelper.updateData_Fg('Device' + _Id, 1);
        FgState();
      } else {
        _firebaseDBHelper.db
            .child('Device' + widget.id.toString())
            .child('FingerPrint')
            .child('Count_ID')
            .once()
            .then((DataSnapshot datasnapshot) {
          print(datasnapshot.value.toString());
          int count = datasnapshot.value + 1;
          if (count != null) {
            _firebaseDBHelper.db
                .child('Device' + widget.id.toString())
                .child('FingerPrint')
                .update({'ID_Number': count});
          }
          print(datasnapshot.value.toString());
        });
        print('Device${widget.id}');
        _firebaseDBHelper.updateData_Fg('Device' + widget.id.toString(), 1);
        FgState();
      }
    }
  }

  void AlreadyToast() async {
    Fluttertoast.showToast(
        msg: '이미 지문을 추가하셨습니다.',
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 3,
        gravity: ToastGravity.TOP);
  }

  Future<String> FgState() async {
    if (_Id != '') {
      print(_Id);
      await _firebaseDBHelper.FgMessage('Device' + _Id);
      if (_firebaseDBHelper.Message.compareTo('저장 완료') == 0) {
        fgCkeckNum = 1;
        return _firebaseDBHelper.Message;
      } else {
        Future.delayed(const Duration(milliseconds: 100), () {
          setState(() {});
        });
        print(_firebaseDBHelper.Message);
        return _firebaseDBHelper.Message;
      }
    } else {
      await _firebaseDBHelper.FgMessage('Device' + widget.id.toString());
      if (_firebaseDBHelper.Message.compareTo('저장 완료') == 0) {
        fgCkeckNum = 1;
        return _firebaseDBHelper.Message;
      } else {
        Future.delayed(const Duration(milliseconds: 100), () {
          setState(() {});
        });
        print(_firebaseDBHelper.Message);
        return _firebaseDBHelper.Message;
      }
    }
  }
}
