import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pusher_beams/pusher_beams.dart';

AndroidNotificationChannel channel = const AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  //'This channel is used for important notifications.', // description
  importance: Importance.high,
);

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  const instanceID = 'b18b0183-110c-49ae-9699-97b69435fffb';
  await PusherBeams.instance.start(instanceID);
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
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }
  @override
  void initState() {
    _initPusherBeams();
    super.initState();
    _beams();
  }

  _initPusherBeams() async {
    String userID = 'user-001';
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    final BeamsAuthProvider beamsAuthProvider = BeamsAuthProvider() // return beams token from backend
    ..authUrl = 'http://192.168.1.107:8080/v1/notification/notification/token'
    ..headers = {'Content-Type': 'application/json'}
    ..queryParams = {'page': '1'}
    ..credentials = 'omit';
    debugPrint('token'+beamsAuthProvider.toString());
    await PusherBeams.instance.setUserId(
   //'User-id',
   userID,
    beamsAuthProvider,
    (error) => {
        if (error != null) { print(error) }
        // Success! Do something...
    }
    );
    //await PusherBeams.instance.('User-id');
  }

  _beams() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('mipmap/ic_launcher');
     final DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification
        );

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: selectNotification);

    PusherBeams.instance.onMessageReceivedInTheForeground(_onMessageReceivedInTheForeground);
  }
  void onDidReceiveLocalNotification(
    int id, String? title, String? body, String? payload) async {
  // display a dialog with the notification details, tap ok to go to another page
  showDialog(
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: Text(title!),
      content: Text(body!),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          child: const Text('Ok'),
          onPressed: () async {
            Navigator.of(context, rootNavigator: true).pop();
            // await Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => SecondScreen(payload),
            //   ),
            // );
          },
        )
      ],
    ),
  );
}
  void _onMessageReceivedInTheForeground(Map<Object?, Object?> data ) {
    debugPrint(data.toString());
    if (!kIsWeb) {
      var data2 = data['data']as Map ;
      //var data3 = data2['pusher'];
      //var publishId = data3;
      //debugPrint("publishId------>>"+publishId.toString());
        flutterLocalNotificationsPlugin.show(
            0,
            data['title'].toString(),
            data['body'].toString(),
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                //channel.description,
                icon: 'launch_background',
              ),
            ),
            
            payload: data2['router'].toString() 
            );
            
            debugPrint("data------>>"+data2['router'].toString());
      } else {
        
      }
  }

  void selectNotification(NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      debugPrint('notification payload: $payload');
    }
    // await Navigator.push(
    //   context,
    //   MaterialPageRoute<void>(builder: (context) => SecondScreen(payload)),
    // );
  }
  void logOut()async{
    await PusherBeams.instance.clearAllState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            TextButton(onPressed: (){
              logOut();
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> const SplashScreen()), (route) => false);
            }, child: const Text('Đăng xuất'))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [TextButton(onPressed: (){
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> const MyHomePage(title: "title")), (route) => false);
    }, child:const Text('Đăng nhập'))],),),);
  }
}
