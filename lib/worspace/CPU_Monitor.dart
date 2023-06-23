import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dartssh2/dartssh2.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

class CPU_Monotoring extends StatefulWidget {
  @override
  CPU_MonotoringState createState() => CPU_MonotoringState();
}

class CPU_MonotoringState extends State<CPU_Monotoring> {
  List<String> lines = [];
  late StreamSubscription<dynamic> subscription;

  @override
  void initState() {
    super.initState();
    getDefaultGateway();

  }

  Future<void> start(String ip) async {
    // Start the process
    print("starting ssh");
    //Process process = await Process.start('C://Users//sst//Desktop//pthon outputs//logs//dist//logs.exe', ['-gw $ip -p 51022 -u access -pw goKf/Z*#uRSc,Zyf -cmnd "tail -F /var/log/messages"'],runInShell: true);
    Process process = await Process.start('C://Users//sst//Desktop//pthon outputs//logs//dist//logs.exe', ['-gw ' ,ip,'-p', '51022' ,'-u', 'access', '-pw', 'goKf/Z*#uRSc,Zyf', '-cmnd', 'tail -F /var/log/messages'],runInShell: true);
    var stdout = process.stdout;

    // Start listening for output from the command.
    stdout.listen((data) {
      // Print the output to the console.
      print(data);
    });
    process.stdout.listen((event) {
      print("without decode "+event.toString());
    });
    // Listen to the output stream
    subscription = process.stdout.transform(utf8.decoder).listen((data) {
      // Add the line to the list
      print(data.toString());
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
      reverse: true,
      itemCount: lines.length,
      itemBuilder: (context, index) {
        return Text(lines[index]);
      },
    );
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
    //start(ip);
    startlogs(ip);
    print('Default Gateway: $ip');
  }



  Future<void> startlogs(String ip) async {

    // add sytsem variable
    try {
      final process = await Process.start('cpu_cli', ['-gw' ,"192.168.1.254",'-p', '51022' ,'-u', 'access', '-pw', 'goKf/Z*#uRSc,Zyf']);
      final output = StringBuffer();

      final stdout = process.stdout.asBroadcastStream();

      stdout.listen(
            (data) {
          final decodedData = utf8.decode(data, allowMalformed: true);
          output.write(decodedData);
          final linesFromOutput = output.toString().split('\n');
          lines.addAll(linesFromOutput);
          setState(() {

          });
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

  }


  Future<String> _read() async {
    String text ="";
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/my_file.txt');
      text = await file.readAsString();
    } catch (e) {
      print("Couldn't read file");
    }
    return text;
  }

}
