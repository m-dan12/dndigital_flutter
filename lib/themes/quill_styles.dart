import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class DnQuillStyles {
  static DefaultStyles getStyles() => DefaultStyles(
    // Обычный текст
    paragraph: DefaultTextBlockStyle(
      TextStyle(
        color: Colors.black87,
        fontSize: 18.0,
        fontFamily: 'Cormorant',
        height: 1.5,
      ),
      HorizontalSpacing(0, 0),
      VerticalSpacing(0, 0),
      VerticalSpacing(0, 0),
      null,
    ),

    // Headline 1
    h1: DefaultTextBlockStyle(
      TextStyle(
        color: Colors.black87,
        fontSize: 32,
        height: 2,
        fontWeight: FontWeight.w600,
        fontFamily: 'Cormorant',
      ),
      HorizontalSpacing(0, 0),
      VerticalSpacing(0, 0),
      VerticalSpacing(0, 0),
      null,
    ),

    // Headline 2
    h2: DefaultTextBlockStyle(
      TextStyle(
        color: Colors.black87,
        fontSize: 28,
        height: 2,
        fontWeight: FontWeight.w600,
        fontFamily: 'Cormorant',
      ),
      HorizontalSpacing(0, 0),
      VerticalSpacing(0, 0),
      VerticalSpacing(0, 0),
      null,
    ),

    // Headline 3
    h3: DefaultTextBlockStyle(
      TextStyle(
        color: Colors.black87,
        fontSize: 24,
        height: 2,
        fontWeight: FontWeight.w600,
        fontFamily: 'Cormorant',
      ),
      HorizontalSpacing(0, 0),
      VerticalSpacing(0, 0),
      VerticalSpacing(0, 0),
      null,
    ),

    // Headline 4
    h4: DefaultTextBlockStyle(
      TextStyle(
        color: Colors.black87,
        fontSize: 20,
        height: 2,
        fontWeight: FontWeight.w600,
        fontFamily: 'Cormorant',
      ),
      HorizontalSpacing(0, 0),
      VerticalSpacing(0, 0),
      VerticalSpacing(0, 0),
      null,
    ),
  );
}
