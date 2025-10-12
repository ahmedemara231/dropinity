import 'package:flutter/material.dart';

/// [padding] extensions
extension PaddingExtension on Widget {

  /// [padding] extension to apply padding to this [widget] at all
  Widget paddingAll(double padding) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: this,
    );
  }
}
