import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:sps/screens/login_screen.dart';
import 'package:sps/utils/sharedpreferences_utils.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SharedpreferencesUtils().init();
  OneSignal.shared.setAppId("2c9a02d4-cc6c-4f96-8286-c7ab6df7f167");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
  return ResponsiveSizer(builder: (context,orientation,screenType){
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Training',
        theme: ThemeData(
          
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with “flutter run”. You’ll see
          // the application has a purple toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke “hot reload” (save your changes or press the “hot
          // reload” button in a Flutter-supported IDE, or press “r” if you used
          // the command line to start the app).
          //
          // Notice that the counter didn’t reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey[900]!),
          useMaterial3: true,
      
        ),
        home: LoginScreen()
      );
  });
  }
}
