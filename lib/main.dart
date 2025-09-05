import 'package:flutter/material.dart';
import 'package:ecopraia/theme.dart';
import 'package:ecopraia/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:ecopraia/presentation/auth/auth_gate.dart';
import 'package:provider/provider.dart';
import 'package:ecopraia/presentation/map/map_state.dart';
import 'package:ecopraia/data/repositories/praia_repository.dart';
import 'package:ecopraia/data/repositories/mock_praia_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (_) => MapState(repository: MockPraiaRepository()),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Praia+Segura',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: const AuthGate(),
    );
  }
}
