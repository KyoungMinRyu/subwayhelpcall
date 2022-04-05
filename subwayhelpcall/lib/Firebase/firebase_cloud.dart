import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:subwayhelpcall/Firebase/firebase_database.dart';

class FirebaseCDHelper {
  FirebaseDBHelper _firebaseDBHelper = new FirebaseDBHelper();
  Firestore store = Firestore.instance;
  String Mac, Message, Uid;
  int CheckPhoneNum;
  var UserNameData,
      UserDeviceData,
      UserAgeData,
      UserGenderData,
      UserPhoneData,
      UserIdData;

  void AddData(String named, String gender, int age, String device,
      String phonenumber, int id) async {
    await _firebaseDBHelper.getUserData('Device'+id.toString());
    print(_firebaseDBHelper.UserText);
    store.collection('USER').document(_firebaseDBHelper.UserText).setData({
      'Name': named,
      'Sex': gender,
      'Age': age,
      'Module': device,
      'PhoneNumber': phonenumber,
      'DeviceNumber': id,
    });
  }

  void UpdataData(String named, String gender, int age, String device,
      String phonenumber, int id) async {
    store.collection('USER').document(Uid).updateData({
      'Name': named,
      'Sex': gender,
      'Age': age,
      'Module': device,
      'PhoneNumber': phonenumber,
      'DeviceNumber': id,
    });
  }

  void GetData() async {
    await store
        .collection('USER')
        .document(Uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      UserNameData = documentSnapshot.data['Name'];
      UserAgeData = documentSnapshot.data['Age'];
      UserDeviceData = documentSnapshot.data['Module'];
      UserGenderData = documentSnapshot.data['Sex'];
      UserPhoneData = documentSnapshot.data['PhoneNumber'];
      UserIdData = documentSnapshot.data['DeviceNumber'];
    });
  }

  void SearchData(String phonenumber) async {
    QuerySnapshot result = await store
        .collection('USER')
        .where('PhoneNumber', isEqualTo: phonenumber)
        .getDocuments();
    List<DocumentSnapshot> document = result.documents;
    CheckPhoneNum = document.length;
    result.documents.forEach((element) {
      Uid = element.documentID;
      print(Uid);
    });
  }

  void DeleteData() async {
    await _firebaseDBHelper.getUserData('Mac');
    store.collection('USER').document(Uid).delete();
  }
}
