import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctseproject/screens/homepage.dart';
import 'package:ctseproject/screens/sithpavan/todo_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:intl/intl.dart';

class DataLoader extends StatefulWidget {

  @override
  _DataLoaderState createState() => _DataLoaderState();

}

class _DataLoaderState extends State<DataLoader> {
  String name = 'user';
  String userPosition = 'home';
  String formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
  String? formattedTime;

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final CollectionReference userDataCollection =
  FirebaseFirestore.instance.collection("Users");
  final LocalStorage storage = LocalStorage('ReminderApp');

  @override
  Future<void> initState() async {
    super.initState();
    formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: fetchData(),
        builder: (context, snapshot) {
          if(userPosition == 'home'){
            return HomePage();
          }
          else if(userPosition == 'todo'){
            return ToDoPage();
          }
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.yellowAccent,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.black26),
            ),
          );
        },
      ),
    );
  }

  fetchUsername() async {
    await userDataCollection.doc('ctse_user_001').get().
    then((ds) => name = ds['name']);
    storage.setItem('username', name);
  }

  fetchUserPosition() async {
    await userDataCollection.doc('ctse_user_001').get().
    then((ds) => userPosition = ds['position']);
    storage.setItem('userPosition', userPosition);
  }

  fetchCurrentDate() async {
    formattedTime = TimeOfDay.now().format(context);
    await userDataCollection.doc('ctse_user_001').get().
    then((ds) => formattedDate = ds['currentDate']);
    await userDataCollection.doc('ctse_user_001').get().
    then((ds) => formattedTime = ds['currentTime']);
    storage.setItem('currentDate', formattedDate);
    storage.setItem('currentDate', formattedTime);
  }

  fetchData() async {
    await fetchTodayTodoList();
    await fetchUsername();
    await fetchUserPosition();
    await setCurrentDateTime();
  }

  setCurrentDateTime() async {
    formattedTime = TimeOfDay.now().format(context);
    await userDataCollection.doc('ctse_user_001').update({"currentTime": formattedTime});
    await userDataCollection.doc('ctse_user_001').update({"currentDate": formattedDate});
    fetchCurrentDate();
  }

  fetchTodayTodoList() async {
    int todoListLength = 0;
    String currentDate = '';
    List dateList = [];
    await userDataCollection.doc('ctse_user_001').get().
    then((ds) => todoListLength = ds['todolistitems'].length);
    for(int i = 0; i < todoListLength ; i ++) {
      await userDataCollection.doc('ctse_user_001').get().
      then((ds) => currentDate = ds['todolistitems'][i]['date']);
      if(formattedDate == currentDate){
        dateList.add(currentDate);
      }
    }
    if (storage.getItem('todayTodoListCount') == null) {
      await storage.setItem('todayTodoListCount', 0);
    }
    await storage.setItem('todayTodoListCount', dateList.length);
    await storage.setItem('todo_list_length', todoListLength);
    debugPrint('todayTodoListCount'+ dateList.length.toString());
  }

}