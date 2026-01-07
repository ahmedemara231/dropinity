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

  /// [padding] extension to apply padding to this [widget] at End
  Widget paddingEnd(double padding) {
    return Padding(
      padding: EdgeInsetsDirectional.only(end: padding),
      child: this,
    );
  }

  /// [padding] extension to apply padding to this [widget] at Top
  Widget paddingTop(double padding) {
    return Padding(
      padding: EdgeInsets.only(top: padding),
      child: this,
    );
  }
}
