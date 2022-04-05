import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:subwayhelpcall/weather_model.dart';
import 'package:flutter/material.dart';
import 'package:subwayhelpcall/Firebase/firebase_auth.dart';
import 'package:subwayhelpcall/Login/login_page.dart';
import 'package:subwayhelpcall/Pages/office_add.dart';
import 'package:subwayhelpcall/Pages/office_delete.dart';
import 'package:subwayhelpcall/Pages/office_update.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class OfficePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<OfficePage> {
  final _openweatherkey = 'f1d5fd746dadf24e2008462c464b45f8';
  FirebaseATHelper _firebaseATHelper = new FirebaseATHelper();
  @override
  void initState() {
    super.initState();
    getWeatherData();
    setState(() {});
  }

  Future<Weather> getWeatherData() async {
    var currentPosition = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
    var lastPosition = await Geolocator()
        .getLastKnownPosition(desiredAccuracy: LocationAccuracy.low);
    print(currentPosition);
    print(lastPosition);
    String lat = currentPosition.latitude.toString();
    String lon = currentPosition.longitude.toString();
    print(lat);
    print(lon);
    var apiAddr =
        'http://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$_openweatherkey&units=metric';
    print(apiAddr);
    var response;
    var dataJson;
    Weather weather;
    try {
      response = await http.get(apiAddr);
      dataJson = json.decode(response.body);
      weather = Weather(
          name: dataJson["name"],
          temp: dataJson["main"]["temp"],
          feeltemp: dataJson["main"]["feels_like"],
          tempMax: dataJson["main"]["temp_max"],
          tempMin: dataJson["main"]["temp_min"],
          humidity: dataJson["main"]["humidity"],
          weatherMain: dataJson["weather"][0]["main"],
          code: dataJson["weather"][0]["id"]);
    } catch (e) {
      print(e);
    }
    return weather;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '홈',
            textAlign: TextAlign.center,
          ),
        ),
        body: InkWell(
          onTap: getWeatherData,
          child: Center(
            child: FutureBuilder(
                future: getWeatherData(),
                builder: (context, AsyncSnapshot<Weather> snapshot) {
                  if (snapshot.hasData == false) {
                    return CircularProgressIndicator();
                  }
                  return Container(
                    margin: EdgeInsets.only(top: 100),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: Text(
                            snapshot.data.name.toString(),
                            style: TextStyle(fontSize: 30),
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                snapshot.data.code == 800
                                    ? Icon(Icons.wb_sunny, size: 100)
                                    : snapshot.data.code / 100 == 8 ||
                                            snapshot.data.code / 100 == 2
                                        ? Icon(Icons.wb_cloudy, size: 100)
                                        : snapshot.data.code / 100 == 3 ||
                                                snapshot.data.code / 100 == 5
                                            ? Icon(Icons.beach_access,
                                                size: 100)
                                            : snapshot.data.code / 100 == 6
                                                ? Icon(Icons.ac_unit, size: 100)
                                                : Icon(
                                                    Icons.cloud_circle,
                                                    size: 100,
                                                  ),
                                Container(
                                  margin: EdgeInsets.only(right: 10, left: 10),
                                ),
                                Text(
                                  '${snapshot.data.temp.toString()} ℃',
                                  style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '${snapshot.data.tempMin.toString()} ℃ / ',
                                style: TextStyle(fontSize: 15),
                              ),
                              Text(
                                '${snapshot.data.tempMax.toString()} ℃',
                                style: TextStyle(fontSize: 15),
                              ),
                              Text(
                                '   체감온도 ${snapshot.data.feeltemp.toString()} ℃',
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 3),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '습도 : ${snapshot.data.humidity.toString()} %',
                                  style: TextStyle(fontSize: 15),
                                ),
                                Text(
                                  '   날씨 : ${snapshot.data.weatherMain.toString()}',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ]),
                        ),
                      ],
                    ),
                  );
                }),
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
}
