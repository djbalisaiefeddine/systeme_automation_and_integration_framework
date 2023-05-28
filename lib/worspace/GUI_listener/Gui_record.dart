import 'package:flutter/material.dart';

import '../main_stage.dart';
import 'DataListWidget.dart';
import 'MongoDBService.dart';

String id =AdaptiveScreenState.getUid();
var mongoDBService = MongoDBService(id);
List<dynamic> dataList = [];
bool ref = true;

class Gui_record extends StatefulWidget {


  @override
  Gui_recordState createState() => Gui_recordState();
}

class Gui_recordState extends State<Gui_record> {
  static bool ref = false;
  static set_ref_stat(bool state){
    ref = false;
  }
  void refresh(){
    mongoDBService = MongoDBService(id);
    setState(() {
      initDatabase();
      ref = true;
    });
  }

  @override
  void initState() {
    super.initState();
    initDatabase();
  }

  Future<void> initDatabase() async {
    await mongoDBService.connect();
    updateDataList();
    /*
    mongoDBService.watchChanges().listen((event) {
      updateDataList();
    });*/
  }

  void updateDataList() async {
    final newDataList = await mongoDBService.fetchData();
    setState(() {
      dataList = newDataList;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(!ref){
      return Column(
        children: [
          IconButton(onPressed:refresh, icon: Icon(Icons.refresh))
        ],
      );
    }else{
      return DataListWidget(dataList);
    }
  }
}
