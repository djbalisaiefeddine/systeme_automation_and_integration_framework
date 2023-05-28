import 'package:flutter/material.dart';
import 'package:flutter_flip_card/controllers/flip_card_controllers.dart';
import 'package:flutter_flip_card/flipcard/flip_card.dart';
import 'package:flutter_flip_card/modal/flip_side.dart';
import 'package:systeme_automation_and_integration_framework/worspace/main_stage.dart';

import 'Login.dart';



late var uid,newuid;

bool isTextFieldEmpty = true;

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String selectedWidget = '';
  final controller = FlipCardController();
  final _textFieldController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    final double cardWidth = screenWidth * 0.2;
    final double cardHeight = screenHeight * 0.2;
    final double spacing = screenWidth * 0.1;

    Widget getSelectedWidget() {
      if (selectedWidget == 'Adaptive_Screen_for_GUI') {
        return Adaptive_Screen_for_GUI(initialText: newuid);
      } else if (selectedWidget == 'Adaptive_Screen_for_RUN') {
        return Adaptive_Screen_for_GUI(initialText: newuid);
      } else if (selectedWidget == 'Adaptive_Screen_for_VAL') {
        return Adaptive_Screen_for_GUI(initialText: newuid);
      } else {
        return Container(
          color: Colors.blue,
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(left: screenWidth * 0.1, right: screenWidth * 0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FlipCard(
                  rotateSide: RotateSide.right,
                  onTapFlipping: true, //When enabled, the card will flip automatically when touched.
                  axis: FlipAxis.vertical,
                  controller: controller,
                  frontWidget: Center(
                      child: Container(
                          width: cardWidth,
                          height: cardHeight,
                          color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.emergency_recording),
                              Container(
                                height: 10,
                              ),
                              Text("Record new test")
                            ],
                          )
                      )
                  ),
                  backWidget: Container(
                      width: cardWidth,
                      height: cardHeight,
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextField(
                            controller: _textFieldController,
                            onChanged: (value) {
                              setState(() {
                                isTextFieldEmpty = value.isEmpty;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'Enter text',
                            ),
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: isTextFieldEmpty ? null : () {
                              setState(() {
                                newuid = newuid+"testid:"+_textFieldController.text;
                                selectedWidget = 'Adaptive_Screen_for_RUN';
                              });
                              // Perform action when start button is clicked
                            },
                            child: Text('Start'),
                          ),
                        ],
                      )
                  )
              ),


              // Flip the card programmatically
              //controller.flipcard();

                  SizedBox(width: spacing),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedWidget = 'Adaptive_Screen_for_RUN';
                      });
                    },
                    child: Container(
                      width: cardWidth,
                      height: cardHeight,
                      child: Card(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.play_arrow),
                            Text('Run Automated Test'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: spacing),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedWidget = 'Adaptive_Screen_for_VAL';
                      });
                    },
                    child: Container(
                      width: cardWidth,
                      height: cardHeight,
                      child: Card(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check),
                            Text('Validate Test'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ); // Default empty container
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Home'),
              onTap: () {
                // Handle the action when 'Home' is tapped
                print('Home tapped!');
              },
            ),
            ListTile(
              title: Text('Settings'),
              onTap: () {
                // Handle the action when 'Settings' is tapped
                print('Settings tapped!');
              },
            ),
          ],
        ),
      ),

      // Display the selected widget
      // Replace AdaptiveScreenForGUI, AdaptiveScreenForRUN, AdaptiveScreenForVAL with your actual widget classes
      body: getSelectedWidget(),
    );
  }

  @override
  void initState() {
    super.initState();
    uid = LoginScreenState.getUid()!;
    final dateTime = DateTime.now();
    final timestamp = dateTime.millisecondsSinceEpoch;
    newuid = uid+timestamp.toString();
  }
}


