import 'package:flutter/material.dart';
import 'package:mockup_1/entities/Order.dart';
import 'package:mockup_1/routes/OrdersListScreen.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  print("Creating database");

  final Future<Database> databaseOrders = openDatabase(
      join(await getDatabasesPath(), "managingOrders.db"),
      onCreate:(db, version){
        print("Creating db");
        print("");
        print("");
        db.execute(
          "CREATE TABLE Orders("
          "orderId INT PRIMARY KEY,"
          "tableName TEXT,"
          "details TEXT,"
          "status TEXT,"
          "time TEXT,"
          "type TEXT)"
        );
        print("Dinished Db");
        print("");
        print("");
      },
      version: 1,
  );

  runApp(MyHomePage(
    database: databaseOrders,
  ));
}


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.database}) : super(key: key){
    initDatabse();
  }

  final Future<Database> database;
  // final Future<Database> database;


  Future<void> initDatabse() async{
    final Database db = await this.database;
    print("initDatabse::databse:"+db.toString());
    final numberMissions_rawResult = await db.rawQuery("SELECT COUNT(*) FROM Orders");
    int numberMissions = Sqflite.firstIntValue(numberMissions_rawResult);

    if(numberMissions == 0){
      Order firstOrder = Order();
      firstOrder.setId(1);
      firstOrder.setAll(
        "Table1",
        "details...",
        "Backing",
        "00 11",
        "normal",
      );
      db.insert(
        "Orders",
        firstOrder.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      print("order added in init: " + firstOrder.toString());
    }
  }

  @override
  _MyHomePageState createState() => _MyHomePageState();
}




class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: "Order Management",
      theme: ThemeData(
        primaryColor: Colors.amberAccent,
      ),
      home: OrdersListScreen(
        database: widget.database,
      ),
    );
  }


}
