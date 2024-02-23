import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mtouch_machine_test/View/User/All%20Users/show_users.dart';
import 'package:mtouch_machine_test/bloc/user_bloc_bloc.dart';
import 'package:mtouch_machine_test/firebase_options.dart';

void main() async {
  // Initialize Flutter
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserBlocBloc(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AllUsersList(),
      ),
    );
  }
}
