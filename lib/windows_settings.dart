import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

void windowsSettings() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Настраиваем окно перед запуском приложения
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(1280, 800),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden, // ← полностью убирает title bar
    // titleBarStyle: TitleBarStyle.hidden,  // если хочешь оставить кнопки, но убрать заголовок
  );

  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
}
