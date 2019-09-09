import 'package:flutter/material.dart';
import './itemShoppingDesign.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './showImageHelper.dart';
import './ShoppingNextPage.dart';

class ShoppingCart extends StatefulWidget {
  @override
  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {


  List dataFromApi;
  List orderMed = [];
  List orderPAndC = [];
  double totalPrice = 0;

  Widget buildGridView(List images) {

    return ListView.builder(
      itemCount: images.length,
      scrollDirection: Axis.horizontal,
      itemBuilder:(BuildContext context , int i){
        return Container(
          width: MediaQuery.of(context).size.width/5,
          height: MediaQuery.of(context).size.width/5,
          padding: EdgeInsets.all(2),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: Container(
              decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
              child: Image(
                  image: NetworkImage(getUrl("/images/${images[i]}"),scale: 1),
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildGridViewText(List items,List images) {

    if(images.length>0){
      return ListView.builder(
          itemCount: items.length,
          scrollDirection: Axis.horizontal,
          itemBuilder:(BuildContext context , int i){
            return Padding(
              padding: const EdgeInsets.only(left: 4,right: 4),
              child: Chip(label: Text(items[i]),
                elevation: 5,padding: EdgeInsets.all(2),),
            );
          }
      );
    }else{
      List<Padding> myChips = [];
      for(var item in items){
        myChips.add(
            Padding(
              padding: const EdgeInsets.only(left: 4,right: 4),
              child: Chip(label: Text(item),elevation: 5,padding: EdgeInsets.all(2),),
            )
        );
      }
      return Wrap(
        spacing: 0,runSpacing: 0,
        children: myChips,
      );
    }
  }


  Future getData()async{
    setState(() {
      dataFromApi = null;
      orderMed.clear();
      orderPAndC.clear();
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    try{
      var response = await http.get(
          getUrl("/api/getproduct"),
          headers: {
            "Accept" : "application/json",
            "Authorization" : "Bearer $token"
          }
      );
      setState(() {
        dataFromApi = jsonDecode(response.body)["cart"];
        totalPrice = jsonDecode(response.body)["price"].toDouble();
      });

      print(response.body);
      if(response.statusCode == 200 || response.statusCode == 201){
        for(int i=0 ;i<dataFromApi.length;i++){
          if(dataFromApi[i]["type"]=="med"){
            setState(() {
              orderMed.add(dataFromApi[i]);
            });

          }else if(dataFromApi[i]["type"]=="package" ||
              dataFromApi[i]["type"]=="cosmetic"){
            setState(() {
              orderPAndC.add(dataFromApi[i]);
            });

          }
        }
      }
      print("med length = :"+orderMed.length.toString());
      print("pac length = :"+orderPAndC.length.toString());
    }catch(e){print(e.toString());}
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  Future deleteItem(var id)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    try{
      var response = await http.post(
          getUrl("/api/deleteproduct"),
          body: {
            "id":"$id"
          },
          headers: {
            "Accept" : "application/json",
            "Authorization" : "Bearer $token"
          }
      );
      if(jsonDecode(response.body)["msg"].toString()=="product deleted"){
        return true;
      }
      print("delete item: "+response.body);
    }catch(e){}
    return false;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,size: 30,color: Colors.black,),
          onPressed: ()=>Navigator.pop(context),
        ),
        title: Container(
          alignment: Alignment.centerRight,
          child: Text("عربة التسوق",style: TextStyle(
              color: Colors.teal.shade600,fontSize: 16,fontWeight: FontWeight.w700
          ),textAlign: TextAlign.right,),
        ), //centerTitle: true,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.grey.shade200,

        child: Center(
          child: dataFromApi==null?CircularProgressIndicator():ListView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(6),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: MediaQuery.of(context).size.width,
                    childAspectRatio: 7/5,
                  ),
                  padding: const EdgeInsets.all(5.0),
                  itemCount:orderMed.length,
                  itemBuilder: (BuildContext context , int i){
                    return Container(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text("ادوية مطلوبة",style: TextStyle(
                                  color: Colors.teal,fontWeight: FontWeight.w700,
                                  fontSize: 16),),
                              ),


                              orderMed[i]["image"]!=null?
                              orderMed[i]["image"].length!=0?Container(
                                padding:EdgeInsets.all(4),
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.width/5,
                                child: buildGridView(
                                    jsonDecode(orderMed[i]["image"]))
                              ):SizedBox(height: 2,):SizedBox(height: 2,),


                              Expanded(
                                child: orderMed[i]["data"]!=null?
                                orderMed[i]["data"].length!=0?Container(
                                    padding:EdgeInsets.all(2),
                                    width: MediaQuery.of(context).size.width,
                                    child: buildGridViewText(
                                        jsonDecode(orderMed[i]["data"]),
                                        orderMed[i]["image"]
                                            ==null?[]:jsonDecode(
                                            orderMed[i]["image"]))
                                ):SizedBox(height: 2,):SizedBox(height: 2,),
                              ),

                              Container(
                                height: 60,
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.all(4),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(5),
                                          child: RaisedButton(
                                            color: Colors.red.shade900,
                                            padding: EdgeInsets.all(8),
                                            onPressed: (){
                                              deleteItem(orderMed[i]["id"]).then((value){
                                                getData();
                                              });
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(2.0),
                                              child: Text("حذف",style: TextStyle(
                                                  color: Colors.white,fontWeight: FontWeight.w700,fontSize: 16),),
                                            ),
                                          ),
                                        ),
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
                  },
                ),
              ),
              Container(
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: MediaQuery.of(context).size.width,
                    childAspectRatio: 3/1,
                  ),
                  padding: const EdgeInsets.all(5.0),
                  itemCount:orderPAndC.length,
                  itemBuilder: (BuildContext context , int i){
                    return orderPAndC[i]!=null?ItemDesign(
                      counter: orderPAndC[i]["count"],
                      productId: orderPAndC[i]["id"],
                      title: orderPAndC[i]["data"].toString(),
                      subtitle: "no details",
                      priceItem: orderPAndC[i]["price"].toString(),
                      imageUrl: getUrl("/images/${orderPAndC[i]["image"]}"),
                      deleteFunction: (){
                        deleteItem(orderPAndC[i]["id"]).then((value){
                          getData();
                        });
                      },
                    ):SizedBox(height: 1,);
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text("$totalPrice",style: TextStyle(
                        fontSize: 20,color: Colors.teal),
                    ),
                    Text(" اجمالي الاسعار ",style: TextStyle(
                        fontSize: 20,color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("ملاحظه : اجمالي الاسعار لا يشمل اسعار الادويه المطلوبة",
                  style: TextStyle(
                    fontSize: 16,color: Colors.red.shade300),textAlign: TextAlign.center,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(8),
                child: RaisedButton(
                  padding:EdgeInsets.all(8),
                  onPressed: (){
                    Navigator.push(context,
                    MaterialPageRoute(builder: (context)=> ShoppingNextPage()));
                  },
                  child: Text("التالي",style: TextStyle(fontSize: 20,
                      color: Colors.white,fontWeight:FontWeight.w700 ),
                    textAlign: TextAlign.center,),
                  color: Colors.teal.shade700,
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}
