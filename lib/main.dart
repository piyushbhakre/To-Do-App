import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:herody_assignment/app.dart';
import 'package:herody_assignment/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
