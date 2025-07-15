import 'package:bushfire_warning_app/src/providers/data_provider.dart';
import 'package:bushfire_warning_app/src/theme/theme_provider.dart';
import 'package:bushfire_warning_app/src/widgets/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:bushfire_warning_app/src/notifications/fcm_notifications.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox("firewatch_wa");
  Get.put<FcmNotifications>(FcmNotifications());
  runApp(
    ChangeNotifierProvider(
        create: (context) => DataProvider(), child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider<ThemeProvider>(
          create: (context) => ThemeProvider()),
      ChangeNotifierProvider<DataProvider>(create: (context) => DataProvider()),
    ], child: const MyHomePage());
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (context, dataProvider, child) {
      return MaterialApp(
        title: 'Firewatch WA',
        debugShowCheckedModeBanner: false,
        theme: Provider.of<ThemeProvider>(context).themeData,
        home: const AppLayout(),
      );
    });
  }
}
