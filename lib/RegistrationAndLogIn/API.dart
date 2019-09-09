import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import '../main.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';


Future registrationRequest({String email,String password,
  String conPassword, String name, String address, String phone, String dOfB,
  String photo ,List<String> disease,String gender,Function callBack,
  Function rejectCallBack,double lat,double lng})async {

  var jsonMap = {
    'email': email,
    'password': password,
    'password_confirmation': conPassword,
    'name': name,
    'address': address,
    'lat': lat.toString(),
    'lng': lng.toString(),
    'phone': phone,
    'gender': gender,
    'dob': dOfB,
    'disease': json.encode(disease),
    'photo': photo,
  };

  try{
    var response = await http.post(
        getUrl("/api/register"),
        body:jsonMap,
        headers: {
          "Accept" : "application/json",
        }
    );
    if(response.statusCode == 200||response.statusCode == 201){
      callBack();
    }else{
      rejectCallBack();
    }
    print('Response status: ${response.body}');
  }catch(exception){print(exception);}
}


Future logInRequest({String email,String password,
  Function callBack,Function rejectCallBack})async {

  var jsonMap = {
    'email': email,
    'password': password,
  };
  try{
    var response = await http.post(
        getUrl("/api/login"),
        body:jsonMap,
        headers: {
          "Accept" : "application/json",
        }
    );
    if(response.statusCode == 200){
      await saveToken(jsonDecode(response.body)["token"]).then((state){
        if(state){
          callBack();
        }
        else {
          rejectCallBack();

        }
      });

    }else {
      rejectCallBack();
      await clearShard();
    }
    print('Response body: ${response.body}');

  }catch(exception){print(exception);}
}


Future<bool> saveToken(String token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('token', token );

  try{
    var response = await http.get(
        getUrl("/api/user"),
        headers: {
          "Accept" : "application/json",
          "Authorization" : "Bearer $token"
        }
    );
    print(response.body);
    if(response.statusCode == 200 || response.statusCode == 201){
      prefs.setDouble("lat", jsonDecode(response.body)["lat"].toDouble());
      prefs.setDouble("lng", jsonDecode(response.body)["lng"].toDouble());
      prefs.setString("phone", jsonDecode(response.body)["phone"]);
      prefs.setString("name", jsonDecode(response.body)["name"]);
      prefs.setString("photo", jsonDecode(response.body)["photo"]);
      prefs.setString("address", jsonDecode(response.body)["address"]);
    }
    print('person data : ${response.body}');

    if(jsonDecode(response.body)["role"].toString() == "user") return true;

  }catch(exception){print(exception);}
  return false;
}
Future clearShard()async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.clear();
}


/*
  HttpClient httpClient = new HttpClient();
  HttpClientRequest request = await httpClient.postUrl(Uri.parse(getUrl("/api/register")));
  request.headers.set('content-type', 'application/json');
  request.headers.set('Accept' , 'application/json');
  request.add(utf8.encode(json.encode(jsonMap)));
  HttpClientResponse response = await request.close();

  String reply = await response.transform(utf8.decoder).join();
  httpClient.close();

  print('Response status: ${response.statusCode}');
  */