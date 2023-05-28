import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:systeme_automation_and_integration_framework/Login.dart';
import 'dart:io';
import 'dart:convert';

import 'OutputItem.dart';
var testlog = {};
var cmndlog = {};
int i = 0;
int steps =0;
String uid ="";
class cmdinteraction extends StatefulWidget {
  @override
  _CmdInteractionState createState() => _CmdInteractionState();
}

class _CmdInteractionState extends State<cmdinteraction> {
  final TextEditingController _textEditingController = TextEditingController();
  List<OutputItem> _displayText = [];

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void _handleSubmitted(String value) async {
    if(cmndlog.isNotEmpty){
      testlog[steps.toString()] = cmndlog;
      cmndlog = {};
      steps++;
    }
    final dateTime = DateTime.now();
    final timestamp = dateTime.millisecondsSinceEpoch;
    cmndlog[value]= timestamp.toString();
    print(timestamp.toString());
    _textEditingController.clear();

    try {
      final process = await Process.start(value, []);
      final output = StringBuffer();

      process.stdout.listen(
            (data) {
          final decodedData = utf8.decode(data, allowMalformed: true);
          output.write(decodedData);
          final lines = output.toString().split('\n');
          lines.forEach(
                (element) {
              if(element.trim().isNotEmpty){
                final newOutput = OutputItem(text: element, isValid: false);
                setState(
                      () {
                    _displayText.add(newOutput);
                  },
                );
              }
            },
          );
        },
        onError: (error) {
          print('Error: $error');
        },
        onDone: () {
          print('Process complete');
        },
      );
    } catch (e) {
      print('Error: $e');
    }
    print(testlog.toString());
  }

  void _saveTextToHashMap(String text) {
    final key = 'variable$i';
    cmndlog[key] = text;
    i++;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Command Line Interface (CLI)'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              flex: 9,
              child: Container(
                width: double.infinity,
                child: ListView.builder(
                  itemCount: _displayText.length,
                  itemBuilder: (context, index) {
                    final item = _displayText[index];
                    return ListTile(
                      title: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: TextEditingController(text: item.text),
                              onChanged: (newValue) {
                                setState(() {
                                  item.text = newValue;
                                });
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                contentPadding: EdgeInsets.zero, // Remove any padding
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _saveTextToHashMap(item.text);
                              item.isValid = true;
                              setState(() {
                                item.isValid = true;
                              });
                            },
                            child: Icon(
                              item.isValid ? Icons.check_circle : Icons.cancel,
                              color: item.isValid ? Colors.green : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              flex: 1,
              child: Container(
                width: double.infinity,
                child: TextField(
                  controller: _textEditingController,
                  decoration: InputDecoration(
                    hintText: 'Enter your text...',
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.newline,
                  onSubmitted: _handleSubmitted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


}
