


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mockup_1/entities/Order.dart';
import 'package:mockup_1/widgets/OrderWidget.dart';
import 'package:sqflite/sqflite.dart';

class OrderItemWidget extends StatefulWidget{

  OrderItemWidget({this.order, this.database, this.addOrder, this.updateOrder, this.deleteOrder});

  Order order;
  Future<Database> database;
  // Database database;
  Function addOrder, updateOrder, deleteOrder;

  @override
  State<StatefulWidget> createState() {
    return _OrderItemWidgetState();
  }

}

class _OrderItemWidgetState extends State<OrderItemWidget>{

  var _statusFont = TextStyle(fontSize: 16, fontWeight: FontWeight.bold, backgroundColor: Colors.white24);
  var _tableFont = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  var _deadlineFont = TextStyle(fontSize: 12);
  var _detailsFont = TextStyle();
  var _additionalInformationFont = TextStyle();
  var _dateAddedFont = TextStyle();


  @override
  Widget build(BuildContext context) {
    Order order = widget.order;

    return ListTile(
      leading: Text(
        order.getStatus(),
        style: this._statusFont,
      ),
      title: Text(
        order.getTable(),
        style: this._tableFont,
      ),
      trailing: ElevatedButton(
        child: Icon(Icons.edit),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context){
                  return OrderWidget(
                    database: widget.database,
                    orderId: order.getId(),
                    addOrder: widget.addOrder,
                    // editMission: widget.editMission,
                  );
                }
            ),
          );
        },
      ),
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context){
              return OrderWidget(
                database: widget.database,
                orderId: order.getId(),
                addOrder: widget.addOrder,
                updateOrder: widget.updateOrder,
              );
            },
          ),
        );
      },
      onLongPress: (){
        showDialog(
          context: context,
          builder: (BuildContext context){
            return AlertDialog(
              title: Text(
                "Delete this order?",
              ),
              actions: [
                FlatButton(
                  onPressed: (){
                    widget.deleteOrder(order);
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Delete",
                  ),
                ),
                FlatButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Close",
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }


}