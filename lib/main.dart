// Copyright (c) 2021. Alexandr Moroz

import 'package:choice/components/material_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'generated/l10n.dart';
import 'services/init.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: materialWrap(
        const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

class App extends StatelessWidget {
  final Future<void> _initFuture = Init.initialize();

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Choice',
      home: FutureBuilder(
        future: _initFuture,
        builder: (context, snapshot) => snapshot.connectionState == ConnectionState.done ? Container() : SplashScreen(),
      ),
      routes: {},
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
