import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:perudo/createGame.dart';
import 'firebase_options.dart';
import 'firebaseLogic.dart';
import 'gameScreen.dart';
import 'homePage.dart';
import 'lang.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  currentTheme = await readData();
  user = await anonymeAuth();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(const MainApp());
}

class Navigate {
  static Map<String, Widget Function(BuildContext)> routes = {
    '/': (context) => const HomePage(),
    'createGame': (context) => const CreateGamePage(),
    'game': (context) => const GamePage(),
  };
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return StreamBuilder<QuickTheme>(
        stream: quickTheme.stream,
        initialData: currentTheme!,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Material(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          return GetMaterialApp(
            title: 'perudo'.tr,
            debugShowCheckedModeBanner: false,
            routes: Navigate.routes,
            translations: TextLang(),
            locale: Locale(snapshot.data!.lang),
            debugShowMaterialGrid: false,
            theme: ThemeData(
              useMaterial3: true,
              colorSchemeSeed: snapshot.data!.color,
            ),
            darkTheme: ThemeData.dark(useMaterial3: true),
            themeMode: snapshot.data!.brightness,
          );
        });
  }
}
