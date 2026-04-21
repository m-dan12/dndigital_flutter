import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:google_fonts/google_fonts.dart';

final DefaultStyles quillTextStyles = DefaultStyles(
  // Обычный текст
  paragraph: DefaultTextBlockStyle(
    GoogleFonts.lora(color: Colors.black87, fontSize: 16.0, height: 1.5),
    HorizontalSpacing(0, 0),
    VerticalSpacing(0, 0),
    VerticalSpacing(0, 0),
    null,
  ),

  // Headline 1
  h1: DefaultTextBlockStyle(
    GoogleFonts.lora(
      color: Colors.black87,
      fontSize: 28.0,
      fontWeight: FontWeight.bold,
      height: 2,
    ),
    HorizontalSpacing(0, 0),
    VerticalSpacing(8, 0),
    VerticalSpacing(0, 0),
    null,
  ),

  // Headline 2
  h2: DefaultTextBlockStyle(
    GoogleFonts.lora(
      color: Colors.black87,
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
      height: 2,
    ),
    HorizontalSpacing(0, 0),
    VerticalSpacing(8, 0),
    VerticalSpacing(0, 0),
    null,
  ),

  // Headline 3
  h3: DefaultTextBlockStyle(
    GoogleFonts.lora(
      color: Colors.black87,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      height: 2,
    ),
    HorizontalSpacing(0, 0),
    VerticalSpacing(8, 0),
    VerticalSpacing(0, 0),
    null,
  ),

  // Headline 4
  h4: DefaultTextBlockStyle(
    GoogleFonts.lora(
      color: Colors.black87,
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
      height: 2,
    ),
    HorizontalSpacing(0, 0),
    VerticalSpacing(8, 0),
    VerticalSpacing(0, 0),
    null,
  ),

  // Headline 5
  h5: DefaultTextBlockStyle(
    GoogleFonts.lora(
      color: Colors.black87,
      fontSize: 16.0,
      fontWeight: FontWeight.bold,
      height: 2,
    ),
    HorizontalSpacing(0, 0),
    VerticalSpacing(8, 0),
    VerticalSpacing(0, 0),
    null,
  ),
);
