import 'package:flutter/material.dart';
import 'package:flutter_demo_firebase/authGate.dart';
import 'package:flutterfire_ui/i10n.dart';

import 'L10n/flutter_fire_ui_localization_labels.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //子Widgetにデータを渡す
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      localizationsDelegates: [
        // Creates an instance of FirebaseUILocalizationDelegate with overridden labels
        FlutterFireUILocalizations.withDefaultOverrides(
            const FlutterFireUIJaLocalizationLabels()),

        // Delegates below take care of built-in flutter widgets
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,

        // This delegate is required to provide the labels that are not overridden by LabelOverrides
        FlutterFireUILocalizations.delegate,
      ],
      home: AuthGate(),
    );
  }
}
