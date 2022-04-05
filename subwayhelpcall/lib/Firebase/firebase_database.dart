import 'dart:core';
import 'package:firebase_database/firebase_database.dart';
import 'package:subwayhelpcall/Pages/subway_model.dart';

class FirebaseDBHelper {
  String Checkdevice = 'Device', key;
  dynamic user;
  int set;
  final db = FirebaseDatabase.instance.reference();
  final db_user =
      FirebaseDatabase.instance.reference().child('User').child('Named');
  final db_fg = FirebaseDatabase.instance
      .reference()
      .child('FingerPrint')
      .child('Stateus');
  String UserText, Message;
  List<Subway> SubwayList = new List();
  int division, num;
  bool firstbool = true;

  Future<List<Subway>> GetFirstList(String uid) async {
    while (firstbool) {
      await db
          .child('Device1')
          .child('SetReady')
          .once()
          .then((DataSnapshot dataSnapshot) async {
        // print(dataSnapshot.value);
        if (dataSnapshot.value == 1) {
          await db
              .child('Device1')
              .child(uid)
              .once()
              .then((DataSnapshot dataSnapshot) {
            if (dataSnapshot.value == null || dataSnapshot.value == '[]') {
            } else {
              SubwayList.add(Subway.fromJson(dataSnapshot.value));
            }
          });
        }
      });
      await db
          .child('Device2')
          .child('SetReady')
          .once()
          .then((DataSnapshot dataSnapshot) async {
        // print(dataSnapshot.value);
        if (dataSnapshot.value == 1) {
          await db
              .child('Device2')
              .child(uid)
              .once()
              .then((DataSnapshot dataSnapshot) {
            if (dataSnapshot.value == null || dataSnapshot.value == '[]') {
            } else {
              SubwayList.add(Subway.fromJson(dataSnapshot.value));
            }
          });
        }
      });
      firstbool = false;
      print('flag');
    }
  }

  Future<List<Subway>> GetList(String uid) async {
    db.onChildChanged.listen((Event event) async {
      key = event.snapshot.key;
      print(key);
      if (key != null) {
        await Future.delayed(Duration(milliseconds: 3000), () {});
        await db
            .child(key)
            .child('SetReady')
            .once()
            .then((DataSnapshot dataSnapshot) async {
          // print(dataSnapshot.value);
          if (dataSnapshot.value == 1) {
            await db
                .child(key)
                .child(uid)
                .once()
                .then((DataSnapshot dataSnapshot) {
              for (int i = 0; i < SubwayList.length; i++) {
                if (SubwayList[i].key ==
                    dataSnapshot.value['User']['DeviceNumber']) {
                  division = 0;
                }
              }
              print(division);
              if (division != 0 || SubwayList.length == 0) {
                SubwayList.add(Subway.fromJson(dataSnapshot.value));
                print('배열 길이: ${SubwayList.length}');
              } else {
                print('중복');
              }
              division = null;
            });
          }
        });
      }
    });
    return SubwayList;
  }

  void createRecord(
      String device, String type, String title, String set) async {
    await db
        .child(device)
        .child(type)
        .child(title)
        .once()
        .then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value == null) {
        db.child(device).set({
          type: set,
        });
      } else
        return print('이미 사용자가 저장되어 있습니다.');
    });
  }

  void FgStateNull(String device) {
    db.child('Device'+device).child('FingerPrint').update({'Stateus': ''});
  }

  void updateData(String device, String type, String title, String set) async {
    await db
        .child(device)
        .child(type)
        .child(title)
        .once()
        .then((DataSnapshot dataSnapshot) {
      if (set.compareTo(dataSnapshot.value) != 0) {
        db.child(device).update({type: set});
      } else
        return print('이미 같은 내용이 저장되어 있습니다.');
    });
  }

  void updateData_Fg(String device, int set) async {
//    await db.child(device).child('FingerPrint').once().then((DataSnapshot dataSnapshot) {
//      Map<dynamic, dynamic> values=dataSnapshot.value;
//      print(values['ControlNumber']);
//      });
    await db
        .child(device)
        .child('FingerPrint')
        .child('Control_Number')
        .once()
        .then((DataSnapshot dataSnapshot) {
      print(dataSnapshot.value);
      if (dataSnapshot.value != 0) {
        print('');
      } else
        db.child(device).child('FingerPrint').update({'Control_Number': set});
    });
  }

  void FgMessage(String device) async {
    await db
        .child(device)
        .child('FingerPrint')
        .child('Stateus')
        .once()
        .then((DataSnapshot dataSnapshot) {
      Message = dataSnapshot.value.toString();
    });
  }

  void getUserData(String device) async {
    await db
        .child(device)
        .child('Mac_Address')
        .once()
        .then((DataSnapshot dataSnapshot) {
      print(dataSnapshot.value.toString());
      UserText = dataSnapshot.value.toString();
    });
  }

  void deleteData(String device, String type) async {
    await db.child(device).child(type).remove();
  }
}
