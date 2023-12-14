import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_app/bloc/plant_bloc.dart';
import 'package:plant_app/pages/homepage.dart';
import 'package:plant_app/pages/register_page.dart';
import 'package:plant_app/repository/plant_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
    return MaterialApp(
      title: 'Plant App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocProvider(
        key: UniqueKey(),
        create: (context) => PlantCubit(PlantRepository()),
        child: Homepage(),
      ),
    );
  }
}
