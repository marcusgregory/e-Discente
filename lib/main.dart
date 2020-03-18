import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';
import 'pages/splash_screen.page.dart';

const myTask = "syncWithTheBackEnd";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
  await Workmanager.initialize(callbackDispatcher,isInDebugMode: true);
  print('init work manager');
  await Workmanager.registerPeriodicTask(
    "1",
    myTask, //This is the value that will be returned in the callbackDispatcher
    frequency: Duration(minutes: 15),
  );
}
void callbackDispatcher() {
  Workmanager.executeTask((task,inputdata) {
    switch (task) {
      case myTask:
        print("this method was called from native!");
        break;
      case Workmanager.iOSBackgroundTask:
        print("iOS background fetch delegate ran");
        break;
    }

    //Return true when the task executed successfully or not
    return Future.value(true);
  });
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'UniDiscente',
        theme: ThemeData(
            accentColor: Colors.teal[300],
            primaryColor: Color(0xFF00396A),
            backgroundColor: Colors.white),
        home: SplashPage());
  }
}

