import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:plant_app/bloc/auth_bloc/auth_bloc.dart';
import 'package:plant_app/bloc/language_bloc/language_bloc.dart';
import 'package:plant_app/bloc/password_visibility_bloc/password_visibility_bloc.dart';
import 'package:plant_app/bloc/plant_bloc/plant_bloc.dart';
import 'package:plant_app/bloc/theme_bloc/theme_bloc.dart';
import 'package:plant_app/bloc/theme_bloc/theme_state.dart';
import 'package:plant_app/models/plant.dart';
import 'package:plant_app/pages/homepage.dart';
import 'package:plant_app/pages/login_page.dart';
import 'package:plant_app/repository/plant_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(PlantAdapter());
  await Hive.openBox<bool>('theme_box');

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
        BlocProvider<PasswordVisibilityBloc>(
          create: (context) => PasswordVisibilityBloc(),
        ),
        BlocProvider<PlantBloc>(
          create: (context) => PlantBloc(PlantRepository()),
        ),
        BlocProvider<ThemeBloc>(create: (context) => ThemeBloc()),
        BlocProvider<LanguageBloc>(
          create: (context) {
            return LanguageBloc();
          },
        ),
      ],
      child: materialApp(),
    );
  }

  BlocBuilder<LanguageBloc, LanguageState> materialApp() {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, languageState) {
        return BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, themeState) {
            return MaterialApp(
              locale: languageState.selectedLanguage.value,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en'),
                Locale('tr'),
              ],
              debugShowCheckedModeBanner: false,
              title: 'Plant App',
              theme: themeState.themeData,
              home: _buildMainPage(),
            );
          },
        );
      },
    );
  }

  Builder _buildMainPage() {
    return Builder(
      builder: (context) {
        final authBloc = BlocProvider.of<AuthBloc>(context);

        return FutureBuilder<bool?>(
          future: authBloc.isUserSignedIn(),
          builder: (context, AsyncSnapshot<bool?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              final isUserSignedIn = snapshot.data ?? false;

              if (isUserSignedIn) {
                return const Homepage();
              } else {
                return const LoginPage();
              }
            }
          },
        );
      },
    );
  }
}
