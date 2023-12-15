import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:plant_app/bloc/auth_bloc.dart';
import 'package:plant_app/models/plant.dart';
import 'package:plant_app/pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory = await getApplicationDocumentsDirectory();

  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(PlantAdapter());
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyAwVvjCHo33NzlHxycsLJ_uhmxpYizAA18",
          appId: "1:181031905081:android:4e5ff950c16a24ee742ae8",
          messagingSenderId: "181031905081",
          storageBucket: "plant-app-2ad9a.appspot.com",
          projectId: "plant-app-2ad9a"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Plant App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const LoginPage(),
      ),
    );

    /*MaterialApp(
      title: 'Plant App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocProvider(
        key: UniqueKey(),
        create: (context) => PlantCubit(PlantRepository()),
        child: const Homepage(),
      ),
    );*/
  }
}
