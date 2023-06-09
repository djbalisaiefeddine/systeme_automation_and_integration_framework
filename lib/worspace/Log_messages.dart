import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';

class log_tail extends StatefulWidget {
  @override
  _log_tailState createState() => _log_tailState();
}

class _log_tailState extends State<log_tail> {
  List<String> lines = [];
  late StreamSubscription<dynamic> subscription;

  @override
  void initState() {
    super.initState();
    //getDefaultGateway();
    startlogs();
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
    ssh_connect();
    print('Default Gateway: $ip');
  }

  Future<void> ssh_connect() async {
      final socket = await SSHSocket.connect('192.168.1.254', 51022);

      final client = SSHClient(
        socket,
        username: 'access',
          onPasswordRequest: () =>'goKf/Z*#uRSc,Zyf',
          //return stdin.readLineSync() ?? exit(1);
      );
      final shell = await client.shell();
      final up = await client.run('uptime');
      print(utf8.decode(up));
      final uptime = await client.run('tail -F /var/log/messages');
      stdout.addStream(shell.stdout);

      stdout.addStream(shell.stdout).asStream().listen((event) {
        print(event);
      });
      print("subscription state "+subscription.isPaused.toString());
      print(utf8.decode(uptime));

      client.close();
      await client.done;
    }

    Future<void> startlogs() async {
      try {
        final process = await Process.start('logs', ['-gw' ,"192.168.1.254",'-p', '51022' ,'-u', 'access', '-pw', 'goKf/Z*#uRSc,Zyf']);
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

}
