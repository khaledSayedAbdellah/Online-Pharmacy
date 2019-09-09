import 'package:flutter/material.dart';

import 'package:online_pharmacy/cosmeticsShop/MainPages/PersonalCare.dart';
import 'package:online_pharmacy/cosmeticsShop/MainPages/Women.dart';
import 'package:online_pharmacy/cosmeticsShop/MainPages/Men.dart';
import 'package:online_pharmacy/cosmeticsShop/MainPages/Children.dart';

class Cosmetics extends StatelessWidget {

  String title;
  String image;
  Function function;

  Cosmetics({this.title,this.image,this.function});

  @override
  Widget build(BuildContext context) {
    return  Container(
      child: InkWell(
        onTap: function,
        child: Column(
          children: <Widget>[
            Container(
              height: 120,
              width: 100,
              child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image(image: AssetImage(image),
                      color: Colors.grey.shade700,),
                  )
              ),
            ),
            Text(title,style: TextStyle(fontSize: 14,
                color: Colors.grey.shade700),)
          ],
        ),
      ),
    );
  }
}

maleClicked(BuildContext context){
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context)=> Men()),
  );
}

femaleClicked(BuildContext context){
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context)=> Women()),
  );
}

childClicked(BuildContext context){
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context)=> Children()),
  );
}

itemCareClicked(BuildContext context){
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context)=> PersonalCare()),
  );
}
