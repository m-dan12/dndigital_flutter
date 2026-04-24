import 'package:dndigital/core/utils/providers/layout_controller_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/utils/providers/windows_settings.dart';
import 'core/theme/app_theme.dart';
import 'core/views/title_bar.dart';
import 'core/views/main_view.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'features/master_notes/data/services/hive_initializer.dart';
import 'features/master_notes/presentation/providers/note_editor_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализируем Hive
  await Hive.initFlutter();
  await HiveInitializer.initialize();

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
        body: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => LayoutControllerProvider()),
            NoteEditorProvider.create(),
            NoteEditorProvider.createListViewModel(),
          ],
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
