import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
      backgroundColor: const Color(0xFF0F0F15),
      appBar: AppBar(
        title: const Text('Flow Box Popup Demo'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [

          const SizedBox(width: 16),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            const Text(
              'Tap the box to see the animation',
              style: TextStyle(color: Colors.white60, fontSize: 16),
            ),
            const SizedBox(height: 40),
            FlowBoxPopup(
              duration: const Duration(milliseconds: 500),
              boxDecoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blueAccent.withValues(alpha: 0.5), width: 2),
              ),
              popupDecoration: BoxDecoration(
                color: const Color(0xFF1F1F25),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 20,
                    spreadRadius: 5,
                  )
                ],
              ),
              popupBuilder: (context) => SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(
                        color: Colors.blueAccent,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.star, color: Colors.white, size: 30),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Animation',
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'This popup uses the new "Flow" style which adds a stretching effect inspired by modern iOS transitions.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              ),
              child: const SizedBox(
                width: 100,
                height: 100,
                child: Center(
                  child: Icon(Icons.add, color: Colors.white, size: 40),
                ),
              ),
            ),
            FlowBoxPopup(
              boxDecoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(20),
              ),
              popupDecoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20)
              ),
              boxPadding: EdgeInsetsGeometry.all(100),
              popupBuilder: (context) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("A smooth animated popup that "
                      "automatically expands based on "
                      "its content and adjusts its position"
                      " when the keyboard appears.", style: TextStyle(color: Colors.black)),
                );
              },
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(CupertinoIcons.info, color: Colors.white),
                const SizedBox(width: 10),
                Text("Info Package", style: TextStyle(color: Colors.white)),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
