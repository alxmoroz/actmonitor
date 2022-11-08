// Copyright (c) 2021. Alexandr Moroz

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:workmanager/workmanager.dart';

import 'components/images.dart';
import 'extra/services.dart';
import 'l10n/generated/l10n.dart';
import 'views/main/main_view.dart';

Future<void> main() async {
  setup();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());

  await Workmanager().initialize(callbackDispatcher);
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    usageController.updateUsageInfo();
    return Future.value(true);
  });
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: bgDecoration(context),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      // debugShowCheckedModeBanner: false,
      title: 'Activity Monitor',
      home: FutureBuilder(
        future: getIt.allReady(),
        builder: (_, snapshot) => snapshot.hasData ? MainView() : SplashScreen(),
      ),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: S.delegate.supportedLocales,
    );
  }
}
