import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:ctseproject/screens/kajathees/medicine_list_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import 'package:page_transition/page_transition.dart';

class AddMedicinePage extends StatefulWidget {
  @override
  _AddMedicinePageState createState() => _AddMedicinePageState();
}

class _AddMedicinePageState extends State<AddMedicinePage> {
  late String name;
  late bool connected;
  String colorValue = '';
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final CollectionReference userDataCollection =
      FirebaseFirestore.instance.collection("Users");
  final LocalStorage storage = LocalStorage('ReminderApp');
  final TextEditingController titleController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  String? _selectedDate;
  String? _selectedTime;
  List itemContent = [];
  List oldItemContent = [];
  String? _selectedName;

  @override
  void initState() {
    super.initState();
    connected = false;
    check();
    debugPrint(storage.getItem('medicineItemCount').toString());
    if (storage.getItem('medicineItemCount') == null) {
      storage.setItem('medicineItemCount', 0);
      debugPrint('medicine item null');
    }
    _selectedName = storage.getItem('medicine_name');
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
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Scaffold(
              backgroundColor: Colors.white,
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MaterialButton(
                          padding: EdgeInsets.only(left: -10.h),
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                PageTransition(
                                    type: PageTransitionType.fade,
                                    child: MedicinePage()),
                                (route) => false);
                          },
                          child: Row(
                            children: [
                              const Icon(Icons.arrow_back, color: Colors.black),
                              SizedBox(width: 20.w),
                              Text(
                                'Go Back',
                                style: GoogleFonts.robotoMono(
                                  textStyle:
                                      Theme.of(context).textTheme.headline4,
                                  color: Colors.black,
                                  fontSize: 15.h,
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.normal,
                                ),
                              )
                            ],
                          ),
                        ),
                        Text(
                          'Add Medicine',
                          style: GoogleFonts.robotoMono(
                            textStyle: Theme.of(context).textTheme.headline4,
                            color: Colors.black,
                            fontSize: 20.h,
                            fontWeight: FontWeight.w900,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        const Divider(
                          thickness: 2.0,
                          color: Colors.black,
                        ),
                        SizedBox(height: 10.h),
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(0),
                          child: MaterialButton(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                            color: Colors.green.shade100,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0.0),
                                side: const BorderSide(
                                    color: Colors.black, width: 1.0)),
                            highlightElevation: 0,
                            child: Row(
                              children: [
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: Text(
                                    'Enter medicine item:',
                                    style: GoogleFonts.robotoMono(
                                      textStyle:
                                          Theme.of(context).textTheme.headline4,
                                      color: Colors.black,
                                      fontSize: 14.h,
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            onPressed: () async {
                              check();
                              if (connected == true) {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        insetPadding:
                                            const EdgeInsets.all(10.0),
                                        backgroundColor: Colors.white,
                                        title: Text('Enter Medicine item',
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
                                            TextFormField(
                                              style: GoogleFonts.robotoMono(
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .headline4,
                                                color: Colors.black,
                                                fontSize: 15.h,
                                                fontWeight: FontWeight.w500,
                                                fontStyle: FontStyle.normal,
                                              ),
                                              controller: titleController,
                                              keyboardType: TextInputType.text,
                                              maxLength: 210,
                                              maxLines: 7,
                                              decoration: InputDecoration(
                                                  alignLabelWithHint: true,
                                                  counterStyle:
                                                      GoogleFonts.robotoMono(
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .headline4,
                                                    color: Colors.black,
                                                    fontSize: 12.h,
                                                    fontWeight: FontWeight.w500,
                                                    fontStyle: FontStyle.normal,
                                                  ),
                                                  labelStyle:
                                                      GoogleFonts.robotoMono(
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .headline4,
                                                    color: Colors.black,
                                                    fontSize: 14.h,
                                                    fontWeight: FontWeight.w500,
                                                    fontStyle: FontStyle.normal,
                                                  ),
                                                  errorStyle:
                                                      GoogleFonts.robotoMono(
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .headline4,
                                                    color: Colors.red,
                                                    fontSize: 12.h,
                                                    fontWeight: FontWeight.w500,
                                                    fontStyle: FontStyle.normal,
                                                  ),
                                                  fillColor: Colors.grey
                                                      .withOpacity(0.3),
                                                  filled: true),
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return "Title field is required.";
                                                }
                                                return null;
                                              },
                                            ),
                                          ],
                                        ),
                                        actions: <Widget>[
                                          MaterialButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text(
                                              'Close',
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
                              } else if (connected == false) {
                                Fluttertoast.showToast(
                                  msg: 'Network Error',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.TOP_RIGHT,
                                  timeInSecForIosWeb: 2,
                                  textColor: Colors.red,
                                  backgroundColor: Colors.black,
                                );
                              }
                            },
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(0),
                          child: MaterialButton(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                            color: Colors.green.shade100,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0.0),
                                side: const BorderSide(
                                    color: Colors.black, width: 1.0)),
                            highlightElevation: 0,
                            child: Row(
                              children: [
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: Text(
                                    'Add additional note to item: '
                                    '\n(Optional)',
                                    style: GoogleFonts.robotoMono(
                                      textStyle:
                                          Theme.of(context).textTheme.headline4,
                                      color: Colors.black,
                                      fontSize: 14.h,
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            onPressed: () async {
                              check();
                              if (connected == true) {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return WillPopScope(
                                        onWillPop: () async => false,
                                        child: AlertDialog(
                                          insetPadding:
                                              const EdgeInsets.all(10.0),
                                          backgroundColor: Colors.white,
                                          title: Text('Add additional note',
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
                                              Text(
                                                  'You can view it by pressing the "i" icon on the medicine item.',
                                                  style: GoogleFonts.robotoMono(
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .headline4,
                                                    color: Colors.black,
                                                    fontSize: 14.h,
                                                    fontWeight: FontWeight.w400,
                                                    fontStyle: FontStyle.normal,
                                                  )),
                                              SizedBox(height: 5.h),
                                              TextFormField(
                                                style: GoogleFonts.robotoMono(
                                                  textStyle: Theme.of(context)
                                                      .textTheme
                                                      .headline4,
                                                  color: Colors.black,
                                                  fontSize: 15.h,
                                                  fontWeight: FontWeight.w500,
                                                  fontStyle: FontStyle.normal,
                                                ),
                                                controller: noteController,
                                                keyboardType:
                                                    TextInputType.text,
                                                maxLength: 150,
                                                maxLines: 5,
                                                decoration: InputDecoration(
                                                    alignLabelWithHint: true,
                                                    counterStyle:
                                                        GoogleFonts.robotoMono(
                                                      textStyle:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .headline4,
                                                      color: Colors.black,
                                                      fontSize: 12.h,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                    ),
                                                    labelStyle:
                                                        GoogleFonts.robotoMono(
                                                      textStyle:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .headline4,
                                                      color: Colors.black,
                                                      fontSize: 14.h,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                    ),
                                                    errorStyle:
                                                        GoogleFonts.robotoMono(
                                                      textStyle:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .headline4,
                                                      color: Colors.red,
                                                      fontSize: 12.h,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                    ),
                                                    fillColor: Colors.grey
                                                        .withOpacity(0.3),
                                                    filled: true),
                                              ),
                                            ],
                                          ),
                                          actions: <Widget>[
                                            MaterialButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text(
                                                'Close',
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
                                        ),
                                      );
                                    });
                              } else if (connected == false) {
                                Fluttertoast.showToast(
                                  msg: 'Network Error',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.TOP_RIGHT,
                                  timeInSecForIosWeb: 2,
                                  textColor: Colors.red,
                                  backgroundColor: Colors.black,
                                );
                              }
                            },
                          ),
                        ),
                        Divider(
                          thickness: 1.h,
                          color: Colors.black,
                        ),
                        Row(
                          children: [
                            Text('Date:',
                                style: GoogleFonts.robotoMono(
                                  textStyle:
                                      Theme.of(context).textTheme.headline4,
                                  color: Colors.black,
                                  fontSize: 14.h,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.normal,
                                )),
                            Container(
                              width: 250.h,
                              padding: const EdgeInsets.all(0),
                              child: MaterialButton(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                color: Colors.white.withOpacity(0.6),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0.0),
                                    side: const BorderSide(
                                        color: Colors.black, width: 1.0)),
                                highlightElevation: 0,
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 0, 0),
                                      child: _selectedDate == null
                                          ? Text(
                                              'Choose Date',
                                              style: GoogleFonts.robotoMono(
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .headline4,
                                                color: Colors.black,
                                                fontSize: 15.h,
                                                fontWeight: FontWeight.w500,
                                                fontStyle: FontStyle.normal,
                                              ),
                                            )
                                          : Text(
                                              _selectedDate!,
                                              style: GoogleFonts.robotoMono(
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .headline4,
                                                color: Colors.black,
                                                fontSize: 15.h,
                                                fontWeight: FontWeight.w500,
                                                fontStyle: FontStyle.normal,
                                              ),
                                            ),
                                    ),
                                  ],
                                ),
                                onPressed: () async {
                                  _selectDate(context);
                                },
                              ),
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        ),
                        SizedBox(height: 5.h),
                        Row(
                          children: [
                            Text('Time:',
                                style: GoogleFonts.robotoMono(
                                  textStyle:
                                      Theme.of(context).textTheme.headline4,
                                  color: Colors.black,
                                  fontSize: 14.h,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.normal,
                                )),
                            Container(
                              width: 250.h,
                              padding: const EdgeInsets.all(0),
                              child: MaterialButton(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                color: Colors.white.withOpacity(0.6),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0.0),
                                    side: const BorderSide(
                                        color: Colors.black, width: 1.0)),
                                highlightElevation: 0,
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 0, 0),
                                      child: _selectedTime == null
                                          ? Text(
                                              'Choose Time',
                                              style: GoogleFonts.robotoMono(
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .headline4,
                                                color: Colors.black,
                                                fontSize: 15.h,
                                                fontWeight: FontWeight.w500,
                                                fontStyle: FontStyle.normal,
                                              ),
                                            )
                                          : Text(
                                              _selectedTime!,
                                              style: GoogleFonts.robotoMono(
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .headline4,
                                                color: Colors.black,
                                                fontSize: 15.h,
                                                fontWeight: FontWeight.w500,
                                                fontStyle: FontStyle.normal,
                                              ),
                                            ),
                                    ),
                                  ],
                                ),
                                onPressed: () async {
                                  _selectTime(context);
                                },
                              ),
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        ),
                        SizedBox(height: 20.h),
                        Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          padding: const EdgeInsets.all(0),
                          child: MaterialButton(
                            padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                            color: Colors.green.shade400,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0.0),
                                side: const BorderSide(
                                    color: Colors.black, width: 1.0)),
                            highlightElevation: 0,
                            child: Row(
                              children: [
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(120, 0, 0, 0),
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Submit',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.robotoMono(
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .headline4,
                                            color: Colors.black,
                                            fontSize: 20.h,
                                            fontWeight: FontWeight.w700,
                                            fontStyle: FontStyle.normal,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            onPressed: () async {
                              check();
                              if (connected == true) {
                                if (_selectedDate == null ||
                                    _selectedTime == null ||
                                    titleController.text.trim() == '') {
                                  Fluttertoast.showToast(
                                    msg: 'Fill the required fields',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.TOP_RIGHT,
                                    timeInSecForIosWeb: 2,
                                    textColor: Colors.red,
                                    backgroundColor: Colors.black,
                                  );
                                } else {
                                  debugPrint('pressed');
                                  storage.setItem(
                                      'medicineItemCount',
                                      (storage.getItem('medicineItemCount') +
                                          1));
                                  debugPrint(
                                      '${storage.getItem('medicineItemCount')} $_selectedDate '
                                      '$_selectedTime ${titleController.text.trim()}');
                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return WillPopScope(
                                          onWillPop: () async => false,
                                          child: AlertDialog(
                                            backgroundColor: Colors.white,
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: const <Widget>[
                                                SizedBox(
                                                  height: 30,
                                                ),
                                                CircularProgressIndicator(
                                                  backgroundColor:
                                                      Colors.yellowAccent,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                              Color>(
                                                          Colors.black26),
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
                                          oldItemContent = ds['medicineitems']);
                                  itemContent.add({
                                    "date": _selectedDate,
                                    "time": _selectedTime,
                                    "item_name": titleController.text.trim(),
                                    "checked": false,
                                    "note": noteController.text.trim()
                                  });
                                  itemContent.addAll(oldItemContent);
                                  debugPrint('added item to the list');
                                  await userDataCollection
                                      .doc('ctse_user_001')
                                      .update({'medicineitems': itemContent});
                                  oldItemContent.clear();
                                  itemContent.clear();
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          type: PageTransitionType.fade,
                                          child: MedicinePage()));
                                  Fluttertoast.showToast(
                                    msg: 'Medicine item added.',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.TOP_RIGHT,
                                    timeInSecForIosWeb: 2,
                                    textColor: Colors.black,
                                    backgroundColor: Colors.lightBlueAccent,
                                  );
                                }
                              } else if (connected == false) {
                                Fluttertoast.showToast(
                                  msg: 'Network Error',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.TOP_RIGHT,
                                  timeInSecForIosWeb: 2,
                                  textColor: Colors.red,
                                  backgroundColor: Colors.black,
                                );
                              }
                            },
                          ),
                        ),
                        SizedBox(height: 30.h),
                      ],
                    ),
                  ),
                ),
              ),
            )));
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2050));
    if (pickedDate != null) {
      setState(() {
        _selectedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
    } else if (pickedDate == null) {
      setState(() {
        _selectedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime.format(context);
      });
    } else if (pickedTime == null) {
      setState(() {
        _selectedTime = TimeOfDay.now().format(context);
      });
    }
  }

  fetchUsername() async {
    await userDataCollection
        .doc('ctse_user_001')
        .get()
        .then((ds) => name = ds['name']);
    storage.setItem('username', name);
  }
}
