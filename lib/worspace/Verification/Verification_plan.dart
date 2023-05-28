import 'package:flutter/material.dart';

import '../Cli_interpreter/User_cmd_interaction.dart';
import '../GUI_listener/Gui_record.dart';

class Verification_Class extends StatefulWidget {
  @override
  State<Verification_Class> createState() => _Verification_ClassState();
}

class _Verification_ClassState extends State<Verification_Class> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verification'),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(

              onPressed: () {
                _showPopup(context, 'GUI');
              },
              child: Text('GUI'),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                _showPopup(context, 'CLI');
              },
              child: Text('CLI'),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                _showPopup(context, 'packet_analyzer');
              },
              child: Text('packet_analyzer'),
            ),
          ],
        ),
      ),
    );
  }

  void _showPopup(BuildContext context, String buttonName) {
    Widget CLI_verif = new cmdinteraction();
    Widget GUI_verif = new Gui_record();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Popup Window'),
          content: Text('You clicked $buttonName'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
