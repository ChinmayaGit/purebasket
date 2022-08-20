import 'package:flutter/foundation.dart';
import 'package:purebasket/Config/config.dart';

class CartItemCounter extends ChangeNotifier{
  int _counter=EApp.sharedPreferences.getStringList(EApp.userCartList).length-1;
  int get count=>_counter;

  Future<void>displayResult()async{
    int _counter = EApp.sharedPreferences.getStringList(EApp.userCartList).length-1;
    await Future.delayed(const Duration(milliseconds: 100),(){
      notifyListeners();
    });
  }

}