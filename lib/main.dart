import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'data/models/livro.dart';
import 'data/repositorio/livroRepositorio.dart';
import 'pages/home/homePage.dart';
import 'core/theme/tema_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(LivroAdapter());
  await Hive.openBox<Livro>(LivroRepositorio.boxName);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Books',
      theme: appTheme(),
      home: const HomePage(),
    );
  }
}