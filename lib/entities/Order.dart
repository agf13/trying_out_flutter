

// enum Status{
//   recorded,
//   preparing,
//   ready,
//   canceled
// }
//
// enum Type{
//   normal,
//   delivery
// }


import 'package:flutter/material.dart';

class Order{
  Order({this.id = -1, this.table, this.details, this.status, this.preparationTime, this.type});

  int id = -1;

  String table;
  String details;
  String status;
  DateTime preparationTime;
  String type;



  void setAll(String table, String details, String status, String preparationTime, String type){
    setTable(table);
    setDetails(details);
    setStatus(status);
    setPreparationTime(convertStringToDateTime(preparationTime));
    setType(type);
  }

  String defaultTable(){ this.table = "(not given)"; }
  String defaultDetails() { this.details = "(none)"; }
  String defaultStatus() { this.status = ""; }
  DateTime defaultPreparationTime(){ this.preparationTime = DateTime(0,0,0,30);/*30 min*/ }
  String defaultType() {  this.type = "normal"; }

  int getId() { return this.id; }
  String getTable(){ return this.table; }
  String getDetails() { return this.details; }
  String getStatus() { return this.status; }
  DateTime getPreparationTime() { return this.preparationTime; }
  String getType() { return this.type; }

  void setId(int newId){
    //only set the id if it was not setted before
    if(this.id == null || this.id == -1){
      if(newId != null && newId > 0) {
        this.id = newId;
      }
    }
  }

  void setTable(String tableName){
    if(tableName != null){
      this.table = tableName;
    }
    else {
      this.table = defaultTable();
    }
  }

  void setDetails(String newDetails){
    if(newDetails != null){
      this.details = newDetails;
    }
    else {
      this.details = defaultDetails();
    }
  }

  void setStatus(String newStatus) {
    if (newStatus != null) {
      this.status = newStatus;
    }
    else {
      this.status = defaultStatus();
    }
  }

  void setPreparationTime(DateTime newDateTime){
    if(newDateTime != null){
      this.preparationTime = newDateTime;
    }
    else{
      this.preparationTime = defaultPreparationTime();
    }
  }
  void serPreparationTimeFromValues({int hours = 0, int minutes = 0}){
    if(hours == 0 && minutes == 0){
      this.preparationTime = defaultPreparationTime();
    }
    else{
      this.preparationTime = DateTime(0,0, hours, minutes);
    }
  }

  void setType(String commandType){
    if(commandType != null){
      this.type = commandType;
    }
    else{
      this.type = defaultType();
    }
  }



  Map<String, dynamic> toMap(){
    return{
      'orderId': this.id,
      'tableName': this.table,
      'details': this.details,
      'status': this.status,
      'time': convertTimeToString(this.preparationTime),
      'type': this.type
    };
  }

  Order fromJson(Map<dynamic, dynamic> json){
    //convertTimeToString(dt);
    return Order(
      id: json['orderId'],
      table: json['tableName'],
      details: json['details'],
      status: json['status'],
      preparationTime: convertStringToDateTime(json['time']),
      type: json['type']
    );
  }

  String convertTimeToString(DateTime dt){
    String output = dt.hour.toString() + " " + dt.minute.toString();
    return output;
  }

  DateTime convertStringToDateTime(String str){
    List<String> args = str.split(" ");
    int hours = int.parse(args[0]);
    int minutes = int.parse(args[1]);
    return DateTime(0,0,0,hours, minutes);
  }

  int getHours(){ return this.preparationTime.hour; }
  int getMinutes(){ return this.preparationTime.minute; }


  @override
  String toString() {
    return 'Order{id: $id, table: $table, details: $details, status: $status, preparationTime: $preparationTime, type: $type}';
  }
}