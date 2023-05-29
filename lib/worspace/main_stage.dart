import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:network_info_plus/network_info_plus.dart';

import '../Login.dart';
import 'GUI_listener/Gui_record.dart';
import 'Cli_interpreter/User_cmd_interaction.dart';
import 'Log_messages.dart';
import 'Verification/Verification_plan.dart';
late String newuid;




class Adaptive_Screen_for_GUI extends StatefulWidget {
  final String initialText;

  Adaptive_Screen_for_GUI({required this.initialText});
  @override
  AdaptiveScreenState createState() => AdaptiveScreenState();
}

class AdaptiveScreenState extends State<Adaptive_Screen_for_GUI> {
  final TextEditingController _textEditingController = TextEditingController();


  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    _textEditingController.text = widget.initialText;
    newuid = widget.initialText;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('Adaptive Screen'),
        SizedBox(width: 16.0),
        Expanded(
          child: TextField(
            controller: _textEditingController,
            readOnly: false,
            onChanged: (value) {
              setState(() {
                newuid = value;
              });
            },
            decoration: InputDecoration(

              border: InputBorder.none,
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.content_copy),
          onPressed: () {
            Clipboard.setData(ClipboardData(text: newuid));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Copied to clipboard')),
            );
          },
        ),
        ElevatedButton(
          onPressed: () {
            // Save button pressed
          },
          child: Text('Save'),
        ),
        ],
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  Expanded(
                    flex: 5,

                    child: Container(
                      color: Colors.blue,
                      child: GestureDetector(
                        onLongPress: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Widget'),
                                content: Container(
                                  width: MediaQuery.of(context).size.width * 0.75,
                                  height: MediaQuery.of(context).size.height * 0.75,
                                  child: Gui_record(),
                                ),
                              );
                            },
                          );
                        },
                        child:Gui_record(),
                      ),
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                  VerticalDivider(
                    width: 1,
                    color: Colors.black,
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(
                      child: GestureDetector(
                        onLongPress: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Widget'),
                                content: Container(
                                  width: MediaQuery.of(context).size.width * 0.75,
                                  height: MediaQuery.of(context).size.height * 0.75,
                                  child: cmdinteraction(),
                                ),
                              );
                            },
                          );
                        },
                        child:cmdinteraction(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 1,
              color: Colors.black,
            ),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      child:GestureDetector(
                        onLongPress: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Widget'),
                                content: Container(
                                  width: MediaQuery.of(context).size.width * 0.75,
                                  height: MediaQuery.of(context).size.height * 0.75,
                                  child: log_tail(),
                                ),
                              );
                            },
                          );
                        },
                        //child: log_tail(),
                      ),
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                  VerticalDivider(
                    width: 1,
                    color: Colors.black,
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      child: Verification_Class(),
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                  VerticalDivider(
                    width: 1,
                    color: Colors.black,
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      color: Colors.red,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  @override
  void initState() {
    super.initState();
    get_dir();
    newuid = _textEditingController.text;
    getDefaultGateway();
  }
  static String getUid() {
    if(newuid.isEmpty){
      return "empty";
    }else{
      return newuid;
    }
  }


  Future<void> getDefaultGateway() async {
    String ip="";
    final result = await Process.run('tracert',  ['-4', '-h', '1', 'google.com']);
    final output = result.stdout as String;
    var lines = output.split("\n");
    //print(lines);
    String myline = lines[4];
    print("this line "+myline);
    var sec= myline.toString().trim().split("ms");
    ip = sec[3].trim();
    /**
    lines.forEach((element) {
      if(element.trim().startsWith("1")){
        var parts = element.split("ms");
        ip= parts[3].trim();
        print(parts.toString());
      }
    });*/
    print('Default Gateway: $ip');
  }

  void get_dir (){

    try{
      final currentDirectory = Directory.current;
      print("this is the running directory"+currentDirectory.toString());
    }catch(e){
      print("ther is an error getting the current path"+e.toString());
    }
  }


}


