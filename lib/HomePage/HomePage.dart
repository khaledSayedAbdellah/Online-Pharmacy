import 'package:flutter/material.dart';
import './Cosmetics.dart';
import 'package:carousel_pro/carousel_pro.dart';
import './Package.dart';
import '../AskForMedicines/AskForMedicines.dart';
import '../Drawer/DrawerPage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import '../main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List packages = [];
  List<NetworkImage> topImages = [];

  List topImagesFromApi;
  List packagesFromApi;

  Future getMyTopImages()async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    try{
      var response = await http.get(
          getUrl("/api/acceptedads"),
          headers: {
            "Accept" : "application/json",
            "Authorization" : "Bearer $token"
          }
      );
      topImagesFromApi = jsonDecode(response.body);
      for(var item in topImagesFromApi){
        setState(() {
          topImages.add(
              NetworkImage(getUrl("/images/${item["image"]}"),scale: 1)
          );
        });
      }
    }catch(e){}
  }
  Future getMyPackages()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    try{
      var response = await http.get(
          getUrl("/api/getpackages"),
          headers: {
            "Accept" : "application/json",
            "Authorization" : "Bearer $token"
          }
      );
      packagesFromApi = jsonDecode(response.body);
      for(var item in packagesFromApi){
        setState(() {
          packages.add({'image': item["image"], 'id': item["id"]});
        });
      }
    }catch(e){}
  }
  @override
  void initState() {
    super.initState();
    getMyTopImages();
    getMyPackages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: DrawerPage(),
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Icon(Icons.local_grocery_store,size: 30,color: Colors.teal),
            SizedBox(width: 8,),
            Text("Pharmacy",style: TextStyle(color: Colors.grey.shade700),),
          ],
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.menu,size: 30,color: Colors.teal,),
          onPressed: ()=> _scaffoldKey.currentState.openDrawer(),
        ),
        backgroundColor: Colors.grey.shade100,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.grey.shade100,
          child: Column(
            children: <Widget>[
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(bottom:4,top:8,left:8,right:8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 150.0,
                      child: topImages.length!=0?Carousel(
                        boxFit: BoxFit.cover,
                        autoplayDuration: Duration(seconds: 10),
                        autoplay: true,
                        animationCurve: Curves.fastOutSlowIn,
                        animationDuration: Duration(milliseconds: 1000),
                        showIndicator: false,
                        images: topImages,
                        overlayShadow: true,
                        overlayShadowSize: 0.4,
                        overlayShadowColors: Colors.grey.shade300,
                      ):Image(image: AssetImage("images/loading.gif"),
                        width: MediaQuery.of(context).size.width,),
                    ),
                  ),
                ),
              ),

              Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: InkWell(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context)=>AskMedicines())
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.teal.shade700,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top:8.0,bottom: 8.0,
                          left: 12.0,right: 12.0),
                          child: Row(
                            children: <Widget>[
                              Container(
                                child: Icon(Icons.photo_camera,
                                  size: 35,color: Colors.white,),
                              ),
                              Expanded(child: SizedBox()),
                              Text("اطلب ادوية",style: TextStyle(fontSize: 20,
                                  color: Colors.white,fontWeight:FontWeight.w700 ),),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 4,right: 10),
                      child: Text("مستحضرات تجميل",style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,color: Colors.grey.shade700,
                      ),),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 6,right: 6),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Cosmetics(
                              title: "عناية شخصية",
                              image: "images/product.png",
                              function: ()=>itemCareClicked(context),
                            ),
                          ),
                          Expanded(
                            child: Cosmetics(
                              title: "اطفال",
                              image: "images/child.png",
                              function: ()=>childClicked(context),
                            ),
                          ),
                          Expanded(
                            child: Cosmetics(
                              title: "سيدات",
                              image: "images/female.png",
                              function: ()=>femaleClicked(context),
                            ),
                          ),
                          Expanded(
                            child: Cosmetics(
                              title: "رجالي",
                              image: "images/male.png",
                              function: ()=>maleClicked(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16,),
              Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4,right: 10),
                        child: Text("باكدج",style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,color: Colors.grey.shade700,
                        ),textAlign: TextAlign.right,),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(8),
                      child: PackagePage(
                        packages: packages,
                        context: context,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
