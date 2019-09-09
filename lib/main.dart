import 'package:flutter/material.dart';
import './RegistrationAndLogIn/LogIn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './HomePage/HomePage.dart';



void main()async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String result = prefs.getString('token');

  runApp(
      MaterialApp(
          title: "pharmacy",
          home: result!=null?HomePage():LogIn(),
          routes: <String, WidgetBuilder>{
            '/logIn' : (BuildContext context) => LogIn(),
            '/homepage' : (BuildContext context) => HomePage(),
          }
      )
  );
}

String getUrl(String partUrl){
  String globalUrl = "https://pharmacy-delivery.000webhostapp.com";
  String result = (globalUrl+partUrl).replaceAll(" ", "");
  return result;
}
