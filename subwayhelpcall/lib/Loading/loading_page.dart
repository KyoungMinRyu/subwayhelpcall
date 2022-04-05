import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:subwayhelpcall/Login/login_page.dart';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override

  void initState() {
    super.initState();
    _mockCheckForSession().then((status) {
      Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginPage()));
    });
  }

  Future<bool> _mockCheckForSession() async {
    await Future.delayed(Duration(milliseconds: 4000), () {});
    return null;
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Center(
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width - 40,
                height: 180,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('img/subway.png'),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 15,
                child: Shimmer(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [
                        0.45,
                        0.5,
                        0.55
                      ],
                      colors: [
                        Colors.white.withOpacity(0),
                        Colors.white.withOpacity(0.6),
                        Colors.white.withOpacity(0),
                      ]),
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width - 70,
                    height: 180,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.7),
                          spreadRadius: 7,
                          blurRadius: 8,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Stack(children: [
        //   Container(
        //     margin: EdgeInsets.only(top: 30),
        //     decoration: BoxDecoration(boxShadow: [
        //       BoxShadow(
        //         color: Colors.pink.withOpacity(0.4),
        //         spreadRadius: 1,
        //         blurRadius: 10,
        //         offset: Offset(0, 0),
        //       )
        //     ]),
        //     child: Shimmer.fromColors(
        //         child: Text(
        //           'SHIMMER',
        //           style: TextStyle(
        //             fontSize: 40,
        //             fontWeight: FontWeight.bold,
        //           ),
        //         ),
        //         baseColor: Colors.black,
        //         highlightColor: Colors.cyanAccent),
        //   ),
        // ]),
      ),
    );
  }
}
