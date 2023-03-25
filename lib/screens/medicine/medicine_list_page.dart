import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:ctseproject/screens/medicine/EditMedicine.dart';
import 'package:ctseproject/screens/medicine/add_medicine.dart';
import 'package:ctseproject/screens/todo/todo_page.dart';
import 'package:ctseproject/screens/lecture_note/notes_list.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import 'package:page_transition/page_transition.dart';
import 'package:roundcheckbox/roundcheckbox.dart';

import '../grocery_list/grocery_items_page.dart';
import '../homepage.dart';

class MedicinePage extends StatefulWidget {
  @override
  _MedicinePageState createState() => _MedicinePageState();
}

class _MedicinePageState extends State<MedicinePage> {
  late String name;
  late bool connected;
  late bool checkedValue;

  int _currentIndex = 2;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final CollectionReference userDataCollection =
      FirebaseFirestore.instance.collection("Users");
  final LocalStorage storage = LocalStorage('ReminderApp');
  String? _selectedDate;
  String? _selectedTime;
  String? selectedColorValue;
  List<String> colors = [
    'Green',
    'Red',
    'Orange',
    'Blue',
    'Purple',
    'Yellow',
    'Pink',
    'Teal'
  ];
  String? selectedPriorityValue;
  List<String> priorities = ['High', 'Medium', 'Low'];
  List itemContent = [];
  List oldItemContent = [];

  Map<String, bool> values = {'checked': true, 'unchecked': false};

  @override
  void initState() {
    super.initState();
    connected = false;
    check();
  }

  Future<void> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      connected = true;
      debugPrint('mobileconnect ' + connected.toString());
    } else if (connectivityResult == ConnectivityResult.wifi) {
      connected = true;
      debugPrint('wificonnect ' + connected.toString());
    } else if (connectivityResult == ConnectivityResult.none) {
      connected = false;
      debugPrint('no connect ' + connected.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Medicine List',
                        style: GoogleFonts.robotoMono(
                          textStyle: Theme.of(context).textTheme.headline4,
                          color: Colors.black,
                          fontSize: 20.h,
                          fontWeight: FontWeight.w900,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      IconButton(
                        iconSize: 30.0,
                        icon: const Icon(Icons.help),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  insetPadding: const EdgeInsets.all(10.0),
                                  backgroundColor: Colors.white,
                                  title: Text('We will help you to schedule',
                                      style: GoogleFonts.robotoMono(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .headline4,
                                        color: Colors.black,
                                        fontSize: 20.h,
                                        fontWeight: FontWeight.w900,
                                        fontStyle: FontStyle.normal,
                                      )),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      RichText(
                                        text: TextSpan(children: [
                                          TextSpan(
                                              text:
                                                  'Touch the medicine item to edit its content.'
                                                  '\n\nYou can delete medicine item once the course is expired'
                                                  '\n\nClick the red circle once you consumed the medicine'
                                                  '\n\nPress the white notes icon on the item, to check any side note attached with the item.',
                                              style: GoogleFonts.robotoMono(
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .headline4,
                                                color: Colors.black,
                                                fontSize: 12.h,
                                                fontWeight: FontWeight.w600,
                                                fontStyle: FontStyle.normal,
                                              )),
                                        ]),
                                      )
                                    ],
                                  ),
                                  actions: <Widget>[
                                    MaterialButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        'Done',
                                        style: GoogleFonts.robotoMono(
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .headline4,
                                          color: Colors.redAccent,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              });
                        },
                      )
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                  const Divider(
                    thickness: 2.0,
                    color: Colors.black,
                  ),
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: StreamBuilder(
                          stream: userDataCollection
                              .doc('ctse_user_001')
                              .snapshots(),
                          builder: (context,
                              AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.hasData) {
                              return GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: 500,
                                          childAspectRatio: 1.5 / 1,
                                          crossAxisSpacing: 1,
                                          mainAxisSpacing: 1),
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  reverse: true,
                                  itemCount:
                                      snapshot.data!['medicineitems'].length,
                                  itemBuilder: (context, i) {
                                    return Container(
                                        margin: const EdgeInsets.only(top: 10),
                                        child: Stack(
                                          children: <Widget>[
                                            MaterialButton(
                                              elevation: 0,
                                              highlightElevation: 0,
                                              highlightColor: Colors.green,
                                              color:
                                                  Colors.green.withOpacity(0.5),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                side: const BorderSide(
                                                    width: 1.0,
                                                    color: Colors.black),
                                              ),
                                              child: ListTile(
                                                title: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 10, 0, 0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      snapshot.data!['medicineitems']
                                                                  [i]['date'] ==
                                                              DateFormat(
                                                                      'dd/MM/yyyy')
                                                                  .format(
                                                                      DateTime
                                                                          .now())
                                                          ? Text(
                                                              'On Today, ${snapshot.data!['medicineitems'][i]['time']}, ',
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: GoogleFonts
                                                                  .robotoMono(
                                                                textStyle: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .headline4,
                                                                color: Colors
                                                                    .black,
                                                                fontSize:
                                                                    11.5.h,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w900,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                              ),
                                                            )
                                                          : Text(
                                                              'On ${snapshot.data!['medicineitems'][i]['date']}, '
                                                              '${snapshot.data!['medicineitems'][i]['time']}, ',
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: GoogleFonts
                                                                  .robotoMono(
                                                                textStyle: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .headline4,
                                                                color: Colors
                                                                    .black,
                                                                fontSize:
                                                                    11.5.h,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w900,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                              ),
                                                            ),
                                                      const Divider(
                                                        thickness: 0.5,
                                                        color: Colors.black,
                                                      ),
                                                      Flexible(
                                                        child: SizedBox(
                                                            height: 145.h,
                                                            child: RichText(
                                                                textAlign:
                                                                    TextAlign
                                                                        .justify,
                                                                text: TextSpan(
                                                                    children: [
                                                                      TextSpan(
                                                                          text: snapshot.data!['medicineitems'][i]
                                                                              [
                                                                              'item_name'],
                                                                          style:
                                                                              GoogleFonts.robotoMono(
                                                                            textStyle:
                                                                                Theme.of(context).textTheme.headline4,
                                                                            color:
                                                                                Colors.black,
                                                                            fontSize:
                                                                                13.h,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            fontStyle:
                                                                                FontStyle.normal,
                                                                          )),
                                                                    ]))),
                                                      ),
                                                      SizedBox(
                                                        height: 10.h,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              onPressed: () async {
                                                check();
                                                if (connected == true) {
                                                  showDialog(
                                                      context: context,
                                                      barrierDismissible: false,
                                                      builder: (BuildContext
                                                          context) {
                                                        return WillPopScope(
                                                          onWillPop: () async =>
                                                              false,
                                                          child: AlertDialog(
                                                            backgroundColor:
                                                                Colors.white,
                                                            content: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: const <
                                                                  Widget>[
                                                                SizedBox(
                                                                  height: 30,
                                                                ),
                                                                CircularProgressIndicator(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .yellowAccent,
                                                                  valueColor: AlwaysStoppedAnimation<
                                                                          Color>(
                                                                      Colors
                                                                          .black26),
                                                                ),
                                                                SizedBox(
                                                                  height: 30,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      });
                                                  await storage.setItem(
                                                      'medicine_name',
                                                      snapshot.data![
                                                              'medicineitems']
                                                          [i]['item_name']);
                                                  await storage.setItem(
                                                      'medicine_note',
                                                      snapshot.data![
                                                              'medicineitems']
                                                          [i]['note']);
                                                  await storage.setItem(
                                                      'medicine_date',
                                                      snapshot.data![
                                                              'medicineitems']
                                                          [i]['date']);
                                                  await storage.setItem(
                                                      'medicine_time',
                                                      snapshot.data![
                                                              'medicineitems']
                                                          [i]['time']);
                                                  await storage.setItem(
                                                      'medicine_checked_status',
                                                      snapshot.data![
                                                              'medicineitems']
                                                          [i]['checked']);
                                                  await storage.setItem(
                                                      'medicine_item_id', i);
                                                  Navigator.push(
                                                      context,
                                                      PageTransition(
                                                          type:
                                                              PageTransitionType
                                                                  .fade,
                                                          child:
                                                              EditMedicinePage()));
                                                } else if (connected == false) {
                                                  Fluttertoast.showToast(
                                                    msg: 'Network Error',
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    gravity:
                                                        ToastGravity.TOP_RIGHT,
                                                    timeInSecForIosWeb: 2,
                                                    textColor: Colors.red,
                                                    backgroundColor:
                                                        Colors.black,
                                                  );
                                                }
                                              },
                                            ),
                                            Positioned(
                                              left: -8.0.w,
                                              top: 160.0.w,
                                              child: RoundCheckBox(
                                                uncheckedWidget:
                                                    const Icon(Icons.close),
                                                checkedWidget:
                                                    const Icon(Icons.done),
                                                uncheckedColor: Colors.redAccent
                                                    .withOpacity(0.7),
                                                checkedColor: Colors.green
                                                    .withOpacity(0.7),
                                                isChecked: snapshot
                                                        .data!['medicineitems']
                                                    [i]['checked'],
                                                onTap: (selected) async {
                                                  check();
                                                  if (connected == true) {
                                                    showDialog(
                                                        context: context,
                                                        barrierDismissible:
                                                            false,
                                                        builder: (BuildContext
                                                            context) {
                                                          return WillPopScope(
                                                            onWillPop:
                                                                () async =>
                                                                    false,
                                                            child: AlertDialog(
                                                              backgroundColor:
                                                                  Colors.white,
                                                              content: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: const <
                                                                    Widget>[
                                                                  SizedBox(
                                                                    height: 30,
                                                                  ),
                                                                  CircularProgressIndicator(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .yellowAccent,
                                                                    valueColor: AlwaysStoppedAnimation<
                                                                            Color>(
                                                                        Colors
                                                                            .black26),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 30,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        });
                                                    await userDataCollection
                                                        .doc('ctse_user_001')
                                                        .get()
                                                        .then((ds) =>
                                                            oldItemContent = ds[
                                                                'medicineitems']);
                                                    oldItemContent.removeAt(i);
                                                    itemContent.add({
                                                      "date": snapshot.data![
                                                              'medicineitems']
                                                          [i]['date'],
                                                      "time": snapshot.data![
                                                              'medicineitems']
                                                          [i]['time'],
                                                      "item_name": snapshot
                                                                  .data![
                                                              'medicineitems']
                                                          [i]['item_name'],
                                                      "checked": selected,
                                                      "note": snapshot.data![
                                                              'medicineitems']
                                                          [i]['note'],
                                                    });
                                                    oldItemContent
                                                        .addAll(itemContent);
                                                    await userDataCollection
                                                        .doc('ctse_user_001')
                                                        .update({
                                                      'medicineitems':
                                                          oldItemContent
                                                    });
                                                    debugPrint(
                                                        selected.toString());
                                                    if (selected == true) {
                                                      Fluttertoast.showToast(
                                                        msg:
                                                            'Selected Medicine checked.',
                                                        toastLength:
                                                            Toast.LENGTH_SHORT,
                                                        gravity: ToastGravity
                                                            .TOP_RIGHT,
                                                        timeInSecForIosWeb: 1,
                                                        textColor: Colors.black,
                                                        backgroundColor:
                                                            Colors.greenAccent,
                                                      );
                                                    } else if (selected ==
                                                        false) {
                                                      Fluttertoast.showToast(
                                                        msg:
                                                            'Selected medicine unchecked.',
                                                        toastLength:
                                                            Toast.LENGTH_SHORT,
                                                        gravity: ToastGravity
                                                            .TOP_RIGHT,
                                                        timeInSecForIosWeb: 1,
                                                        textColor: Colors.black,
                                                        backgroundColor:
                                                            Colors.redAccent,
                                                      );
                                                    }
                                                    oldItemContent.clear();
                                                    itemContent.clear();
                                                    Navigator.pop(context);
                                                  } else if (connected ==
                                                      false) {
                                                    Fluttertoast.showToast(
                                                      msg: 'Network Error',
                                                      toastLength:
                                                          Toast.LENGTH_SHORT,
                                                      gravity: ToastGravity
                                                          .TOP_RIGHT,
                                                      timeInSecForIosWeb: 2,
                                                      textColor: Colors.red,
                                                      backgroundColor:
                                                          Colors.black,
                                                    );
                                                  }
                                                },
                                                border: Border.all(
                                                  width: 1.h,
                                                  color: Colors.black,
                                                ),
                                                size: 50,
                                              ),
                                            ),
                                            snapshot.data!['medicineitems'][i]
                                                        ['note'] !=
                                                    ''
                                                ? Positioned(
                                                    left: 285.0.w,
                                                    top: -5.0.w,
                                                    child: RoundCheckBox(
                                                      uncheckedWidget:
                                                          const Icon(
                                                              Icons.notes,
                                                              size: 20),
                                                      checkedWidget: const Icon(
                                                          Icons.notes,
                                                          size: 20),
                                                      uncheckedColor:
                                                          Colors.white,
                                                      checkedColor:
                                                          Colors.white,
                                                      isChecked: true,
                                                      onTap: (selected) async {
                                                        check();
                                                        if (connected == true) {
                                                          showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return AlertDialog(
                                                                  insetPadding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          10.0),
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  title: Text(
                                                                    'Note: ',
                                                                    style: GoogleFonts
                                                                        .robotoMono(
                                                                      textStyle: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .headline4,
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          20.5.h,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w900,
                                                                      fontStyle:
                                                                          FontStyle
                                                                              .normal,
                                                                    ),
                                                                  ),
                                                                  content:
                                                                      Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: <
                                                                        Widget>[
                                                                      Flexible(
                                                                        child: SizedBox(
                                                                            child: RichText(
                                                                                textAlign: TextAlign.justify,
                                                                                text: TextSpan(children: [
                                                                                  TextSpan(
                                                                                      text: snapshot.data!['medicineitems'][i]['note'],
                                                                                      style: GoogleFonts.robotoMono(
                                                                                        textStyle: Theme.of(context).textTheme.headline4,
                                                                                        color: Colors.black,
                                                                                        fontSize: 13.h,
                                                                                        fontWeight: FontWeight.w600,
                                                                                        fontStyle: FontStyle.normal,
                                                                                      )),
                                                                                ]))),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  actions: <
                                                                      Widget>[
                                                                    MaterialButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        'Done',
                                                                        style: GoogleFonts
                                                                            .robotoMono(
                                                                          textStyle: Theme.of(context)
                                                                              .textTheme
                                                                              .headline4,
                                                                          color:
                                                                              Colors.redAccent,
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight:
                                                                              FontWeight.w700,
                                                                          fontStyle:
                                                                              FontStyle.normal,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                );
                                                              });
                                                        } else if (connected ==
                                                            false) {
                                                          Fluttertoast
                                                              .showToast(
                                                            msg:
                                                                'Network Error',
                                                            toastLength: Toast
                                                                .LENGTH_SHORT,
                                                            gravity:
                                                                ToastGravity
                                                                    .TOP_RIGHT,
                                                            timeInSecForIosWeb:
                                                                2,
                                                            textColor:
                                                                Colors.red,
                                                            backgroundColor:
                                                                Colors.black,
                                                          );
                                                        }
                                                      },
                                                      border: Border.all(
                                                        width: 1.h,
                                                        color: Colors.black,
                                                      ),
                                                      size: 45,
                                                    ),
                                                  )
                                                : Container(),
                                          ],
                                        ));
                                  });
                            } else if (snapshot.hasError) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.yellowAccent,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.black26),
                                ),
                              );
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.yellowAccent,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.black26),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: StreamBuilder(
                          stream: userDataCollection
                              .doc('ctse_user_001')
                              .snapshots(),
                          builder: (context,
                              AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.hasData) {
                              return snapshot.data!['medicineitems'].length == 0
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Column(
                                          children: [
                                            Container(
                                                width: double.infinity,
                                                alignment: Alignment.center,
                                                margin:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 10, 0, 0),
                                                child: RichText(
                                                    textAlign: TextAlign.center,
                                                    text: TextSpan(children: [
                                                      TextSpan(
                                                          text:
                                                              'Oh oh! Looks like there is nothing in the list. '
                                                              'Try to add one by'
                                                              '\npressing the "+" button',
                                                          style: GoogleFonts
                                                              .robotoMono(
                                                            textStyle: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headline4,
                                                            color: Colors
                                                                .redAccent,
                                                            fontSize: 15.h,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontStyle: FontStyle
                                                                .normal,
                                                          )),
                                                    ]))),
                                          ],
                                        ),
                                      ],
                                    )
                                  : Container();
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1.h),
            color: Colors.lightBlueAccent.withOpacity(0.95),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            iconSize: 30.0,
            icon: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return WillPopScope(
                      onWillPop: () async => false,
                      child: AlertDialog(
                        backgroundColor: Colors.white70,
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const <Widget>[
                            SizedBox(
                              height: 30,
                            ),
                            CircularProgressIndicator(
                              backgroundColor: Colors.yellowAccent,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.black26),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                      ),
                    );
                  });
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.fade, child: AddMedicinePage()));
            },
          ),
        ),
        bottomNavigationBar: CustomNavigationBar(
          iconSize: 20.0,
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
                  fontSize: 12,
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
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
            CustomNavigationBarItem(
              icon: const Icon(Icons.medical_services_outlined),
              title: Text(
                "Medicine",
                style: GoogleFonts.robotoMono(
                  textStyle: Theme.of(context).textTheme.headline4,
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
            CustomNavigationBarItem(
              icon: const Icon(Icons.map_outlined),
              title: Text(
                "Notes",
                style: GoogleFonts.robotoMono(
                  textStyle: Theme.of(context).textTheme.headline4,
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
            CustomNavigationBarItem(
              icon: const Icon(Icons.local_grocery_store),
              title: Text(
                "Grocery",
                style: GoogleFonts.robotoMono(
                  textStyle: Theme.of(context).textTheme.headline4,
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
          ],
          currentIndex: 2,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            if (_currentIndex == 0) {
              userDataCollection
                  .doc('ctse_user_001')
                  .update({"position": 'home'});
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.fade, child: HomePage()));
              setState(() {
                _currentIndex = index;
              });
            }
            if (_currentIndex == 1) {
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
                      type: PageTransitionType.fade, child: NotesList()));
              setState(() {
                _currentIndex = index;
              });
            }
            if (_currentIndex == 4) {
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.fade, child: GroceryItemPage()));
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
}
