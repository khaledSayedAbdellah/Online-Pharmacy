import 'package:flutter/material.dart';
import '../ShoppingCart/ShoppingCart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './SendComplaints.dart';
import 'dart:async';
import '../main.dart';

class DrawerPage extends StatefulWidget {

  @override
  _DrawerPageState createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {

  String userName="name";
  String imageUrl;

  Future setData()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('name');
      prefs.getString('photo')!=null?
      imageUrl = getUrl("/images/${prefs.getString('photo')}"):imageUrl=null;
    });
  }

  @override
  void initState() {
    super.initState();
    setData();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          new DrawerHeader(
            decoration: BoxDecoration(
                //color: Colors.grey.shade300,
                color: Colors.teal.shade100,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(50.0),
                    bottomLeft: Radius.circular(50.0))),
            child: Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  InkWell(
                    child: Row(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          width: 85.0,
                          height: 85.0,
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(),
                            image: imageUrl==null?DecorationImage(image: AssetImage("images/user.png")):
                            new DecorationImage(
                              fit: BoxFit.cover,
                              image:NetworkImage(imageUrl),
                            ),
                          ),
                        ),
                      ],
                    ),
                    onTap: (){}
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 1),
                        child: new Row(
                          children: <Widget>[
                            Text("$userName",style: TextStyle(fontSize: 15),)
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: RaisedButton(
                            elevation: 5.0,
                            color: Colors.white,
                            onPressed: (){},
                            child: Text("تغيير البيانات",style: TextStyle(fontSize: 15),),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.push(context,
                MaterialPageRoute(builder: (context)=> ShoppingCart())
              );
            },
            leading: new Icon(Icons.shopping_cart,color: Colors.teal,),
            title: Text("عربة التسوق",
                style: TextStyle(fontSize: 18.0,color: Colors.teal.shade700)),
          ),
          ListTile(
            enabled: false,
            onTap: () {},
            leading: new Icon(Icons.notifications,color: Colors.teal,),
            title: Text("المنبه",
                style: TextStyle(fontSize: 18.0,color: Colors.teal.shade700)),
          ),
          ListTile(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context)=>
                        SendComplaints(title: "نصائح",)));
              },
              leading: new Icon(Icons.help,color: Colors.teal,),
              title: Text("نصائح",
                  style: TextStyle(fontSize: 18.0,color: Colors.teal.shade700)),
              ),
          ListTile(
            onTap: () {
              Navigator.push(context,
              MaterialPageRoute(builder: (context)=>
                  SendComplaints(title: "الشكاوي",)));
            },
            leading: new Icon(Icons.message,color: Colors.teal,),
            title: Text("شكاوي",
                style: TextStyle(fontSize: 18.0,color: Colors.teal.shade700)),
          ),
          ListTile(
            onTap: () {},
            leading: new Icon(Icons.contacts,color: Colors.teal,),
            title: Text("About Us",
                style: TextStyle(fontSize: 18.0,color: Colors.teal.shade300)),
          ),
          ListTile(
              onTap:()=>logOut(context),
              leading: new Icon(Icons.exit_to_app,color: Colors.pink.shade900,),
              title: Text("تسجيل الخروج", style: TextStyle(fontSize: 18.0,color: Colors.red.shade900)),
          ),
        ],
      ),
    );
  }

  Future logOut(BuildContext context)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.of(context).pushNamedAndRemoveUntil('/logIn',
            (Route<dynamic> route) => false);
  }
}
