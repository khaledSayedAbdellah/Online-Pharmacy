import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_pharmacy/RegistrationAndLogIn/InputDesign.dart';
import './API.dart';
import 'package:location/location.dart';
import 'package:online_pharmacy/GetLocation/ShowMap.dart';

class SecondPage extends StatefulWidget {

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController sex = TextEditingController();
  TextEditingController birthDate = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confPassword = TextEditingController();
  List<String> infoItems= [];
  String image;
  SecondPage({this.email,this.name,this.phone,this.sex,this.birthDate,
    this.password,this.confPassword,this.infoItems,this.image});
  @override
  _SecondPageState createState() => _SecondPageState();
}
class _SecondPageState extends State<SecondPage> {

  double latitude=0.0;
  double longitude=0.0;


  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  LocationData  currentLocation;
  var location = new Location();

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
        latitude = currentLocation.latitude;
        longitude = currentLocation.longitude;
      });
    }catch (e) {
      currentLocation = null;
    }
    return result;
  }
  TextEditingController description = new TextEditingController();

  Future<Map<String,double>> _navigateAndDisplaySelection(
      BuildContext context,Map result) async {
    final getFromMap = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>
          ShowMap(result["longitude"],result["latitude"])),
    );
    return getFromMap;
  }

  String message = "";
  Container myContainer = new Container();
  showContainer(bool state){
    if(state){
      setState(() {
        myContainer = Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.black54,
          child: Center(
            child: Container(
                width: 50,
                height: 50,
                child: CircularProgressIndicator()
            ),
          ),
        );
      });
    }else{
      setState(() {
        myContainer = new Container();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      resizeToAvoidBottomPadding: true,
      key: _scaffoldKey,
      body: Stack(
        children: <Widget>[
          Container(
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
                                longitude = finalResult["longitude"];
                                latitude = finalResult["latitude"];
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
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.only(left: 22),
                    child: Text("latitude   : $latitude"),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 22),
                    child: Text("longitude: $longitude"),
                  ),
                  SizedBox(height: 12,),

                  fieldInput(
                    enable: true,
                    controller: description,
                    obscure: false,
                    hint: "وصف العنوان",
                    myIcon: Icon(Icons.description,color: Colors.grey,),
                    textInputType: TextInputType.text,
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

                          if(longitude==0.0){
                            setState(() {message = "يرجي تحديد موقعك";});
                          }else{
                            if(description.text.length<10){
                              setState(() {message = "يرجي كتابه عنوانك بالتفصيل";});
                            }else{
                              showContainer(true);

                              registrationRequest(
                                  lat: longitude,
                                  lng: longitude,
                                  email: widget.email.text.toString(),
                                  name: widget.name.text.toString(),
                                  password: widget.password.text.toString(),
                                  conPassword: widget.confPassword.text.toString(),
                                  dOfB: widget.birthDate.text.toString(),
                                  gender: widget.sex.text.toString(),
                                  phone: widget.phone.text.toString(),
                                  photo: "defaultImage.png",
                                  address: description.text.toString(),
                                  disease: widget.infoItems,
                                  callBack: (){
                                    Navigator.of(context).pushNamedAndRemoveUntil('/logIn',
                                            (Route<dynamic> route) => false);
                                  },
                                  rejectCallBack: (){
                                    showContainer(false);

                                    setState(() {
                                      message = "خطأ في التسجيل يرجي المحاوله مره اخري والتأكد من صحة البيانات";
                                    });
                                  }
                              );
                            }
                          }
                        },
                        child: Text("تسجيل", style:
                        TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                  message.length>0?Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Card(
                        color: Colors.grey.shade200,
                        child:Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(message,style: TextStyle(
                              fontSize: 18,color: Colors.redAccent),
                            textAlign: TextAlign.center,),
                        ),
                      ),
                    ),
                  ):SizedBox(height: 1,),

                ],
              ),
            ),
          ),
          myContainer,
        ],

      ),
    );
  }
}

