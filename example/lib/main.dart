import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flow_box_popup/flow_box_popup.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyPopup(),
    );
  }
}

class MyPopup extends StatelessWidget {
  const MyPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FlowBoxPopup(
          boxDecoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.red, blurRadius: 100)]
          ),
          popupDecoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20)
          ),
          boxPadding: EdgeInsetsGeometry.all(100),
          popupBuilder: (context) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Text("A smooth animated popup that "
                      "automatically expands based on "
                      "its content and adjusts its position"
                      " when the keyboard appears."),
                  SizedBox(height: 300,),
                  TextField()
                ],
              ),
            );
          },
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(CupertinoIcons.info, color: Colors.white),
            const SizedBox(width: 10),
            Text("Info Package", style: TextStyle(color: Colors.white)),
          ]),
        ),
      ),
    );
  }
}
