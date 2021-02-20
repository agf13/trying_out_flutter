
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mockup_1/widgets/OrderItemWidget.dart';
import 'package:mockup_1/widgets/OrderWidget.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:connectivity/connectivity.dart';
import 'package:web_socket_channel/io.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sql.dart';


import 'package:mockup_1/entities/Order.dart';



class OrdersListScreen extends StatefulWidget{

  OrdersListScreen({Key key, this.database}): super(key: key);

  final Future<Database> database;
  // final Database database;

  @override
  State<StatefulWidget> createState() {
    print("OrdersListScreen::database:"+this.database.toString());
    return _OrdersListScreenState();
  }

}

class _OrdersListScreenState extends State<OrdersListScreen>{

  Future<List<Order>> _listOrders;
  Scaffold currentScaffold;

  @override
  void initState(){
    _listOrders = getOrders_local();
  }

  @override
  Widget build(BuildContext context) {
    Scaffold scf = Scaffold(
      appBar: AppBar(
        title: Text(
          "Orders",
        ),
        actions: [
          FlatButton(
            child: Text("Filter"),
            onPressed: (){
              showSnack();
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _listOrders,
        builder: (BuildContext context,
            AsyncSnapshot<List<Order>> snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState != ConnectionState.waiting) {
            return ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                print("FutureBuilder:: databasse:" + widget.database.toString());
                return OrderItemWidget(
                  order: snapshot.data[index],
                  database: widget.database,
                  addOrder: addOrder_local,
                  // updateOrder: this.editMission,
                  // deleteOrder: this.deleteMission,
                );
              },
            );
          }
          else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        }
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context){
                  print("FAB::database:"+widget.database.toString());
                  return OrderWidget(
                    database: widget.database,
                    addOrder: addOrder_local,
                    // updateOrder: updateOrder,
                  );
                },
            ),
          );
        },
      ),
    );
    this.currentScaffold = scf;
    return scf;
  }

  Future<List<Order>> getOrders_local() async{
    final Database db = await widget.database;

    final List<Map<String, dynamic>> maps = await db.query("Orders");

    //convert List<Map<String, dynamic>> to List<Mission>
    final List<Order> orders = List.generate(maps.length, (i){
      Order order = new Order();
      order.setId(maps[i]["orderId"]);
      order.setAll(
        maps[i]["tableName"],
        maps[i]["details"],
        maps[i]["status"],
        maps[i]["time"],
        maps[i]["type"],
      );
      return order;
    });

    print("Local missions get all: " + orders.toString());

    return orders;
  }

  Future<void> addOrder_local(Order order) async{
    final Database db = await widget.database;

    //set the missionId
    int orderId = await getNextOrderId();
    order.setId(orderId);

    //add the mission
    await db.insert(
      "Orders",
      order.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    print("Orders created locally: " + order.toString());
    setState(() {
      _listOrders = getOrders_local();
    });
  }


  Future<int> getNextOrderId() async {
    final Database db = await widget.database;
    int maxExistingOrderId = 0;
    final result = await db.rawQuery("SELECT MAX(orderId) FROM Orders");
    if(result.length != 0)
      maxExistingOrderId = Sqflite.firstIntValue(result);

    return maxExistingOrderId+1;
  }

  void showSnack(){
    SnackBar snack = SnackBar(content: Text("Merge, nu?"),);

    Scaffold.of(context).showSnackBar(snack);
  }
}