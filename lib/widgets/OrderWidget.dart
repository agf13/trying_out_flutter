


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mockup_1/entities/Order.dart';
import 'package:sqflite/sqflite.dart';

class OrderWidget extends StatefulWidget{
  OrderWidget({this.orderId, this.database, this.addOrder, this.updateOrder});

  int orderId;
  Future<Database> database;
  // Database database;
  Function addOrder, updateOrder;

  @override
  State<StatefulWidget> createState() {
    return _OrderWidgetState();
  }

}


class _OrderWidgetState extends State<OrderWidget>{

  final _orderFormKey = GlobalKey<FormState>();

  TextEditingController tableController;
  TextEditingController detailsController;
  TextEditingController statusController;
  TextEditingController hoursController;
  TextEditingController minutesController;
  TextEditingController typeController;


  @override
  void initState(){
    if(widget.orderId != null && widget.orderId > 0){
      getOrder(widget.orderId).then((order) {
        tableController.text = order.getTable();
        detailsController.text = order.getDetails();
        statusController.text = order.getStatus();

        hoursController.text = order.getHours().toString();
        minutesController.text = order.getMinutes().toString();

        typeController.text = order.getType();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    this.tableController = TextEditingController(text: "");
    this.detailsController = TextEditingController(text: "");
    this.statusController = TextEditingController(text: "");
    this.hoursController = TextEditingController(text: "");
    this.minutesController = TextEditingController(text: "");
    this.typeController = TextEditingController(text: "");

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Mission Details",
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: this._orderFormKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Table",
                ),
                controller: this.tableController,
                validator: (value) {
                  if(value.isEmpty){
                    return "Please let the agent know";
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Details",
                ),
                controller: this.detailsController,
                validator: (value) {
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Status",
                ),
                controller: this.statusController,
                validator: (value){
                  return null;
                },
              ),
              Row(
                children: [
                  Expanded(
                  child:
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Hours",
                      ),
                      controller: this.hoursController,
                      validator: (value){
                        return null;
                      },
                    ),
                  ),
                  Expanded(
                    child:
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Minutes",
                      ),
                      controller: this.minutesController,
                      validator: (value){
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Type",
                ),
                controller: this.typeController,
                validator: (value){
                  return null;
                },
              ),
              ElevatedButton(
                child: Text(
                  "Save",
                ),
                onPressed: (){
                  if(_orderFormKey.currentState.validate()){
                    int hours = int.parse(this.hoursController.text);
                    int minutes = int.parse(this.minutesController.text);
                    String time = hours.toString() + " " + minutes.toString();

                    Order order_fromForm = Order();
                    order_fromForm.setAll(
                      this.tableController.text,
                      this.detailsController.text,
                      this.statusController.text,
                      time,
                      this.typeController.text,
                    );
                    if(widget.orderId != null && widget.orderId != -1){
                      order_fromForm.setId(widget.orderId);
                      widget.updateOrder(order_fromForm);
                    }
                    else{
                      widget.addOrder(order_fromForm);
                    }
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Order> getOrder(int orderId) async{
    final Database db = await widget.database;
    final List<Map<String, dynamic>> orders = await db.query(
      "Orders",
      where:"orderId = ?",
      whereArgs: [widget.orderId],
    );

    if(orders.length != 0){
      Order currentOrder = Order();
      currentOrder.setId(widget.orderId);
      currentOrder.setAll(
        orders[0]["tableName"],
        orders[0]["details"],
        orders[0]["status"],
        orders[0]["time"],
        orders[0]["type"]
      );
      return currentOrder;
    }

    return null;
  }

}