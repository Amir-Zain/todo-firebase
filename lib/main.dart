import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:todo_firebase/providers/auth_provider.dart';
import 'package:todo_firebase/providers/todo_provider.dart';
import 'package:todo_firebase/screens/auth_screen.dart';
import 'package:todo_firebase/screens/todo_list_screen.dart';

import 'firebase_options.dart';

void main()async {
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TodoProvider()),
      ],
      child: Sizer(
        builder: (context,orientation,deviceType) {
          return MaterialApp(
            title: 'Todo App',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: Consumer<AuthProvider>(
              builder: (context, authProvider, _) {
                if (authProvider.isLoggedUser) {
                  return TodoListScreen();
                } else {
                  return const AuthScreen();
                }
              },
            ),
          );
        }
      ),
    );
  }
}
