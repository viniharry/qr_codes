import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

void main() async{ 
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // var db = FirebaseFirestore.instance;

  //   QuerySnapshot result = await db.collection('qr_codes').get();

  //   result.docs.forEach((element) {
  //     print(element.id);
  //     print(element.data());
  //   });
  runApp(MyApp()); 
} 
  
class MyApp extends StatelessWidget { 
  // This widget is the root of your application. 
  @override 
  Widget build(BuildContext context) { 
    return MaterialApp( 
      //Given Title 
      title: 'Flutter Demo', 
      debugShowCheckedModeBanner: false, 
      //Given Theme Color 
      theme: ThemeData( 
       primarySwatch: Colors.indigo, 
      ), 
      //Declared first page of our app 
      home: HomePage(), 
    ); 
  } 
} 