import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/index_view.dart';
import 'package:flutter_application_1/views/not_found.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:pusher_beams/pusher_beams.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

AndroidNotificationChannel channel = const AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  //'This channel is used for important notifications.', // description
  importance: Importance.high,
);

class AppComponent extends StatefulWidget {
  const AppComponent({super.key});

  @override
  State<AppComponent> createState() => _AppComponentState();
}

class _AppComponentState extends State<AppComponent> {

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

  @override
  Widget build(BuildContext context) {
    final app = GetMaterialApp(
      title: 'Booking',
      debugShowCheckedModeBanner: false,
      // onGenerateRoute: Application.router.generator,
      theme: ThemeData(
        backgroundColor: Colors.white,
        textTheme:const TextTheme(
          headline3: TextStyle(fontSize: 64.0, fontWeight: FontWeight.w700),
          headline4: TextStyle(fontSize: 36.0, fontWeight: FontWeight.w700),
          headline5: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700),
          headline6: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w700),
          subtitle1: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700),
          subtitle2: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
          bodyText1: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w700),
          bodyText2: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400),
        ),
      ),
      // initialRoute: "/admin/appointment/SjhiMEt1bURFY1grS0IxaEQrRjRxdz09|trghfghfhg",
      initialRoute: '/',
      unknownRoute: GetPage(name: '/not-found', page: () => const NotFoundView()),
      getPages: [
        GetPage(name: '/', page: () => const IndexView()),
        GetPage(name: '/admin/getting-stater', page: () => GettingStaterView()),
        GetPage(name: '/admin/login', page: () => LoginView()),
        GetPage(name: '/admin/reset-password', page: () => ResetPasswordView()),
        GetPage(
            name: '/admin/appointment', page: () => AppointmentView(token: '')),
        GetPage(
            name: '/admin/appointment/:token',
            page: () => AppointmentView(token: Get.parameters['token'])),
        GetPage(
            name: '/admin/appointment-detail/:id',
            page: () {
              final id = num.tryParse(Get.parameters['id']!);
              if (id == null) {
                return NotFoundView();
              } else {
                return AppointmentDetailView(
                    id: int.parse(Get.parameters['id']!));
              }
            }),
        GetPage(
            name: '/admin/appointment-detail/:token/:id',
            page: () {
              final id = num.tryParse(Get.parameters['id']!);
              if (id == null) {
                return NotFoundView();
              } else {
                return AppointmentView(
                  token: Get.parameters['token'],
                  nextDetail: true,
                  appointmentDetail: int.parse(Get.parameters['id']!),
                );
              }
            }),
        GetPage(
            name: '/admin/appointment-detail-notification/:tenant/:id',
            page: () {
              final id = num.tryParse(Get.parameters['id']!);
              if (id == null) {
                return NotFoundView();
              } else {
                return AppointmentDetailNotification(
                    tenant: Get.parameters['tenant']!,
                    appointmentId: int.parse(Get.parameters['id']!));
              }
            }),
        GetPage(name: '/admin/inbox', page: () => InboxView()),
        GetPage(
            name: '/admin/inbox/:id',
            page: () => InboxDetailView(id: int.parse(Get.parameters['id']!))),
        GetPage(name: '/not-found', page: () => NotFoundView()),
        GetPage(name: '/admin/notification', page: () => NotificationView()),
        GetPage(name: '/admin/client', page: () => ClientView()),
        GetPage(name: '/admin/profile', page: () => ProfileView()),
        GetPage(
            name: '/admin/reschedule/your-appointment/:id',
            page: () {
              final id = num.tryParse(Get.parameters['id']!);
              if (id == null) {
                return NotFoundView();
              } else {
                return YourAppointmentView(
                    id: int.parse(Get.parameters['id']!));
              }
            }),
      ],
    );

    // print("initial route = ${app.initialRoute}");

    return app;
  
  }
}