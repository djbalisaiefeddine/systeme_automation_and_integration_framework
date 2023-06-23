import 'dart:convert';

import 'package:flutter/material.dart';

import '../main_stage.dart';



String id =AdaptiveScreenState.getUid();
class DataListWidget extends StatelessWidget {
  final List<dynamic> dataList;

  DataListWidget(this.dataList);

  @override
  Widget build(BuildContext context) {
    if (dataList.length >= 1 && dataList[0] is Map<String, dynamic>) {
      final jsonMap = dataList[0][id] as Map<String, dynamic>;

      return ListView.builder(
        itemCount: jsonMap.length,
        itemBuilder: (context, index) {
          final key = jsonMap.keys.elementAt(index);
          final value = jsonMap[key];

          return Card(
            child : ListTile(
            title: Text('Step: $key'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Full XPath: ${value['fullXPath']}'),
                Text('Timestamp: ${value['timestamp']}'),
              ],
            ),
            )
          );
        },
      );
    } else {

      return Container(); // Return an empty container if the JSON object is not available
    }
  }
}


































/**
import 'package:flutter/material.dart';

class DataListWidget extends StatelessWidget {
  final List<dynamic> dataList;

  DataListWidget(this.dataList);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: dataList.length,
      itemBuilder: (context, index) {
        final entry = dataList[index];
        final key = entry['key'];
        final value = entry['value'];

        return ListTile(
          title: Text('Key: $key'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Full XPath: ${value['fullxpath']}'),
              Text('Timestamp: ${value['timestamp']}'),
            ],
          ),
        );
      },
    );
  }
}
*/