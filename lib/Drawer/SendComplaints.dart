import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import '../main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../RegistrationAndLogIn/InputDesign.dart';

class SendComplaints extends StatefulWidget {

  String title;
  SendComplaints({this.title});

  @override
  _SendComplaintsState createState() => _SendComplaintsState();
}

class _SendComplaintsState extends State<SendComplaints> {

  Container myContainer = new Container();
  String message = "";
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

  TextEditingController titleController = TextEditingController();

  TextEditingController compController = TextEditingController();

  Future sendComplaint()async {
    showContainer(true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    try{
      var response = await http.post(
          getUrl("/api/addcomplaint"),
          body: {
            'title' : titleController.text.toString(),
            'body' : compController.text.toString(),
          },
          headers: {
            "Accept" : "application/json",
            "Authorization" : "Bearer $token"
          }
      );
      if(response.statusCode == 200 || response.statusCode == 201){
        Navigator.pop(context);
        Navigator.pop(context);
      }else{
        showContainer(false);
        setState(() {
          message = "يرجي التأكد من صحة البيانات والمحاوله مره اخري";
        });
      }
      print(response.body);
    }catch(e){}
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          backgroundColor: Colors.grey.shade200,
          appBar: AppBar(
            title: Text(widget.title,style: TextStyle(color: Colors.teal),),
            centerTitle: true,
            backgroundColor: Colors.grey.shade100,
            leading: IconButton(
              icon: Icon(Icons.arrow_back,size: 30,color: Colors.teal,),
              onPressed: (){
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(6),
              color: Colors.grey.shade200,
              child: Column(
                children: <Widget>[

                  SizedBox(height: 20,),
                  fieldInput(
                    controller: titleController,
                    obscure: false,
                    hint: "العنوان",
                    myIcon: Icon(Icons.title,color: Colors.grey,),
                    textInputType: TextInputType.text,
                  ),
                  SizedBox(height: 16,),

                  Container(
                    padding: const EdgeInsets.all(4.0),
                    child: TextFormField(
                      controller: compController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: Colors.grey.shade300)
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: Colors.grey.shade300)
                        ),
                        hintText: "اكتب المحتوي",
                        enabled: true,
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      textCapitalization: TextCapitalization.words,
                      maxLines: 10,
                      keyboardType: TextInputType.text,
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),

                  SizedBox(height: 16,),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 65,
                    padding: EdgeInsets.only(top: 10,left: 2,right: 2),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: RaisedButton(
                        color: Colors.teal.shade700,
                        padding: EdgeInsets.all(8),
                        onPressed: (){
                          if(titleController.text.isEmpty){
                            setState(() {message = "يرجي كتابة العنوان";});
                          }else{
                            if(compController.text.length<10){
                              setState(() {message = "يرجي كتابة المحتوي";});
                            }else{
                              sendComplaint();
                            }
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text("ارسال",style: TextStyle(
                              color: Colors.white,fontWeight: FontWeight.w700,fontSize: 16),),
                        ),
                      ),
                    ),
                  ),
                  message.length>0?Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: Colors.white,
                      child:Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(message,style: TextStyle(
                            fontSize: 18,color: Colors.redAccent),
                            textAlign: TextAlign.center),
                      ),
                    ),
                  ):SizedBox(height: 1,),
                ],
              ),
            ),
          ),
        ),
        myContainer,
      ],
    );
  }
}
