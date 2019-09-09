import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_pharmacy/RegistrationAndLogIn/InputDesign.dart';
import 'package:location/location.dart';
import 'package:online_pharmacy/GetLocation/ShowMap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShoppingNextPage extends StatefulWidget {

  double latitude=0.0;
  double longitude=0.0;

  @override
  _ShoppingNextPageState createState() => _ShoppingNextPageState();
}
class _ShoppingNextPageState extends State<ShoppingNextPage> {


  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String stateData = "";

  LocationData  currentLocation;
  var location = new Location();

  String phone;
  String description;
  int pharmacyId;

  Future<Map<String,double>> getCurrentLocation()async{
    Map<String,double> result={
      "latitude":0.0,
      "longitude":0.0
    };
    try {
      currentLocation = await location.getLocation();
      result = {
        "latitude":currentLocation.latitude,
        "longitude":currentLocation.longitude
      };
      setState(() {
        widget.latitude = currentLocation.latitude;
        widget.longitude = currentLocation.longitude;
      });
    }catch (e) {
      currentLocation = null;
    }
    return result;
  }

  Future getDefaultLocation()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double lat = prefs.getDouble('lat');
    double lng = prefs.getDouble('lng');
    setState(() {
      widget.latitude  = lat;
      widget.longitude = lng;
    });
  }

  Future getDefaultPhone()async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    phone = prefs.getString('phone');
  }

  Future getDefaultDescription()async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    phone = prefs.getString('address');
  }



  Future getNearestPharmacy()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    try{
      var response = await http.post(
          getUrl("/api/nearest"),
          body: {
            "lat":"${widget.latitude}",
            "lng":"${widget.longitude}",
          },
          headers: {
            "Accept" : "application/json",
            "Authorization" : "Bearer $token"
          }
      );
      if(response.statusCode == 200 || response.statusCode == 201){
        pharmacyId = int.parse(response.body);
      }else pharmacyId = 2;
      print('nearest : ${response.body}');

    }catch(exception){print(exception);}
  }

  Future makeTheOrder()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    if(descriptionController!=null){
      if(descriptionController.text!=null){
        if(descriptionController.text.length>5)
          description = descriptionController.text;
      } else getDefaultDescription();
    }

    if(phoneController.text!=null){
      if(phoneController.text.length==11) phone = phoneController.text;
    } else getDefaultPhone();

    try{
      var response = await http.post(
          getUrl("/api/addorder"),
          body: {
            "address":description,
            "pharmacy_id":"$pharmacyId",
            "phone":phone,
          },
          headers: {
            "Accept" : "application/json",
            "Authorization" : "Bearer $token"
          }
      );
      if(response.statusCode == 200 || response.statusCode == 201){

      }
      print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> : ${response.body}');

    }catch(exception){print(exception);}
  }



  TextEditingController descriptionController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();

  Future<Map<String,double>> _navigateAndDisplaySelection(
      BuildContext context,Map result) async {
    final getFromMap = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>
          ShowMap(result["longitude"],result["latitude"])),
    );
    return getFromMap;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      resizeToAvoidBottomPadding: true,
      key: _scaffoldKey,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(6),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 100,),
              Container(
                padding: EdgeInsets.only(left: 4,right: 4),
                height: 60,
                width: MediaQuery.of(context).size.width,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: RaisedButton(
                    color: Colors.teal.shade800,
                    onPressed: (){
                      getCurrentLocation().then((result){
                        _navigateAndDisplaySelection(context,result).
                        then((finalResult){
                          setState(() {
                            widget.longitude = finalResult["longitude"];
                            widget.latitude = finalResult["latitude"];
                          });
                        });
                      });
                    },
                    child: Text("تحديد الموقع علي الخريطه", style:
                    TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12,),
              Container(
                padding: EdgeInsets.only(left: 4,right: 4),
                height: 60,
                width: MediaQuery.of(context).size.width,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: RaisedButton(
                    color: Colors.teal.shade800,
                    onPressed: getCurrentLocation,
                    child: Text("موقعي الحالي", style:
                    TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12,),
              Container(
                padding: EdgeInsets.only(left: 4,right: 4),
                height: 60,
                width: MediaQuery.of(context).size.width,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: RaisedButton(
                    color: Colors.teal.shade800,
                    onPressed: getDefaultLocation,
                    child: Text("اختيار الموقع الاساسي", style:
                    TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.only(left: 22),
                child: Text("latitude   : ${widget.latitude}"),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 22),
                child: Text("longitude: ${widget.longitude}"),
              ),
              SizedBox(height: 12,),

              fieldInput(
                enable: true,
                controller: descriptionController,
                obscure: false,
                hint: "وصف العنوان",
                myIcon: Icon(Icons.description,color: Colors.grey,),
                textInputType: TextInputType.text,
              ),
              fieldInput(
                enable: true,
                controller: phoneController,
                obscure: false,
                hint: "رقم الهاتف",
                myIcon: Icon(Icons.phone,color: Colors.grey,),
                textInputType: TextInputType.phone,
              ),
              SizedBox(height: 20,),
              Container(
                padding: EdgeInsets.only(left: 4,right: 4),
                height: 60,
                width: MediaQuery.of(context).size.width,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: RaisedButton(
                    color: Colors.teal.shade800,
                    onPressed: (){
                      if(widget.longitude!=0.0&&widget.latitude!=0.0){
                        getNearestPharmacy().whenComplete((){
                          makeTheOrder();
                        });

                      }else{
                        setState(() {
                          stateData = "incorrect data, please fill with true data";
                        });
                      }
                    },
                    child: Text("اطلب", style:
                    TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

