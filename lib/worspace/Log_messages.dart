import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

class log_tail extends StatefulWidget {
  @override
  _log_tailState createState() => _log_tailState();
}

class _log_tailState extends State<log_tail> {
  List<String> lines = [];
  late StreamSubscription<String> subscription;

  @override
  void initState() {
    super.initState();
    start();
  }

  Future<void> start() async {
    // Start the process
    Process process = await Process.start('cmd', ['/c', 'ping 8.8.8.8 -t']);

    // Listen to the output stream
    subscription = process.stdout.transform(utf8.decoder).listen((data) {
      // Add the line to the list
      lines.add(data);

      // Remove empty lines
      lines.removeWhere((line) => line.isEmpty);

      // Update the list view
      setState(() {});
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: lines.length,
      itemBuilder: (context, index) {
        return Text(lines[index]);
      },
    );
  }
}