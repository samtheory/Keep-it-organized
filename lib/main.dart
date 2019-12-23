// ?   Dependemcy
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
// ?   S C R E E N
import 'package:keep_it_organized/screen/inbox.dart';
import 'package:keep_it_organized/screen/Addpage.dart';
import 'package:keep_it_organized/screen/ComplitedPage.dart';
// ?     DATA  _  BASE   Modul
import 'package:keep_it_organized/database/myTask_db.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(MytaskAdapter(), 0);
  final complited = Hive.openBox<Mytask>('Complited');
  runApp(KeepItSimple());
}

class KeepItSimple extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KIO',
      theme: ThemeData(
          primaryColor: Colors.white,
          scaffoldBackgroundColor: Color(0xffF1F3F4)),
      initialRoute: '/',
      routes: {
        '/': (context) => InboxPage(),
        '/complited': (context) => ComplitedPage(),
        // '/': (context) => TestPage(),
        // '/other': (context) => InboxPage(),
      },
    );
  }
}
