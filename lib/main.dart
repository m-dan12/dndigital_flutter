import 'package:dndigital/providers/resizable_controller_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'windows_settings.dart';
import 'themes/theme.dart';
import 'views/title_bar.dart';
import 'views/main_view.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  windowsSettings();
  runApp(
    MaterialApp(
      theme: dnTheme,
      debugShowCheckedModeBanner: false,

      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        FlutterQuillLocalizations.delegate,
      ],

      supportedLocales: const [Locale('ru'), Locale('en')],

      home: Scaffold(
        body: ChangeNotifierProvider(
          create: (_) => ResizableControllerModel(),
          child: Column(
            children: [
              const TitleBar(),
              const Expanded(child: MainView()),
            ],
          ),
        ),
      ),
    ),
  );
}
