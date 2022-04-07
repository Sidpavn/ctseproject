import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctseproject/screens/kajathees/medicine_list_page.dart';
import 'package:ctseproject/screens/sithpavan/todo_page.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import 'package:page_transition/page_transition.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String name = '';
  String userPosition = 'home';
  String formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
  String? formattedTime;

  int _currentIndex = 0;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final CollectionReference userDataCollection =
      FirebaseFirestore.instance.collection("Users");
  final LocalStorage storage = LocalStorage('ReminderApp');

  @override
  void initState() {
    super.initState();
    fetchData();
    formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: FutureBuilder(
            future: fetchData(),
            builder: (context, snapshot) {
              return Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back, ${storage.getItem(('username'))}!',
                        style: GoogleFonts.robotoMono(
                          textStyle: Theme.of(context).textTheme.headline4,
                          color: Colors.black,
                          fontSize: 20.h,
                          fontWeight: FontWeight.w900,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      Text(
                        'As of date, ${storage.getItem(('currentDate'))}.',
                        style: GoogleFonts.robotoMono(
                          textStyle: Theme.of(context).textTheme.headline4,
                          color: Colors.black45,
                          fontSize: 13.h,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      const Divider(
                        thickness: 2,
                        color: Colors.black,
                      ),
                      SizedBox(height: 10.h),
                      Container(
                        width: double.infinity,
                        height: 90.h,
                        decoration: BoxDecoration(
                            color: Colors.yellowAccent.shade100,
                            borderRadius: BorderRadius.circular(0),
                            border:
                                Border.all(color: Colors.black, width: 2.0)),
                        child: Column(
                          children: [
                            Flexible(
                              child: Stack(
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () => Navigator.push(
                                        context,
                                        PageTransition(
                                            type: PageTransitionType.fade,
                                            child: ToDoPage())),
                                    child: Column(
                                      children: [
                                        Container(
                                            alignment: Alignment.topLeft,
                                            margin: EdgeInsets.only(
                                                top: 10.h,
                                                left: 15.h,
                                                right: 15.h),
                                            child: RichText(
                                                textAlign: TextAlign.left,
                                                text: TextSpan(children: [
                                                  storage.getItem(
                                                              ('todayTodoListCount')) ==
                                                          1
                                                      ? TextSpan(
                                                          text:
                                                              'Today you have,\n${storage.getItem(('todayTodoListCount'))} task to do.',
                                                          style: GoogleFonts
                                                              .robotoMono(
                                                            textStyle: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headline4,
                                                            color: Colors.black,
                                                            fontSize: 18.h,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            fontStyle: FontStyle
                                                                .normal,
                                                          ),
                                                        )
                                                      : TextSpan(
                                                          text:
                                                              'Today you have,\n${storage.getItem(('todayTodoListCount'))} tasks to do.',
                                                          style: GoogleFonts
                                                              .robotoMono(
                                                            textStyle: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headline4,
                                                            color: Colors.black,
                                                            fontSize: 18.h,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            fontStyle: FontStyle
                                                                .normal,
                                                          ),
                                                        )
                                                ]))),
                                        Container(
                                            alignment: Alignment.topLeft,
                                            margin: EdgeInsets.only(
                                                top: 5.h,
                                                left: 15.h,
                                                right: 15.h),
                                            child: RichText(
                                                textAlign: TextAlign.left,
                                                text: TextSpan(children: [
                                                  TextSpan(
                                                    text: 'Check here!',
                                                    style:
                                                        GoogleFonts.robotoMono(
                                                      textStyle:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .headline4,
                                                      color: Colors.black,
                                                      fontSize: 10.5.h,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                    ),
                                                  ),
                                                ]))),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                      left: 225.0.w,
                                      top: -10.0.w,
                                      child: Container(
                                        width: 120.0.w,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.black, width: 2.h),
                                          color: Colors.lightBlueAccent
                                              .withOpacity(0.95),
                                          borderRadius: BorderRadius.all(
                                              Radius.elliptical(90.h, 90.h)),
                                        ),
                                        child: IconButton(
                                          iconSize: 90.0.h,
                                          icon: const Icon(
                                              Icons.arrow_forward_outlined,
                                              size: 30.0),
                                          onPressed: () {},
                                        ),
                                      )),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Container(
                        width: double.infinity,
                        height: 90.h,
                        decoration: BoxDecoration(
                            color: Colors.green.shade200,
                            borderRadius: BorderRadius.circular(0),
                            border:
                                Border.all(color: Colors.black, width: 2.0)),
                        child: Column(
                          children: [
                            Flexible(
                              child: Stack(
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () => Navigator.push(
                                        context,
                                        PageTransition(
                                            type: PageTransitionType.fade,
                                            child: MedicinePage())),
                                    child: Column(
                                      children: [
                                        Container(
                                            alignment: Alignment.topLeft,
                                            margin: EdgeInsets.only(
                                                top: 10.h,
                                                left: 15.h,
                                                right: 15.h),
                                            child: RichText(
                                                textAlign: TextAlign.left,
                                                text: TextSpan(children: [
                                                  storage.getItem(
                                                              ('medicineItemCount')) ==
                                                          1
                                                      ? TextSpan(
                                                          text:
                                                              'Today you have \n${storage.getItem(('medicineItemCount'))} medicines',
                                                          style: GoogleFonts
                                                              .robotoMono(
                                                            textStyle: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headline4,
                                                            color: Colors.black,
                                                            fontSize: 18.h,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            fontStyle: FontStyle
                                                                .normal,
                                                          ),
                                                        )
                                                      : TextSpan(
                                                          text:
                                                              'Today you have \n${storage.getItem(('medicineItemCount'))} medicines',
                                                          style: GoogleFonts
                                                              .robotoMono(
                                                            textStyle: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headline4,
                                                            color: Colors.black,
                                                            fontSize: 18.h,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            fontStyle: FontStyle
                                                                .normal,
                                                          ),
                                                        )
                                                ]))),
                                        Container(
                                            alignment: Alignment.topLeft,
                                            margin: EdgeInsets.only(
                                                top: 5.h,
                                                left: 15.h,
                                                right: 15.h),
                                            child: RichText(
                                                textAlign: TextAlign.left,
                                                text: TextSpan(children: [
                                                  TextSpan(
                                                    text:
                                                        'take care of your health!',
                                                    style:
                                                        GoogleFonts.robotoMono(
                                                      textStyle:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .headline4,
                                                      color: Colors.black,
                                                      fontSize: 10.5.h,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                    ),
                                                  ),
                                                ]))),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                      left: 225.0.w,
                                      top: -10.0.w,
                                      child: Container(
                                        width: 120.0.w,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.black, width: 2.h),
                                          color: Colors.lightGreen.shade400,
                                          borderRadius: BorderRadius.all(
                                              Radius.elliptical(90.h, 90.h)),
                                        ),
                                        child: IconButton(
                                          iconSize: 90.0.h,
                                          icon: const Icon(
                                              Icons.arrow_forward_outlined,
                                              size: 30.0),
                                          onPressed: () {},
                                        ),
                                      )),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        bottomNavigationBar: CustomNavigationBar(
          iconSize: 20.0.h,
          selectedColor: Colors.lightBlueAccent,
          unSelectedColor: Colors.lightBlueAccent.withOpacity(0.4),
          backgroundColor: Colors.black,
          items: [
            CustomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
              title: Text(
                "Home",
                style: GoogleFonts.robotoMono(
                  textStyle: Theme.of(context).textTheme.headline4,
                  color: Colors.white,
                  fontSize: 12.h,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
            CustomNavigationBarItem(
              icon: const Icon(Icons.list_alt_outlined),
              title: Text(
                "To-Do",
                style: GoogleFonts.robotoMono(
                  textStyle: Theme.of(context).textTheme.headline4,
                  color: Colors.white,
                  fontSize: 12.h,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
            CustomNavigationBarItem(
              icon: const Icon(Icons.map_outlined),
              title: Text(
                "Medicine",
                style: GoogleFonts.robotoMono(
                  textStyle: Theme.of(context).textTheme.headline4,
                  color: Colors.white,
                  fontSize: 12.h,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
            CustomNavigationBarItem(
              icon: const Icon(Icons.map_outlined),
              title: Text(
                "Home",
                style: GoogleFonts.robotoMono(
                  textStyle: Theme.of(context).textTheme.headline4,
                  color: Colors.white,
                  fontSize: 12.h,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
            CustomNavigationBarItem(
              icon: const Icon(Icons.map_outlined),
              title: Text(
                "Home",
                style: GoogleFonts.robotoMono(
                  textStyle: Theme.of(context).textTheme.headline4,
                  color: Colors.white,
                  fontSize: 12.h,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
          ],
          currentIndex: 0,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            if (_currentIndex == 0) {
              setState(() {
                _currentIndex = index;
              });
            }
            if (_currentIndex == 1) {
              userDataCollection
                  .doc('ctse_user_001')
                  .update({"position": 'todo'});
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.fade, child: ToDoPage()));
              setState(() {
                _currentIndex = index;
              });
            }
            if (_currentIndex == 2) {
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.fade, child: MedicinePage()));
              setState(() {
                _currentIndex = index;
              });
            }
            if (_currentIndex == 3) {
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.fade, child: HomePage()));
              setState(() {
                _currentIndex = index;
              });
            }
            if (_currentIndex == 4) {
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.fade, child: HomePage()));
              setState(() {
                _currentIndex = index;
              });
            }
            debugPrint(_currentIndex.toString());
          },
        ));
  }

  fetchUsername() async {
    await userDataCollection
        .doc('ctse_user_001')
        .get()
        .then((ds) => name = ds['name']);
    storage.setItem('username', name);
  }

  fetchUserPosition() async {
    await userDataCollection
        .doc('ctse_user_001')
        .get()
        .then((ds) => userPosition = ds['position']);
    storage.setItem('userPosition', userPosition);
  }

  fetchCurrentDate() async {
    formattedTime = TimeOfDay.now().format(context);
    await userDataCollection
        .doc('ctse_user_001')
        .get()
        .then((ds) => formattedDate = ds['currentDate']);
    await userDataCollection
        .doc('ctse_user_001')
        .get()
        .then((ds) => formattedTime = ds['currentTime']);
    storage.setItem('currentDate', formattedDate);
    storage.setItem('currentDate', formattedTime);
  }

  fetchData() async {
    await fetchTodayTodoList();
    await fetchUsername();
    await fetchUserPosition();
    await setCurrentDateTime();
    await fetchMedicine();
  }

  fetchMedicine() async {
    int medicineLength = 0;
    String currentDate = '';
    List dateList = [];
    await userDataCollection
        .doc('ctse_user_001')
        .get()
        .then((ds) => medicineLength = ds['medicineitems'].length);
    for (int i = 0; i < medicineLength; i++) {
      await userDataCollection
          .doc('ctse_user_001')
          .get()
          .then((ds) => currentDate = ds['medicineitems'][i]['date']);
      if (formattedDate == currentDate) {
        dateList.add(currentDate);
      }
    }
    if (storage.getItem('medicineItemCount') == null) {
      await storage.setItem('medicineItemCount', 0);
    }
    await storage.setItem('medicineItemCount', dateList.length);
    await storage.setItem('medicine_length', medicineLength);
    debugPrint('medicineItemCount' + dateList.length.toString());
  }

  setCurrentDateTime() async {
    formattedTime = TimeOfDay.now().format(context);
    await userDataCollection
        .doc('ctse_user_001')
        .update({"currentTime": formattedTime});
    await userDataCollection
        .doc('ctse_user_001')
        .update({"currentDate": formattedDate});
    fetchCurrentDate();
  }

  fetchTodayTodoList() async {
    int todoListLength = 0;
    String currentDate = '';
    List dateList = [];
    await userDataCollection
        .doc('ctse_user_001')
        .get()
        .then((ds) => todoListLength = ds['todolistitems'].length);
    for (int i = 0; i < todoListLength; i++) {
      await userDataCollection
          .doc('ctse_user_001')
          .get()
          .then((ds) => currentDate = ds['todolistitems'][i]['date']);
      if (formattedDate == currentDate) {
        dateList.add(currentDate);
      }
    }
    if (storage.getItem('todayTodoListCount') == null) {
      await storage.setItem('todayTodoListCount', 0);
    }
    await storage.setItem('todayTodoListCount', dateList.length);
    await storage.setItem('todo_list_length', todoListLength);
    debugPrint('todayTodoListCount' + dateList.length.toString());
  }
}
