import 'package:carwash/constants.dart';
import 'package:carwash/screen/Landing.dart';
import 'package:carwash/screen/Splash.dart';
import 'package:carwash/viewmodel/IndexViewModel.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  String? osUserID;


  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await initOneSignal(context);
    });
    super.initState();
  }


  Future<void> initOneSignal(context) async {
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    OneSignal.shared.setAppId('f92a3eeb-ed75-4b6b-ba23-1ae05f7540e6');
    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
        print('Accepted permission $accepted');
      },
    );

    final status = await OneSignal.shared.getDeviceState();
    osUserID = status?.userId;
    await ShPref.storeDeviceId(osUserID);

    await OneSignal.shared.promptUserForPushNotificationPermission(
      fallbackToSettings: true,
    );

    /// Calls when foreground notification arrives.
    OneSignal.shared.setNotificationWillShowInForegroundHandler(
            (handleForegroundNotifications) {});
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<IndexViewModel>(create: (context) {
          return IndexViewModel();
        }),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Car Wash',
        theme: ThemeData(
          appBarTheme: AppBarTheme(),
          inputDecorationTheme: InputDecorationTheme(
            suffixIconColor: Colors.black54,
            prefixIconColor: Colors.black54,
            iconColor: Colors.grey,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black45),
            ),
            labelStyle: TextStyle(color: Colors.black54),
            hintStyle: TextStyle(
              color: Colors.grey,
            ),
          ),

        ),
        initialRoute: 'splash',
        routes: {
          'splash': (context) => SplashScreen(),
        },
      ),
    );
  }
}


