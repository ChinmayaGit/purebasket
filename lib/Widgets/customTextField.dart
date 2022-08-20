import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget
{
  final TextEditingController controller;
  final IconData ico;
//  final IconData subIcon;
  final String hintText;
  bool isObsecure = true;



  CustomTextField(
  {Key key, this.controller, this.ico, this.hintText,this.isObsecure,
//    this.subIcon
  }
      ) : super(key: key);



  @override
  Widget build(BuildContext context)
  {
    return Container
    (
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.all(10.0),
      child: TextFormField(
        controller: controller,
        obscureText: isObsecure,
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(ico,color: Theme.of(context).primaryColor,),
          focusColor: Theme.of(context).primaryColor,
          hintText: hintText,
//          suffixIcon: IconButton(icon: Icon(subIcon,color: Theme.of(context).primaryColor,), onPressed: (){
//
//          })
        ),
      ),
    );
  }
}
