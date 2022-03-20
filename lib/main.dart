import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctseproject/screens/homepage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localstorage/localstorage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: () => MaterialApp(
        title: 'Reminder App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Colors.blue,
          errorColor: Colors.redAccent,
          backgroundColor: Colors.grey,
          // textTheme: GoogleFonts.latoTextTheme(
          //   Theme.of(context).textTheme,
          // ),
        ),
        home: const Navigation(title: 'Ctse Project'),
        debugShowCheckedModeBanner: false,
      )
    );
  }
}

class Navigation extends StatefulWidget {
  const Navigation({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  final CollectionReference userDataCollection =
  FirebaseFirestore.instance.collection("Users");
  final LocalStorage storage = LocalStorage('ReminderApp');

  @override
  void initState() {
    super.initState();
    fetchUsername();
  }

  @override
  Widget build(BuildContext context) {
    return HomePage();
  }

  fetchUsername() {
    String name1 = '';

    userDataCollection.doc('ctse_user_001').get().
    then((ds) => name1 = ds['name']);
    storage.setItem('username', name1);
  }
}
