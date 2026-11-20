

import 'package:flutter/material.dart';

class MyColor{
  final Color color;
  final String name;

  var _v1;

  dynamic get v1 => _v1;
  set v2(dynamic value) => _v1 = value;


  //Constructor
  MyColor(this.color, {this.name = "Enamul"});
  //Here color is positional and name is named parameter

  //Factory constructor
  MyColor.red(): color = Colors.red, name = "Enamul";

  var names = ["nemaul", "enamul", "haque"];

  var collegeMap = {"name": "Enamul", "age": 25};

  var schooleSet = {1,2,3,4,3};

  List<String> calculate(){
    //return names.map((name) => name.toUpperCase()).toList();
    var reslut = [...names, "suraiy"];

    //getter setter
    v2 = v1;

    final list = [1,2,3,4,5];
    list.add(6); //[1,2,3,4,5,6]//no error
    const list2 = [1,2,3,4,5];
   // list2.add(6); //[1,2,3,4,5]//runtime error

    if(_v1 == v1){

    }

    _v1 ??= "Enamul";

    //String extension
    String res = "";
    res.emailValidation("condition");


    return reslut;
  }
}

enum Resout{
  Success,
  Failed,
  Error
}

extension StringExtension on String{
  bool emailValidation(String condition){
    return this.isEmpty;
  }
}

String getRes(Resout res){


  return switch (res) {
    Resout.Success => "Success",
    Resout.Failed => "Failed",
    Resout.Error => "Error"
  };
}