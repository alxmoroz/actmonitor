// Copyright (c) 2021. Alexandr Moroz

import 'package:amonitor/ui/components/images.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'generated/l10n.dart';
import 'services/globals.dart';
import 'ui/main_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
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
  final Future<void> _initFuture = Globals.initialize();

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Activity Monitor',
      home: FutureBuilder(
        future: _initFuture,
        builder: (_, snapshot) => snapshot.connectionState == ConnectionState.done ? MainView() : SplashScreen(),
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
