import 'package:chat/auth_bloc.dart';
import 'package:chat/auth_repo.dart';
import 'package:chat/chat_bloc.dart';
import 'package:chat/chat_repository.dart';
import 'package:chat/firebase_options.dart';
import 'package:chat/login_page.dart';
import 'package:chat/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  // Handle background messages
  print("Background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);

  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  await flutterLocalNotificationsPlugin.initialize(
    const InitializationSettings(android: androidSettings),
  );
 runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(AuthRepository()),
          
        ),
         BlocProvider(create: (_) => ChatBloc(ChatRepository())),
        // Add other Blocs here
      ],
      child: EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('ar')],
        path: 'assets/lang',
        fallbackLocale: const Locale('en'),
              startLocale: WidgetsBinding.instance.window.locale,
        child: const MyApp(),
      ),
    ),
  );
  // runApp(
  //   EasyLocalization(
  //     supportedLocales: [Locale('en'), Locale('ar')],
  //     path: 'assets/lang',
  //     fallbackLocale: Locale('en'),
  //     startLocale: WidgetsBinding.instance.window.locale,
  //     child: const MyApp(),
  //   ),
  // );
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Chat App',
//       debugShowCheckedModeBanner: false,
//       locale: context.locale,
//       supportedLocales: context.supportedLocales,
//       localizationsDelegates: context.localizationDelegates,
//       theme: ThemeData(
//         useMaterial3: true,
//         primarySwatch: Colors.teal,
//       ),
//       home: const LoginPage(),
//     );
//   }
// }
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('ar')],
      debugShowCheckedModeBanner: false,
    );
  }
}

void setupInteractedMessageHandler() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    if (notification != null) {
      flutterLocalNotificationsPlugin.show(
        0,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'chat_channel',
            'Chat Notifications',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
      );
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print("Notification Clicked: ${message.data}");
  });
}

Future<void> requestNotificationPermissions() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  print("Permission: ${settings.authorizationStatus}");
}
