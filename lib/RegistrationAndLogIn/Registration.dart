import 'dart:io';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_pharmacy/RegistrationAndLogIn/InputDesign.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import './RegistrationSecondPage.dart';

class Registration extends StatefulWidget {

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController sex = TextEditingController();
  TextEditingController birthDate = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confPassword = TextEditingController();
  TextEditingController addInfo = TextEditingController();

  List<String> infoItems= [];

  String message = "";
  addItemToInfo(){
    setState(() {
      infoItems.add(addInfo.text);
    });
  }
  getCards(){
    List<Card> myCards = [];
    for(int i=0; i<infoItems.length;i++){
      myCards.add(
        Card(
          child: Chip(
            deleteIconColor: Colors.red.shade900,
            backgroundColor: Colors.white,
            padding: EdgeInsets.all(8),
            label: Text(infoItems[i]),
            onDeleted: (){
              setState(() {
                infoItems.removeAt(i);
              });
            },
          ),
        )
      );
    }
    return myCards;
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance = ScreenUtil(
      width: 750,
      height: 1334,
      allowFontScaling: true,
    );
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey.shade300,
      resizeToAvoidBottomPadding: true,
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(8),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 30),
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Container(
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(),
                            ),
                            child: Image(
                              image: AssetImage("images/user.png"),
                              width:85,height:85,),
                          ),
                        )
                      ),
                    ),
                    Container(
                      child: RaisedButton(
                        shape: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade700)
                        ),
                        onPressed: (){},
                        child: Text("اضف صورة شخصية",
                          style: TextStyle(fontWeight: FontWeight.w700),),
                      ),

                    ),

                    SizedBox(height: 16,),


                    fieldInput(
                      controller: name,
                      hint: "الاسم",
                      obscure: false,
                      myIcon: Icon(Icons.person,color: Colors.grey,),
                      textInputType: TextInputType.text,
                    ),
                    fieldInput(
                      controller: email,
                      obscure: false,
                      hint: "البريد الالكتروني",
                      myIcon: Icon(Icons.mail_outline,color: Colors.grey,),
                      textInputType: TextInputType.emailAddress,
                    ),
                    fieldInput(
                      controller: phone,
                      obscure: false,
                      hint: "رقم الموبايل",
                      myIcon: Icon(Icons.phone,color: Colors.grey,),
                      textInputType: TextInputType.phone,
                    ),
                    fieldInput(
                      controller: sex,
                      obscure: false,
                      hint: "النوع",
                      myIcon: Icon(Icons.keyboard_arrow_down,color: Colors.grey,),
                      textInputType: TextInputType.url,
                    ),
                    InkWell(
                      onTap: (){
                        {
                          DatePicker.showDatePicker(
                            context,
                            showTitleActions: true,
                            minTime: DateTime(1950, 3, 5),
                            maxTime: DateTime.now().subtract(Duration(days: 365*18)),
                            onChanged: (date) {
                              setState(() {
                                birthDate.value = TextEditingValue(
                                    text: "${date.toString().substring(0,10)}");
                              });
                              print('change $date');
                            },
                            onConfirm: (date) {
                              print("${date.toString().substring(0,10)}");
                            },
                            currentTime: DateTime.now(), locale: LocaleType.en,
                          );
                          print("work");
                        }
                      },
                      child: fieldInput(
                        enable: false,
                        controller: birthDate,
                        obscure: false,
                        hint: "تاريخ الميلاد",
                        myIcon: Icon(Icons.date_range,color: Colors.grey,),
                        textInputType: TextInputType.text,
                      ),
                    ),
                    fieldInput(
                      hint: "كلمه السر",
                      obscure: true,
                      controller: password,
                      myIcon: Icon(Icons.lock_open,color: Colors.grey,),
                    ),
                    fieldInput(
                      hint: "تأكيد كلمه السر",
                      obscure: true,
                      controller: confPassword,
                      myIcon: Icon(Icons.lock_open,color: Colors.grey,),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(top: 14,right: 8,bottom: 4),
                      child: Text("هل تعاني من اي امراض مزمنة؟",),
                    ),
                    fieldInput(
                      hint: "اضف",
                      obscure: false,
                      controller: addInfo,
                      myIcon: Icon(Icons.add,color: Colors.grey,),
                      iconOnPressed: addItemToInfo,
                    ),
                    SizedBox(height: 12,),
                    Container(
                      alignment: Alignment.centerRight,
                      child: Wrap(
                        children: getCards(),
                        direction: Axis.horizontal,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        textDirection: TextDirection.rtl,
                        alignment: WrapAlignment.start,
                        runAlignment: WrapAlignment.start,

                      ),
                    ),
                    SizedBox(height: 22,),
                    Container(
                      padding: EdgeInsets.only(left: 4,right: 4),
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: RaisedButton(
                          color: Colors.teal.shade800,
                          onPressed: (){
                            if(name.text.isEmpty){
                              setState(() {message = "يرجي ادخال الاسم";});
                            }else{
                              if(email.text.isEmpty || !(email.text.contains("@"))
                              || !(email.text.contains(".com"))){
                                setState(() {message = "يرجي ادخال بريد الكتروني صحيح";});
                              }else{
                                if(phone.text.isEmpty || phone.text.length!=11){
                                  setState(() {message = "برجاء ادخار رقم هاتف صحيح";});
                                }else{
                                  if(sex.text.isEmpty ||
                                      (sex.text.toLowerCase()!="male" &&
                                          sex.text.toLowerCase()!="female")){
                                    setState(() {message = "برجاء تحديد الجنس";});
                                  }else{
                                    if(birthDate.text.isEmpty){
                                      setState(() {message = "يرجي ادخال تاريخ الميلاد";});
                                    }else{
                                      if(password.text.isEmpty){
                                        setState(() {message = "يرجي ادخال كلمة السر";});
                                      }else{
                                        if(confPassword.text.isEmpty){
                                          setState(() {message = "يرجي ادخال تأكيد كلمة السر";});
                                        }else{
                                          if(confPassword.text!=password.text){
                                            setState(() {message = "كلمه السر غير متطابقة";});
                                          }else{
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context)=> SecondPage(
                                                      email: email,
                                                      name: name,
                                                      password: password,
                                                      confPassword: confPassword,
                                                      birthDate: birthDate,
                                                      sex: sex,
                                                      phone: phone,
                                                      image: "defaul image",
                                                      infoItems: infoItems,
                                                    )
                                                )
                                            );
                                          }
                                        }
                                      }
                                    }
                                  }
                                }
                              }
                            }
                          },
                          child: Text("التالي", style:
                          TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                    ),

                    message.length>0?Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: Colors.grey.shade200,
                        child:Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(message,style: TextStyle(
                              fontSize: 18,color: Colors.redAccent),
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,),
                        ),
                      ),
                    ):SizedBox(height: 1,),

                    Container(
                      child: Center(
                        child: InkWell(
                          onTap: ()=>Navigator.pop(context),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text("رجوع",style: TextStyle(
                              fontSize: 18,color: Colors.teal.shade800,fontWeight: FontWeight.w700
                            ),),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

