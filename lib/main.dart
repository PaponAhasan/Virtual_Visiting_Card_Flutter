import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:virtual_visiting_card/pages/contact_page.dart';
import 'package:virtual_visiting_card/pages/form_page.dart';
import 'package:virtual_visiting_card/pages/home_page.dart';
import 'package:virtual_visiting_card/pages/scan_page.dart';
import 'package:virtual_visiting_card/providers/contact_provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => ContactProvider(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      builder: EasyLoading.init(),
      initialRoute: HomePage.routeName,
      routes: {
        HomePage.routeName: (context) => const HomePage(),
        ScanPage.routeName: (context) => const ScanPage(),
        FormPage.routeName: (context) => const FormPage(),
        ContactPage.routeName: (context) => const ContactPage(),
      },
    );
  }
}

